//
//  SlideStrategyFactory.swift
//  SlideShow
//
//  Created by Jose Servet Font on 02/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class SlideStrategyFactory {
    static func strategy(withName name: String) -> SlideStrategy {
        return DefaultSlideStrategy()
    }
}
