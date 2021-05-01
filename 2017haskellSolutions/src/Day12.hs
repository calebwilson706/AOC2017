module Day12 where

import Data.Char
import Data.List
day12FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day12Input.txt"

append :: Foldable t => t a -> [a] -> [a]
append xs ys = foldr (:) ys xs


part1 :: [String] -> IO ()
part1 inputLines = print(length(getChildren("0",communications,[])))
        where communications = getInitialAdjacencyLists inputLines

part2 :: [String] -> IO ()
part2 inputLines = print(fst (foldr (curry changeStateOfConnectionsAfterGrouping) (0, communications) [0..1999]))
        where communications = getInitialAdjacencyLists inputLines

changeStateOfConnectionsAfterGrouping :: (Int,(Int,[(String,[String])])) -> (Int,[(String,[String])])
changeStateOfConnectionsAfterGrouping (currentNumber, (totalGroups, connections)) = (newAmountOfGroups, remainingConnections)
        where stringOfParent = show currentNumber
              validGroup = any (\connection -> isKeyEqualToDesiredKey(stringOfParent, connection)) connections
              foundGroupOfCurrentNumber = if validGroup then  getChildren(stringOfParent, connections, []) else []
              remainingConnections = filter (\connection -> fst connection `notElem` foundGroupOfCurrentNumber) connections
              newAmountOfGroups = totalGroups + if validGroup then 1 else 0

getChildren :: (String, [(String,[String])], [String]) -> [String]
getChildren (searchParent, communications, foundAlready) = nub allChildren
        where directChildren = snd (head (filter (\connection -> isKeyEqualToDesiredKey(searchParent,connection)) communications))
              thoseFound = append [searchParent] foundAlready
              newChildrenToSearch = filter (`notElem` thoseFound) directChildren
              allChildren = foldr (append . (\child -> getChildren(child, communications, thoseFound))) directChildren newChildrenToSearch

getInitialAdjacencyLists :: [String] -> [(String,[String])]
getInitialAdjacencyLists assignmentStatements = communications
        where assignmentStatementsNumberLists = map (words . filter (\character -> isDigit character || isSpace character)) assignmentStatements
              communications = map (\assignmentNumbers -> (head assignmentNumbers,tail assignmentNumbers)) assignmentStatementsNumberLists

isKeyEqualToDesiredKey :: (String, (String, [String])) -> Bool
isKeyEqualToDesiredKey (desiredKey, (key, children)) = key == desiredKey

main :: IO()
main = do inputText <- readFile day12FilePath
          part2 $ lines inputText
