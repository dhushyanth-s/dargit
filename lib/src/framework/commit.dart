import 'dart:ffi';
import 'package:meta/meta.dart';

import 'package:dargit/gen/generated_bindings.dart';
import 'package:dargit/src/internals/git_object.dart';
import 'package:equatable/equatable.dart';
import 'package:ffi/ffi.dart';

import 'oid.dart';

class Commit extends GitObject with EquatableMixin {
  late final String message;
  late final NativeLibrary _lib;
  late final Pointer<git_oid> _id;
  late final Pointer<git_repository> _repo;
  Pointer<Int8>? _idString;

  Commit.fromPointer(Pointer<git_commit> ptr, this._lib, this._repo)
      : super(_lib) {
    _id = _lib.git_commit_id(ptr);
    message = _lib.git_commit_message(ptr).cast<Utf8>().toDartString();
    _lib.git_commit_free(ptr);
  }

  Commit.fromId(Oid id, this._lib, this._repo) : super(_lib) {
    var commit = calloc<Pointer<git_commit>>();
    throwIfError(_lib.git_commit_lookup(commit, _repo, id.id));
    _id = _lib.git_commit_id(commit.value);
    message = _lib.git_commit_message(commit.value).cast<Utf8>().toDartString();
    _lib.git_commit_free(commit.value);
    calloc.free(commit);
  }

  String get id {
    _idString = _lib.git_oid_tostr_s(_id);
    return _idString!.cast<Utf8>().toDartString();
  }

  /// Must be disposed immediately after usage by calling [disposePtr], causes memory leaks otherwise
  Pointer<git_commit> _getPtr() {
    final ptr = calloc<Pointer<git_commit>>();
    throwIfError(_lib.git_commit_lookup(ptr, _repo, _id));
    var res = ptr.value;
    calloc.free(ptr);
    return res;
  }

  // void lookupMessage() {
  //   var ptr = _getPtr();
  //   // _disposePtr(ptr);
  // }

  void _disposePtr(Pointer<git_commit> ptr) {
    _lib.git_commit_free(ptr);
  }

  List<Commit> parents() {
    var thisptr = _getPtr();
    final parentCount = _lib.git_commit_parentcount(thisptr);
    final parents = <Commit>[];
    for (var i = 0; i < parentCount; i++) {
      var id = _lib.git_commit_parent_id(thisptr, i);
      parents.add(Commit.fromId(Oid(id, _lib), _lib, _repo));
    }
    _disposePtr(thisptr);
    return parents;
  }

  @override
  void dispose() {
    calloc.free(_id);
    if (_idString != null) {
      calloc.free(_idString!);
    }
  }

  @override
  List<Object?> get props => [id];
}
