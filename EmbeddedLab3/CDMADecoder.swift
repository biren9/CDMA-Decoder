//
//  CDMADecoder.swift
//  EmbeddedLab3
//
//  Created by gil biren on 23/11/2018.
//  Copyright © 2018 Gil Biren. All rights reserved.
//

import Cocoa

class CDMADecoder: NSObject {
    /*
        Es muss Gerade / Ungerade Registerlänge beachtet werden! S.598
     
     
     */
    private static let upperPeak = NSDecimalNumber(decimal: pow(2, 6) - 1).intValue
    private static let lowerPeak = NSDecimalNumber(decimal: -pow(2, 6) - 1).intValue

    private static func signalBit(signal: [Int], goldCode: [Int]) -> Int {
        var scalar = 0
        for index in 0..<signal.count {
            scalar += goldCode[index] * signal[index]
        }
        scalar /= 10
        if scalar >= upperPeak {
            return 1
        }
        else if scalar <= lowerPeak {
            return 0
        }
        return -1
    }
    
    private static func shift(signal: inout [Int]) {
        signal.insert(signal.popLast() ?? 0, at: 0)
    }
    
    static func decode(signal: [Int]) -> [(id: Int, bit: Bool, delta: Int)] {
        let goldCodes = GoldCodeGenerator.createGoldCode()
        var results: [(id: Int, bit: Bool, delta: Int)] = []
        for satellit in 0..<GoldCodeGenerator.NUMBER_OF_SATELLITE {
            var mutatingSignal = signal
            for delta in 0..<signal.count {
                let bit = signalBit(signal: mutatingSignal, goldCode: goldCodes[satellit])
                shift(signal: &mutatingSignal)
                if bit != -1 {
                    let signalBit = bit == 1 ? true : false
                    results.append((id: satellit+1, bit: signalBit, delta: delta))
                    break;
                }
            }
        }
        return results
    }
}
