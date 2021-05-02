module Day10 where
import Numeric
import Data.List
import Data.Char
import Data.Bits

---inputs

chainLengthsPart1 :: [Int]
chainLengthsPart1 = [94,84,0,79,2,27,81,1,123,93,218,23,103,255,254,243]

chainLengthsAsString :: [Char]
chainLengthsAsString = "94,84,0,79,2,27,81,1,123,93,218,23,103,255,254,243"

myAsciiNumbers :: [Int]
myAsciiNumbers = map ord chainLengthsAsString

part2ChainLengthsOneRound :: [Int]
part2ChainLengthsOneRound = append myAsciiNumbers [17, 31, 73, 47, 23]

--helpers
chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs =
    let (ys, zs) = splitAt n xs
    in  ys : chunksOf n zs

append :: Foldable t => t a -> [a] -> [a]
append xs ys = foldr (:) ys xs

rotateLeft :: Int -> [a] -> [a]
rotateLeft _ [] = []
rotateLeft n xs = zipWith const (drop n (cycle xs)) xs


--hashing 
getInUsableForm :: ([Int], Int) -> [Int]
getInUsableForm (listToChange, currentIndex) = rotateLeft currentIndex listToChange

returnListToOriginal :: ([Int], Int) -> [Int]
returnListToOriginal (listToFix, amountMoved) = rotateLeft (length listToFix - amountMoved) listToFix

getRemainderOfList :: ([Int], Int) -> [Int]
getRemainderOfList (theListOfNumbers, chainLength) = drop chainLength theListOfNumbers

getPartOfListToReverse :: ([Int], Int) -> [Int]
getPartOfListToReverse (theListOfNumbers, chainLength) = take chainLength theListOfNumbers

getNextIndex :: (Int, Int, Int, Int) -> Int
getNextIndex (currentIndex, skipCounter, chainLength, maxLength) = rem (currentIndex + skipCounter + chainLength) maxLength

applyOneCycle :: (Int, [Int], Int, [Int]) -> (Int, [Int])
applyOneCycle (currentIndex, currentList, indexOfChainLength, chainLengthInput) = (getNextIndex(currentIndex, indexOfChainLength, chainLength, length currentList),newList)
              where chainLength = chainLengthInput!!rem indexOfChainLength (length chainLengthInput)
                    rearrangedUsableList = getInUsableForm(currentList, currentIndex)
                    reversedHeaderOfList = reverse $ getPartOfListToReverse(rearrangedUsableList, chainLength)
                    footerOfList = getRemainderOfList(rearrangedUsableList, chainLength)
                    modifiedListToBeRearranged = append reversedHeaderOfList footerOfList
                    newList
                       | chainLength > 1 = returnListToOriginal(modifiedListToBeRearranged, currentIndex)
                       | otherwise = currentList

--use of functions above
getSparseHashUsing :: ([Int], Int)  -> (Int, [Int])
getSparseHashUsing (listOfChainLengths, amountOfCycles) = foldr (\ chainLengthIndex (currentIndex, accumulatingList) -> applyOneCycle(currentIndex, accumulatingList, chainLengthIndex, listOfChainLengths)) (0, [0..255]) (reverse [ 0 .. length listOfChainLengths * amountOfCycles - 1])

--part 2 get final hash
getDenaryFromChunk :: [Int] -> Int
getDenaryFromChunk chunk = foldl xor (head chunk) (drop 1 chunk)

integerToHexString :: Int -> String
integerToHexString a = (if length mainPart == 1 then "0" else "") ++ mainPart
        where mainPart = showHex a ""

getChunksOfSparseHash :: [Int] -> [[Int]]
getChunksOfSparseHash = chunksOf 16

--main parts
knotHash :: [Int] -> [Char]
knotHash numbersToHash = concatMap (integerToHexString . getDenaryFromChunk) (getChunksOfSparseHash (snd (getSparseHashUsing(numbersToHash, 64))))

part1 :: IO ()
part1 = print(head foundList * foundList!!1)
        where (endIndex, foundList) = getSparseHashUsing(chainLengthsPart1, 1)

part2 :: IO()
part2 = print(knotHash part2ChainLengthsOneRound)

main :: IO ()
main = print finalDay14Hashes

--Day 14 get input hashes

day14StringInput :: [Char]
day14StringInput = "uugsqrei-"

getAsciiListsForDay14 :: [[Int]]
getAsciiListsForDay14 = map ((\a -> append a [17, 31, 73, 47, 23]) . (map ord . (append day14StringInput . show))) [0..127]

finalDay14Hashes :: [[Char]]
finalDay14Hashes = map knotHash getAsciiListsForDay14