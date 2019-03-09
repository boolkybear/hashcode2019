//
//  DefaultSlideStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 02/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class TspSlideStrategy {
    static let name = "tsp"

    required init() {
    }
}

extension TspSlideStrategy: SlideStrategy {

    static func calculateValue(first: Slide, second: Slide) -> Int {
        let commonTags = Slide.commonTags(slide1: first, slide2: second).count
        if commonTags == 0 {
            return 0
        }
        let firstTags = Slide.tagsNotInFirst(slide1: first, slide2: second).count
        if firstTags == 0 {
            return 0
        }
        return min( commonTags,
                    firstTags,
                    Slide.tagsNotInSecond(slide1: first, slide2: second).count)
    }

    struct Node {
        let startNode: Int
        let endNode: Int
        let value: Int
        let path: [Int]
    }

    func solve(slides: Set<Slide>) -> [Slide] {
        print("Solving \(TspSlideStrategy.name)")
        let validSlides = Array(slides.filter { $0.tags.count > 1 })
        let slideCount = validSlides.count
        let slideRange = 0..<slideCount
        var values: [Int] = Array(repeating: Int.min, count: slideCount * slideCount)
//        let values: [[Int]] = slideRange.map { j in
//            let jslide = validSlides[j]
//            print("Calculating distances \(TspSlideStrategy.name) - \(j)/\(validSlides.count)")
//            return slideRange.map { i in
//                if i == j {
//                    return Int.min
//                }
//                return TspSlideStrategy.calculateValue(first: jslide, second: validSlides[i])
//            }
//        }

        func getValue(j: Int, i: Int) -> Int {
            return values[j * slideCount + i]
        }

        func setValue(j: Int, i: Int, value: Int) {
            values[j * slideCount + i] = value
        }

        slideRange.forEach { j in
            let jslide = validSlides[j]
            print("Calculating distances \(TspSlideStrategy.name) - \(j)/\(validSlides.count)")
            let subrange = (j + 1)..<validSlides.count
            subrange.forEach { i in
                let value = TspSlideStrategy.calculateValue(first: jslide, second: validSlides[i])
                setValue(j: j, i: i, value: value)
                setValue(j: i, i: j, value: value)
            }
        }

        var liveNodes: [Int: Node] = [:]
        slideRange.forEach {
            liveNodes[$0] = Node(startNode: $0, endNode: $0, value: 0, path: [$0])
        }

        func subgraphValue(from: Node, to: Node) -> Int {
            return from.value + getValue(j: from.endNode, i: to.startNode) + to.value
        }

        while liveNodes.count > 1 {
            let keys = Array(liveNodes.keys)
            var bestOrigin = keys.first!
            var bestEnd = keys.last!
            let bestOriginNode = liveNodes[bestOrigin]!
            let bestEndNode = liveNodes[bestEnd]!
            var bestValue = subgraphValue(from: bestOriginNode, to: bestEndNode)

            liveNodes.forEach { sourceIndex, sourceNode in
//                print("Finding max \(TspSlideStrategy.name) - \(sourceIndex)/\(keys.count)")

                liveNodes.forEach { endIndex, endNode in
                    if sourceIndex == endIndex {
                        return
                    }

                    let value = subgraphValue(from: sourceNode, to: endNode)
                    if value > bestValue {
                        bestOrigin = sourceIndex
                        bestEnd = endIndex
                        bestValue = value
                    }
                }
            }

            let sourceNode = liveNodes[bestOrigin]!
            let endNode = liveNodes[bestEnd]!
            let newOriginNode = Node(startNode: bestOrigin, endNode: endNode.endNode, value: bestValue, path: sourceNode.path + endNode.path)
            liveNodes[bestOrigin] = newOriginNode
            liveNodes[bestEnd] = nil

            print("Live nodes \(TspSlideStrategy.name) \(liveNodes.count)/\(bestValue)")
        }

        let bestSolution = liveNodes.first!.value

        return bestSolution.path.map { validSlides[$0] }
    }
}
