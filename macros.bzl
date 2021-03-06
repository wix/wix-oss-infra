load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def resources(name = "resources", runtime_deps=[], testonly = 0, tags = [], visibility=None):
    native.java_library(
        name = name,
        resources = native.glob(["**"],exclude=["BUILD"]),
        resource_strip_prefix = "%s/" % native.package_name(),
        runtime_deps = runtime_deps,
        testonly = testonly,
        tags = tags,
        visibility = visibility
    )


def maven_archive(name, artifact):
  http_archive(
      name = name,
      urls = _convert_to_url(artifact),
      build_file_content = """filegroup(name = "unpacked", srcs = glob(["**/*"],exclude=["BUILD.bazel","WORKSPACE","*.zip","*.tar.gz"]), visibility = ["//visibility:public"])
filegroup(name = "archive", srcs = glob(["*.zip","*.tar.gz"]), visibility = ["//visibility:public"])
"""
  )

def maven_proto(name, artifact, deps = []):
  http_archive(
      name = name,
      urls = _convert_to_url(artifact),
      build_file_content = """load("@server_infra//framework/protos:well_known_protos.bzl", "WIX_PROTOS")
proto_library(name = "proto", srcs = glob(["**/*.proto"]), deps = {deps} + WIX_PROTOS, visibility = ["//visibility:public"])""".format(deps = deps)
  )

def _convert_to_url(artifact):
    parts = artifact.split(":")
    group_id_part = parts[0].replace(".","/")
    artifact_id = parts[1]
    version = parts[2]
    packaging = "jar"
    classifier_part = ""
    if len(parts) == 4:
      packaging = parts[2]
      version = parts[3]
    elif len(parts) == 5:
      packaging = parts[2]
      classifier_part = "-"+parts[3]
      version = parts[4]

    final_name = artifact_id + "-" + version + classifier_part + "." + packaging
    url_suffix = group_id_part+"/"+artifact_id + "/" + version + "/" + final_name
    url_prefix = "https://repo.dev.wixpress.com/artifactory/%s/"
    return [url_prefix % "libs-snapshots" + url_suffix,
            url_prefix % "libs-releases" + url_suffix,]


def _package_visibility(pacakge_name):
    return ["//{p}:__pkg__".format(p=pacakge_name)]
 

def sources(visibility = None):
    if visibility == None:
      visibility = _package_visibility(native.package_name())
    native.filegroup(
       name = "sources",
       srcs = native.glob(["*.java"], allow_empty=True) + native.glob(["*.scala"], allow_empty=True),
       visibility = visibility,
    )

