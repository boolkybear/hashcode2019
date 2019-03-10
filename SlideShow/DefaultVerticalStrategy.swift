//
//  DefaultVerticalStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 03/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class DefaultVerticalStrategy {
    static let name = "default"

    required init() {
    }
}

extension DefaultVerticalStrategy: VerticalStrategy {
    func arrange(photos: Set<Photo>) -> Set<Slide> {
        var arranged: Set<Slide> = []
        var verticalPhotos = photos.filter { $0.orientation == .vertical }

        while verticalPhotos.count > 1 {
            if let first = verticalPhotos.popFirst(),
                let second = verticalPhotos.popFirst() {
                arranged.insert(Slide(first, second))
            }
        }

        return arranged
    }
}
