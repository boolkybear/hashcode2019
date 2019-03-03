//
//  DirectSolver.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Cocoa

class StrategySolver {
    let photos: [Photo]
    let verticalStrategy: String
    let slideStrategy: String

    init(photos: [Photo], verticalStrategy: String, slideStrategy: String) {
        self.photos = photos
        self.verticalStrategy = verticalStrategy
        self.slideStrategy = slideStrategy
    }

    func solve() -> Slideshow {
        let result = Slideshow()
        var slides: Set<Slide> = []

        let horizontalSlides: [Slide] = photos
            .filter { $0.orientation == .horizontal }
            .map { .horizontal($0) }
        slides.formUnion(horizontalSlides)

        let verticalSlides = VerticalStrategyFactory.strategy(withName: verticalStrategy).arrange(photos: Set(photos))
        slides.formUnion(verticalSlides)

        let slideSolver = SlideStrategyFactory.strategy(withName: slideStrategy)
        result.slides = slideSolver.solve(slides: slides)

        return result
    }
}
