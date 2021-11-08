import 'dart:collection';
import 'dart:ffi';

import 'package:dargit/gen/generated_bindings.dart';
import 'package:dargit/src/errors/libgit2_error.dart';
import 'package:dargit/src/internals/git_object.dart';
import 'package:ffi/ffi.dart';

import '../../dargit.dart';
import 'commit.dart';

class RevWalk extends GitObject {
  late final NativeLibrary _lib;
  late final Pointer<git_revwalk> _revWalk;
  late final Pointer<git_repository> _repo;

  RevWalk(this._lib, this._repo) : super(_lib) {
    var revWalk = calloc<Pointer<git_revwalk>>();
    throwIfError(_lib.git_revwalk_new(revWalk, _repo));
    throwIfError(_lib.git_revwalk_push_head(revWalk.value));
    _revWalk = revWalk.value;
    calloc.free(revWalk);
  }

  RevWalk.fromPointer(this._lib, this._revWalk, this._repo) : super(_lib);

  List<Commit> getCommits({int? count}) {
    final res = <Commit>[];
    var c = 0;
    while (count == null || c < count) {
      final commit = _getNextCommit();
      if (commit == null) break;
      res.add(commit);
    }
    return res;
  }

  Commit? _getNextCommit() {
    var oid = calloc<git_oid>();
    final res = _lib.git_revwalk_next(oid, _revWalk);
    if (res == git_error_code.GIT_ITEROVER) {
      calloc.free(oid);
      _hasReset();
      return null;
    }
    throwIfError(res);
    final commit = calloc<Pointer<git_commit>>();
    throwIfError(_lib.git_commit_lookup(commit, _repo, oid));
    var commitObj = Commit.fromPointer(commit.value, _lib, _repo);
    calloc.free(commit);
    return commitObj;
  }

  void _hasReset() {
    throwIfError(_lib.git_revwalk_push_head(_revWalk));
  }

  @override
  void dispose() {
    _lib.git_revwalk_free(_revWalk);
  }
}
