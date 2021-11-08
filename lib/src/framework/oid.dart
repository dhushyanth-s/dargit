import 'dart:ffi';
import 'package:meta/meta.dart';

import 'package:dargit/gen/generated_bindings.dart';
import 'package:dargit/src/internals/git_object.dart';

class Oid extends GitObject {
  @internal
  late Pointer<git_oid> id;
  late final NativeLibrary _lib;

  Oid(this.id, this._lib) : super(_lib);

  @override
  void dispose() {
  }
}
