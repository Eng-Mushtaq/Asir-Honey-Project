-- ============================================
-- SUPABASE ADMIN SETUP - QUICK SQL REFERENCE
-- ============================================
-- Run these commands in Supabase SQL Editor
-- ============================================

-- Step 1: Update User Type Constraint
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_user_type_check;
ALTER TABLE users ADD CONSTRAINT users_user_type_check 
    CHECK (user_type IN ('consumer', 'beekeeper', 'admin'));

-- Step 2: Create Admin Helper Function
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users 
        WHERE id = auth.uid() AND user_type = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 3: Create Admin RLS Policies
DROP POLICY IF EXISTS "Admins can view all users" ON users;
DROP POLICY IF EXISTS "Admins can update any user" ON users;
DROP POLICY IF EXISTS "Admins can view all products" ON products;
DROP POLICY IF EXISTS "Admins can update any product" ON products;
DROP POLICY IF EXISTS "Admins can view all orders" ON orders;
DROP POLICY IF EXISTS "Admins can update any order" ON orders;
DROP POLICY IF EXISTS "Admins can view all order items" ON order_items;
DROP POLICY IF EXISTS "Admins can update any order item" ON order_items;
DROP POLICY IF EXISTS "Admins can view all reviews" ON reviews;
DROP POLICY IF EXISTS "Admins can update any review" ON reviews;

CREATE POLICY "Admins can view all users" ON users
    FOR SELECT USING (is_admin());

CREATE POLICY "Admins can update any user" ON users
    FOR UPDATE USING (is_admin());

CREATE POLICY "Admins can view all products" ON products
    FOR SELECT USING (is_admin());

CREATE POLICY "Admins can update any product" ON products
    FOR UPDATE USING (is_admin());

CREATE POLICY "Admins can view all orders" ON orders
    FOR SELECT USING (is_admin());

CREATE POLICY "Admins can update any order" ON orders
    FOR UPDATE USING (is_admin());

CREATE POLICY "Admins can view all order items" ON order_items
    FOR SELECT USING (is_admin());

CREATE POLICY "Admins can update any order item" ON order_items
    FOR UPDATE USING (is_admin());

CREATE POLICY "Admins can view all reviews" ON reviews
    FOR SELECT USING (is_admin());

CREATE POLICY "Admins can update any review" ON reviews
    FOR UPDATE USING (is_admin());

-- Step 4: Create Admin User (after creating in Auth Dashboard)
-- First create user in Supabase Auth Dashboard, then run:
-- UPDATE users SET user_type = 'admin' WHERE email = 'admin@asir.sa';

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check if admin user exists
SELECT * FROM users WHERE user_type = 'admin';

-- Check if is_admin function works
SELECT is_admin();

-- Check RLS policies
SELECT tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public' 
AND policyname LIKE '%Admin%';

-- ============================================
-- END
-- ============================================

