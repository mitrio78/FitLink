import SwiftUI

enum AppSize {
    static let numberPadButtonHeight: CGFloat = 44
    static let sheetHandleWidth: CGFloat = 40
    static let sheetHandleHeight: CGFloat = 4
    /// Preferred height of the custom number pad sheet.
    /// Calculated as:
    ///  - ~56 pt for picker section and drag indicator
    ///  - ~48 pt value display
    ///  - 4 rows of buttons at 44 pt each plus spacing
    ///  - ~52 pt Done button plus padding
    ///  - Remaining paddings between blocks
    ///  = ~394 pt total
    static let numberPadSheetHeight: CGFloat = 412

    /// Default height for an approach card in the workout session.
    static let approachCardHeight: CGFloat = 64

    /// Height of an approach card when only one metric is displayed in
    /// compact mode.
    static let compactApproachSingleHeight: CGFloat = 44

    /// Height of an approach card when two or more metrics are displayed in
    /// compact mode.
    static let compactApproachMultiHeight: CGFloat = 56
}
