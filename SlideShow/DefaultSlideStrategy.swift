//
//  DefaultSlideStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 02/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class DefaultSlideStrategy {
    static let name = "default"

    required init() {
    }
}

extension DefaultSlideStrategy: SlideStrategy {
    func solve(slides: Set<Slide>) -> [Slide] {
        return Array(slides.filter { $0.tags.count > 1 })
    }
}
