-- ============================================
-- DISABLE RLS FOR TESTING (Quick Fix)
-- ============================================
-- Run this in Supabase SQL Editor to allow registration

-- Option 1: Disable RLS completely (for testing only)
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Option 2: Or add permissive INSERT policy
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- DROP POLICY IF EXISTS "Allow registration" ON users;
-- CREATE POLICY "Allow registration" ON users
--     FOR INSERT 
--     TO authenticated
--     WITH CHECK (true);

-- Verify RLS status
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'users';
