//
//  Area_Code_FillerTests.swift
//  Area Code FillerTests
//
//  Created by Javon Davis on 12/11/18.
//  Copyright © 2018 Javon Davis. All rights reserved.
//

import XCTest
@testable import Area_Code_Filler

class Area_Code_FillerTests: XCTestCase {

    var numbers = ["(876) 3682393", "", "343231342", "134333223","4535643"]
    var expectedResult = [ "8763682393", "", "8763231342", "18764333223", "8764535643" ]
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        let numberOperations = NumberOperations()
        self.measure {
            for (i, e) in numbers.enumerated() {
                let expectedNumber = expectedResult[expectedResult.index(expectedResult.startIndex, offsetBy: i)]
                XCTAssertEqual(numberOperations.replaceWith876(phoneNumber: e), expectedNumber)
            }
        }
    }

}
