# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vcc_session',
  :secret      => 'd90b567176334e855359e1aaa78b2fae929069d0ac306070953b3bc9675c0250bcffd364517661e2c46f52f426e2e20e2fa40fc8de1eda027f85443d8685650b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
