import 'dart:ffi' as ffi;
import 'package:dargit/src/errors/commons.dart';
import 'package:dargit/src/errors/libgit2_error.dart';
import 'package:dargit/src/framework/repository.dart';
import 'package:ffi/ffi.dart';
import '../gen/generated_bindings.dart';
import 'package:meta/meta.dart';

class Dargit {
  late NativeLibrary _lib;
  bool _init = false;

  Dargit();

  @internal
  Dargit.fromNative(this._lib) {
    _init = true;
  }

  void init({String? path}) {
    var libpath = path ?? 'libgit2.1.3.dylib';
    var lib = ffi.DynamicLibrary.open(libpath);

    var libgit = NativeLibrary(lib);
    final major = calloc<ffi.Int32>();
    final minor = calloc<ffi.Int32>();
    final revision = calloc<ffi.Int32>();
    libgit.git_libgit2_version(major, minor, revision);

    print("Libgit2 version: ${major.value}.${minor.value}.${revision.value}");
    calloc.free(major);
    calloc.free(minor);
    calloc.free(revision);
    libgit.git_libgit2_init();
    _lib = libgit;
    _init = true;
  }

  Repository? openRepository(String repoPath) {
    if (!_init) {
      throw DargitUninitializedException();
    }
    final path = repoPath.toNativeUtf8().cast<ffi.Int8>();
    final out = calloc<ffi.Pointer<git_repository>>();
    final res = _lib.git_repository_open(out, path);
    if (res != 0) throw getLastError();
    final repo = Repository.fromPointer(_lib, out.value);
    calloc.free(out);
    return repo;
  }

  // Defining here since we can't extend git object here
  LibGitInternalError getLastError() {
    final err = _lib.git_error_last();
    return LibGitInternalError(
      message: err.ref.message.cast<Utf8>().toDartString(),
      errorCode: err.ref.klass,
    );
  }
}
