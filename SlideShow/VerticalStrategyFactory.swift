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
        let classes: [VerticalStrategy.Type] = [DisjointVerticalStrategy.self]

        guard let validClass = classes.first(where: { $0.name == name }) else {
            return DefaultVerticalStrategy()
        }

        return validClass.init()
    }
}
