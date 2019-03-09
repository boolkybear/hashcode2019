//
//  DirectSolver.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Cocoa

class SearchSetSolver {
    let photos: [Photo]
    let search: Bool

    init(photos: [Photo], search: Bool) {
        self.photos = photos
        self.search = search
    }

    func solve() -> Slideshow {
        let result = Slideshow()
        var slides: Set<Slide> = []

        let horizontalSlides: [Slide] = photos
            .filter { $0.orientation == .horizontal }
            .map { .horizontal($0, []) }
        slides.formUnion(horizontalSlides) //.append(contentsOf: horizontalSlides)

        var verticalPhotos = Set(photos).filter { $0.orientation == .vertical }
        if verticalPhotos.count & 1 != 0 {
            _ = verticalPhotos.popFirst()
        }

        var iterationv = 0
        let maxitv = verticalPhotos.count / 2

        var fv = verticalPhotos.popFirst()
//        var restv = Array(verticalPhotos.dropFirst())
        while fv != nil {
            print("Iteration Vert \(iterationv)/\(maxitv)")
            iterationv += 1

            let safefv = fv!
            if !verticalPhotos.isEmpty {
                if let secondv = verticalPhotos.first(where: { secondvv in
                    safefv.tags.isDisjoint(with: secondvv.tags)
                }) {
                    slides.insert(.vertical(safefv, secondv, []))
                    verticalPhotos.remove(secondv)
                } else {
                    slides.insert(.vertical(safefv, verticalPhotos.popFirst()!, []))
                }
                fv = verticalPhotos.popFirst()
            } else {
                fv = nil
            }
        }

        var first = slides.popFirst()

        var iteration = 0
        let maxIteration = slides.count

        if let first = first {
            result.add(slide: first)
        }

        if search {
            while first != nil {
                print("Iteration \(iteration)/\(maxIteration)")
                iteration += 1
                let safeFirst = first!
                if !slides.isEmpty {
                    if let next = slides.first(where: { second in
                        return Slide.commonTags(slide1: safeFirst, slide2: second).count > 0 &&
                                Slide.tagsNotInFirst(slide1: safeFirst, slide2: second).count > 0 &&
                                Slide.tagsNotInSecond(slide1: safeFirst, slide2: second).count > 0
                    }) {
                        result.add(slide: next)
                        first = next
                        slides.remove(next)
                    } else {
                        first = slides.popFirst()
                        result.add(slide: first!)
                    }
                } else {
                    first = nil
                }
            }
        } else {
            while first != nil {
                print("Iteration \(iteration)/\(maxIteration)")
                iteration += 1
                let safeFirst = first!
                if !slides.isEmpty {
                    if let next = slides.first(where: { second in
                        return Slide.commonTags(slide1: safeFirst, slide2: second).count > 0
                    }) {
                        result.add(slide: next)
                        first = next
                        slides.remove(next)
                    } else {
                        first = slides.popFirst()
                        result.add(slide: first!)
                    }
                } else {
                    first = nil
                }
            }
        }

        return result
    }
}
