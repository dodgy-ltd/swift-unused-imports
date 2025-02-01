# swift-unused-imports
Tool to find and remove unneeded imports for Swift code using a brute force, dumb as a rock, approach.

## Wait, Doesn't SwiftLint Do This? Why does this exist?
SwiftLint has a feature to remmove unsed dependencies via an analyze pass, but I can't make it work. It removes dependencies which are required, breaking the build, seemingly due to transitive dependencies. For example, the natural thing to do is `import SwiftUI`, but if the structure you're using is in `SwiftUICore` then it seems SwiftLint will remove the `SwiftUI` dependency, breaking the code. At least, I think that's what's happening. The proposed SwiftLint solution to this is to explicitly include every submodules, requiring your code to import many more modules in every files. This seems less than useful to me, but perhaps this system can be fixed in future.

The nature of the approach used by `swiftlint anaylze` is also tied to a particular xcodebuild, which may be a problem if a dependency is used in one build path but not another. It's seems like it should also be possible to add conditional compilation to the import statements themselves to resolve this case, but that may not be preferred.

There is also an tool called [Periphery](https://github.com/peripheryapp/periphery?tab=readme-ov-file#unused-imports) which seems to have similar challenges to SwiftLint.

There is also a tool called [funimp](https://github.com/edmundmok/funimp/blob/master/README.md) which is pretty much exactly the same as this tool, but written as a bash script.

## The Future
* Support non-macOS platforms.
