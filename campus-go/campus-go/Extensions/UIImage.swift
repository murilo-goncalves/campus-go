//
//  UIImage.swift
//  campus-go
//
//  Created by Giordano Mattiello on 07/10/21.
//

import Foundation
import UIKit

extension UIImage {
    public func convertToGrayScale() -> UIImage? {
            let image = self
            let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)
            let colorSpace = CGColorSpaceCreateDeviceGray()
            let width = image.size.width
            let height = image.size.height
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
            let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
            if let cgImg = image.cgImage {
                context?.draw(cgImg, in: imageRect)
                if let makeImg = context?.makeImage() {
                    let imageRef = makeImg
                    let newImage = UIImage(cgImage: imageRef)
                    return newImage
                }
            }
            return UIImage()
        }

    
}
