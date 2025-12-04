-- Fix constraint to allow admin users
ALTER TABLE users DROP CONSTRAINT IF EXISTS beekeeper_required_fields;

ALTER TABLE users ADD CONSTRAINT beekeeper_required_fields CHECK (
    user_type IN ('consumer', 'admin') OR 
    (user_type = 'beekeeper' AND business_name IS NOT NULL)
);
