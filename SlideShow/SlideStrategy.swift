//
//  SlideStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 02/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

protocol SlideStrategy {
    static var name: String { get }

    init()
    func solve(slides: Set<Slide>) -> [Slide]
}
