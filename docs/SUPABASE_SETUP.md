# 🗄️ Supabase Setup Guide - Phase 2

## Step 1: Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in
3. Click "New Project"
4. Fill in:
   - Project Name: `asir-honey-marketplace`
   - Database Password: (create a strong password)
   - Region: Choose closest to Saudi Arabia
5. Wait for project to be created (~2 minutes)

## Step 2: Get API Credentials

1. Go to Project Settings → API
2. Copy:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public key** (starts with `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`)
3. Update `lib/config/supabase_config.dart` with these values

## Step 3: Create Database Tables

Go to SQL Editor in Supabase Dashboard and run these queries:

### 1. Users Table (extends Supabase Auth)
```sql
CREATE TABLE users (
  id UUID REFERENCES auth.users PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT NOT NULL,
  user_type TEXT NOT NULL CHECK (user_type IN ('consumer', 'beekeeper')),
  business_name TEXT,
  business_license TEXT,
  location TEXT,
  description TEXT,
  avatar TEXT,
  rating DECIMAL(2,1) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view all profiles" ON users FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);
```

### 2. Products Table
```sql
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  category TEXT NOT NULL,
  images TEXT[] NOT NULL,
  beekeeper_id UUID REFERENCES users(id) NOT NULL,
  rating DECIMAL(2,1) DEFAULT 0,
  review_count INTEGER DEFAULT 0,
  stock INTEGER NOT NULL DEFAULT 0,
  weight TEXT NOT NULL,
  harvest_date DATE NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can view active products" ON products FOR SELECT USING (is_active = true);
CREATE POLICY "Beekeepers can insert own products" ON products FOR INSERT WITH CHECK (auth.uid() = beekeeper_id);
CREATE POLICY "Beekeepers can update own products" ON products FOR UPDATE USING (auth.uid() = beekeeper_id);
CREATE POLICY "Beekeepers can delete own products" ON products FOR DELETE USING (auth.uid() = beekeeper_id);
```

### 3. Orders Table
```sql
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_number TEXT UNIQUE NOT NULL,
  user_id UUID REFERENCES users(id) NOT NULL,
  items JSONB NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  delivery_fee DECIMAL(10,2) NOT NULL,
  discount DECIMAL(10,2) DEFAULT 0,
  total DECIMAL(10,2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
  payment_method TEXT NOT NULL,
  delivery_address TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own orders" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create own orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Beekeepers can view orders for their products" ON orders FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM products p
    WHERE p.beekeeper_id = auth.uid()
    AND p.id::text = ANY(SELECT jsonb_array_elements(items)->>'product_id')
  )
);
```

### 4. Reviews Table
```sql
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES users(id) NOT NULL,
  rating DECIMAL(2,1) NOT NULL CHECK (rating >= 0 AND rating <= 5),
  comment TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(product_id, user_id)
);

-- Enable RLS
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can view reviews" ON reviews FOR SELECT USING (true);
CREATE POLICY "Users can create reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own reviews" ON reviews FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own reviews" ON reviews FOR DELETE USING (auth.uid() = user_id);
```

### 5. Create Functions and Triggers

```sql
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply to all tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update product rating
CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE products
  SET 
    rating = (SELECT AVG(rating) FROM reviews WHERE product_id = NEW.product_id),
    review_count = (SELECT COUNT(*) FROM reviews WHERE product_id = NEW.product_id)
  WHERE id = NEW.product_id;
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_product_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW EXECUTE FUNCTION update_product_rating();
```

## Step 4: Enable Storage for Product Images

1. Go to Storage in Supabase Dashboard
2. Create a new bucket: `product-images`
3. Make it public
4. Set policies:

```sql
-- Allow authenticated users to upload
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'product-images');

-- Allow public to view images
CREATE POLICY "Public can view images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'product-images');

-- Allow users to delete own images
CREATE POLICY "Users can delete own images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'product-images' AND auth.uid()::text = (storage.foldername(name))[1]);
```

## Step 5: Test Connection

Run the app and check console for "Supabase initialized successfully" message.

## 📝 Next Steps

After setup:
1. Update `lib/config/supabase_config.dart` with your credentials
2. Run `flutter pub get`
3. Restart the app
4. Test authentication flow
5. Test product CRUD operations

## 🔐 Security Notes

- Never commit `supabase_config.dart` with real credentials to Git
- Add to `.gitignore`: `lib/config/supabase_config.dart`
- Use environment variables for production
- Enable RLS (Row Level Security) on all tables
- Regularly rotate API keys

## 📚 Resources

- [Supabase Docs](https://supabase.com/docs)
- [Supabase Flutter](https://supabase.com/docs/reference/dart/introduction)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
