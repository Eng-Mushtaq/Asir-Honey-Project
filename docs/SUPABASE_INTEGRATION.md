# Supabase Integration Guide

## Project Details
- **Project ID**: `pdutcorgkgpxndgqljwa`
- **Project URL**: `https://pdutcorgkgpxndgqljwa.supabase.co`

## Setup Steps

### 1. Get Supabase Anon Key
1. Go to [Supabase Dashboard](https://supabase.com/dashboard/project/pdutcorgkgpxndgqljwa/settings/api)
2. Copy the `anon` `public` key
3. Update `lib/config/supabase_config.dart`:
```dart
static const String supabaseAnonKey = 'YOUR_COPIED_KEY_HERE';
```

### 2. Initialize Database
1. Go to [SQL Editor](https://supabase.com/dashboard/project/pdutcorgkgpxndgqljwa/sql/new)
2. Copy entire content from `supabase_init.sql`
3. Paste and click "Run"
4. Wait for success message

### 3. Enable Email Auth
1. Go to [Authentication Settings](https://supabase.com/dashboard/project/pdutcorgkgpxndgqljwa/auth/providers)
2. Enable "Email" provider
3. Disable "Confirm email" for testing

### 4. Install Dependencies
```bash
cd d:\projects\asal_asir
flutter pub get
```

### 5. Run Application
```bash
flutter run
```

## Database Schema Created
- ✅ users (with beekeeper profiles)
- ✅ products (multilingual JSONB)
- ✅ orders (with tracking)
- ✅ order_items (per-item status)
- ✅ reviews (with ratings)
- ✅ cart (persistent)
- ✅ favorites
- ✅ notifications
- ✅ Storage buckets (products, avatars)
- ✅ RLS policies (security)
- ✅ Triggers (auto-ratings, stock updates)

## Test Accounts
After running app, register:
- **Consumer**: consumer@test.com / Test@123
- **Beekeeper**: beekeeper@test.com / Test@123

## Next Steps
1. Update controllers to use ApiService
2. Test authentication flow
3. Test product CRUD
4. Test order creation
5. Test image uploads
