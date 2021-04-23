module Day4 where

import System.IO ()
import Data.Char(digitToInt)
import Data.List

day4FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day4Input.txt"

calculateAmountOfValidPasswords :: ([String], Int)  -> Int
calculateAmountOfValidPasswords (passwords, part) = length  $ filter (passwordValidator part) passwords
    ---foldr (\nextLine accumulator -> accumulator + if passwordValidator part nextLine then 0 else 1) 0 passwords

doesLineNotContainRepeats :: String -> Bool
doesLineNotContainRepeats line = length wordsInLine == length (nub wordsInLine)
    where wordsInLine = words line

doesLineNotContainAnagrams :: String -> Bool
doesLineNotContainAnagrams line = length frequencyMapArray == length (nub frequencyMapArray)
    where wordsInLine = words line
          frequencyMapArray = map getFrequencyMapOfChars wordsInLine

passwordValidator :: Int -> String -> Bool
passwordValidator 1 = doesLineNotContainRepeats
passwordValidator 2 = doesLineNotContainAnagrams

getFrequencyMapOfChars :: Ord a => [a] -> [(a, Int)]
getFrequencyMapOfChars word = map (\x -> (head x, length x)) $ group $ sort word

main :: IO()
main = do inputText <- readFile day4FilePath
          print(calculateAmountOfValidPasswords (lines inputText, 2))
