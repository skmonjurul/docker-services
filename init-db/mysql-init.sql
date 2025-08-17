-- init.sql
-- This script will be executed when the MySQL container starts for the first time.

-- Create Database 1
CREATE DATABASE IF NOT EXISTS onboarding;

-- Create Database 2
CREATE DATABASE IF NOT EXISTS kyc_verification;

-- Create Database 3
CREATE DATABASE IF NOT EXISTS customer;

-- Create Database 4
CREATE DATABASE IF NOT EXISTS document;

-- Create Database 5
CREATE DATABASE IF NOT EXISTS notification;

-- Create Database 4
CREATE DATABASE IF NOT EXISTS tokenization;

-- Create Database 5
CREATE DATABASE IF NOT EXISTS account;

-- You can also create users and grant privileges here if needed.
-- Example: Create a user for my_app_db
-- CREATE USER 'app_user'@'%' IDENTIFIED BY 'app_password';
-- GRANT ALL PRIVILEGES ON my_app_db.* TO 'app_user'@'%';

-- Example: Create a user for another_service_db
-- CREATE USER 'service_user'@'%' IDENTIFIED BY 'service_password';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON another_service_db.* TO 'service_user'@'%';

-- FLUSH PRIVILEGES;



-- Grant all privileges to 'dev_user' on each specific database
GRANT ALL PRIVILEGES ON `onboarding`.* TO 'dev_user'@'%';
GRANT ALL PRIVILEGES ON `customer`.* TO 'dev_user'@'%';
GRANT ALL PRIVILEGES ON `kyc_verification`.* TO 'dev_user'@'%';
GRANT ALL PRIVILEGES ON `document`.* TO 'dev_user'@'%';
GRANT ALL PRIVILEGES ON `notification`.* TO 'dev_user'@'%';
GRANT ALL PRIVILEGES ON `tokenization`.* TO 'dev_user'@'%';
GRANT ALL PRIVILEGES ON `account`.* TO 'dev_user'@'%';

-- Flush privileges to apply the changes immediately
FLUSH PRIVILEGES;
