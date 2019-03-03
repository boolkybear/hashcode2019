//
//  DefaultVerticalStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 03/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class MaxtagsVerticalStrategy {
    static let name = "maxtags"

    required init() {
    }
}

extension MaxtagsVerticalStrategy: VerticalStrategy {
    func arrange(photos: Set<Photo>) -> Set<Slide> {
        var arranged: Set<Slide> = []
        var verticalPhotos = photos.filter { $0.orientation == .vertical }

        var iterationv = 0
        let maxitv = verticalPhotos.count / 2

        var fv = verticalPhotos.popFirst()
        while fv != nil {
            print("Vertical \(MaxtagsVerticalStrategy.name): \(iterationv)/\(maxitv)")
            iterationv += 1

            let safefv = fv!
            let safetags = safefv.tags
            if !verticalPhotos.isEmpty {
                let disjoints = verticalPhotos.filter { safetags.isDisjoint(with: $0.tags) }
                if disjoints.isEmpty {
                    // minimum common tags
                    let sorted = verticalPhotos.sorted { photo1, photo2 in
                        let set1 = photo1.tags.intersection(safetags)
                        let set2 = photo2.tags.intersection(safetags)

                        return set1.count < set2.count
                    }

                    let mincommon = sorted.first!
                    arranged.insert(.vertical(safefv, mincommon))
                    verticalPhotos.remove(mincommon)
                } else {
                    // maximum total tags
                    let sorted = disjoints.sorted { photo1, photo2 in
                        let set1 = photo1.tags.union(safetags)
                        let set2 = photo2.tags.union(safetags)

                        return set1.count > set2.count
                    }

                    let maxtags = sorted.first!
                    arranged.insert(.vertical(safefv, maxtags))
                    verticalPhotos.remove(maxtags)
                }

                fv = verticalPhotos.popFirst()
            } else {
                fv = nil
            }
        }

        return arranged
    }
}
