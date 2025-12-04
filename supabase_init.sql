-- ============================================
-- ASIR HONEY MARKETPLACE - SUPABASE INIT
-- Run this in Supabase SQL Editor
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLES
-- ============================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    phone TEXT NOT NULL CHECK (phone ~ '^05[0-9]{8}$'),
    user_type TEXT NOT NULL CHECK (user_type IN ('consumer', 'beekeeper', 'admin')),
    business_name TEXT,
    business_license TEXT,
    location TEXT,
    description TEXT,
    avatar TEXT,
    rating DECIMAL(2,1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT beekeeper_required_fields CHECK (
        user_type IN ('consumer', 'admin') OR (user_type = 'beekeeper' AND business_name IS NOT NULL)
    )
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    beekeeper_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name JSONB NOT NULL,
    description JSONB NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category TEXT NOT NULL CHECK (category IN ('sidr', 'acacia', 'wildflower', 'mixed', 'other')),
    weight TEXT NOT NULL,
    images TEXT[] NOT NULL DEFAULT '{}',
    thumbnail TEXT,
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    sold_count INTEGER DEFAULT 0,
    rating DECIMAL(2,1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    review_count INTEGER DEFAULT 0,
    harvest_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT valid_images CHECK (array_length(images, 1) > 0)
);

CREATE SEQUENCE order_number_seq;

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_number TEXT UNIQUE NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    delivery_fee DECIMAL(10,2) DEFAULT 0 CHECK (delivery_fee >= 0),
    discount DECIMAL(10,2) DEFAULT 0 CHECK (discount >= 0),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (
        status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')
    ),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('cash', 'card', 'wallet')),
    payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
    delivery_address JSONB NOT NULL,
    delivery_notes TEXT,
    tracking_number TEXT,
    estimated_delivery DATE,
    delivered_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    cancelled_at TIMESTAMPTZ,
    cancellation_reason TEXT
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    beekeeper_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_name JSONB NOT NULL,
    product_image TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal > 0),
    item_status TEXT DEFAULT 'pending' CHECK (
        item_status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled')
    ),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    images TEXT[] DEFAULT '{}',
    is_verified BOOLEAN DEFAULT false,
    is_visible BOOLEAN DEFAULT true,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(product_id, user_id, order_id)
);

CREATE TABLE cart (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title JSONB NOT NULL,
    message JSONB NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('order', 'product', 'review', 'system')),
    related_id UUID,
    related_type TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_type ON users(user_type);
CREATE INDEX idx_products_beekeeper ON products(beekeeper_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_active ON products(is_active) WHERE is_active = true;
CREATE INDEX idx_products_rating ON products(rating DESC);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_beekeeper ON order_items(beekeeper_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_favorites_user ON favorites(user_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);

-- ============================================
-- TRIGGERS
-- ============================================

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

CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET 
        rating = COALESCE((
            SELECT ROUND(AVG(rating)::numeric, 1)
            FROM reviews
            WHERE product_id = COALESCE(NEW.product_id, OLD.product_id) AND is_visible = true
        ), 0),
        review_count = (
            SELECT COUNT(*) FROM reviews
            WHERE product_id = COALESCE(NEW.product_id, OLD.product_id) AND is_visible = true
        )
    WHERE id = COALESCE(NEW.product_id, OLD.product_id);
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER review_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW EXECUTE FUNCTION update_product_rating();

CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_number = 'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(nextval('order_number_seq')::TEXT, 6, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER order_number_trigger
BEFORE INSERT ON orders
FOR EACH ROW EXECUTE FUNCTION generate_order_number();

CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE products SET stock = stock - NEW.quantity, sold_count = sold_count + NEW.quantity
        WHERE id = NEW.product_id;
    ELSIF TG_OP = 'UPDATE' AND OLD.item_status != 'cancelled' AND NEW.item_status = 'cancelled' THEN
        UPDATE products SET stock = stock + OLD.quantity, sold_count = sold_count - OLD.quantity
        WHERE id = OLD.product_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_stock_trigger
AFTER INSERT OR UPDATE ON order_items
FOR EACH ROW EXECUTE FUNCTION update_product_stock();

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can insert own profile" ON users FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Anyone can view active beekeepers" ON users FOR SELECT USING (user_type = 'beekeeper' AND is_active = true);

CREATE POLICY "View active products" ON products FOR SELECT USING (is_active = true);
CREATE POLICY "Beekeepers manage products" ON products FOR ALL USING (auth.uid() = beekeeper_id);

CREATE POLICY "Users view own orders" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users create orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users view own order items" ON order_items FOR SELECT USING (
    EXISTS (SELECT 1 FROM orders WHERE id = order_id AND user_id = auth.uid())
);
CREATE POLICY "Beekeepers view order items" ON order_items FOR SELECT USING (auth.uid() = beekeeper_id);
CREATE POLICY "Beekeepers update order items" ON order_items FOR UPDATE USING (auth.uid() = beekeeper_id);

CREATE POLICY "View visible reviews" ON reviews FOR SELECT USING (is_visible = true);
CREATE POLICY "Users create reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users update reviews" ON reviews FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users manage cart" ON cart FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users manage favorites" ON favorites FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users view notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users update notifications" ON notifications FOR UPDATE USING (auth.uid() = user_id);

-- ============================================
-- STORAGE BUCKETS
-- ============================================

INSERT INTO storage.buckets (id, name, public) VALUES ('products', 'products', true) ON CONFLICT DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true) ON CONFLICT DO NOTHING;

CREATE POLICY "View product images" ON storage.objects FOR SELECT USING (bucket_id = 'products');
CREATE POLICY "Upload product images" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'products' AND auth.role() = 'authenticated');
CREATE POLICY "Delete own product images" ON storage.objects FOR DELETE USING (bucket_id = 'products' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "View avatars" ON storage.objects FOR SELECT USING (bucket_id = 'avatars');
CREATE POLICY "Upload avatar" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
CREATE POLICY "Update avatar" ON storage.objects FOR UPDATE USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
