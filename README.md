# StaticMemberIterable

Confidently cover all static members. Like `CaseIterable`, this macro creates an array of all the static members of a type. This is useful when a type has a few examples as static members. 

Here, we have a `Chili` type so that we can discuss the heat level and names of various chilis. So far, we have two: `jalapeño` and `habenero`. For testing or for displaying in the UI, we want to confidently list both the jalapeño & the habenero. With `@StaticMemberIterable`, we can finally do si.

```
@StaticMemberIterable
struct Chili {
  let name: String
  let heatLevel: Int
  
  static let jalapeño = Chili(name: "jalapeño", heatLevel: 2)
  static let habenero = Chili(name: "habenero", heatLevel: 5)
}
```

expands to
 
```
struct Chili {
  let name: String
  let heatLevel: Int
  
  static let jalapeño = Chili(name: "jalapeño", heatLevel: 2)
  static let habenero = Chili(name: "habenero", heatLevel: 5)
  
  static let allStaticMembers = [jalapeño, habenero]
}
```

## Installation

In `Package.swift`, add the package to your dependencies.
```
.package(url: "https://github.com/FullQueueDeveloper/StaticMemberIterable.git", from: "1.0.0"),
```

And add `"StaticMemberIterable"` to the list of your target's dependencies.

When prompted by Xcode, trust the macro.


## Swift macros?

Introduced at WWDC '23, requiring Swift 5.9

## License

[BSD-3-Clause](https://opensource.org/license/bsd-3-clause/)
