import 'dart:ffi';

import 'package:dargit/gen/generated_bindings.dart';
import 'package:dargit/src/errors/libgit2_error.dart';
import 'package:ffi/ffi.dart';

abstract class GitObject {
  late final NativeLibrary _library;
  GitObject(this._library);

  LibGitInternalError getLastError(int code) {
    print("$code last error");
    if (code == git_error_code.GIT_ITEROVER) {
      return IteratorOverError();
    }
    print(code);
    final err = _library.git_error_last();
    return LibGitInternalError(
      message: err.ref.message.cast<Utf8>().toDartString(),
      errorCode: code,
    );
  }

  void throwIfError(int code) {
    if (code != 0) {
      throw getLastError(code);
    }
  }

  void dispose();
}
