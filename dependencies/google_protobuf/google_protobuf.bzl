load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

# TODO: Replace this macro with rules_proto_setup()
def google_protobuf():
    rules_proto_dependencies() # Declares @com_google_protobuf repository
    rules_proto_toolchains()

    maybe(
        repo_rule = http_archive,
        name = "google_api_protos",
        urls = ["https://github.com/googleapis/googleapis/archive/c911062bb7a1c41a208957bed923b8750f3b6f28.zip"],
        strip_prefix = "googleapis-c911062bb7a1c41a208957bed923b8750f3b6f28",
        sha256 = "9ecae675e5f169f93bf07d8ff80b51444c8eb57b10beba2e0657a317bdf378a4",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/proto/grpc_deps",
        actual = "@server_infra//framework/grpc/generator-bazel/src/main/rules:wix_grpc_dependencies",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/proto/implicit_compile_deps",
        actual = "@server_infra//framework/grpc/generator-bazel/src/main/rules:wix_implicit_gen_dependencies",
    )

    
