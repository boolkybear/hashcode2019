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
        var slides: [Slide] = []

        let horizontalSlides: [Slide] = photos
            .filter { $0.orientation == .horizontal }
            .map { .horizontal($0) }
        slides.append(contentsOf: horizontalSlides)

        var verticalPhotos = photos.filter { $0.orientation == .vertical }
        if verticalPhotos.count & 1 != 0 {
            verticalPhotos.removeLast()
        }

//        let count = verticalPhotos.count / 2
//        for i in 0..<count {
//            let first = verticalPhotos[i*2]
//            let second = verticalPhotos[i*2+1]
//            slides.append(.vertical(first, second))
//        }

        var iterationv = 0
        let maxitv = verticalPhotos.count / 2

        var fv = verticalPhotos.first
        var restv = Array(verticalPhotos.dropFirst())
        while fv != nil {
            print("Iteration Vert \(iterationv)/\(maxitv)")
            iterationv += 1

            let safefv = fv!
            if restv.count > 0 {
                if let secondv = restv.enumerated().first(where: { secondvv in
                    safefv.tags.intersection(secondvv.element.tags).count == 0
                }) {
                    slides.append(.vertical(safefv, secondv.element))
                    restv.remove(at: secondv.offset)
                    fv = restv.first
                    restv = Array(restv.dropFirst())
                } else {
                    slides.append(.vertical(safefv, restv.first!))
                    restv.removeFirst()
                    fv = restv.first
                    restv = Array(restv.dropFirst())
                }
            } else {
                fv = nil
            }
        }

        var first = slides.first
        var rest = Array(slides.dropFirst())

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
                if rest.count > 0 {
                    if let next = rest.enumerated().first(where: { (index, second) in
                        return Slide.commonTags(slide1: safeFirst, slide2: second).count > 0 &&
                                Slide.tagsNotInFirst(slide1: safeFirst, slide2: second).count > 0 &&
                                Slide.tagsNotInSecond(slide1: safeFirst, slide2: second).count > 0
                    }) {
                        result.add(slide: next.element)
                        first = next.element
                        rest.remove(at: next.offset)
                    } else {
                        first = rest.first
                        result.add(slide: first!)
                        rest.removeFirst()
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
                if rest.count > 0 {
                    if let next = rest.enumerated().first(where: { (index, second) in
                        return Slide.commonTags(slide1: safeFirst, slide2: second).count > 0
                    }) {
                        result.add(slide: next.element)
                        first = next.element
                        rest.remove(at: next.offset)
                    } else {
                        first = rest.first
                        result.add(slide: first!)
                        rest.removeFirst()
                    }
                } else {
                    first = nil
                }
            }
        }

        return result
    }
}
