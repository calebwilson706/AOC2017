module Day23 where

import Data.Char


day23InputFilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day23Input.txt"

append :: Foldable t => t a -> [a] -> [a]
append xs ys = foldr (:) ys xs

isPrime n = go 2
  where
    go d
      | d*d > n        = True
      | n `rem` d == 0 = False
      | otherwise      = go (d+1)

checkIfStringIsANumber :: String -> Bool
checkIfStringIsANumber = not . any isLetter

getIndexOfRegisterInArray :: Char -> Int
getIndexOfRegisterInArray myRegister = ord myRegister - 97

getValueOfArgument :: (String , [Int]) -> Int
getValueOfArgument (argument, arrayOfRegisters) =  if checkIfStringIsANumber argument then read argument else arrayOfRegisters!!getIndexOfRegisterInArray(head argument)

getPairOfArgumentValuesFromList :: ([String], [Int]) -> (Int, Int)
getPairOfArgumentValuesFromList (arguments, registers) = (getValueOfArgument(head arguments, registers), getValueOfArgument(last arguments, registers))

insertNewValue :: (Int, String, [Int]) -> [Int]
insertNewValue (newValue, register, startList) = header ++ [newValue] ++ drop 1 footer
    where (header, footer) = splitAt index startList
          index = getIndexOfRegisterInArray(head register)

calculateNewValueForRegister :: (String, Int, Int) -> Int
calculateNewValueForRegister ("mul", existingValue, multiplyer) = existingValue * multiplyer
calculateNewValueForRegister ("sub", existingValue, numberbeingSubtracted) = existingValue - numberbeingSubtracted

updateStateDueToCurrentInstruction :: (String, [String],  ([Int], Int, Int)) -> ([Int], Int, Int)

updateStateDueToCurrentInstruction ("set", arguments, (registers, currentIndex, amountOfMulsCalled)) = (newListOfRegisters, currentIndex + 1, amountOfMulsCalled)
    where newListOfRegisters = insertNewValue(getValueOfArgument(last arguments, registers), head arguments, registers)

updateStateDueToCurrentInstruction ("jnz", arguments, (registers, currentIndex, amountOfMulsCalled)) = (registers, newIndex, amountOfMulsCalled)
    where shouldJump = getValueOfArgument(head arguments, registers) /= 0
          newIndex = currentIndex + if shouldJump then getValueOfArgument(last arguments, registers) else 1

updateStateDueToCurrentInstruction (instructionString, arguments, (registers, currentIndex, amountOfMulsCalled)) = (newListOfRegisters, currentIndex + 1, newMulsCalledTotal)
    where newListOfRegisters = insertNewValue(calculateNewValueForRegister(instructionString, existingValue, secondParameter), head arguments, registers)
          (existingValue, secondParameter) = getPairOfArgumentValuesFromList(arguments, registers)
          newMulsCalledTotal = amountOfMulsCalled + if instructionString == "mul" then 1 else 0

continueRunningProgramUntilEndOfList :: ([String], ([Int], Int, Int)) -> ([Int], Int, Int)
continueRunningProgramUntilEndOfList (instructions, stateAtStartOfCycle) =
    if currentIndex < length instructions then continueRunningProgramUntilEndOfList(instructions, updatedState) else stateAtStartOfCycle
    where (_, currentIndex, _) = stateAtStartOfCycle
          updatedState = updateStateDueToCurrentInstruction(head currentInstructionParts, tail currentInstructionParts, stateAtStartOfCycle)
          currentInstructionParts = words $ instructions!!currentIndex

startProgramAndGetFinalState :: String -> ([Int], Int, Int )
startProgramAndGetFinalState inputText =  continueRunningProgramUntilEndOfList(lines inputText, (map (const 0) ['a'..'h'],0,0))

part1 :: String -> IO()
part1 inputText = print answer
    where (_,_,answer) = startProgramAndGetFinalState inputText

part2NumbersToCheck :: [Int]
part2NumbersToCheck = filter (\num -> rem (num - b) 17 == 0) [b .. (b + 17000)]
    where b = 79*100 + 100000

part2 :: IO()
part2 = print $ length $ filter (not . isPrime) part2NumbersToCheck

main :: IO()
main = do inputText <- readFile day23InputFilePath
          part2

