# Quick RLS Fix - Registration Error

## Error Still Happening?
```
PostgrestException: new row violates row-level security policy for table "users"
```

## Fastest Solution (For Testing)

### Go to Supabase SQL Editor:
https://supabase.com/dashboard/project/pdutcorgkgpxndgqljwa/sql/new

### Copy and Run This:
```sql
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
```

That's it! Registration will work immediately.

## Alternative (Keep RLS Enabled)

If you want to keep RLS enabled, run this instead:

```sql
-- Drop all existing policies
DROP POLICY IF EXISTS "Users can insert own profile" ON users;
DROP POLICY IF EXISTS "Users can view own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Anyone can view active beekeepers" ON users;

-- Create permissive policies
CREATE POLICY "Allow registration" ON users
    FOR INSERT TO authenticated
    WITH CHECK (true);

CREATE POLICY "Users can view own profile" ON users
    FOR SELECT TO authenticated
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE TO authenticated
    USING (auth.uid() = id);

CREATE POLICY "Public can view beekeepers" ON users
    FOR SELECT TO anon, authenticated
    USING (user_type = 'beekeeper' AND is_active = true);
```

## Why This Happens

The RLS policy requires `auth.uid() = id` but during registration:
1. User is created in auth.users
2. App tries to insert into public.users
3. RLS blocks because the check happens before insert completes

## For Production

Re-enable RLS later with proper policies:
```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
```

## Test After Fix

1. Run the SQL
2. Try registration again
3. Should see: ✅ API: User data inserted successfully
4. User should be created in database