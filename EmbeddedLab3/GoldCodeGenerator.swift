//
//  GoldCodeGenerator.swift
//  EmbeddedLab3
//
//  Created by Gil Biren on 23.11.18.
//  Copyright © 2018 Gil Biren. All rights reserved.
//

import Cocoa

class GoldCodeGenerator: NSObject {
    // Page 603
    static let CODE_LENGTH = 1024;
    static let NUMBER_OF_SATELLITE = GPS_REGISTER_PROPERTYS.count;
    
    private static let TOP_PUSH_REGISTER_1 = 3;
    private static let TOP_PUSH_REGISTER_2 = 10;
    
    private static let BOTTOM_PUSH_REG_1 = 2;
    private static let BOTTOM_PUSH_REG_2 = 3;
    private static let BOTTOM_PUSH_REG_3 = 6;
    private static let BOTTOM_PUSH_REG_4 = 8;
    private static let BOTTOM_PUSH_REG_5 = 9;
    private static let BOTTOM_PUSH_REG_6 = 10;
    
    private static let GPS_REGISTER_PROPERTYS: [(k1: Int, k2: Int)] = [
        (2, 6),
        (3, 7),
        (4, 8),
        (5, 9),
        (1, 9),
        (2, 10),
        (1, 8),
        (2, 9),
        (3, 10),
        (2, 3),
        (3, 4),
        (5, 6),
        (6, 7),
        (7, 8),
        (8, 9),
        (9, 10),
        (1, 4),
        (2, 5),
        (3, 6),
        (4, 7),
        (5, 8),
        (6, 9),
        (1, 3),
        (4, 6)
    ];
    
    private static func createGoldCode(forSat goldCode: inout [Int], registers: (k1: Int, k2: Int)) {
        var sequenceTop = Array(repeating: 1, count: 10)
        var sequenceBottom = Array(repeating: 1, count: 10)
        var i = 0
        while i < CODE_LENGTH {
            let newElementTop =  sequenceTop[TOP_PUSH_REGISTER_2-1] ^
                sequenceTop[TOP_PUSH_REGISTER_1-1]
            
            let newElementBottom =  sequenceBottom[BOTTOM_PUSH_REG_6-1] ^
                        sequenceBottom[BOTTOM_PUSH_REG_5-1] ^
                        sequenceBottom[BOTTOM_PUSH_REG_4-1] ^
                        sequenceBottom[BOTTOM_PUSH_REG_3-1] ^
                        sequenceBottom[BOTTOM_PUSH_REG_2-1] ^
                        sequenceBottom[BOTTOM_PUSH_REG_1-1]
            
            let x = sequenceBottom[registers.k1 - 1] ^
                    sequenceBottom[registers.k2 - 1] ^
                    sequenceTop[TOP_PUSH_REGISTER_2-1]
            
            goldCode[i] = x == 0 ? -1 : 1
            sequenceTop.shifted(by: 1)
            sequenceBottom.shifted(by: 1)
            sequenceBottom[0] = newElementBottom;
            sequenceTop[0] = newElementTop;
            i += 1
        }
    }
    
    static func createGoldCode() -> [[Int]] {
        var goldCodes:[[Int]] = Array(repeating: Array(repeating: 0, count: CODE_LENGTH), count: NUMBER_OF_SATELLITE)
        for i in 0..<NUMBER_OF_SATELLITE {
            createGoldCode(forSat: &goldCodes[i], registers: GPS_REGISTER_PROPERTYS[i])
        }
        return goldCodes
    }
}



extension Array {
    mutating func shifted(by: UInt) {
        for _ in 0 ..< by {
            let lastIndex = self.count - 1
            let tmp = self[lastIndex]
            for i in stride(from: lastIndex, to: 0, by: -1) { // 9...1
                self[i] = self[i - 1]
            }
            self[0] = tmp
        }
    }
    
}
