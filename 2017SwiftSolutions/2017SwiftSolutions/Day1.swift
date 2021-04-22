//
//  Day1.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 22/04/2021.
//

import Foundation
import PuzzleBox

class Day1 : PuzzleClass, PuzzleClassProtocol {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day2Input.txt")
    }
    
    func getInputLines() -> [[Int]] {
        let lines = inputStringUnparsed?.components(separatedBy: "\n") ?? []
        return lines.map { line in
            line
                .components(separatedBy: "\t")
                .map { Int($0) ?? 0 }
        }
    }
    
    
    func part1() {
        solution(operatorForPart: getSmallestAndLargestDifferenceFromLine)
    }
    
    func part2() {
        solution(operatorForPart: getResultOfValidDivisionInLine)
    }
    
    private func solution(operatorForPart : ([Int]) -> Int) {
        let lines = getInputLines()
        print(lines.reduce(0, { accumulator, nextLine in
            accumulator + operatorForPart(nextLine)
        }))
    }
    
    private func getSmallestAndLargestDifferenceFromLine(line : [Int]) -> Int {
        var smallest = 1000
        var largest = 0
        
        line.forEach {
            if $0 > largest {
                largest = $0
            } else if $0 < smallest {
                smallest = $0
            }
        }
        
        return largest - smallest
    }
    
    private func getResultOfValidDivisionInLine(line : [Int]) -> Int {
        let sortedLine = line.map { Double($0) }

        for lowerNumber in sortedLine {
            for higherNumber in sortedLine {
                
                if higherNumber == lowerNumber {
                    continue
                }
                
                let resultOfDivision = higherNumber/lowerNumber
                
                if resultOfDivision.truncatingRemainder(dividingBy: 1) == 0 {
                    return Int(resultOfDivision)
                }
            }
        }
        
        return 0
    }
    
    
}
