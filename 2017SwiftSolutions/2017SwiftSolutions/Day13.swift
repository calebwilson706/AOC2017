//
//  Day13.swift
//  2017SwiftSolutions
//
//  Created by Caleb Wilson on 02/05/2021.
//

import Foundation
import PuzzleBox

class Day13 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day13Input.txt")
    }
    
    private func getMapOfLayerToDepth() -> [Int : Int] {
        let linesSplitIntoNumberStrings = inputStringUnparsed!
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: ": ").map { numString in Int(numString)! }}
        
        return linesSplitIntoNumberStrings.reduce([Int : Int](), { accumulator, nextPair in
            var workingMap = accumulator
            workingMap[nextPair.first!] = nextPair.last!
            return workingMap
        })
    }
    
    func part1() {
        let layerDepths = getMapOfLayerToDepth()
        print((0 ..< layerDepths.keys.max()!).reduce(0, { accumulator, scannerLocation in
            let depthOfLayer = layerDepths[scannerLocation] ?? 0
            let severityOfThisLayer = isScannerAtTop(scannerLocation: scannerLocation, depthOfLayer: depthOfLayer) ? scannerLocation*depthOfLayer : 0
            return (accumulator + severityOfThisLayer)
        }))
    }
    
    func part2() {
        let layerDepths = getMapOfLayerToDepth()
        print((0..<Int.max).first {
            doesDelayAvoidBeingCaught(delay: $0, layerDepths: layerDepths)
        }!)
    }
    
    private func doesDelayAvoidBeingCaught(delay : Int, layerDepths : [Int : Int]) -> Bool {
        !(0 ... layerDepths.keys.max()!).contains { myLocation in
            isScannerAtTop(scannerLocation: delay + myLocation, depthOfLayer: layerDepths[myLocation] ?? 0)
        }
    }
    
    private func isScannerAtTop(scannerLocation : Int, depthOfLayer : Int) -> Bool {
        (scannerLocation % (2*(depthOfLayer - 1))) == 0 && depthOfLayer != 0
    }
    
}



