// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'package:dargit/dargit.dart';
import 'package:dargit/gen/generated_bindings.dart';
import 'package:mockito/mockito.dart';
import "package:ffi/ffi.dart";

class FakeNativeLibrary extends Fake implements NativeLibrary {
  late List<Branch> branches;
  late int branchesType;
  int branchIndex = -1;
  FakeNativeLibrary() {
    branches = [
      Branch(this, name: "hello", type: BranchType.local),
      Branch(this, name: "hello", type: BranchType.remote),
      Branch(this, name: "hello", type: BranchType.local),
      Branch(this, name: "hello", type: BranchType.local),
      Branch(this, name: "hello", type: BranchType.local),
      Branch(this, name: "hello", type: BranchType.remote),
      Branch(this, name: "hello", type: BranchType.local),
      Branch(this, name: "hello", type: BranchType.local),
      Branch(this, name: "hello", type: BranchType.remote),
      Branch(this, name: "hello", type: BranchType.local),
    ];
  }
  @override
  int git_repository_open(
          Pointer<Pointer<git_repository>> out, Pointer<Int8> path) =>
      0;

  @override
  int git_revwalk_new(
          Pointer<Pointer<git_revwalk>> _, Pointer<git_repository> __) =>
      0;

  @override
  int git_revwalk_push_head(Pointer<git_revwalk> walk) => 0;

  @override
  int git_commit_lookup(Pointer<Pointer<git_commit>> commit,
          Pointer<git_repository> repo, Pointer<git_oid> id) =>
      0;

  @override
  int git_branch_iterator_new(Pointer<Pointer<git_branch_iterator>> out,
      Pointer<git_repository> repo, int list_flags) {
    branchIndex = -1;
    branchesType = list_flags;
    return 0;
  }

  @override
  int git_branch_next(Pointer<Pointer<git_reference>> out,
      Pointer<Int32> out_type, Pointer<git_branch_iterator> iter) {
    late List<BranchType> branchSource;
    switch (branchesType) {
      case git_branch_t.GIT_BRANCH_ALL:
        branchSource = [BranchType.local, BranchType.remote];
        break;
      case git_branch_t.GIT_BRANCH_LOCAL:
        branchSource = [BranchType.local];
        break;
      case git_branch_t.GIT_BRANCH_REMOTE:
        branchSource = [BranchType.remote];
        break;
    }
    var equivalent = branches.where((element) => branchSource.contains(element.type)).toList();
    branchIndex++;
    return branchIndex > equivalent.length - 1 ? git_error_code.GIT_ITEROVER : 0;
  }

  @override
  int git_branch_iterator_free(Pointer<git_branch_iterator> iter) => 0;

  @override
  int git_branch_name(Pointer<Pointer<Int8>> out, Pointer<git_reference> ref) {
    out.value = branches[branchIndex].name.toNativeUtf8().cast<Int8>();
    return 0;
  }

  @override
  int git_branch_is_checked_out(Pointer<git_reference> branch) =>
      branchIndex == 0 ? 1 : 0;
}
