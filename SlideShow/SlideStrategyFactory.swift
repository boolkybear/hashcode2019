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
        let classes: [SlideStrategy.Type] = [SearchSlideStrategy.self,
                                             CommonSlideStrategy.self,
                                             CommonMaxSlideStrategy.self,
                                             ExpandSlideStrategy.self,
                                             BreadthSlideStrategy.self,
                                             TspSlideStrategy.self]

        guard let validClass = classes.first(where: { $0.name == name }) else {
            return DefaultSlideStrategy()
        }

        return validClass.init()
    }
}
