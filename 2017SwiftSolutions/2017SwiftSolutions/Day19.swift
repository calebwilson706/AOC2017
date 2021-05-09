//
//  Day19.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 07/05/2021.
//

import Foundation
import PuzzleBox

class Day19 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day19Input.txt")
    }
    
    func part1() {
        let (path, _) = getDataForBothParts()
        print(path)
    }
    
    func part2() {
        let (_, steps) = getDataForBothParts()
        print(steps)
    }
    
    func getDataForBothParts() -> (String, Int) {
        let state = StateOfMovement(inputStringLines: inputStringUnparsed!.components(separatedBy: "\n"))
        return state.getDataFromStartToEnd()
    }
    
}

class StateOfMovement {
    var currentPoint : Point
    var lettersPassedOver = [Character]()
    var currentDirection = DirectionsDay19.DOWN
    var stepsTaken = 0
    let map : [String]
    
    init(inputStringLines : [String]) {
        let y = 0
        let x = [Character](inputStringLines[y]).firstIndex(of: "|")!
        
        self.currentPoint = Point(x: x, y: y)
        self.map = inputStringLines
    }
    
    func getDataFromStartToEnd() -> (String, Int){
        while currentDirection != .STOP {
            switch currentDirection {
            case .UP:
                moveUp()
            case .LEFT:
                moveLeft()
            case .RIGHT:
                moveRight()
            case .DOWN:
                moveDown()
            case .STOP:
                print("found the end")
            }
        }
        return(lettersPassedOver.reduce("") { acc, next in
            acc + String(next)
        },stepsTaken)
    }
    
    func moveUp() {
        move {
            $0.down()
        }
    }
    
    func moveDown() {
        move {
            $0.up()
        }
    }
    
    func moveLeft() {
        move {
            $0.left()
        }
    }
    
    func moveRight() {
        move {
            $0.right()
        }
    }
    
    private func move(changeCoordsMethod : (Point) -> Point) {
        currentPoint = changeCoordsMethod(currentPoint)
        stepsTaken += 1
        var currentCharacter = map[currentPoint.y][currentPoint.x]
        while currentCharacter != "+" && currentCharacter != " " {
            if currentCharacter.isLetter {
                lettersPassedOver.append(currentCharacter)
            }
            
            self.currentPoint = changeCoordsMethod(currentPoint)
            currentCharacter = map[currentPoint.y][currentPoint.x]
            stepsTaken += 1
        }
        changeToNextDirection()
    }
    
    private func changeToNextDirection() {
        var listOfAvailableSteps = [DirectionsDay19]()
        
        updateAvailableDirections(point: currentPoint.up(), direction: .DOWN, existingList: &listOfAvailableSteps)
        updateAvailableDirections(point: currentPoint.down(), direction: .UP, existingList: &listOfAvailableSteps)
        updateAvailableDirections(point: currentPoint.left(), direction: .LEFT, existingList: &listOfAvailableSteps)
        updateAvailableDirections(point: currentPoint.right(), direction: .RIGHT, existingList: &listOfAvailableSteps)
        
        self.currentDirection = listOfAvailableSteps.filter { $0 != currentDirection.opposite() }.first ?? .STOP
    }
    
    private func updateAvailableDirections(point : Point, direction : DirectionsDay19, existingList : inout [DirectionsDay19]) {
        if map.count <= point.y {
            return
        }
        
        if map[point.y].count <= point.x {
            return
        }
        
        let theCharacter = map[point.y][point.x]
        
        if theCharacter == "|" || theCharacter == "-" {
            existingList.append(direction)
        }
    }
}

enum DirectionsDay19 {
    case UP,LEFT,RIGHT,DOWN,STOP
    
    func opposite() -> DirectionsDay19 {
        switch self {
        case .UP:
            return .DOWN
        case .LEFT:
            return .RIGHT
        case .RIGHT:
            return .LEFT
        case .DOWN:
            return .UP
        case .STOP:
            return self
        }
    }
}
