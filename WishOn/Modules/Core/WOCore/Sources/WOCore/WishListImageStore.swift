import Foundation
import UIKit

public enum WishListImageStore {
    public static let prefix = "local:"
    
    public enum SaveError: LocalizedError {
        case encodingFailed
        
        public var errorDescription: String? {
            switch self {
            case .encodingFailed:
                return "Could not save the photo."
            }
        }
    }
    
    public static func defaultDirectory() -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("WishListCovers", isDirectory: true)
    }
    
    public struct SavedPhoto {
        public let storageKey: String
        public let avatar: String
    }
    
    public static func save(_ image: UIImage, id: UUID, directory: URL = defaultDirectory()) throws -> SavedPhoto {
        let prepared = flattened(image)
        guard let data = jpegData(for: prepared) else {
            throw SaveError.encodingFailed
        }
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let filename = "\(id.uuidString).jpg"
        try data.write(to: directory.appendingPathComponent(filename), options: .atomic)
        return SavedPhoto(storageKey: prefix + filename, avatar: data.base64EncodedString())
    }
    
    public static func image(fromAvatar avatar: String?) -> UIImage? {
        guard let avatar, let data = Data(base64Encoded: avatar) else { return nil }
        return UIImage(data: data)
    }
    
    private static func jpegData(for image: UIImage) -> Data? {
        var quality: CGFloat = 0.7
        var data = image.jpegData(compressionQuality: quality)
        while let current = data, current.count > 500_000, quality > 0.35 {
            quality -= 0.1
            data = image.jpegData(compressionQuality: quality)
        }
        return data
    }
    
    public static func fileURL(for stored: String?, directory: URL = defaultDirectory()) -> URL? {
        guard let stored, stored.hasPrefix(prefix) else { return nil }
        let filename = String(stored.dropFirst(prefix.count))
        guard !filename.isEmpty, !filename.contains("/"), filename != ".", filename != ".." else {
            return nil
        }
        let url = directory.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return url
    }
    
    private static func flattened(_ image: UIImage) -> UIImage {
        let maxSide: CGFloat = 1600
        let longest = max(image.size.width, image.size.height)
        let scale = longest > maxSide ? maxSide / longest : 1
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
