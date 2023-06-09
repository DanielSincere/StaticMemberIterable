import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct StaticMemberIterableMacro: MemberMacro {
  public static func expansion<Declaration, Context>(
    of node: SwiftSyntax.AttributeSyntax,
    providingMembersOf declaration: Declaration,
    in context: Context) throws -> [SwiftSyntax.DeclSyntax] where Declaration : SwiftSyntax.DeclGroupSyntax, Context : SwiftSyntaxMacros.MacroExpansionContext {

      let staticMemberNames: [String] = declaration.memberBlock.members
        .flatMap { (memberDeclListItemSyntax: MemberDeclListItemSyntax) in
          memberDeclListItemSyntax
            .children(viewMode: .fixedUp)
            .compactMap({ $0.as(VariableDeclSyntax.self) })
        }
        .compactMap { (variableDeclSyntax: VariableDeclSyntax) in
          guard variableDeclSyntax.hasStaticModifier else {
            return nil
          }
          return variableDeclSyntax.bindings
            .compactMap { (patternBindingSyntax: PatternBindingSyntax) in
              patternBindingSyntax.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            }
            .first
        }
      return ["static let allStaticMembers = [\(raw: staticMemberNames.joined(separator: ", "))]"]
    }
}

private extension VariableDeclSyntax {
  var hasStaticModifier: Bool {
    guard let modifiers = self.modifiers else {
      return false
    }

    return modifiers.children(viewMode: .fixedUp)
      .compactMap { syntax in
        syntax.as(DeclModifierSyntax.self)?
          .children(viewMode: .fixedUp)
          .contains { syntax in
            switch syntax.as(TokenSyntax.self)?.tokenKind {
            case .keyword(.static):
              return true
            default:
              return false
            }
          }
      }
      .contains(true)
  }
}

@main
struct StaticMemberIterablePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StaticMemberIterableMacro.self,
  ]
}
