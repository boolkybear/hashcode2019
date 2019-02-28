//
//  SlideShowProblem.swift
//  SlideShow
//
//  Created by Jose Servet Font on 28/02/2019.
//  Copyright © 2019 Jose Servet Font. All rights reserved.
//

import Cocoa

class SlideShowProblem: NSObject {
    let fotos: [Photo]

    init?(inputFile: String) {
        guard let inputString = try? String(contentsOfFile: inputFile) else {
            return nil
        }

        let lines = inputString.components(separatedBy: "\n")

        guard lines.count > 0,
            let firstLine = lines.first,
            let rowCount = Int(firstLine) else {
            return nil
        }

        let rows = lines[1...rowCount]
        fotos = rows.enumerated().compactMap { Photo(line: $0.element, index: $0.offset) }
    }

    func solve(outputFile: String) {
        let solver = DirectSolver(photos: fotos)
        let solution = solver.solve()

        do {
            try solution.textRepresentation().write(toFile: outputFile, atomically: true, encoding: .utf8)
        } catch {
            return
        }
    }
}
