import SwiftUI

/// View that renders a subset of Markdown (bold and italics) while keeping
/// emojis inline. Unsupported elements are shown as plain text.
struct MarkdownTextView: View {
    /// Raw markdown text to display
    let text: String

    var body: some View {
        Text(MarkdownRenderer.attributedString(from: text))
            .font(Theme.font.body)
            .multilineTextAlignment(.leading)
    }
}

/// Helper responsible for converting markdown strings into `AttributedString`
/// instances using the Foundation parser available on iOS 15+.
enum MarkdownRenderer {
    static func attributedString(from string: String) -> AttributedString {
        let options = AttributedString.MarkdownParsingOptions(
            interpretedSyntax: .inlineOnlyPreservingWhitespace
        )
        if let parsed = try? AttributedString(markdown: string, options: options) {
            return parsed
        } else {
            return AttributedString(string)
        }
    }
}

#if DEBUG
#Preview {
    VStack(alignment: .leading, spacing: Theme.spacing.small) {
        MarkdownTextView(text: "This is **bold** text, this is *italic*, and here is a smiley 😄.")
        MarkdownTextView(text: "Nested **bold and *italic* together** works as well.")
        MarkdownTextView(text: "Unmatched asterisks *are rendered** literally.")
    } //: VStack
    .padding()
}
#endif
