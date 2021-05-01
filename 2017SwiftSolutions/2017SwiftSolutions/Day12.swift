//
//  Day12.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 30/04/2021.
//

import Foundation
import PuzzleBox

class Day12 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day12Input.txt")
    }
    
    var communicationAssignmentStrings : [String] {
        self.inputStringUnparsed!.components(separatedBy: "\n")
    }
    
    func part1() {
        let foundCommunications = getInitialAdjacencyListMap()
        print(Set(getThoseCommunicating(with: 0, in: foundCommunications, currentFound: [])).count)
    }
    
    func part2() {
        var communications = getInitialAdjacencyListMap()
        var counter = 0
        
        while !communications.isEmpty {
            for relative in getThoseCommunicating(with: communications.keys.first!, in: communications, currentFound: []) {
                communications.removeValue(forKey: relative)
            }
            counter += 1
        }
        
        print(counter)
    }
    
    func getThoseCommunicating(with number : Int, in map : [Int : [Int]], currentFound : [Int]) -> [Int] {
        let directCommunicators = map[number]!
        var thoseCommunicating = directCommunicators
        let thoseFound = currentFound + [number] + directCommunicators
        
        directCommunicators.filter { !currentFound.contains($0) }.forEach {
            thoseCommunicating += getThoseCommunicating(with: $0, in: map, currentFound: thoseFound)
        }
        
        return thoseCommunicating
    }
    
    func getInitialAdjacencyListMap() -> [Int : [Int]] {
        var adjacencyListMap = [Int : [Int]]()
        
        communicationAssignmentStrings.forEach {
            let componentsOfAssignment = $0.components(separatedBy: " <-> ")
            let lhs = Int(componentsOfAssignment.first!)!
            let rightHandSideNumbers = componentsOfAssignment
                .last!
                .components(separatedBy: ", ")
                .map { Int($0)! }
            
            var existingListForLHS = adjacencyListMap[lhs] ?? []
            
            rightHandSideNumbers.forEach { number in
                existingListForLHS.append(number)
            }
            
            adjacencyListMap[lhs] = existingListForLHS
            
        }
        
        return adjacencyListMap
    }
    
}
