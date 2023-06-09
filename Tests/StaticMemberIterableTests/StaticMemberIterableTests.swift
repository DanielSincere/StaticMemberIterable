import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import StaticMemberIterableMacros

let testMacros: [String: Macro.Type] = [
  "StaticMemberIterable": StaticMemberIterableMacro.self,
]

final class StaticMemberIterableTests: XCTestCase {
  func testEnumWithOnlyStaticMembers() {
    assertMacroExpansion(
    """
    struct MyRecord {
      @StaticMemberIterable
      enum Fixtures {
        static let a = MyRecord()
        static let b = MyRecord()
      }
    }
    """,
    expandedSource:
    """
    struct MyRecord {
      enum Fixtures {
        static let a = MyRecord()
        static let b = MyRecord()
        static let allStaticMembers = [a, b]
      }
    }
    """,
    macros: testMacros
    )
  }

  func testEnumWithCasesAndStaticMembers() {
    assertMacroExpansion(
    """
    @StaticMemberIterable
    enum Flavors {
      case red, green
      case blue
      static let original = Flavors.blue
      static let newest = Flavors.green
    }
    """,
    expandedSource:
    """

    enum Flavors {
      case red, green
      case blue
      static let original = Flavors.blue
      static let newest = Flavors.green
      static let allStaticMembers = [original, newest]
    }
    """,
    macros: testMacros
    )
  }

  func testStructWithStaticMembers() {
    assertMacroExpansion(
      """
      @StaticMemberIterable
      struct Chili {
        let name: String
        let heatLevel: Int
        static let jalapeño = Chili(name: "jalapeño", heatLevel: 2)
        static let habenero = Chili(name: "habenero", heatLevel: 5)
      }
      """,
      expandedSource:
      """

      struct Chili {
        let name: String
        let heatLevel: Int
        static let jalapeño = Chili(name: "jalapeño", heatLevel: 2)
        static let habenero = Chili(name: "habenero", heatLevel: 5)
        static let allStaticMembers = [jalapeño, habenero]
      }
      """,
      macros: testMacros
    )
  }
}
