# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_scaffold_session',
  :secret      => 'f0c50f6d38723ed86b05ada4610d9d8f98b9a5ab681640942dcceb9c07483a139bc8195676d5bdf01294927c18712a9f2f569ad60d867eeb7f7855166ac08e6b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
