//
//  main.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Foundation

if CommandLine.arguments.count < 3 {
    print("main inputFile outputFile")
    exit(-1)
}

guard let problem = SlideShowProblem(inputFile: CommandLine.arguments[1]) else {
    print("Error on input file: \(CommandLine.arguments[1])")
    exit(-1)
}

problem.solve(outputFile: CommandLine.arguments[2])

