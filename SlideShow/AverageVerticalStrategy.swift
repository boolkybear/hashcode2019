//
//  DefaultVerticalStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 03/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class AverageVerticalStrategy {
    static let name = "average"

    required init() {
    }
}

extension AverageVerticalStrategy: VerticalStrategy {
    func arrange(photos: Set<Photo>) -> Set<Slide> {
        var arranged: Set<Slide> = []
        var verticalPhotos = photos.filter { $0.orientation == .vertical }
        var sortedVerticalPhotos = verticalPhotos.sorted { return $0.tags.count > $1.tags.count }

        var iterationv = 0
        let maxitv = verticalPhotos.count / 2

        var fv = sortedVerticalPhotos.first
        while fv != nil {
            print("Vertical \(AverageVerticalStrategy.name): \(iterationv)/\(maxitv)")
            iterationv += 1

            let safefv = fv!
            sortedVerticalPhotos.remove(at: sortedVerticalPhotos.firstIndex(of: safefv)!)

            let safetags = safefv.tags
            if !verticalPhotos.isEmpty {
                if let maxtags = sortedVerticalPhotos.last(where: { safefv != $0 && safetags.isDisjoint(with: $0.tags) }) {
                    // maximum total tags
                    arranged.insert(.vertical(safefv, maxtags))
                    verticalPhotos.remove(maxtags)
                    sortedVerticalPhotos.remove(at: sortedVerticalPhotos.firstIndex(of: maxtags)!)
                } else {
                    // minimum common tags
                    let sorted = sortedVerticalPhotos.sorted { photo1, photo2 in
                        let set1 = photo1.tags.intersection(safetags)
                        let set2 = photo2.tags.intersection(safetags)

                        return set1.count < set2.count
                    }

                    let mincommon = sorted.first!
                    arranged.insert(.vertical(safefv, mincommon))
                    verticalPhotos.remove(mincommon)
                    sortedVerticalPhotos.remove(at: sortedVerticalPhotos.firstIndex(of: mincommon)!)
                }

                fv = sortedVerticalPhotos.first
            } else {
                fv = nil
            }
        }

        return arranged
    }
}
