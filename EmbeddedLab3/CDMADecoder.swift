//
//  CDMADecoder.swift
//  EmbeddedLab3
//
//  Created by gil biren on 23/11/2018.
//  Copyright © 2018 Gil Biren. All rights reserved.
//

import Cocoa

class CDMADecoder: NSObject {
    private static let numberOfInterferingSatellites = 3
    private static let maxNoise = 65
    private static let upperPeak = GoldCodeGenerator.CODE_LENGTH-1 -  numberOfInterferingSatellites * maxNoise
    private static let lowerPeak = -(GoldCodeGenerator.CODE_LENGTH-1) + numberOfInterferingSatellites * maxNoise
    
    private static func createScalar(signal: [Int], goldCode: [Int], delta: Int) -> Int {
        var scalar = 0
        var index = 0
        for _ in 0..<signal.count {
            scalar += signal[index] * goldCode[(index + delta) % (goldCode.count-1)]
            index += 1
        }
        return scalar
    }
    
    static func decode(signal: [Int]) -> [(id: Int, bit: Bool, delta: Int)] {
        let goldCodes = GoldCodeGenerator.createGoldCode()
        var results: [(id: Int, bit: Bool, delta: Int)] = []
        for satellit in 0..<GoldCodeGenerator.NUMBER_OF_SATELLITE {
            for delta in 0..<signal.count {
                let scalar = createScalar(signal: signal, goldCode: goldCodes[satellit], delta: delta)
                if(scalar >= upperPeak || scalar <= lowerPeak) {
                    let bit = (scalar >= upperPeak) ? true : false;
                    results.append((id: satellit+1, bit: bit, delta: delta))
                }
            }
        }
        return results
    }
}
