import StaticMemberIterable

struct MyRecord {
  // ...
  @StaticMemberIterable
  enum Fixtures {
    static let a = MyRecord()
    static let b = MyRecord()
  }
}

print(MyRecord.Fixtures.allStaticMembers)
