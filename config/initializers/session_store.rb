# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_failbin_session',
  :secret      => 'e111e7507bb4755e89cd0494094c62e8f0ae89d4be85843dd07d9cdaafa87da90bfb94a408ff91c3d412f987572aecdd449fc14598f1867ba32b72de330184bd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
