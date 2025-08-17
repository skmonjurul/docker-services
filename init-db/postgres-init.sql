-- init-db/init.sql

-- Exit immediately if any command fails
\set ON_ERROR_STOP on

-- Create a dedicated user for your applications
-- !! CHANGE 'appuser_password' to a strong, unique password !!
CREATE USER dev_user WITH PASSWORD 'dev_password';

-- Create multiple databases
CREATE DATABASE onboarding OWNER dev_user;
CREATE DATABASE customer OWNER dev_user;
CREATE DATABASE kyc_verification OWNER dev_user;
CREATE DATABASE account OWNER dev_user;
CREATE DATABASE notification OWNER dev_user;
CREATE DATABASE document OWNER dev_user;
CREATE DATABASE tokenization OWNER dev_user;

-- Grant all privileges on the newly created databases to 'dev_user'
-- This ensures 'dev_user' can manage schema and data in these databases
GRANT ALL PRIVILEGES ON DATABASE onboarding TO dev_user;
GRANT ALL PRIVILEGES ON DATABASE customer TO dev_user;
GRANT ALL PRIVILEGES ON DATABASE kyc_verification TO dev_user;
GRANT ALL PRIVILEGES ON DATABASE account TO dev_user;
GRANT ALL PRIVILEGES ON DATABASE notification TO dev_user;
GRANT ALL PRIVILEGES ON DATABASE document TO dev_user;
GRANT ALL PRIVILEGES ON DATABASE tokenization TO dev_user;

-- Optional: If you need 'dev_user' to be able to create objects in the 'public' schema
-- of these databases, and if the default template doesn't handle it,
-- you might need to add something like:
-- ALTER SCHEMA public OWNER TO appuser;
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO appuser;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO appuser;
-- GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO appuser;
-- However, typically the 'OWNER' clause in CREATE DATABASE handles most of this.
-- Test thoroughly!

-- Log success message (visible in container logs)
\echo 'Multiple databases created and privileges granted successfully!'