//
//  ImageCollection.swift
//  Assignment3
//
//  Created by user225115 on 7/24/23.
//

import Foundation

// Protocol to notify the delegate when the image collection is updated
protocol ImageCollectionDelegate: AnyObject {
    func didUpdateImageCollection()
}

class ImageCollection {
    private var images: [Image] = []
    
    // Weak reference to the delegate to avoid strong reference cycles
    weak var delegate: ImageCollectionDelegate?

    // Method to add a new image to the collection
    func addImage(_ image: Image) {
        images.append(image)
        // Notify the delegate that the image collection has been updated
        delegate?.didUpdateImageCollection()
    }

    // Method to get the count of images in the collection
    func numberOfImages() -> Int {
        return images.count
    }

    // Method to get the image at a specific index in the collection
    func image(at index: Int) -> Image? {
        guard index >= 0, index < images.count else {
            return nil
        }
        return images[index]
    }
}
