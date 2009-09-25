# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fluxy_session',
  :secret      => 'dc710e6d3cca7df6a137297731a19810d1d1853208f1025b5e1245e5828c01e833f7d5dd2e686b3db6861028c290d7b888eeddcb0ae8f39c785cfc0b10ef5dce'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
