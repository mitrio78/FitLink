import Foundation
import UniformTypeIdentifiers

extension URL {
    var isVideo: Bool {
        if let type = UTType(filenameExtension: pathExtension) {
            return type.conforms(to: .movie)
        }
        return false
    }
}

extension URL: Identifiable {
    public var id: URL { self }
}
