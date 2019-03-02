//
//  Photo.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Cocoa

enum Orientation: String {
    case vertical = "V"
    case horizontal = "H"
}

class Photo {
    let orientation: Orientation
    let tags: Set<String>
    let index: Int
    let hashValue: Int

    init?(line: String, index: Int) {
        self.index = index
        let components = line.components(separatedBy: " ")
        guard components.count > 2,
            let orient = Orientation(rawValue: components[0]),
            let tagCount = Int(components[1]) else {
                return nil
        }

        orientation = orient
        tags = Set(components[2..<(tagCount + 2)])

        self.hashValue = "\(orient.rawValue)-\(index)".hashValue
    }
}

extension Photo: Hashable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.index == rhs.index
    }
}
