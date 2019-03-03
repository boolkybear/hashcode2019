//
//  VerticalStrategyFactory.swift
//  SlideShow
//
//  Created by Jose Servet Font on 03/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class VerticalStrategyFactory {
    static func strategy(withName name: String) -> VerticalStrategy {
        return DefaultVerticalStrategy()
    }
}
