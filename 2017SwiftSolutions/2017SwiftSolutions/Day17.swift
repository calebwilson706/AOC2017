//
//  Day17.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 04/05/2021.
//

import Foundation
import PuzzleBox

class Day17 {
    let stepSize = 316
    
    func part1() {
        var circularBuffer = [0]
        var currentIndex = 0
        
        (1...2017).forEach {
            currentIndex = getNextIndex(step: stepSize, current: currentIndex, max: circularBuffer.count)
            circularBuffer.insert($0, at: currentIndex)
        }
        
        print(circularBuffer[currentIndex + 1])
    }
    
    func part2() {
        var valueAtIndexOne = 0
        var currentLength = 1
        var currentIndex = 0
        
        (1...50000000).forEach {
            currentIndex = getNextIndex(step: stepSize, current: currentIndex, max: currentLength)
            if currentIndex == 1 {
                valueAtIndexOne = $0
            }
            currentLength += 1
        }
        
        print(valueAtIndexOne)
    }
    
    func getNextIndex(step : Int, current : Int, max : Int) -> Int {
        ((current + step) % max) + 1
    }
}
