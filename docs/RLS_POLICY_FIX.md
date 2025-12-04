# RLS Policy Fix for Registration

## Error
```
PostgrestException: new row violates row-level security policy for table "users"
Code: 42501 (Forbidden)
```

## Root Cause
The RLS policy on `users` table is missing **INSERT** permission for authenticated users during registration.

## Solution

### Run this SQL in Supabase SQL Editor:

```sql
-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "View active beekeepers" ON users;

-- Create new policies with INSERT permission
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
```

## Quick Fix Steps

1. Go to [Supabase SQL Editor](https://supabase.com/dashboard/project/pdutcorgkgpxndgqljwa/sql/new)
2. Copy the SQL above
3. Click **Run**
4. Try registration again

## What Changed

✅ Added `INSERT` policy: Users can insert their own profile during registration
✅ Kept `SELECT` policy: Users can view their own profile
✅ Kept `UPDATE` policy: Users can update their own profile
✅ Public `SELECT` policy: Anyone can view active beekeepers

## Verification

After running the SQL, test:
1. Register new consumer account
2. Register new beekeeper account
3. Check console logs for success messages
4. Verify user appears in database

## Files Updated

- ✅ `fix_rls_policies.sql` - Standalone fix script
- ✅ `supabase_init.sql` - Updated for future deployments