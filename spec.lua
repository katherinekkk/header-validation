local helpers = require "spec.helpers"
local kong = kong
local ngx = ngx

describe("HeaderEncodePlugin", function()
  local client

  setup(function()
    -- Start Kong with the plugin enabled
    assert(helpers.start_kong({
      plugins = "bundled,header-encode-plugin",  -- Include the plugin name here
    }))
  end)

  teardown(function()
    -- Stop Kong
    helpers.stop_kong()
  end)

  before_each(function()
    -- Create a client for making requests to Kong
    client = helpers.proxy_client()
  end)

  after_each(function()
    if client then
      client:close()
    end
  end)

  describe("when sending a request with valid headers", function()
    it("should return the encoded headers in the response", function()
      local res = client:get("/request_path", {
        headers = {
          username = "myuser",
          ["user-id"] = "1234",
        }
      })

      assert.res_status(200, res)
      assert.equal("bXl1c2Vy", res.headers["X-Encoded-Username"])
      assert.equal("MTIzNA==", res.headers["X-Encoded-User-Id"])
    end)
  end)

  describe("when sending a request with missing headers", function()
    it("should return 400 with an error message", function()
      local res = client:get("/request_path", {
        headers = {
          username = "myuser",  -- Missing user-id
        }
      })

      assert.res_status(400, res)
      assert.equal('{"message":"Missing username or user-id header"}', res.body)
    end)
  end)
end)
