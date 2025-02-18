local ngx = ngx
local kong = kong

local HeaderValidationPlugin = {}

-- Constructor
function HeaderValidationPlugin:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

-- Access phase to validate headers
function HeaderValidationPlugin:access(conf)
  local headers = kong.request.get_headers()
  local username = headers["username"]
  local user_id = headers["user-id"]

  if not username or not user_id then
    return kong.response.exit(400, { message = "Missing username or user-id header" })
  end

  -- Add validated headers for downstream services if needed
  kong.service.request.set_header("X-Validated-User", username)
  kong.service.request.set_header("X-Validated-User-Id", user_id)
  kong.log.debug("Validated headers - Username: " .. username .. ", User-ID: " .. user_id)
end

-- Header filter phase to prepare the body for encoding
function HeaderValidationPlugin:header_filter()
  -- Ensure Content-Length is removed for encoded responses
  ngx.header["Content-Length"] = nil
end

-- Remove the body_filter method as the encoding logic is to be removed

-- Define the plugin priority (mandatory)
HeaderValidationPlugin.PRIORITY = 10

-- Define the plugin version (mandatory)
HeaderValidationPlugin.VERSION = "1.0.0"

return HeaderValidationPlugin
