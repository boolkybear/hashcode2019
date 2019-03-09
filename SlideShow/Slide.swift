//
//  Slide.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Cocoa

enum Slide {
    case horizontal(Photo, Set<Int>)
    case vertical(Photo, Photo, Set<Int>)

    var tags: Set<String> {
        switch self {
        case .horizontal(let photo, _):
            return photo.tags

        case .vertical(let ph1, let ph2, _):
            return ph1.tags.union(ph2.tags)
        }
    }

    var intTags: Set<Int> {
        switch self {
        case .horizontal(_, let intTags):
            return intTags

        case .vertical(_, _, let intTags):
            return intTags
        }
    }

    static func commonTags(slide1: Slide, slide2: Slide) -> Set<String> {
        return slide1.tags.intersection(slide2.tags)
    }

    static func tagsNotInFirst(slide1: Slide, slide2: Slide) -> Set<String> {
        return slide2.tags.subtracting(slide1.tags)
    }

    static func tagsNotInSecond(slide1: Slide, slide2: Slide) -> Set<String> {
        return slide1.tags.subtracting(slide2.tags)
    }

    static func commonIntTags(slide1: Slide, slide2: Slide) -> Set<Int> {
        return slide1.intTags.intersection(slide2.intTags)
    }

    static func intTagsNotInFirst(slide1: Slide, slide2: Slide) -> Set<Int> {
        return slide2.intTags.subtracting(slide1.intTags)
    }

    static func intTagsNotInSecond(slide1: Slide, slide2: Slide) -> Set<Int> {
        return slide1.intTags.subtracting(slide2.intTags)
    }

    var text: String {
        switch self {
        case .horizontal(let photo, _):
            return "\(photo.index)"

        case .vertical(let ph1, let ph2, _):
            return "\(ph1.index) \(ph2.index)"
        }
    }

    var photo1: Photo? {
        switch self {
        case .horizontal(let photo, _):
            return photo

        case .vertical(let photo1, _, _):
            return photo1
        }
    }

    var photo2: Photo? {
        switch self {
        case .horizontal(_, _):
            return nil

        case .vertical(_, let photo2, _):
            return photo2
        }
    }
}

extension Slide: Hashable {
    var hashValue: Int {
        return text.hashValue
    }
}

extension Slide: Equatable {
    static func == (lhs: Slide, rhs: Slide) -> Bool {
        return lhs.text == rhs.text
    }
}
