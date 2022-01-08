//
//  CGImage+FaceCrop.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/12/21.
//

import Foundation
import Vision
import CoreGraphics
import CoreImage
import VideoToolbox

public extension CGImage {
    func faceCrop(margin: CGFloat = 200, completion: @escaping (FaceCropResult) -> Void) {
        let req = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let results = request.results, !results.isEmpty else {
                completion(.notFound)
                return
            }

            var faces: [VNFaceObservation] = []
            for result in results {
                guard let face = result as? VNFaceObservation else { continue }
                faces.append(face)
            }

            let croppingRect = self.getCroppingRect(for: faces, margin: margin)
            let faceImage = self.cropping(to: croppingRect)

            guard let result = faceImage else {
                completion(.notFound)
                return
            }
            completion(.success(result))
        }

        do {
            try VNImageRequestHandler(cgImage: self, options: [:]).perform([req])
        } catch {
            completion(.failure(error))
        }
    }

    private func getCroppingRect(for faces: [VNFaceObservation], margin: CGFloat) -> CGRect {
        var totalX = CGFloat(0)
        var totalY = CGFloat(0)
        var totalW = CGFloat(0)
        var totalH = CGFloat(0)
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        let numFaces = CGFloat(faces.count)

        for face in faces {
            let w = face.boundingBox.width * CGFloat(width)
            let h = face.boundingBox.height * CGFloat(height)
            let x = face.boundingBox.origin.x * CGFloat(width)
            let y = (1 - face.boundingBox.origin.y) * CGFloat(height) - h
            totalX += x
            totalY += y
            totalW += w
            totalH += h
            minX = .minimum(minX, x)
            minY = .minimum(minY, y)
        }

        let avgX = totalX / numFaces
        let avgY = totalY / numFaces
        let avgW = totalW / numFaces
        let avgH = totalH / numFaces

        let offset = margin + avgX - minX

        return CGRect(x: avgX - offset, y: avgY - offset, width: avgW + (offset * 2), height: avgH + (offset * 2))
    }
}

extension CGImage {
    /**
     Converts the image to an ARGB `CVPixelBuffer`.
     */
    public func pixelBuffer() -> CVPixelBuffer? {
        return pixelBuffer(width: width, height: height, orientation: .up)
    }

    /**
     Resizes the image to `width` x `height` and converts it to an ARGB
     `CVPixelBuffer`.
     */
    public func pixelBuffer(width: Int, height: Int,
                            orientation: CGImagePropertyOrientation) -> CVPixelBuffer? {
        return pixelBuffer(width: width, height: height,
                           pixelFormatType: kCVPixelFormatType_32ARGB,
                           colorSpace: CGColorSpaceCreateDeviceRGB(),
                           alphaInfo: .noneSkipFirst,
                           orientation: orientation)
    }

    /**
     Converts the image to a grayscale `CVPixelBuffer`.
     */
    public func pixelBufferGray() -> CVPixelBuffer? {
        return pixelBufferGray(width: width, height: height, orientation: .up)
    }

    /**
     Resizes the image to `width` x `height` and converts it to a grayscale
     `CVPixelBuffer`.
     */
    public func pixelBufferGray(width: Int, height: Int,
                                orientation: CGImagePropertyOrientation) -> CVPixelBuffer? {
        return pixelBuffer(width: width, height: height,
                           pixelFormatType: kCVPixelFormatType_OneComponent8,
                           colorSpace: CGColorSpaceCreateDeviceGray(),
                           alphaInfo: .none,
                           orientation: orientation)
    }

    /**
     Resizes the image to `width` x `height` and converts it to a `CVPixelBuffer`
     with the specified pixel format, color space, and alpha channel.
     */
    public func pixelBuffer(width: Int, height: Int,
                            pixelFormatType: OSType,
                            colorSpace: CGColorSpace,
                            alphaInfo: CGImageAlphaInfo,
                            orientation: CGImagePropertyOrientation) -> CVPixelBuffer? {
        assert(orientation == .up)

        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         pixelFormatType,
                                         attrs as CFDictionary,
                                         &maybePixelBuffer)

        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }

        let flags = CVPixelBufferLockFlags(rawValue: 0)
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(pixelBuffer, flags) else {
            return nil
        }
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, flags) }

        guard let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer),
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: colorSpace,
                                      bitmapInfo: alphaInfo.rawValue)
        else {
            return nil
        }

        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        return pixelBuffer
    }
}

extension CGImage {
    /**
     Creates a new CGImage from a CVPixelBuffer.
     - Note: Not all CVPixelBuffer pixel formats support conversion into a
     CGImage-compatible pixel format.
     */
    public static func create(pixelBuffer: CVPixelBuffer) -> CGImage? {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        return cgImage
    }

    /**
     Creates a new CGImage from a CVPixelBuffer, using Core Image.
     */
    public static func create(pixelBuffer: CVPixelBuffer, context: CIContext) -> CGImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let rect = CGRect(x: 0,
                          y: 0,
                          width: CVPixelBufferGetWidth(pixelBuffer),
                          height: CVPixelBufferGetHeight(pixelBuffer))
        return context.createCGImage(ciImage, from: rect)
    }
}

public enum FaceCropResult {
    case success(CGImage)
    case notFound
    case failure(Error)
}
