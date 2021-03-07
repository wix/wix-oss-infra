load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@wix_oss_infra//dependencies/test_network_sandboxing:download_network_sandboxing.bzl", "download_network_sandboxing_according_to_os")
load("@main_repository_name//:defs.bzl", "main_repository_name")

_default_rules_scala_version = "fb6e0f0c9383816bddccdbb1e04c90f51a8edb89"
_default_rules_scala_version_sha256 = "3bd0152f59c28947020fb9717eb57f8e5093c7abd8da361780752d4088e5ea17"

_EXPERIMENTAL_REPOS = ["wix_ci", "bazel_tooling", "core_server_build_tools"]
_EXPRIMENT_ON = True

_exprimental_rules_scala_version = "fb6e0f0c9383816bddccdbb1e04c90f51a8edb89"
_experimental_rules_scala_version_sha256 = "3bd0152f59c28947020fb9717eb57f8e5093c7abd8da361780752d4088e5ea17"

RULES_SCALA_TOGGLES = {}

def _rules_scala_version():
    if _EXPRIMENT_ON and main_repository_name in _EXPERIMENTAL_REPOS:
        return _exprimental_rules_scala_version
    else:
        return _default_rules_scala_version

def _rules_scala_version_sha256():
    if _EXPRIMENT_ON and main_repository_name in _EXPERIMENTAL_REPOS:
        return _experimental_rules_scala_version_sha256
    else:
        return _default_rules_scala_version_sha256

rules_scala_version = _rules_scala_version()
rules_scala_version_sha256 = _rules_scala_version_sha256()

def rules_scala():
    if native.existing_rule("test_network_sandboxing") == None:
        download_network_sandboxing_according_to_os(name = "test_network_sandboxing")

    if native.existing_rule("io_bazel_rules_scala") == None:
        http_archive(
            name = "io_bazel_rules_scala",
            url = "https://github.com/bazelbuild/rules_scala/archive/%s.zip" % rules_scala_version,
            type = "zip",
            strip_prefix = "rules_scala-%s" % rules_scala_version,
            sha256 = rules_scala_version_sha256,
        )
