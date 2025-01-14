group "default" {
  targets = ["lint", "test", "build"]
}

target "lint" {
  target = "lint"
  dockerfile = "demo3.Dockerfile"
  output = ["type=cacheonly"]
  args = {CACHE_BUST=timestamp()}
}

target "test" {
  target = "test"
  dockerfile = "demo3.Dockerfile"
  output = ["type=local,dest=coverage"]
  args = {CACHE_BUST=timestamp()}
}

target "build" {
  target = "build"
  dockerfile = "demo3.Dockerfile"
  tags = ["demo5"]
}
