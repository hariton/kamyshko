# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kamyshko_session',
  :secret      => 'a37d2f8b5a3d9388648dacc5a095639f15cf3a9cf1d63090d071d85300e556463048a4837014b0f38b94b7972affeb42ea4bbb0a570e140f301565c94664ba42'
}

ActionController::Base.session_store = :active_record_store
