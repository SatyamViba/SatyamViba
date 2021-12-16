//
//  VibaImageCache.swift
//  Viba
//
//  Created by Satyam Sutapalli on 01/12/21.
//

import Foundation
import UIKit

protocol VibaImageCache {
    /**
     Retrieves an image from the local file system. If the image does not exist it will save it
     */
    func localImage(forKey key: String, from remoteUrl: URL, completion:@escaping ((UIImage?, String) -> Void))

    /**
     Retrieves an image from the in memory cache. These images are not persisted across sessions
     */
    func inMemoryImage(forKey key: String, from url: URL, completion:@escaping ((UIImage?, String) -> Void))

    /**
     Folder name. Defaults to "ImageCacheable" unless dedicated cache object declares new name
     */
    var imageFolderName: String? { get }

    /**
     Cache object, only initialized by the conforming object if calling
     inMemoryImage(forKey:from:completion:)
     */
    var inMemoryImageCache: NSCache<AnyObject, UIImage>? { get }
}

extension VibaImageCache {
    // both properties have default values initialized on get
    var imageFolderName: String? { return "ImageCacheable" }
    var inMemoryImageCache: NSCache<AnyObject, UIImage>? { return NSCache<AnyObject, UIImage>() }

    // MARK: - Image Fetching

    func localImage(forKey key: String, from remoteUrl: URL, completion:@escaping ((UIImage?, String) -> Void)) {
        let documentsDir = imageDirectoryURL().path
        var filePathString = "\(documentsDir)/\(key)"

        if let fileExtension = fileExtension(for: remoteUrl) {
            filePathString.append(fileExtension)
        }

        let localURL = URL(fileURLWithPath: filePathString)
        let imageExistsLocally = self.fileExists(at: filePathString)
        let dataURL = imageExistsLocally ? localURL : remoteUrl
        self.fetchImage(from: dataURL, saveTo: (imageExistsLocally ? nil : localURL)) { image  in
            completion(image, key)
        }
    }

    func inMemoryImage(forKey key: String, from url: URL, completion:@escaping ((UIImage?, String) -> Void)) {
        guard let inMemoryImageCache = inMemoryImageCache else {
            fatalError("ERROR: in Memory Image Cache must be set in order to use in-memory image cache")
        }

        if let cachedImage = inMemoryImageCache.object(forKey: key as AnyObject) {
            completion(cachedImage, key)
        } else {
            fetchImage(from: url, saveTo: nil, completion: { image in
                if let image = image {
                    inMemoryImageCache.setObject(image, forKey: key as AnyObject)
                }
                completion(image, key)
            })
        }
    }

    /**
     Creates the UIImage from either local or remote url. If remote, will save to disk
     */
    private func fetchImage(from url: URL,
                            saveTo localURL: URL?,
                            session: URLSession = URLSession.shared,
                            completion:@escaping ((UIImage?) -> Void)) {
        session.dataTask(with: url) { imageData, _, error in
            do {
                guard
                    let imageData = imageData,
                    let image = UIImage(data: imageData)
                else {
                    completion(nil)
                    return
                }

                if let localURL = localURL {
                    try imageData.write(to: localURL, options: .atomic)
                }
                completion(image)
            } catch {
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }

    // MARK: - Cache Management

    /**
     Deletes the image files on disk
     */
    internal func clearLocalCache(success: (Bool) -> Void) {
        let fileManager = FileManager.default
        let imageDirectory = imageDirectoryURL()

        if fileManager.isDeletableFile(atPath: imageDirectory.path) {
            do {
                try fileManager.removeItem(atPath: imageDirectory.path)
                success(true)
            } catch {
                debugPrint(error.localizedDescription)
                success(false)
            }
        }

        success(true)
    }

    /**
     Clears the in memory image cache
     */
    internal func clearInMemoryCache(success: (Bool) -> Void) {
        guard let inMemoryImageCache = inMemoryImageCache else {
            success(false)
            return
        }

        inMemoryImageCache.removeAllObjects()
        success(true)
    }

    // MARK: - File Management

    internal func fileExtension(for url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let fileExtension = components?.url?.pathComponents.last?.components(separatedBy: ".").last else {
            return nil
        }

        return ".\(fileExtension)"
    }

    internal func fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    /**
     Returns the image folder directory
     */
    internal func imageDirectoryURL() -> URL {
        guard let imageFolderName = imageFolderName else {
            fatalError("ERROR: Image Folder Name must be set in order to use local file storage image cache")
        }

        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageFolderPath = documentsPath.appendingPathComponent(imageFolderName)
        let fileManager = FileManager.default
        var directoryExists: ObjCBool = false

        if fileManager.fileExists(atPath: imageFolderPath.path, isDirectory: &directoryExists) {
            if directoryExists.boolValue {
                return imageFolderPath
            }
        } else {
            do {
                try FileManager.default.createDirectory(atPath: imageFolderPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }

        return imageFolderPath
    }
}
