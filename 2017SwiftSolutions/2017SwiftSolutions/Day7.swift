//
//  Day7.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 26/04/2021.
//

import Foundation
import PuzzleBox


private struct TreeNode {
    var name : String
    var weight : Int
    var children = [TreeNode]()
    
    init(name : String, mapOfAssignments : [String : [String]], weightMap : [String : Int]){
        self.name = name
        self.weight = weightMap[name]!
        mapOfAssignments[name]!.forEach {
            addChild(name: $0, mapOfAssignments: mapOfAssignments, weightMap: weightMap)
        }
    }
    
    func getWeight() -> Int {
        return weight + children.reduce(0, { acc, next in
            acc + next.getWeight()
        })
    }
    
    func getBadPathNode() -> TreeNode? {
        let childrenTotals = children.map { $0.getWeight() }
        
        if Set(childrenTotals).count == 1 {
            return self
        }
        
        let oddIndex = childrenTotals.firstIndex {
            childrenTotals.firstIndex(of: $0) == childrenTotals.lastIndex(of: $0)
        }
        
        return children[oddIndex!].getBadPathNode()
        
    }
    
    func getOffsetOfBadChild() -> Int {
        let childrenTotals = children.map { $0.getWeight() }
        
        let oddIndex = childrenTotals.firstIndex {
            childrenTotals.firstIndex(of: $0) == childrenTotals.lastIndex(of: $0)
        }!
        
        return childrenTotals[oddIndex == 0 ? 1 : 0] - childrenTotals[oddIndex]
    }
    
    mutating func addChild(name : String, mapOfAssignments : [String : [String]], weightMap : [String : Int]) {
        children.append(
            TreeNode(name: name, mapOfAssignments: mapOfAssignments, weightMap: weightMap)
        )
    }
}

class Day7 : PuzzleClass {
    
    var inputLines = [String]()
    
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day7Input.txt")
        inputLines = inputStringUnparsed!.components(separatedBy: "\n")
    }
    
    func part1() {
        print(getLowestProgram(in : getMapOfAssignments()))
    }
    
    func part2() {
        let rootItem = getMapOfAssignments()
        let root = TreeNode(name: getLowestProgram(in: rootItem), mapOfAssignments: rootItem, weightMap: mapOfProgramsToWeight())
        
        print(root.getBadPathNode()!.weight + root.getOffsetOfBadChild())
    }
    
    func getLowestProgram(in map : [String : [String]]) -> String {
        return map.filter { pair in
            !map.values.contains(where: {
                $0.contains(pair.key)
            })
        }.filter {
            $0.value.count > 1
        }.first!.key

    }
    
    func getMapOfAssignments() -> [String : [String]] {
        let linesWithOnlyPrograms = inputLines.map { $0.filter { char in char.isLetter || char == " "}}
        let listOfProgramAssignments2D = linesWithOnlyPrograms
            .map { $0.components(separatedBy: .whitespaces).filter {newWord in newWord != ""} }
        var mapOfValuesToChildren = [String : [String]]()
        
        listOfProgramAssignments2D.forEach {
            mapOfValuesToChildren[$0.first!] = $0.dropFirst().map { child in String(child) }
        }
        
        return mapOfValuesToChildren
    }
    
    
    func mapOfProgramsToWeight() -> [String : Int] {
        let weights = inputLines.map {
            Int($0.filter{ char in
                char.isNumber
            })
        }
        
        let keys = inputLines.map {
            $0.filter {
                $0.isLetter || $0.isWhitespace
            }.components(separatedBy: .whitespaces)
             .first!
        }
        
        var results = [String : Int]()
        
        (0 ..< weights.count).forEach {
            results[keys[$0]] = weights[$0]
        }
        
        return results
    }
    
}
