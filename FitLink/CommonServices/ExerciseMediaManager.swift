import Foundation
import UniformTypeIdentifiers

/// Handles saving and removing exercise media files inside the app's document directory.
/// All file operations are asynchronous and errors are propagated for the caller to handle.
actor ExerciseMediaManager {
    static let shared = ExerciseMediaManager()

    private let fileManager = FileManager.default
    private let directory: URL
    private let maxFileSize: Int = 15 * 1024 * 1024 // 15 MB

    enum MediaError: LocalizedError {
        case fileTooLarge
        case unsupportedFormat

        var errorDescription: String? {
            switch self {
            case .fileTooLarge:
                return NSLocalizedString("Media.Error.TooLarge", comment: "")
            case .unsupportedFormat:
                return NSLocalizedString("Media.Error.Unsupported", comment: "")
            }
        }
    }

    private init() {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.directory = docs.appendingPathComponent("exerciseMedia", isDirectory: true)
    }

    /// Stores media for an exercise from a temporary URL. Returns the final file location.
    func saveMedia(for exerciseId: UUID, from tempURL: URL) async throws -> URL {
        try await ensureDirectory()
        try validateFile(tempURL)
        let targetURL = directory.appendingPathComponent("\(exerciseId).\(tempURL.pathExtension)")
        if fileManager.fileExists(atPath: targetURL.path) {
            try fileManager.removeItem(at: targetURL)
        }
        try fileManager.copyItem(at: tempURL, to: targetURL)
        return targetURL
    }

    /// Removes media for the provided exercise id if it exists.
    func removeMedia(for exerciseId: UUID) async throws {
        guard let existing = try currentMediaURL(for: exerciseId) else { return }
        try fileManager.removeItem(at: existing)
    }

    /// Replaces existing media with a new file.
    func updateMedia(for exerciseId: UUID, with tempURL: URL) async throws -> URL {
        try await removeMedia(for: exerciseId)
        return try await saveMedia(for: exerciseId, from: tempURL)
    }

    /// Cleans up orphaned files that don't correspond to any provided exercise ids.
    func cleanup(orphanedAgainst exerciseIds: Set<UUID>) async throws {
        try await ensureDirectory()
        let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        for url in contents {
            let idString = url.deletingPathExtension().lastPathComponent
            if let uuid = UUID(uuidString: idString), !exerciseIds.contains(uuid) {
                try? fileManager.removeItem(at: url)
            }
        }
    }

    // MARK: - Helpers
    private func ensureDirectory() async throws {
        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }

    private func validateFile(_ url: URL) throws {
        let attrs = try fileManager.attributesOfItem(atPath: url.path)
        if let size = attrs[.size] as? NSNumber, size.intValue > maxFileSize {
            throw MediaError.fileTooLarge
        }
        guard
            let type = UTType(filenameExtension: url.pathExtension),
            type.conforms(to: .image) || type.conforms(to: .movie) || type == .gif
        else {
            throw MediaError.unsupportedFormat
        }
    }

    private func currentMediaURL(for exerciseId: UUID) throws -> URL? {
        let contents = try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        return contents?.first { $0.deletingPathExtension().lastPathComponent == exerciseId.uuidString }
    }
}
