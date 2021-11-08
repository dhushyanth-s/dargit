import 'package:dargit/dargit.dart';

void main() async {
  var lib = Dargit();
  lib.init(path: "./native/libgit2.1.3.dylib");
  var repo = lib.openRepository("../../BooxWoox-App-Cloud");
  print(repo!.branches(BranchSource.all));
  repo.revWalk.getCommits().forEach((commit) {
    print("-----------------");
    print("${commit.id}: ${commit.message}");
    commit.parents().forEach((element) {
      print(element.id);
    });
  });
  print("-----------------");
  //     .forEach((commit) {
  //   print("-----------------");
  //   // hash = commit.id;
  //   // print(commit.message);
  //   print(commit.id);
  //   print(commit.message);
  //   print(repo.lookupRaw(commit.id).message);
  //   // print(commit.message);
  //   // commit.dispose();
  // });
}
