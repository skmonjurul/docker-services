// MongoDB initialization script for tokenization service

// 1. Define the name of your actual application database
var appDbName = 'local';

// 2. Switch to the ADMIN database to create the user
//    Users should typically be created in the 'admin' database or the database they primarily interact with.
//    Creating in 'admin' makes it easier to manage permissions across multiple databases if needed.
var adminDb = db.getSiblingDB('admin');

// 3. Create application user if it doesn't exist
//    Check for user existence in the admin database
if (adminDb.getUser("tokenization_user") == null) {
  print('Creating user: tokenization_user in admin database');
  adminDb.createUser({
    user: "tokenization_user",
    pwd: "tokenization_password", // !! CHANGE THIS TO A SECURE PASSWORD IN PRODUCTION !!
    roles: [
      {
        role: "readWrite",
        db: appDbName // Grant roles on the actual application database, NOT 'local'
      }
      // You can add more roles/databases here if needed, e.g.,
      // { role: "read", db: "another_db" }
    ]
  });
  print('User tokenization_user created successfully.');
} else {
  print('User tokenization_user already exists. Skipping creation.');
}


// 4. Now, switch to your actual application database to create collections and indexes
var appDb = db.getSiblingDB(appDbName);

print('Switching to database: ' + appDbName);

// 5. Create collections (only if they don't exist)
//    It's good practice to check for collection existence in idempotent scripts
if (!appDb.getCollectionNames().includes('tokenization_records')) {
  print('Creating collection: tokenization_records');
  appDb.createCollection('tokenization_records');
} else {
  print('Collection tokenization_records already exists. Skipping creation.');
}


// 6. Create indexes for better query performance (only if they don't exist)
//    Use ensureIndex (or createIndex) for idempotency, it won't re-create if it exists.
print('Creating index on tokenization_records.id');
appDb.tokenization_records.createIndex({ "id": 1 }, { unique: true });


// Print initialization complete message
print('MongoDB initialization completed for tokenization service in ' + appDbName + ' database.');