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

        func calculateDistances() -> [[Int]] {
            let distanceFileName = "distanceMap.txt"
//
//            if let inputString = try? String(contentsOfFile: distanceFileName) {
//                print("Reading distances \(TspSlideStrategy.name) from file")
//
//                let lines = inputString.components(separatedBy: "\n").filter { !$0.isEmpty }
//                return lines.map {
//                    $0.components(separatedBy: ",").map { Int($0)! }
//                }
//            }

            let values: [[Int]] = slideRange.map { j in
                let jslide = validSlides[j]
                print("Calculating distances \(TspSlideStrategy.name) - \(j)/\(validSlides.count)")
                let subrange = (j + 1)..<validSlides.count
                return subrange.map { i in
                    return TspSlideStrategy.calculateValue(first: jslide, second: validSlides[i])
//                    return 1
                }
            }

            let valuesString = values.map {
                $0.map { "\($0)" }.joined(separator: ",")
            }
            let singleString = valuesString.joined(separator: "\n")
            do {
                try? singleString.write(toFile: distanceFileName, atomically: true, encoding: .utf8)
            }

            return values
        }

        let values = calculateDistances()

        func getValue(j: Int, i: Int) -> Int {
            let mini = min(j, i)
            let maxi = max(j, i)
            return values[mini][maxi - mini - 1]
        }

        func subgraphValue(from: Node, to: Node) -> Int {
            return from.value + getValue(j: from.endNode, i: to.startNode) + to.value
        }

        let maxNodes = 1100
        var groups = slideCount / maxNodes
        if slideCount % maxNodes != 0 {
            groups += 1
        }

        var maxPath: [Int] = []

        (0..<groups).forEach { group in
            let lowerBound = group * maxNodes
            let upperBound = lowerBound + maxNodes

            var liveNodes: [Int: Node] = [:]
            slideRange.filter { lowerBound <= $0 && $0 < upperBound }.forEach {
                liveNodes[$0] = Node(startNode: $0, endNode: $0, value: 0, path: [$0])
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

                print("(\(group)/\(groups)) Live nodes \(TspSlideStrategy.name) \(liveNodes.count)/\(bestValue)")
            }

            let bestSolution = liveNodes.first!.value
            maxPath.append(contentsOf: bestSolution.path)
        }

        return maxPath.map { validSlides[$0] }
    }
}
