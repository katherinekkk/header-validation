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

-- Body filter phase to encode the response body
function HeaderValidationPlugin:body_filter()
  local chunk = ngx.arg[1]
  local eof = ngx.arg[2]

  -- Initialize the buffer to accumulate chunks if not already initialized
  if not ngx.ctx.buffer then
    ngx.ctx.buffer = ""
  end

  -- Append the current chunk to the buffer
  if chunk then
    ngx.ctx.buffer = ngx.ctx.buffer .. chunk
    ngx.arg[1] = nil  -- Clear the chunk to prevent it from being outputted before encoding
  end

  -- Once the response is complete (eof is true), perform encoding
  if eof then
    -- Encode the entire response body in Base64
    local encoded = ngx.encode_base64(ngx.ctx.buffer)

    -- Set the encoded data back into ngx.arg to be sent as the response body
    ngx.arg[1] = encoded
  end
end

-- Define the plugin priority (mandatory)
HeaderValidationPlugin.PRIORITY = 10

-- Define the plugin version (mandatory)
HeaderValidationPlugin.VERSION = "1.0.0"

return HeaderValidationPlugin
