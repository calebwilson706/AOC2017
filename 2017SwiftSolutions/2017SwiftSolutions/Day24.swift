//
//  Day24.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 14/05/2021.
//

import Foundation
import PuzzleBox



class Day24 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day24Input.txt")
    }
    
    func part1() {
        print(getStrongestBridgeStrength(bridges: getBridgesStartingFromZero()))
    }
    
    func part2() {
        let foundBridges = getBridgesStartingFromZero()
        let longestLength = foundBridges.map { $0.count }.max()!
        let allLongestBridges = foundBridges.filter { $0.count == longestLength }
        print(getStrongestBridgeStrength(bridges: allLongestBridges))
    }
    
    private func getComponents() -> [BridgeComponent] {
        inputStringUnparsed!.components(separatedBy: "\n").map { line in
            let numbersInLine = line.components(separatedBy: "/").map { Int($0)! }
            return BridgeComponent(head: numbersInLine.first!, tail: numbersInLine.last!)
        }
    }
    
    private func getBridgesStartingFromZero() -> [[BridgeComponent]] {
        var foundBridges = [[BridgeComponent]]()
        findBridgesFromExistingBridgeOrStartingPoint(
            foundBridges: &foundBridges,
            startingBridge: [],
            availableComponents: getComponents(),
            valueToConnect: 0
        )
        return foundBridges
    }
    
    private func findBridgesFromExistingBridgeOrStartingPoint(foundBridges : inout [[BridgeComponent]], startingBridge : [BridgeComponent], availableComponents : [BridgeComponent], valueToConnect : Int) {
        let thoseWhichHeadsCanConnect = availableComponents.filter { $0.head == valueToConnect }
        let thoseWhichTailsCanConnect = availableComponents.filter { $0.tail == valueToConnect }
        
        if thoseWhichHeadsCanConnect.isEmpty || thoseWhichTailsCanConnect.isEmpty {
            foundBridges.append(startingBridge)
        }
        
        extendFoundBridges(foundBridges: &foundBridges, availableComponents: availableComponents, componentsToUse: thoseWhichTailsCanConnect, useHead: true, startingBridge: startingBridge)
        extendFoundBridges(foundBridges: &foundBridges, availableComponents: availableComponents, componentsToUse: thoseWhichHeadsCanConnect, useHead: false, startingBridge: startingBridge)
    }
    
    private func extendFoundBridges(
        foundBridges : inout [[BridgeComponent]],
        availableComponents : [BridgeComponent],
        componentsToUse : [BridgeComponent],
        useHead : Bool,
        startingBridge : [BridgeComponent])
    {
        componentsToUse.forEach { nextComponent in
            findBridgesFromExistingBridgeOrStartingPoint(
                foundBridges: &foundBridges,
                startingBridge: startingBridge + [nextComponent],
                availableComponents: availableComponents.filter { $0 != nextComponent },
                valueToConnect: useHead ? nextComponent.head : nextComponent.tail
            )
        }
    }
    
    
    private func getStrengthOfBridge(_ bridge : [BridgeComponent]) -> Int {
        bridge.reduce(0) { acc, next in
            acc + next.strength
        }
    }
    
    private func getStrongestBridgeStrength(bridges : [[BridgeComponent]]) -> Int {
        bridges.map {
            getStrengthOfBridge($0)
        }.max()!
    }
}

struct BridgeComponent : Equatable {
    let head : Int
    let tail : Int
    
    var strength : Int {
        head + tail
    }

}
