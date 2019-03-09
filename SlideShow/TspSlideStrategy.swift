//
//  DefaultSlideStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 02/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class TspSlideStrategy {
    static var tagMapper: [String: Int] = [:]

    static let name = "tsp"

    required init() {
    }
}

extension TspSlideStrategy: SlideStrategy {

    static func calculateValue(first: Slide, second: Slide) -> Int {
        let commonTags = Slide.commonIntTags(slide1: first, slide2: second).count
//        let commonTags = firstTags.intersection(secondTags).count
        if commonTags == 0 {
            return 0
        }
        let firstTagCount = Slide.intTagsNotInFirst(slide1: first, slide2: second).count
//        let firstTagCount = secondTags.subtracting(firstTags).count
        if firstTagCount == 0 {
            return 0
        }
        return min( commonTags,
                    firstTagCount,
                    Slide.intTagsNotInSecond(slide1: first, slide2: second).count)
    }

//    static func calculateValue(first: Slide, second: Slide) -> Int {
//        return 1
//    }

    class Node {
        let startNode: Int
        let endNode: Int
        let value: Int
        let path: [Int]
        let identifier: String

        init(startNode: Int, endNode: Int, value: Int, path: [Int]) {
            self.startNode = startNode
            self.endNode = endNode
            self.value = value
            self.path = path
            identifier = "\(startNode)-[path.count]-\(endNode)"
        }
    }

    func solve(slides: Set<Slide>) -> [Slide] {
        print("Solving \(TspSlideStrategy.name)")
        let validSlides = Array(slides.filter { $0.tags.count > 1 })
        let slideCount = validSlides.count
        let slideRange = 0..<slideCount

        var tagSet: Set<String> = []
        validSlides.forEach {
            tagSet.formUnion($0.tags)
        }
        let tags = Array(tagSet)
        tags.enumerated().forEach {
            TspSlideStrategy.tagMapper[$0.element] = $0.offset
        }

//        var values: [Int] = Array(repeating: Int.min, count: slideCount * slideCount)
        let values: [[Int]] = slideRange.map { j in
            let jslide = validSlides[j]
            print("Calculating distances \(TspSlideStrategy.name) - \(j)/\(validSlides.count)")
            let subrange = (j + 1)..<validSlides.count
            return subrange.map { i in
                return TspSlideStrategy.calculateValue(first: jslide, second: validSlides[i])
            }
        }

        func getValue(j: Int, i: Int) -> Int {
//            return values[j * slideCount + i]
            let mini = min(j, i)
            let maxi = max(j, i)
            return values[mini][maxi - mini - 1]
        }

//        func setValue(j: Int, i: Int, value: Int) {
//            values[j * slideCount + i] = value
//        }

//        slideRange.forEach { j in
//            let jslide = validSlides[j]
//            print("Calculating distances \(TspSlideStrategy.name) - \(j)/\(validSlides.count)")
//            let subrange = (j + 1)..<validSlides.count
//            subrange.forEach { i in
//                let value = TspSlideStrategy.calculateValue(first: jslide, second: validSlides[i])
//                setValue(j: j, i: i, value: value)
//                setValue(j: i, i: j, value: value)
//            }
//        }

        var liveNodes: [Int: Node] = [:]
        slideRange.forEach {
            liveNodes[$0] = Node(startNode: $0, endNode: $0, value: 0, path: [$0])
        }

        var lookupValue: [String: [String: Int]] = [:]

//        func subgraphValue(from: Node, to: Node) -> Int {
//            let value: Int
//            if var lookup = lookupValue[from.identifier] {
//                if let val = lookup[to.identifier] {
//                    return val
//                } else {
//                    value = from.value + getValue(j: from.endNode, i: to.startNode) + to.value
//                    lookup[to.identifier] = value
//                    lookupValue[from.identifier] = lookup
//                }
//            } else {
//                value = from.value + getValue(j: from.endNode, i: to.startNode) + to.value
//                lookupValue[from.identifier] = [to.identifier: value]
//            }
//
//            return value
//        }

        func subgraphValue(from: Node, to: Node) -> Int {
            return from.value + getValue(j: from.endNode, i: to.startNode) + to.value
        }

        while liveNodes.count > 1 {
            var keys = Array(liveNodes.keys)
            var bestRoundValue = 0

            while !keys.isEmpty {
                let origin = keys.removeFirst()
                let originNode = liveNodes[origin]!

                if !keys.isEmpty {
                    let second = keys.first!
                    var bestKey = second
                    var bestNode = liveNodes[second]!

                    var bestValue = subgraphValue(from: originNode, to: bestNode)

                    keys.forEach { key in
                        let keyNode = liveNodes[key]!
                        let value = subgraphValue(from: originNode, to: keyNode)
                        if bestValue < value {
                            bestKey = key
                            bestNode = keyNode
                            bestValue = value
                        }
                    }

                    if bestRoundValue < bestValue {
                        bestRoundValue = bestValue
                    }
                    let newOriginNode = Node(startNode: originNode.startNode, endNode: bestNode.endNode, value: bestValue, path: originNode.path + bestNode.path)
                    liveNodes[origin] = newOriginNode
                    liveNodes[bestKey] = nil
                    keys = keys.filter { $0 != bestKey }
                }
            }

            print("Live nodes \(TspSlideStrategy.name) \(liveNodes.count)/\(bestRoundValue)")
        }

        let bestSolution = liveNodes.first!.value

        return bestSolution.path.map { validSlides[$0] }
    }
}
