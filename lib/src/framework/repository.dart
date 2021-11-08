import 'dart:ffi';
import 'package:dargit/dargit.dart';
import 'package:dargit/src/framework/rev_walk.dart';
import 'package:dargit/src/internals/git_object.dart';
import 'package:ffi/ffi.dart';

import '../../gen/generated_bindings.dart';
import 'branch.dart';

enum BranchSource { local, remote, all }

class Repository extends GitObject {
  late final Pointer<git_repository> _native;
  late final NativeLibrary _lib;
  late final RevWalk revWalk;

  Repository.fromPointer(this._lib, this._native) : super(_lib) {
    revWalk = RevWalk(_lib, _native);
  }

  List<Branch> branches(BranchSource source) {
    final iterator = calloc<Pointer<git_branch_iterator>>();
    var s = git_branch_t.GIT_BRANCH_ALL;

    switch (source) {
      case BranchSource.all:
        s = git_branch_t.GIT_BRANCH_ALL;
        break;
      case BranchSource.local:
        s = git_branch_t.GIT_BRANCH_LOCAL;
        break;
      case BranchSource.remote:
        s = git_branch_t.GIT_BRANCH_REMOTE;
        break;
      default:
    }

    throwIfError(_lib.git_branch_iterator_new(iterator, _native, s));

    var branches = <Branch>[];

    while (true) {
      final branch = calloc<Pointer<git_reference>>();
      final branchType = calloc<Int32>();
      final r = _lib.git_branch_next(branch, branchType, iterator.value);
      if (r == git_error_code.GIT_ITEROVER) {
        break;
      }
      throwIfError(r);

      branches.add(
        Branch.fromPointer(
          _lib,
          branch.value,
          branchType.value == git_branch_t.GIT_BRANCH_REMOTE
              ? BranchType.remote
              : BranchType.local,
        ),
      );
      calloc.free(branchType);
      calloc.free(branch);
    }
    _lib.git_branch_iterator_free(iterator.value);
    return branches;
  }

  Commit lookup(String id) {
    final oid = calloc<git_oid>();
    final r = _lib.git_oid_fromstr(oid, id.toNativeUtf8().cast<Int8>());
    if (r != 0) {
      throwIfError(r);
    }
    final commit = calloc<Pointer<git_commit>>();
    throwIfError(_lib.git_commit_lookup(commit, _native, oid));
    var res = commit.value;
    return Commit.fromPointer(res, _lib, _native);
  }

  @override
  void dispose() {
    _lib.git_repository_free(_native);
    revWalk.dispose();
  }
}
