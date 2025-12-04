-- ============================================
-- FIX RLS POLICIES FOR USER REGISTRATION
-- ============================================

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Users can view own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "View active beekeepers" ON users;

-- Create new policies that allow registration
CREATE POLICY "Users can insert own profile" ON users
    FOR INSERT 
    WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view own profile" ON users
    FOR SELECT 
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE 
    USING (auth.uid() = id);

CREATE POLICY "Anyone can view active beekeepers" ON users
    FOR SELECT 
    USING (user_type = 'beekeeper' AND is_active = true);

-- Verify policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'users';
