-- schema.lua
local typedefs = require "kong.db.schema.typedefs"
 
return {
  name = "header-encode-plugin",
  fields = {
    { consumer = typedefs.no_consumer }, -- Plugin applies globally
    { protocols = typedefs.protocols_http }, -- Supports only HTTP/HTTPS
    { config = {
        type = "record",
        fields = {
          { required_headers = { type = "array", elements = { type = "string" }, default = { "username", "user-id" } } },
          { enable_encoding = { type = "boolean", default = true } } -- Option to enable/disable encoding
        }
      }
    }
  }
}