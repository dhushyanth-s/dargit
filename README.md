# Dargit

Libgit2 bindings for Dart Programming Language.

Currently very very new and under development.
See features list for implemented and upcoming features

If you like flutter and dart community, please considering contributing to this repo. For further instruction on how to contribute, see [Contributing to this repository](contributing.md).

If you use this library or you just want it to be developed actively, please consider donating.

# Guide

Currently, this library expects you to handle dynamically linking to `libgit2` manually, though this may change in future.

The file name of the library is:

 - For MacOS: `libgit2.dylib`
 - For Windows: `libgit2.dll`
 - For Linux: `libgit2.so`
 - For Android: `libgit2.so`
 - For iOS: You have to manually package a framework file

Place the library wherever you like and then pass the path to the `Dargit().init()` function.

**Flutter**: You have to setup dynamically linking to each target you are building. Check [Flutter Docs](https://flutter.dev/docs/development/platform-integration/c-interop#other-use-cases) for more info. Better docs will be provided after testing on all platforms have been performed.

The entry point to the library is the `Dargit` class. Use it like this:
```dart
// import the library
import 'package:dargit/dargit.dart';

// Create a instance of the library
var dargit = Dargit();

// **Important** Always initalize the library before using it.
// path parameter refers to the path to the library.
// By default, the library calls [DynamicLibrary.open("libgit2.dylib")]
dargit.init(path);
```

Then, you can use the instance to open a repository:

```dart
var repo = dargit.openRepository("/path/to/repo");
```

You can then use the repository to do whatever you want. Some examples are:

Getting all branches:

```dart
repo.branches()
```

Revision walking the repository for commits

```dart
// Do not give `count` parameter to get all commits in repository
repo.revwalk.getCommits(count: 10)
```

# Features

## Repositories
 - [x] Opening a local repository
 - [ ] Creating a new repository
 - [ ] Cloning a remote repository
 - [ ] Fetching changes from remote
 - [ ] Pushing changes to remote

## Branches
 - [x] Listing branches
 - [ ] Creating a new branch
 - [ ] Checking out a branch
 - [ ] Deleting a branch
 - [ ] Merging branches
 - [ ] Rebasing branches
 - [ ] Creating a new branch from a commit
 - [ ] Renaming a branch

## Commits
 - [x] Listing commits using revision walking
 - [x] Getting parents of a commit
 - [x] Getting message and id of each commit
 - [ ] Creating a new commit

I know there is a lot of features missing. Please feel free to open a pull request to add more entries to this list (or to even fix a typo).

# Note

The main purpose of this library is to provide a simple interface to the `libgit2` library. Therefore, some functions might not map to the `libgit2` functions exactly.

Any and all doubts are welcome. Please file an issue for it.