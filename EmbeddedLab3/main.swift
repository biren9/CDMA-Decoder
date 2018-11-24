//
//  main.swift
//  EmbeddedLab3
//
//  Created by Gil Biren on 22.11.18.
//  Copyright © 2018 Gil Biren. All rights reserved.
//

import Foundation

guard CommandLine.arguments.count > 1 else {
    fatalError("Missing filepath argument")
}

let content: String
do {
    content = try String(contentsOfFile: CommandLine.arguments[1])
}
catch(_) {
    fatalError("Could not read File!")
}

let escapedContent = content.replacingOccurrences(of: "\n", with: "")
let signalMap = escapedContent.split(separator: " ").map { Int($0)! }
let results = CDMADecoder.decode(signal: signalMap)

for result in results {
    print("Satellite \(result.id) has sent bit \(result.bit ? "1" : "0") (delta = \(result.delta))")
}
