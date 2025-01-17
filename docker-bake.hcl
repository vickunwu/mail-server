group "default" {
  targets = ["build"]
}
variable "TARGET" {
  default = "$TARGET"
}
variable "ARTIFACT_REPO" {
  default = "$ARTIFACT_REPO"
}
variable "BUILD_ENV" {
  default = "$BUILD_ENV"
}
variable "ZIG_VERSION" {
  default = "$ZIG_VERSION"
}
variable "DOCKER_PLATFORM" {
  default = "$DOCKER_PLATFORM"
}
target "docker-metadata-action" {}
target "build" {
  secret = [
    "type=env,id=ACTIONS_CACHE_URL",
    "type=env,id=ACTIONS_RUNTIME_TOKEN"
  ]
  args = {
    TARGET = "${TARGET}"
    BUILD_ENV = equal("", "${BUILD_ENV}") ? null : "${BUILD_ENV}"
    ZIG_VERSION = "${ZIG_VERSION}"
  }
  target = "binaries"
  cache-from = [
    "type=registry,ref=${ARTIFACT_REPO}:buildcache-${TARGET}"
  ]
  cache-to = [
    "type=registry,ref=${ARTIFACT_REPO}:buildcache-${TARGET},mode=max,compression=zstd,compression-level=9,force-compression=true,oci-mediatypes=true,image-manifest=false"
  ]
  context = "./"
  dockerfile = "Dockerfile.build"
  output = ["./artifact"]
}
target "image" {
  inherits = ["build","docker-metadata-action"]
  cache-to = [""]
  cache-from = [
    "type=registry,ref=${ARTIFACT_REPO}:buildcache-${TARGET}"
  ]
  target = "${regexall("(?P<arch>[^-]+)-unknown-linux-(?P<tgt>.+)", TARGET)[0].tgt}-${DOCKER_PLATFORM}"
  output = ["type=image,push=true,compression=zstd,compression-level=9,force-compression=true,oci-mediatypes=true"]
}
