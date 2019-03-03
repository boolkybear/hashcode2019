//
//  VerticalStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 03/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

protocol VerticalStrategy {
    static var name: String { get }

    init()
    func arrange(photos: Set<Photo>) -> Set<Slide>
}
