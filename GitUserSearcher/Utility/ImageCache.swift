//
//  ImageCache.swift
//  GitUserSearcher
//
//  Created by Surya Teja Nammi on 7/18/25.
//

import Foundation
import SwiftUI

final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func insertImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
