module Day16 where

import Data.List

startingString = ['a'..'p']

day16InputFilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day16Input.txt"

wordsWhen     :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'

splitByCommas :: String -> [String]
splitByCommas = wordsWhen (==',')

splitBySlash :: String -> [String]
splitBySlash = wordsWhen (=='/')

append :: Foldable t => t a -> [a] -> [a]
append xs ys = foldr (:) ys xs

unwrapMaybeInt :: Maybe Int -> Int
unwrapMaybeInt Nothing = -1
unwrapMaybeInt (Just x) = x

rotateRight  :: Int -> [a] -> [a]
rotateRight  _ [] = []
rotateRight n xs = append newHeader newFooter
    where amountBeforeLastNAmount = length xs - n
          newFooter = take amountBeforeLastNAmount xs
          newHeader = drop amountBeforeLastNAmount xs

exchange :: ([String], [a]) -> [a]
exchange (myParametersAsStrings, currentList) = if a == b then currentList else append header $ append middle footer
    where (lowerLimit, upperLimit) = if a < b then (a, b) else (b, a)
          programOriginallyAtLower = currentList!!lowerLimit
          programOriginallyAtHigher= currentList!!upperLimit
          header = append (take lowerLimit currentList) [programOriginallyAtHigher]
          footer = append [programOriginallyAtLower] $ drop (upperLimit + 1) currentList
          middle = take (upperLimit - lowerLimit - 1) $ drop (lowerLimit + 1) currentList
          parametersAsNumbers = map (\numString -> read numString :: Int) myParametersAsStrings
          a = head parametersAsNumbers
          b = last parametersAsNumbers

partner :: Eq a => (a, a, [a]) -> [a]
partner (a, b, currentList) = exchange([show indexOfA, show indexOfB],currentList)
    where indexOfA = unwrapMaybeInt $ elemIndex a currentList
          indexOfB = unwrapMaybeInt $ elemIndex b currentList

carryOutInstruction :: ([Char], String ) -> [Char]
carryOutInstruction (currentList, instruction) = newList
        where newList
                 | head instruction == 's' = rotateRight (read instructionFooter) currentList
                 | head instruction == 'x' = exchange(parameters, currentList)
                 | otherwise = partner(head $ head parameters, head $ last parameters, currentList)
              instructionFooter = tail instruction
              parameters = splitBySlash instructionFooter



completeOneCycle :: ([String], [Char]) -> [Char]
completeOneCycle (instructions, startingStringForCycle) = foldl (curry carryOutInstruction) startingStringForCycle instructions

part1 :: [String] -> IO()
part1 instructions = print(completeOneCycle(instructions, startingString))

part2 :: [String] -> IO()
part2 instructions = print(cycle!!rem 1000000000 (length cycle))
      where cycle = part2GetCycle([startingString],instructions)

part2GetCycle :: ([String], [String]) -> [String]
part2GetCycle (previousResults, instructions) = if nextCalculation == startingString then previousResults else part2GetCycle(updatedResults, instructions)
      where nextCalculation = completeOneCycle(instructions, last previousResults)
            updatedResults = append previousResults [nextCalculation]

main :: IO()
main = do inputText <- readFile day16InputFilePath
          let instructionStrings = splitByCommas inputText
          part2 instructionStrings