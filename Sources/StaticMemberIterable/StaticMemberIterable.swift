// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(allStaticMembers))
public macro StaticMemberIterable() -> () = #externalMacro(module: "StaticMemberIterableMacros", type: "StaticMemberIterableMacro")
