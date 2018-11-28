//
//  CDMADecoder.swift
//  EmbeddedLab3
//
//  Created by gil biren on 23/11/2018.
//  Copyright © 2018 Gil Biren. All rights reserved.
//

import Cocoa

class CDMADecoder: NSObject {
    
    private static var highPeak = 0
    private static var lowPeak = 0
    
    static func generatePeak(for signal: [Int]) {
        let numberOfInterferingSatellites = abs(signal.max() ?? 0)
        highPeak =  1023 - numberOfInterferingSatellites * 65
        lowPeak = -1 * (1023 + numberOfInterferingSatellites * -63)
    }

    private static func signalBit(signal: [Int], goldCode: [Int]) -> Int {
        var scalar = 0
        for index in 0..<signal.count {
            scalar += goldCode[index] * signal[index]
        }
        if scalar >= highPeak {
            return 1
        }
        else if scalar <= lowPeak {
            return 0
        }
        return -1
    }
    
    private static func shift(signal: inout [Int]) {
        signal.insert(signal.popLast() ?? 0, at: 0)
    }
    
    static func decode(signal: [Int]) -> [(id: Int, bit: Bool, delta: Int)] {
        generatePeak(for: signal)
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
