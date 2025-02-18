-- schema.lua
local typedefs = require "kong.db.schema.typedefs"

return {
  name = "header-validation-plugin",  -- The name of the plugin
  fields = {
    { consumer = typedefs.no_consumer },  -- No consumer-specific configuration
    { protocols = typedefs.protocols_http },  -- Supports only HTTP/HTTPS
    { config = {
        type = "record",
        fields = {
          { username_header = {  -- Allow the user to configure the username header
              type = "string",
              default = "username",  -- Default header name is "username"
              required = true,  -- This field must be provided
            },
          },
          { user_id_header = {  -- Allow the user to configure the user-id header
              type = "string",
              default = "user-id",  -- Default header name is "user-id"
              required = true,  -- This field must be provided
            },
          },
        },
      },
    },
  },
}
