package = "header-validation-plugin"
version = "1.0.0-1"
rockspec_format = "1.0"

dependencies = {
  "kong >= 2.0.0",
}

source = {
  url = "/home/kong1/Desktop/header-validation-plugin",  -- Use the local path for the plugin source
}

description = {
  summary = "A Kong plugin to validate 'username' and 'user-id' headers",
  homepage = "/home/kong1/Desktop/header-validation-plugin",  -- Replace with a URL if you have a homepage
  license = "MIT",
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.header-validation-plugin.handler"] = "/home/kong1/Desktop/header-validation-plugin/handler.lua",
    ["kong.plugins.header-validation-plugin.schema"] = "/home/kong1/Desktop/header-validation-plugin/schema.lua",
  },
}
