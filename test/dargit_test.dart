import 'package:dargit/dargit.dart';
import 'package:test/test.dart';

import 'fake_native_lib.dart';

void main() {
  group('Repository:', () {
    var mockNativeLibrary = FakeNativeLibrary();
    var dargit = Dargit.fromNative(mockNativeLibrary);

    setUp(() {});

    test('opening repo', () async {
      var repo = dargit.openRepository("");
      expect(repo, isA<Repository>());
    });

    test("counting branches", () {
      var repo = dargit.openRepository("");
      var allBranches = repo!.branches(BranchSource.all);
      var remoteBranches = repo.branches(BranchSource.remote);
      var localBranches = repo.branches(BranchSource.local);
      expect(allBranches.length, 10);
      expect(remoteBranches.length, 3);
      expect(localBranches.length, 7);
    });
  });
}
