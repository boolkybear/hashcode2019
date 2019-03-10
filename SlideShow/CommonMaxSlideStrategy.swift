//
//  DefaultSlideStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 02/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class CommonMaxSlideStrategy {
    static let name = "commonmax"

    required init() {
    }
}

extension CommonMaxSlideStrategy: SlideStrategy {
    func solve(slides: Set<Slide>) -> [Slide] {
        var result: [Slide] = []
        var validSlides = slides.filter { $0.tags.count > 1 }

        var first = validSlides.popFirst()

        var iteration = 0
        let maxIteration = slides.count

        if let first = first {
            result.append(first)
        }

        while first != nil {
            print("Iteration \(CommonMaxSlideStrategy.name) \(iteration)/\(maxIteration)")
            iteration += 1
            let safeFirst = first!
            if !validSlides.isEmpty {
                let commonSlides = validSlides
                    .filter { !Slide.commonTags(slide1: safeFirst, slide2: $0).isEmpty }
                    .sorted { Slide.commonTags(slide1: safeFirst, slide2: $0).count > Slide.commonTags(slide1: safeFirst, slide2: $1).count }
                if let next = commonSlides.first {
                    result.append(next)
                    first = next
                    validSlides.remove(next)
                } else {
                    first = validSlides.popFirst()
                    result.append(first!)
                }
            } else {
                first = nil
            }
        }

        return result
    }
}
