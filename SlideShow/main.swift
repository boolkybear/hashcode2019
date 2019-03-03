//
//  main.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

func extractStrategy(from strategies: [String], prefix: String) -> String {
    let prefixLength = prefix.count
    return strategies
        .filter { $0.hasPrefix(prefix) }
        .map { $0[$0.index($0.startIndex, offsetBy: prefixLength)...] }
        .map { String($0) }
        .first ?? ""
}

if CommandLine.arguments.count < 3 {
    print("main inputFile outputFile [v:verticalStrategy] [s:slideStrategy]")
    exit(-1)
}

let strategies = Array(CommandLine.arguments[3...])
let verticalStrategy = extractStrategy(from: strategies, prefix: "v:")
let slideStrategy = extractStrategy(from: strategies, prefix: "s:")

guard let problem = SlideShowProblem(inputFile: CommandLine.arguments[1],
                                     verticalStrategy: verticalStrategy,
                                     slideStrategy: slideStrategy) else {
    print("Error on input file: \(CommandLine.arguments[1])")
    exit(-1)
}

problem.solve(outputFile: CommandLine.arguments[2])
