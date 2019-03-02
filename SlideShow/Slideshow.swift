//
//  Slideshow.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Cocoa

class Slideshow {
    var slides: [Slide] = []

    func add(slide: Slide) {
        slides.append(slide)
    }

    func textRepresentation() -> String {
        let rows = slides.map { $0.text }.joined(separator: "\n")

        return "\(slides.count)\n\(rows)"
    }
}
