import 'dart:ffi';
import 'package:dargit/gen/generated_bindings.dart';
import 'package:dargit/src/internals/git_object.dart';
import 'package:ffi/ffi.dart';

enum BranchType { local, remote }

class Branch extends GitObject {
  late String name;
  late bool isCheckedOut;
  late Pointer<git_reference> _ptr;
  late BranchType type;
  late final NativeLibrary _library;

  Branch(
    this._library, {
    required this.name,
    required this.type,
    this.isCheckedOut = false,
  }) : super(_library);

  Branch.fromPointer(this._library, this._ptr, this.type) : super(_library) {
    final out = calloc<Pointer<Int8>>();
    _library.git_branch_name(out, _ptr);
    final code = _library.git_branch_is_checked_out(_ptr);
    switch (code) {
      case 0:
        isCheckedOut = false;
        break;
      case 1:
        isCheckedOut = true;
        break;
      default:
        throw getLastError(code);
    }

    name = out.value.cast<Utf8>().toDartString();
    calloc.free(out);
  }

  @override
  void dispose() {
    _library.git_reference_free(_ptr);
  }

  @override
  String toString() {
    return name;
  }
}
