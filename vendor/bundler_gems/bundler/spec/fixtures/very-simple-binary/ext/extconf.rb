require "mkmf"

unless with_config("simple")
  exit 1
end

extension_name = "very_simple_binary"
dir_config       extension_name
create_makefile  extension_name