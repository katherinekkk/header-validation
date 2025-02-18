package = "header-encode-plugin"
version = "0.1.0-1"
rockspec_format = "1.0"
 
dependencies = {
  "kong >= 2.0.0",
}
 
source = {
  url = "/home/kong3/Desktop/header-encode-plugin", -- Use file URL for local paths
}
 
description = {
  summary = "A Kong plugin to validate headers and encode it",
  homepage = "/home/kong3/Desktop/header-encode-plugin",
  license = "MIT",
}
 
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.header-encode-plugin.handler"] = "/home/kong3/Desktop/header-encode-plugin/handler.lua",
    ["kong.plugins.header-encode-plugin.schema"] = "/home/kong3/Desktop/header-encode-plugin/schema.lua",
  },
}