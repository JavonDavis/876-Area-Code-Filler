//
//  NumberOperations.swift
//  Area Code Filler
//
//  Created by Javon Davis on 3/31/19.
//  Copyright © 2019 Javon Davis. All rights reserved.
//

import Foundation

struct NumberOperations {
    func getNumbers(phoneNumber: String) -> String {
        var newNumber = ""
        for char in phoneNumber {
            if char <= "9" && char >= "0" {
                newNumber += String(char)
            }
        }
        return newNumber
    }
    
    func startsWith876(phoneNumber: String) -> Bool {
        let numbers = getNumbers(phoneNumber: phoneNumber)
        if numbers.count >= 7 {
            return numbers.starts(with: "1876") || numbers.starts(with: "876")
        }
        return false
    }
    
    func replaceWith876(phoneNumber: String) -> String {
        var newNumber = ""
        let numbers = getNumbers(phoneNumber: phoneNumber)
        
        guard numbers.count >= 7 else {
                return phoneNumber
        }
        
        if numbers.starts(with: "1") {
            newNumber += "1"
        }
        
        newNumber += "876"
        newNumber += String(numbers[numbers.index(numbers.startIndex, offsetBy: max(0, numbers.count - 7))...])
        return newNumber
    }
}
