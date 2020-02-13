//
//  ImageHelper.swift
//  TextRecognition
//
//  Created by Cemre ÖNCEL on 12.02.2020.
//  Copyright © 2020 Accecare. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
    static let bestQualitySize : CGSize = CGSize(width: 480.0, height: 640.0)
    
    enum ImageQuality : CGFloat {
        case highestQuality = 1.0
        case highQuality = 0.75
        case mediumQuality = 0.5
        case lowQuality = 0.25
        case lowestQuality = 0.0
    }
    
    static func compressImage(image: UIImage, imageQuality: ImageQuality) -> UIImage {
        return UIImage(data: image.jpegData(compressionQuality: imageQuality.rawValue)!) ?? image
    }
    
    static func fitImageSizeForVision(image: UIImage, newSize: CGSize)-> UIImage {
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage
    }
    
    static func fitImageSizeForVision(image: UIImage) -> UIImage {
        return fitImageSizeForVision(image: image, newSize: bestQualitySize)
    }
    
}
