//
//  DefaultSlideStrategy.swift
//  SlideShow
//
//  Created by Jose Servet Font on 02/03/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

class ExpandSlideStrategy {
    static let name = "expand"

    required init() {
    }
}

extension ExpandSlideStrategy: SlideStrategy {
    class Node {
        let slide: Slide
        let maxEstimatedValue: Int

        init(slide: Slide) {
            self.slide = slide
            maxEstimatedValue = slide.tags.count / 2
        }
    }

    class Solution {

        let nodes: [Node]
        let nodesLeft: Set<Slide>
        let nodeCount: Int
        let maxEstimatedValue: Int

        let isSolution: Bool
        let value: Int

        init(nodes: [Node], nodesLeft: Set<Slide>) {
            self.nodes = nodes
            self.nodesLeft = nodesLeft
            nodeCount = nodes.count
            isSolution = nodesLeft.isEmpty
            var accumulated = 0
            var last = nodes.first
            nodes.dropFirst().forEach {
                if let last = last {
                    accumulated += Solution.calculateValue(first: last.slide, second: $0.slide)
                }

                last = $0
            }
            value = accumulated
            let nodeValues = nodesLeft.map { $0.tags.count / 2 }
            maxEstimatedValue = value + nodeValues.reduce(0, +)
        }

        init(nodes: [Node], nodesLeft: Set<Slide>, value: Int, maxEstimatedValue: Int) {
            self.nodes = nodes
            self.nodesLeft = nodesLeft
            nodeCount = nodes.count
            isSolution = nodesLeft.isEmpty
            self.value = value
            self.maxEstimatedValue = maxEstimatedValue
        }

        static func calculateValue(first: Slide, second: Slide) -> Int {
            return min( Slide.commonTags(slide1: first, slide2: second).count,
                        Slide.tagsNotInFirst(slide1: first, slide2: second).count,
                        Slide.tagsNotInSecond(slide1: first, slide2: second).count)
        }

        func expand(bestValue: Int) -> [Solution] {
            if isSolution {
                return []
            }

            let nodes = nodesLeft.map { solutionByAddingSlide($0) }
            return nodes.filter { $0.maxEstimatedValue > bestValue }
        }

        func solutionByAddingSlide(_ slide: Slide) -> Solution {
            var newNodes = nodesLeft
            newNodes.remove(slide)
            let newNode = Node(slide: slide)
            var newValue = 0
            if let last = nodes.last {
                newValue = Solution.calculateValue(first: last.slide, second: slide)
            }
            return Solution(nodes: nodes + [newNode],
                            nodesLeft: newNodes,
                            value: value + newValue,
                            maxEstimatedValue: maxEstimatedValue - newNode.maxEstimatedValue)
        }
    }

    func solve(slides: Set<Slide>) -> [Slide] {
        var result: [Slide] = []
        let validSlides = slides.filter { $0.tags.count > 1 }
//        let slideCount = validSlides.count
//        let shuffle = slideCount * 5

        let fastSolver = DefaultSlideStrategy()
        let fastSlides = fastSolver.solve(slides: validSlides)
        var bestSolution = Solution(nodes: fastSlides.map({ Node(slide: $0) }), nodesLeft: [])
        var bestValue = bestSolution.value

        var iteration = 0

        let firstNode = Solution(nodes: [], nodesLeft: validSlides)
        var liveNodes: [Solution] = [firstNode]

        while !liveNodes.isEmpty {
//            if (iteration % 5000) == 0 {
//                liveNodes.sort {
//                    if $0.nodeCount < $1.nodeCount {
//                        return true
//                    } else if $0.nodeCount == $1.nodeCount {
//                        return $0.maxEstimatedValue < $1.maxEstimatedValue
//                    } else {
//                        return false
//                    }
////                    return $0.nodeCount > $1.nodeCount ||
////                        ($0.nodeCount == $1.nodeCount && $0.maxEstimatedValue > $1.maxEstimatedValue)
//                }
//            }

//            let best: Solution
//            if (iteration % shuffle) == 0 {
//                best = liveNodes.removeFirst()
//            } else {
//                best = liveNodes.removeLast()
//            }

            let best = liveNodes.removeLast()
            if best.isSolution || best.value > bestValue {
                if bestValue < best.value {
                    bestSolution = best
                    bestValue = best.value
                    liveNodes = liveNodes.filter { $0.maxEstimatedValue > bestValue }

                    print ("New solution found: \(bestValue)")
                }
            }

            let solutions = best.expand(bestValue: bestValue)
            let sortedSolutions = solutions.sorted { $0.maxEstimatedValue < $1.maxEstimatedValue }
            liveNodes.append(contentsOf: sortedSolutions)
//            liveNodes.append(contentsOf: solutions)

            if iteration == 0 {
                print("Iteration: \(iteration) - \(bestValue)|\(best.nodes.count)-\(best.nodesLeft.count)|\(best.value)/\(best.maxEstimatedValue)")
            }
            iteration += 1
            iteration &= 0xFFF
        }

        result = bestSolution.nodes.map { $0.slide }

        return result
    }
}
