//
//  DefaultSlideStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 02/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class SearchSlideStrategy {
    static let name = "search"

    required init() {
    }
}

extension SearchSlideStrategy: SlideStrategy {
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
            print("Iteration \(SearchSlideStrategy.name) \(iteration)/\(maxIteration)")
            iteration += 1
            let safeFirst = first!
            if !validSlides.isEmpty {
                if let next = validSlides.first(where: { second in
                    let common = Slide.commonTags(slide1: safeFirst, slide2: second)
                    if common.isEmpty {
                        return false
                    }
                    let left = Slide.tagsNotInFirst(slide1: safeFirst, slide2: second)
                    if left.isEmpty {
                        return false
                    }
                    let right = Slide.tagsNotInSecond(slide1: safeFirst, slide2: second)
                    if right.isEmpty {
                        return false
                    }
                    return true
                }) {
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
