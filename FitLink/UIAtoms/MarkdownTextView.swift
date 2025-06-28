import SwiftUI

/// Simple view that renders a small subset of Markdown (bold and italics)
/// while ignoring unsupported elements. Emojis are rendered as part of the text.
struct MarkdownTextView: View {
    /// Raw markdown text to display
    let text: String

    var body: some View {
        parsedText(from: text)
            .multilineTextAlignment(.leading)
    }

    /// Parses the input markdown and returns a concatenated `Text` view.
    private func parsedText(from string: String) -> Text {
        let tokens = MarkdownParser.parse(string)
        // Build the Text by concatenating styled segments
        return tokens.reduce(Text("")) { partial, token in
            partial + token.asText()
        }
    }
}

/// Token representing a piece of markdown text with a specific style.
private struct MarkdownToken {
    enum Style {
        case normal, bold, italic, boldItalic
    }

    var text: String
    var style: Style

    /// Converts the token to a SwiftUI `Text` with the correct formatting.
    func asText() -> Text {
        var result = Text(text)
            .font(Theme.font.body)
        switch style {
        case .bold:
            result = result.bold()
        case .italic:
            result = result.italic()
        case .boldItalic:
            result = result.bold().italic()
        case .normal:
            break
        }
        return result
    }
}

/// Basic Markdown parser supporting bold (**text**) and italics (*text*).
/// Unsupported syntax is rendered as plain text.
private enum MarkdownParser {
    static func parse(_ text: String) -> [MarkdownToken] {
        var tokens: [MarkdownToken] = []
        var index = text.startIndex
        var buffer = ""
        var isBold = false
        var isItalic = false

        func flush() {
            guard !buffer.isEmpty else { return }
            let style: MarkdownToken.Style
            switch (isBold, isItalic) {
            case (true, true): style = .boldItalic
            case (true, false): style = .bold
            case (false, true): style = .italic
            default: style = .normal
            }
            tokens.append(MarkdownToken(text: buffer, style: style))
            buffer.removeAll()
        }

        while index < text.endIndex {
            if text[index...].hasPrefix("**") {
                // Look ahead for a closing '**'
                let searchStart = text.index(index, offsetBy: 2)
                if let _ = text.range(of: "**", range: searchStart..<text.endIndex) {
                    flush()
                    isBold.toggle()
                    index = text.index(index, offsetBy: 2)
                    continue
                } else {
                    buffer.append("**")
                    index = text.index(index, offsetBy: 2)
                    continue
                }
            } else if text[index] == "*" {
                // Look ahead for a closing '*'
                let searchStart = text.index(after: index)
                if let _ = text.range(of: "*", range: searchStart..<text.endIndex) {
                    flush()
                    isItalic.toggle()
                    index = text.index(after: index)
                    continue
                } else {
                    buffer.append("*")
                    index = text.index(after: index)
                    continue
                }
            }

            buffer.append(text[index])
            index = text.index(after: index)
        }
        flush()
        return tokens
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
