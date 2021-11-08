import 'package:dargit/gen/generated_bindings.dart';

class LibGitInternalError implements Exception {
  String message;
  int errorCode;

  LibGitInternalError({required this.message, required this.errorCode});

  @override
  String toString() {
    return "Error $errorCode: $message";
  }
}

class IteratorOverError extends LibGitInternalError {
  IteratorOverError()
      : super(
          message: "Iterator over",
          errorCode: git_error_code.GIT_ITEROVER,
        );
}
