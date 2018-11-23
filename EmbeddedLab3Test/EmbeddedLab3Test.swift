//
//  GoldCodeGeneratorTest.swift
//  EmbeddedLab3
//
//  Created by Gil Biren on 23.11.18.
//  Copyright © 2018 Gil Biren. All rights reserved.
//

import XCTest

class GoldCodeGeneratorTest: XCTestCase {
    var expectedResults:[String] = Array(repeating: "", count: 24)
    override func setUp() {
        expectedResults[0] = "110010000011"
        expectedResults[1] = "111001000011"
        expectedResults[2] = "111100100011"
        expectedResults[3] = "111110010011"
        expectedResults[4] = "100101101100"
        expectedResults[5] = "110010110100"
        expectedResults[6] = "100101100111"
        expectedResults[7] = "110010110001"
        expectedResults[8] = "111001011010"
        expectedResults[9] = "110100010010"
        expectedResults[10] = "111010001011"
        expectedResults[11] = "111110100001"
        expectedResults[12] = "111111010010"
        expectedResults[13] = "111111101011"
        expectedResults[14] = "111111110111"
        expectedResults[15] = "111111111001"
        expectedResults[16] = "100110111000"
        expectedResults[17] = "110011011110"
        expectedResults[18] = "111001101101"
        expectedResults[19] = "111100110100"
        expectedResults[20] = "111110011000"
        expectedResults[21] = "111111001110"
        expectedResults[22] = "100011001111"
        expectedResults[23] = "111100011010"
    }
    
    func testGoldCode() {
        var index = 0;
        let goldCodes = GoldCodeGenerator.createGoldCode()
        for goldCode in goldCodes {
            var formattedGoldCode = ""
            for i in goldCode {
                formattedGoldCode.append("\(i == 1 ? 1:0)")
            }
            
            let result = formattedGoldCode[..<formattedGoldCode.index(formattedGoldCode.startIndex, offsetBy: expectedResults[index].count)]
            XCTAssert(result == expectedResults[index], "Fail! Gold codes are wrong")
            index += 1
        }
    }
}
