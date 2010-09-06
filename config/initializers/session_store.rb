# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vodasign_session',
  :secret      => 'be1518b967a85c3d90c66e794c4d55f014b05ae4b6c995a495b1e1e8ca711bee53e9cdcdc00164626c2ce4e9de2f53bff50b55d667907980c24946653cfe80e9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
