//
//  Day9.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 27/04/2021.
//

import Foundation
import PuzzleBox


class Day9 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day9Input.txt")
    }
    
    func part1() {
        solution(part: 1)
    }
    
    func part2() {
        solution(part: 2)
    }
    
    func solution(part : Int) {
        let characters = [Character](inputStringUnparsed!)
        
        var amountOfGroups = 0
        var amountOfGarbage = 0
        
        var howManyGroupsDeep = 0
        var isGarbage = false
        var index = 0
        
        while index < characters.count {
            let currentCharacter = characters[index]
            
            if isGarbage {
                switch currentCharacter {
                case "!":
                    index += 1
                case ">":
                    isGarbage = false
                default:
                    amountOfGarbage += 1
                }
                
                index += 1
                continue
            }
            
            if currentCharacter == "<" {
                isGarbage = true
            }
            
            if currentCharacter == "{" {
                howManyGroupsDeep += 1
            }
            
            if currentCharacter == "}" {
                amountOfGroups += howManyGroupsDeep
                howManyGroupsDeep -= 1
            }
            
            index += 1
        }
        
        
        print(part == 1 ? amountOfGroups : amountOfGarbage)
        
    }
}
