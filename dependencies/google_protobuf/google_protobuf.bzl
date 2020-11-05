load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

def google_protobuf():
    rules_proto_dependencies()
    rules_proto_toolchains()

    native.bind(
        name = "io_bazel_rules_scala/dependency/proto/grpc_deps",
        actual = "@server_infra//framework/grpc/generator-bazel/src/main/rules:wix_grpc_dependencies",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/proto/implicit_compile_deps",
        actual = "@server_infra//framework/grpc/generator-bazel/src/main/rules:wix_implicit_gen_dependencies",
    )

    
