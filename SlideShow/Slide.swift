//
//  Slide.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Cocoa

//enum Slide {
//    case horizontal(Photo)
//    case vertical(Photo, Photo)
//
//    var tags: Set<String> {
//        switch self {
//        case .horizontal(let photo):
//            return photo.tags
//
//        case .vertical(let ph1, let ph2):
//            return ph1.tags.union(ph2.tags)
//        }
//    }
//
//    static func commonTags(slide1: Slide, slide2: Slide) -> Set<String> {
//        return slide1.tags.intersection(slide2.tags)
//    }
//
//    static func tagsNotInFirst(slide1: Slide, slide2: Slide) -> Set<String> {
//        return slide2.tags.subtracting(slide1.tags)
//    }
//
//    static func tagsNotInSecond(slide1: Slide, slide2: Slide) -> Set<String> {
//        return slide1.tags.subtracting(slide2.tags)
//    }
//
//    var text: String {
//        switch self {
//        case .horizontal(let photo):
//            return "\(photo.index)"
//
//        case .vertical(let ph1, let ph2):
//            return "\(ph1.index) \(ph2.index)"
//        }
//    }
//}

class Slide: Hashable {
    let photo1: Photo
    let photo2: Photo
    let tags: Set<String>
    let text: String
    let hashValue: Int

    init(_ photo: Photo) {
        self.photo1 = photo
        self.photo2 = photo
        tags = photo.tags
        text = "\(photo.index)"
        hashValue = text.hashValue
    }

    init(_ photo1: Photo, _ photo2: Photo) {
        self.photo1 = photo1
        self.photo2 = photo2
        tags = photo1.tags.union(photo2.tags)
        text = "\(photo1.index) \(photo2.index)"
        hashValue = text.hashValue
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
}

//extension Slide: Hashable {
//    var hashValue: Int {
//        return text.hashValue
//    }
//}

extension Slide: Equatable {
    static func == (lhs: Slide, rhs: Slide) -> Bool {
        return lhs.text == rhs.text
    }
}
