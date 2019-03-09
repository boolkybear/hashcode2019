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

        var tagMapper: [String: Int] = [:]
        var tagSet: Set<String> = []
        photos.forEach {
            tagSet.formUnion($0.tags)
        }
        let tags = Array(tagSet)
        tags.enumerated().forEach {
            tagMapper[$0.element] = $0.offset
        }

        let horizontalSlides: [Slide] = photos
            .filter { $0.orientation == .horizontal }
            .map {
                let intTags = $0.tags.map { tagMapper[$0]! }
                return .horizontal($0, Set(intTags))
            }

        slides.formUnion(horizontalSlides)

        let verticalSlides = VerticalStrategyFactory.strategy(withName: verticalStrategy).arrange(photos: Set(photos))
        let taggedSlides: [Slide] = verticalSlides.map {
            let intTags = $0.tags.map { tagMapper[$0]! }
            return .vertical($0.photo1!, $0.photo2!, Set(intTags))
        }
        slides.formUnion(taggedSlides)

        let slideSolver = SlideStrategyFactory.strategy(withName: slideStrategy)
        result.slides = slideSolver.solve(slides: slides)

        return result
    }
}
