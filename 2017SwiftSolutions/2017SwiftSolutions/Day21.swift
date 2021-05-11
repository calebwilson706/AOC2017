//
//  Day21.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 11/05/2021.
//

import Foundation
import PuzzleBox

class Day21 {
    let startingString = ".#./..#/###"
    
    func part1() {
        print(getFinalPatternAfter(n: 5).filter { $0 == "#" }.count)
    }
    
    func part2() {
        print(getFinalPatternAfter(n: 18).filter { $0 == "#" }.count)
    }
    
    
    func getFinalPatternAfter(n : Int) -> String {
        let enhancements = Enhancements().getEnhancements()
        var currentString = startingString
        
        for _ in 0..<n {
            let chunksExpanded = splitIntoSmallestChunks(pattern: currentString).map { enhancements[$0]! }
            currentString = reassemblePatternFromChunks(chunks: chunksExpanded)
        }
        
        return currentString
    }
    
    func splitIntoSmallestChunks(pattern : String) -> [String] {
        let lines = pattern.components(separatedBy: "/")
        let chunkSize = (lines.count % 2 == 0) ? 2 : 3
        let linesPaired = lines.map { [Character]($0).chunked(into: chunkSize).map {charArray in String(charArray) } }.chunked(into: chunkSize)
        
        if chunkSize == 2 {
            let foundChunks = linesPaired.flatMap { zip($0[0], $0[1]) }
                
            return foundChunks.map { (first, second) in
                first + "/" + second
            }
        } else {
            let foundChunks = linesPaired.flatMap {
                zip($0[0], zip($0[1], $0[2]))
            }
            
            return foundChunks.map { (first, arg1) in
                let (second, third) = arg1
                return first + "/" + second + "/" + third
            }
        }
    }
    
    func reassemblePatternFromChunks(chunks : [String]) -> String {
        let rowCount = Int(pow(Double(chunks.count), 0.5))
        let quartersAsArrays = chunks.map { $0.components(separatedBy: "/") }
        let groups = quartersAsArrays.chunked(into: rowCount)
        var lines = [String]()
        
        groups.forEach { linesInGroups in
            for index in ( 0..<linesInGroups[0].count ) {
                let line = linesInGroups.reduce("") { accumulatingLine, nextGroup in
                    accumulatingLine + nextGroup[index]
                }
                lines.append(line)
            }
        }
        
        return assembleLines(lines: lines)
    }
}


private func assembleLines(lines : [String]) -> String {
    String(lines.reduce(""){ acc, next in
        acc + next + "/"
    }.dropLast())
}


class Enhancements : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day21Input.txt")
    }
    
    func getEnhancements() -> [String : String] {
        let pairs = inputStringUnparsed!.components(separatedBy: "\n").map { $0.components(separatedBy: " => ")}
        return pairs.reduce([String : String]()) { accumulator, next in
            var theEnhancements = accumulator
            let arrangements = getPossibleArrangements(of: next.first!)
            let value = next.last!
            
            arrangements.forEach {
                theEnhancements[$0] = value
            }
            
            return theEnhancements
        }
    }
    
    private func getPossibleArrangements(of string : String) -> [String] {
        let lines = string.components(separatedBy: "/")
        let flipped = assembleLines(lines: lines.map { String($0.reversed()) })
        let flippedVertically = assembleLines(lines: lines.reversed())
        return getAllRotations(string: string) + getAllRotations(string: flipped) + getAllRotations(string: flippedVertically)
    }
    
    private func rotateBy90(string : String) -> String {
        let lines = string.components(separatedBy: "/").map { [Character]($0) }
        var answer = ""
        
        (0 ..< lines.count).forEach { index in
            var runningLineTotal = ""
            lines.forEach { line in
                runningLineTotal += String(line[index])
            }
            answer += runningLineTotal.reversed() + "/"
        }
        
        return String(answer.dropLast())
    }

    private func getAllRotations(string : String) -> [String] {
        let rotatedBy90 = rotateBy90(string: string)
        let rotatedBy180 = String(string.reversed())
        let rotatedBy270 = rotateBy90(string: rotatedBy180)
        
        return [string,rotatedBy90,rotatedBy180,rotatedBy270]
    }
    
}

