//
//  VisionHelper.swift
//  TextRecognition
//
//  Created by Cemre ÖNCEL on 12.02.2020.
//  Copyright © 2020 Accecare. All rights reserved.
//

import Foundation
import FirebaseMLVision

class VisionHelper {
    
    enum VisionResult: Int {
        case found = 1
        case notFound = 0
        case error = -1
    }
    
    static func processResult(text: VisionText?, specifiedWords: [String], error: Error?) -> VisionResult {
        
        guard let features = text else {
            return .error
        }
        for block in features.blocks {
            for line in block.lines {
                for element in line.elements {
                    for word in specifiedWords {
                        if word == element.text.lowercased() {
                            return .found
                        }
                    }
                }
            }
        }
        return .notFound
    }
}
