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

  func testStructWithNoStaticMembers() {
    assertMacroExpansion(
      """
      @StaticMemberIterable
      struct Fruit {
        let name: String
      }
      """,
      expandedSource:
      """

      struct Fruit {
        let name: String
      }
      """,
      diagnostics: [DiagnosticSpec(message: "'@StaticMemberIterable' does not generate an empty list when there are no static members", line: 1, column: 1, severity: .warning)],
      macros: testMacros
    )
  }

  func testClassWithNoStaticMembers() {
    assertMacroExpansion(
      """
      @StaticMemberIterable
      class Fruit {
        let name: String
      }
      """,
      expandedSource:
      """

      class Fruit {
        let name: String
      }
      """,
      diagnostics: [DiagnosticSpec(message: "'@StaticMemberIterable' does not generate an empty list when there are no static members", line: 1, column: 1, severity: .warning)],
      macros: testMacros
    )
  }

  func testEnumWithNoStaticMembers() {
    assertMacroExpansion(
      """
      @StaticMemberIterable
      enum Fruit {
        case mango
      }
      """,
      expandedSource:
      """

      enum Fruit {
        case mango
      }
      """,
      diagnostics: [DiagnosticSpec(message: "'@StaticMemberIterable' does not generate an empty list when there are no static members", line: 1, column: 1, severity: .warning)],
      macros: testMacros
    )
  }
}
