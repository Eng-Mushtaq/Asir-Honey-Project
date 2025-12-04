-- Add admin user to database manually
-- Replace the UUID with the actual auth user ID from the error log

INSERT INTO users (
    id,
    email,
    name,
    phone,
    user_type,
    is_active,
    is_verified
) VALUES (
    'fb305849-9921-48aa-a38b-e986d02a61c7', -- Replace with actual UUID from error
    'admin@gmail.com',
    'Admin',
    '0512345678',
    'admin',
    true,
    true
) ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    user_type = EXCLUDED.user_type;

-- Verify
SELECT * FROM users WHERE user_type = 'admin';
