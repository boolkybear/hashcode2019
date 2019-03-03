//
//  DefaultVerticalStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 03/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class DisjointVerticalStrategy {
    static let name = "disjoint"

    required init() {
    }
}

extension DisjointVerticalStrategy: VerticalStrategy {
    func arrange(photos: Set<Photo>) -> Set<Slide> {
        var arranged: Set<Slide> = []
        var verticalPhotos = photos.filter { $0.orientation == .vertical }

        var iterationv = 0
        let maxitv = verticalPhotos.count / 2

        var fv = verticalPhotos.popFirst()
        while fv != nil {
            print("Vertical \(DisjointVerticalStrategy.name): \(iterationv)/\(maxitv)")
            iterationv += 1

            let safefv = fv!
            if !verticalPhotos.isEmpty {
                if let secondv = verticalPhotos.first(where: { secondvv in
                    safefv.tags.isDisjoint(with: secondvv.tags)
                }) {
                    arranged.insert(.vertical(safefv, secondv))
                    verticalPhotos.remove(secondv)
                } else {
                    arranged.insert(.vertical(safefv, verticalPhotos.popFirst()!))
                }
                fv = verticalPhotos.popFirst()
            } else {
                fv = nil
            }
        }

        return arranged
    }
}
