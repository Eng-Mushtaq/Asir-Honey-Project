-- ============================================
-- ASIR HONEY MARKETPLACE DATABASE SCHEMA
-- ============================================
-- Supabase PostgreSQL Database
-- Created: 2024
-- Version: 1.0
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    phone TEXT NOT NULL CHECK (phone ~ '^05[0-9]{8}$'),
    user_type TEXT NOT NULL CHECK (user_type IN ('consumer', 'beekeeper', 'admin')),
    
    -- Beekeeper specific fields
    business_name TEXT,
    business_license TEXT,
    location TEXT,
    description TEXT,
    avatar TEXT,
    rating DECIMAL(2,1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0,
    
    -- Metadata
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT beekeeper_required_fields CHECK (
        user_type = 'consumer' OR 
        (user_type = 'beekeeper' AND business_name IS NOT NULL)
    )
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_type ON users(user_type);
CREATE INDEX idx_users_active ON users(is_active) WHERE is_active = true;
CREATE INDEX idx_users_beekeeper_rating ON users(rating DESC) WHERE user_type = 'beekeeper';

-- ============================================
-- 2. PRODUCTS TABLE
-- ============================================
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    beekeeper_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Product details
    name JSONB NOT NULL, -- {"en": "Sidr Honey", "ar": "عسل السدر"}
    description JSONB NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category TEXT NOT NULL CHECK (category IN ('sidr', 'acacia', 'wildflower', 'mixed', 'other')),
    weight TEXT NOT NULL, -- "500g", "1kg", etc.
    
    -- Images
    images TEXT[] NOT NULL DEFAULT '{}',
    thumbnail TEXT,
    
    -- Inventory
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    sold_count INTEGER DEFAULT 0,
    
    -- Ratings
    rating DECIMAL(2,1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    review_count INTEGER DEFAULT 0,
    
    -- Dates
    harvest_date DATE NOT NULL,
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT valid_images CHECK (array_length(images, 1) > 0)
);

-- Indexes
CREATE INDEX idx_products_beekeeper ON products(beekeeper_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_active ON products(is_active) WHERE is_active = true;
CREATE INDEX idx_products_featured ON products(is_featured) WHERE is_featured = true;
CREATE INDEX idx_products_rating ON products(rating DESC);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_stock ON products(stock) WHERE stock > 0;
CREATE INDEX idx_products_created ON products(created_at DESC);

-- Full-text search index
CREATE INDEX idx_products_name_search ON products USING GIN ((name::text));

-- ============================================
-- 3. ORDERS TABLE
-- ============================================
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Order details
    order_number TEXT UNIQUE NOT NULL,
    
    -- Pricing
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    delivery_fee DECIMAL(10,2) DEFAULT 0 CHECK (delivery_fee >= 0),
    discount DECIMAL(10,2) DEFAULT 0 CHECK (discount >= 0),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    
    -- Status
    status TEXT NOT NULL DEFAULT 'pending' CHECK (
        status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')
    ),
    
    -- Payment
    payment_method TEXT NOT NULL CHECK (payment_method IN ('cash', 'card', 'wallet')),
    payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
    
    -- Delivery
    delivery_address JSONB NOT NULL, -- {"street": "", "city": "", "region": "", "phone": ""}
    delivery_notes TEXT,
    
    -- Tracking
    tracking_number TEXT,
    estimated_delivery DATE,
    delivered_at TIMESTAMPTZ,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    cancelled_at TIMESTAMPTZ,
    cancellation_reason TEXT
);

-- Indexes
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_created ON orders(created_at DESC);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);

-- ============================================
-- 4. ORDER_ITEMS TABLE
-- ============================================
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    beekeeper_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Item details (snapshot at order time)
    product_name JSONB NOT NULL,
    product_image TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal > 0),
    
    -- Status per item
    item_status TEXT DEFAULT 'pending' CHECK (
        item_status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled')
    ),
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_order_items_beekeeper ON order_items(beekeeper_id);
CREATE INDEX idx_order_items_status ON order_items(item_status);

-- ============================================
-- 5. REVIEWS TABLE
-- ============================================
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    
    -- Review content
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    
    -- Images
    images TEXT[] DEFAULT '{}',
    
    -- Status
    is_verified BOOLEAN DEFAULT false, -- Verified purchase
    is_visible BOOLEAN DEFAULT true,
    
    -- Helpful votes
    helpful_count INTEGER DEFAULT 0,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    UNIQUE(product_id, user_id, order_id)
);

-- Indexes
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_rating ON reviews(rating DESC);
CREATE INDEX idx_reviews_created ON reviews(created_at DESC);
CREATE INDEX idx_reviews_verified ON reviews(is_verified) WHERE is_verified = true;

-- ============================================
-- 6. CART TABLE (Optional - for persistent cart)
-- ============================================
CREATE TABLE cart (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(user_id, product_id)
);

-- Indexes
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_cart_product ON cart(product_id);

-- ============================================
-- 7. FAVORITES TABLE
-- ============================================
CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(user_id, product_id)
);

-- Indexes
CREATE INDEX idx_favorites_user ON favorites(user_id);
CREATE INDEX idx_favorites_product ON favorites(product_id);

-- ============================================
-- 8. NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Notification content
    title JSONB NOT NULL,
    message JSONB NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('order', 'product', 'review', 'system')),
    
    -- Related entities
    related_id UUID,
    related_type TEXT,
    
    -- Status
    is_read BOOLEAN DEFAULT false,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = false;
CREATE INDEX idx_notifications_created ON notifications(created_at DESC);

-- ============================================
-- TRIGGERS
-- ============================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER reviews_updated_at BEFORE UPDATE ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER cart_updated_at BEFORE UPDATE ON cart
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Update product rating when review is added/updated/deleted
CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET 
        rating = COALESCE((
            SELECT ROUND(AVG(rating)::numeric, 1)
            FROM reviews
            WHERE product_id = COALESCE(NEW.product_id, OLD.product_id)
            AND is_visible = true
        ), 0),
        review_count = (
            SELECT COUNT(*)
            FROM reviews
            WHERE product_id = COALESCE(NEW.product_id, OLD.product_id)
            AND is_visible = true
        )
    WHERE id = COALESCE(NEW.product_id, OLD.product_id);
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER review_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW EXECUTE FUNCTION update_product_rating();

-- Update beekeeper rating based on product reviews
CREATE OR REPLACE FUNCTION update_beekeeper_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users
    SET 
        rating = COALESCE((
            SELECT ROUND(AVG(p.rating)::numeric, 1)
            FROM products p
            WHERE p.beekeeper_id = (
                SELECT beekeeper_id FROM products WHERE id = COALESCE(NEW.product_id, OLD.product_id)
            )
            AND p.review_count > 0
        ), 0),
        total_reviews = (
            SELECT SUM(p.review_count)
            FROM products p
            WHERE p.beekeeper_id = (
                SELECT beekeeper_id FROM products WHERE id = COALESCE(NEW.product_id, OLD.product_id)
            )
        )
    WHERE id = (SELECT beekeeper_id FROM products WHERE id = COALESCE(NEW.product_id, OLD.product_id));
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER beekeeper_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW EXECUTE FUNCTION update_beekeeper_rating();

-- Generate order number
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_number = 'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(nextval('order_number_seq')::TEXT, 6, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE SEQUENCE order_number_seq;

CREATE TRIGGER order_number_trigger
BEFORE INSERT ON orders
FOR EACH ROW EXECUTE FUNCTION generate_order_number();

-- Update product stock when order is placed
CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE products
        SET 
            stock = stock - NEW.quantity,
            sold_count = sold_count + NEW.quantity
        WHERE id = NEW.product_id;
    ELSIF TG_OP = 'UPDATE' AND OLD.item_status != 'cancelled' AND NEW.item_status = 'cancelled' THEN
        UPDATE products
        SET 
            stock = stock + OLD.quantity,
            sold_count = sold_count - OLD.quantity
        WHERE id = OLD.product_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_stock_trigger
AFTER INSERT OR UPDATE ON order_items
FOR EACH ROW EXECUTE FUNCTION update_product_stock();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view their own profile" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Anyone can view active beekeepers" ON users
    FOR SELECT USING (user_type = 'beekeeper' AND is_active = true);

-- Products policies
CREATE POLICY "Anyone can view active products" ON products
    FOR SELECT USING (is_active = true);

CREATE POLICY "Beekeepers can manage their products" ON products
    FOR ALL USING (auth.uid() = beekeeper_id);

-- Orders policies
CREATE POLICY "Users can view their own orders" ON orders
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create orders" ON orders
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Order items policies
CREATE POLICY "Users can view their order items" ON order_items
    FOR SELECT USING (
        EXISTS (SELECT 1 FROM orders WHERE id = order_id AND user_id = auth.uid())
    );

CREATE POLICY "Beekeepers can view their order items" ON order_items
    FOR SELECT USING (auth.uid() = beekeeper_id);

CREATE POLICY "Beekeepers can update their order items status" ON order_items
    FOR UPDATE USING (auth.uid() = beekeeper_id);

-- Reviews policies
CREATE POLICY "Anyone can view visible reviews" ON reviews
    FOR SELECT USING (is_visible = true);

CREATE POLICY "Users can create reviews" ON reviews
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their reviews" ON reviews
    FOR UPDATE USING (auth.uid() = user_id);

-- Cart policies
CREATE POLICY "Users can manage their cart" ON cart
    FOR ALL USING (auth.uid() = user_id);

-- Favorites policies
CREATE POLICY "Users can manage their favorites" ON favorites
    FOR ALL USING (auth.uid() = user_id);

-- Notifications policies
CREATE POLICY "Users can view their notifications" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their notifications" ON notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================
-- ADMIN POLICIES
-- ============================================

-- Function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users 
        WHERE id = auth.uid() AND user_type = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Admin can view all users
CREATE POLICY "Admins can view all users" ON users
    FOR SELECT USING (is_admin());

-- Admin can update any user
CREATE POLICY "Admins can update any user" ON users
    FOR UPDATE USING (is_admin());

-- Admin can view all products
CREATE POLICY "Admins can view all products" ON products
    FOR SELECT USING (is_admin());

-- Admin can update any product
CREATE POLICY "Admins can update any product" ON products
    FOR UPDATE USING (is_admin());

-- Admin can view all orders
CREATE POLICY "Admins can view all orders" ON orders
    FOR SELECT USING (is_admin());

-- Admin can update any order
CREATE POLICY "Admins can update any order" ON orders
    FOR UPDATE USING (is_admin());

-- Admin can view all order items
CREATE POLICY "Admins can view all order items" ON order_items
    FOR SELECT USING (is_admin());

-- Admin can update any order item
CREATE POLICY "Admins can update any order item" ON order_items
    FOR UPDATE USING (is_admin());

-- Admin can view all reviews
CREATE POLICY "Admins can view all reviews" ON reviews
    FOR SELECT USING (is_admin());

-- Admin can update any review
CREATE POLICY "Admins can update any review" ON reviews
    FOR UPDATE USING (is_admin());

-- ============================================
-- STORAGE BUCKETS
-- ============================================

-- Create storage bucket for product images
INSERT INTO storage.buckets (id, name, public)
VALUES ('products', 'products', true);

-- Storage policies
CREATE POLICY "Anyone can view product images" ON storage.objects
    FOR SELECT USING (bucket_id = 'products');

CREATE POLICY "Beekeepers can upload product images" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'products' AND
        auth.role() = 'authenticated'
    );

CREATE POLICY "Beekeepers can delete their product images" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'products' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Create storage bucket for user avatars
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true);

CREATE POLICY "Anyone can view avatars" ON storage.objects
    FOR SELECT USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload their avatar" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'avatars' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can update their avatar" ON storage.objects
    FOR UPDATE USING (
        bucket_id = 'avatars' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- ============================================
-- VIEWS FOR ANALYTICS
-- ============================================

-- Beekeeper dashboard stats
CREATE OR REPLACE VIEW beekeeper_stats AS
SELECT 
    u.id as beekeeper_id,
    u.name as beekeeper_name,
    COUNT(DISTINCT p.id) as total_products,
    COUNT(DISTINCT oi.order_id) as total_orders,
    COALESCE(SUM(oi.subtotal), 0) as total_revenue,
    COALESCE(AVG(p.rating), 0) as avg_rating,
    SUM(p.review_count) as total_reviews
FROM users u
LEFT JOIN products p ON u.id = p.beekeeper_id
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE u.user_type = 'beekeeper'
GROUP BY u.id, u.name;

-- Popular products
CREATE OR REPLACE VIEW popular_products AS
SELECT 
    p.*,
    u.name as beekeeper_name,
    u.rating as beekeeper_rating
FROM products p
JOIN users u ON p.beekeeper_id = u.id
WHERE p.is_active = true
ORDER BY p.sold_count DESC, p.rating DESC
LIMIT 20;

-- ============================================
-- SAMPLE DATA FUNCTIONS
-- ============================================

-- Function to get product with beekeeper info
CREATE OR REPLACE FUNCTION get_product_details(product_uuid UUID)
RETURNS TABLE (
    product_data JSONB,
    beekeeper_data JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        to_jsonb(p.*) as product_data,
        jsonb_build_object(
            'id', u.id,
            'name', u.name,
            'businessName', u.business_name,
            'rating', u.rating,
            'location', u.location
        ) as beekeeper_data
    FROM products p
    JOIN users u ON p.beekeeper_id = u.id
    WHERE p.id = product_uuid;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Composite indexes for common queries
CREATE INDEX idx_products_active_category ON products(category, is_active) WHERE is_active = true;
CREATE INDEX idx_products_beekeeper_active ON products(beekeeper_id, is_active) WHERE is_active = true;
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_order_items_beekeeper_status ON order_items(beekeeper_id, item_status);

-- ============================================
-- COMMENTS
-- ============================================

COMMENT ON TABLE users IS 'Stores both consumer and beekeeper user profiles';
COMMENT ON TABLE products IS 'Product catalog with multilingual support';
COMMENT ON TABLE orders IS 'Customer orders with full tracking';
COMMENT ON TABLE order_items IS 'Individual items within orders';
COMMENT ON TABLE reviews IS 'Product reviews and ratings';
COMMENT ON TABLE cart IS 'Persistent shopping cart';
COMMENT ON TABLE favorites IS 'User favorite products';
COMMENT ON TABLE notifications IS 'User notifications';

-- ============================================
-- END OF SCHEMA
-- ============================================
