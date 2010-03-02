# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kamyshkо_session',
  :secret      => '36355d53889665c19ff3075a61b0183b865442356915dd8a1edb2b14daf1a6873afc79c0266a9fc5d441accbee727d2bfab0c115bbd460ae6ecf4dc4098fc0ae'
}

ActionController::Base.session_store = :active_record_store
