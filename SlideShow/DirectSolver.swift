//
//  DirectSolver.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Cocoa

class DirectSolver: NSObject {
    var photos: [Photo]

    init(photos: [Photo]) {
        self.photos = photos
    }

    func solve() -> Slideshow {
        let result = Slideshow()

        photos
            .filter { $0.orientation == .horizontal }
            .forEach { result.add(slide: .horizontal($0)) }

        var verticalPhotos = photos.filter { $0.orientation == .vertical }
        if verticalPhotos.count & 1 != 0 {
            verticalPhotos.removeLast()
        }

        let count = verticalPhotos.count / 2
        for i in 0..<count {
            let first = verticalPhotos[i*2]
            let second = verticalPhotos[i*2+1]
            result.add(slide: .vertical(first, second))
        }

        return result
    }
}
