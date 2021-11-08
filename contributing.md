# Contributing Guidelines

All contributions are welcome. You can contribute in any of the following ways

1. Making a pull request
2. Filing a issue for a bug or a feature request
3. Writing documentation for the library
4. Donating to the contributors

The remainder of this document will help developers getting around the repo.

## Folder Structure

I do not know the _standard_ folder structure for a repo, so here's how how I have scaffolded mine

```
lib/
├── dargit.dart // Main file that other programs import.
| 				//  Contains all the exports
├── src/
| 	├── dargit_base.dart // Contains the base class `Dargit`
│   ├── framework/ // Contains all the main objects. Ex: `Repository`, `Branch`, `Commit`
│   │   └── ...
│   ├── internals/ // Contains all the internal objects. 
|	|	└── ...		// These are not meant to be used by external applications
│   └── errors/ // Errors thrown by the library
|		└── ...
└── gen/
	└── generated_bindings.dart // Contains the generated bindings to libgit2
```

Other documentation regarding each file is contained in the file itself.

Enjoy contributing!