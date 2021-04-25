//
//  Day5.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 25/04/2021.
//

import Foundation
import PuzzleBox

class Day5 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day5Input.txt")
    }
    
    func getOriginalNumberList() -> [Int] {
        inputStringUnparsed!.components(separatedBy: "\n").map { Int($0)! }
    }
    
    func part1() {
        solution() { existingValue in
            existingValue + 1
        }
    }
    
    func part2() {
        solution() { existingValue in
            existingValue + (existingValue >= 3 ? -1 : 1)
        }
    }
    
    func solution(getNewValueForCurrentLocation : (Int) -> Int) {
        var numbers = getOriginalNumberList()
        
        var counter = 0
        var index = 0
        
        while index < numbers.count && index >= 0 {
            let original = numbers[index]
            numbers[index] = getNewValueForCurrentLocation(original)
            index += original
            counter += 1
        }
        
        print(counter)
    }
    
}
