local helpers = require "spec.helpers"
local assert = require "luassert"
local kong = kong

describe("Header Validation Plugin", function()

  local client

  before_each(function()
    -- Set up a new client to interact with Kong
    client = helpers.proxy_client()
  end)

  after_each(function()
    -- Clean up the client after the test
    if client then
      client:close()
    end
  end)

  describe("Access phase", function()

    it("returns 400 if username is missing", function()
      local res = client:get("/test", {
        headers = {
          ["user-id"] = "1234"
        }
      })
      assert.res_status(400, res)
      assert.equal('{"message":"Missing username or user-id header"}', res.body)
    end)

    it("returns 400 if user-id is missing", function()
      local res = client:get("/test", {
        headers = {
          ["username"] = "john_doe"
        }
      })
      assert.res_status(400, res)
      assert.equal('{"message":"Missing username or user-id header"}', res.body)
    end)

    it("passes when both username and user-id are present", function()
      local res = client:get("/test", {
        headers = {
          ["username"] = "john_doe",
          ["user-id"] = "1234"
        }
      })
      assert.res_status(200, res)
    end)

    it("adds validated headers to the downstream service", function()
      local res = client:get("/test", {
        headers = {
          ["username"] = "john_doe",
          ["user-id"] = "1234"
        }
      })
      assert.res_status(200, res)
      -- Check that the validated headers are set
      assert.equal("john_doe", res.headers["X-Validated-User"])
      assert.equal("1234", res.headers["X-Validated-User-Id"])
    end)

  end)

end)
