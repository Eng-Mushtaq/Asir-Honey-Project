# Supabase Connection Guide - Real Implementation

## ✅ What Has Been Done

1. **Supabase Config Updated** - Real credentials added
2. **AuthController Updated** - Now uses real Supabase authentication
3. **AdminController Updated** - Now uses real Supabase queries
4. **API Service Updated** - All methods now connect to real Supabase
5. **Models Updated** - Handle database schema (snake_case, JSONB fields)

## 📋 SQL Commands to Run in Supabase SQL Editor

### Step 1: Update User Type to Include Admin

```sql
-- Drop existing constraint
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_user_type_check;

-- Add new constraint with admin
ALTER TABLE users ADD CONSTRAINT users_user_type_check 
    CHECK (user_type IN ('consumer', 'beekeeper', 'admin'));
```

### Step 2: Create Admin Helper Function

```sql
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
```

### Step 3: Create Admin RLS Policies

```sql
-- Admin can view all users
DROP POLICY IF EXISTS "Admins can view all users" ON users;
CREATE POLICY "Admins can view all users" ON users
    FOR SELECT USING (is_admin());

-- Admin can update any user
DROP POLICY IF EXISTS "Admins can update any user" ON users;
CREATE POLICY "Admins can update any user" ON users
    FOR UPDATE USING (is_admin());

-- Admin can view all products
DROP POLICY IF EXISTS "Admins can view all products" ON products;
CREATE POLICY "Admins can view all products" ON products
    FOR SELECT USING (is_admin());

-- Admin can update any product
DROP POLICY IF EXISTS "Admins can update any product" ON products;
CREATE POLICY "Admins can update any product" ON products
    FOR UPDATE USING (is_admin());

-- Admin can view all orders
DROP POLICY IF EXISTS "Admins can view all orders" ON orders;
CREATE POLICY "Admins can view all orders" ON orders
    FOR SELECT USING (is_admin());

-- Admin can update any order
DROP POLICY IF EXISTS "Admins can update any order" ON orders;
CREATE POLICY "Admins can update any order" ON orders
    FOR UPDATE USING (is_admin());

-- Admin can view all order items
DROP POLICY IF EXISTS "Admins can view all order items" ON order_items;
CREATE POLICY "Admins can view all order items" ON order_items
    FOR SELECT USING (is_admin());

-- Admin can update any order item
DROP POLICY IF EXISTS "Admins can update any order item" ON order_items;
CREATE POLICY "Admins can update any order item" ON order_items
    FOR UPDATE USING (is_admin());

-- Admin can view all reviews
DROP POLICY IF EXISTS "Admins can view all reviews" ON reviews;
CREATE POLICY "Admins can view all reviews" ON reviews
    FOR SELECT USING (is_admin());

-- Admin can update any review
DROP POLICY IF EXISTS "Admins can update any review" ON reviews;
CREATE POLICY "Admins can update any review" ON reviews
    FOR UPDATE USING (is_admin());
```

### Step 4: Enable Foreign Key Relationships for Joins

**Important**: For Supabase PostgREST to support joins, you need to ensure foreign key relationships are properly set up. The database schema already has these, but verify:

```sql
-- Verify foreign keys exist
SELECT
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name IN ('products', 'orders', 'order_items');
```

### Step 5: Create Admin User

**Option A: Create through Supabase Auth Dashboard**
1. Go to Supabase Dashboard → Authentication → Users
2. Click "Add User"
3. Enter email: `admin@asir.sa`
4. Set password
5. Copy the user ID

**Option B: Create directly in database (after auth user is created)**
```sql
-- After creating user in Auth, update their user_type to admin
UPDATE users 
SET user_type = 'admin' 
WHERE email = 'admin@asir.sa';
```

**Option C: Insert admin user directly (if Auth is not set up)**
```sql
-- Insert admin user (requires auth.users entry first)
-- First create user in Supabase Auth, then run:
INSERT INTO users (id, email, name, phone, user_type)
VALUES (
    'YOUR_USER_ID_FROM_AUTH',  -- Get from auth.users table
    'admin@asir.sa',
    'Admin',
    '0500000000',
    'admin'
)
ON CONFLICT (email) DO UPDATE SET user_type = 'admin';
```

## 🔧 Testing the Connection

### 1. Test Authentication
- Login with admin credentials (`admin@asir.sa`)
- Should redirect to admin dashboard
- Check if user data is loaded correctly

### 2. Test Admin Dashboard
- Check if statistics load correctly
- Verify counts match database

### 3. Test User Management
- Load all users
- Activate/deactivate users
- Verify changes persist in database

### 4. Test Product Management
- Load all products
- Approve/reject products
- Feature products
- Verify changes persist in database

### 5. Test Order Management
- Load all orders
- Update order status
- Verify changes persist in database

### 6. Test Beekeeper Verification
- Load all beekeepers
- Verify/unverify beekeepers
- Verify changes persist in database

## 🐛 Troubleshooting

### Issue: "Foreign key relationship not found"
**Solution**: Verify foreign keys exist in database schema

### Issue: "Permission denied"
**Solution**: Check RLS policies are created correctly

### Issue: "Join not working"
**Solution**: The app has fallback logic to fetch data without joins. If joins fail, it will still work but without beekeeper/user names.

### Issue: "Admin user not found"
**Solution**: 
1. Verify user exists in `auth.users` table
2. Verify user exists in `users` table with `user_type = 'admin'`
3. Check RLS policies allow admin access

### Issue: "Products not loading"
**Solution**: 
1. Check if products table has data
2. Verify `is_active` column exists
3. Check RLS policies allow viewing products

### Issue: "Orders not loading"
**Solution**:
1. Check if orders table has data
2. Verify `order_items` table has data
3. Check RLS policies allow viewing orders

## 📝 Notes

1. **Joins**: The app tries to use Supabase joins but has fallback logic if joins don't work. This ensures the app works even if join syntax needs adjustment.

2. **JSONB Fields**: Products use JSONB for `name` and `description` (multilingual). The app extracts the correct language based on current locale.

3. **Snake_case vs CamelCase**: All models handle both formats - database uses snake_case, app uses camelCase.

4. **Error Handling**: All API calls have try-catch blocks with fallback logic to ensure the app doesn't crash.

5. **Testing**: Test with real data in Supabase to ensure everything works correctly.

## 🚀 Next Steps

1. Run all SQL commands in Supabase SQL Editor
2. Create admin user through Supabase Auth
3. Test login with admin credentials
4. Test all admin features
5. Add test data (users, products, orders) to Supabase
6. Verify all features work with real data

## 📞 Support

If you encounter issues:
1. Check Supabase logs in Dashboard → Logs
2. Check browser console for errors
3. Verify RLS policies are correct
4. Verify foreign keys are set up correctly
5. Check if tables have data

---

**Status**: ✅ Ready for Testing  
**Version**: 1.0  
**Last Updated**: November 2024

