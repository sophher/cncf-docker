group "default" {
  targets = ["test", "build"]
}

target "test" {
  target = "test"
  dockerfile = "demo3.Dockerfile"
  tags = ["demo4"]
  output = ["type=local,dest=coverage"]
}

target "build" {
  target = "build"
  dockerfile = "demo3.Dockerfile"
  tags = ["demo4"]
}
