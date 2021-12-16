//
//  CacheManager.swift
//  Viba
//
//  Created by Satyam Sutapalli on 14/12/21.
//

import Foundation

final class Cache {
    static let manager = Cache()
    private init() {}

    // Get user's cache directory path
    private var getCacheDirectoryPath: URL {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectoryPath = arrayPaths[0]
        return cacheDirectoryPath
    }

    func save(data: Data, with name: String) {
        let path = getCacheDirectoryPath.appendingPathComponent(name.sha256)
        try? data.write(to: path)
    }

    private func data(from name: String) -> Data? {
        let path = getCacheDirectoryPath.appendingPathComponent(name.sha256)
        return try? Data(contentsOf: path)
    }

    func get(from path: String, onCompletion handler: @escaping ((Data?) -> Void)) {
        if let fileData = self.data(from: path) {
            handler(fileData)
        } else {
            _ = NetworkManager.shared.downloadAsset(urlString: path) { url, location in
                if let loc = location {
                    let destPath = self.getCacheDirectoryPath.appendingPathComponent(url.sha256)
                    do {
                        try FileManager.default.moveItem(at: loc, to: destPath)
                        let fileData = try Data(contentsOf: destPath)
                        handler(fileData)
                    } catch {
                        handler(nil)
                    }
                }
            }
        }
    }
}
