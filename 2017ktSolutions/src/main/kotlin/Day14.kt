import java.io.File
import java.math.BigInteger

private val day14InputHashes = File("/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day14CalculatedHashes.txt")
    .readText()
    .filter { it != '"'}
    .split(",")


object Day14 {
    private val binaryLines = day14InputHashes.map {
        it.map { char ->
            Integer.parseInt(char.toString(), 16)
                .toString(2).padStart(4, '0')
        }.joinToString("")
    }

    fun part1() {
        println(binaryLines.fold(0) { acc, nextLine ->
            acc + nextLine.count { it == '1' }
        })
    }

    fun part2() {
        val existingRegions = mutableMapOf<Pair<Int, Int>, Int>()
        var latestGroup = 1

        fun fillMapWithThoseNeighbouring(currentPoint : Pair<Int, Int>) {
            existingRegions[currentPoint] = latestGroup

            listOf(
                currentPoint.above(),
                currentPoint.below(),
                currentPoint.right(),
                currentPoint.left()
            ).filter {
                (0..127).contains(it.first)
                        && (0..127).contains(it.second)
                        && binaryLines[it.second][it.first] == '1'
                        && existingRegions[it] == null
            }.forEach {
                fillMapWithThoseNeighbouring(it)
            }
        }

        for (y in 0..127){
            for (x in 0..127){
                val point = Pair(x, y)
                if (binaryLines[y][x] == '1' && existingRegions[point] == null) {
                    fillMapWithThoseNeighbouring(point)
                    latestGroup += 1
                }
            }
        }

        println(latestGroup - 1)
    }

    private fun getNeighbouringRegion(existingRegions : Map<Pair<Int, Int>, Int>, currentPoint : Pair<Int, Int>) : Int? {
        listOf(
            currentPoint.above(),
            currentPoint.below(),
            currentPoint.right(),
            currentPoint.left()
        ).forEach {
            existingRegions[it]?.let { neighbouringRegion ->
                return neighbouringRegion
            }
        }
        return null
    }
}

fun Pair<Int, Int>.above() = Pair(first, second + 1)
fun Pair<Int, Int>.below() = Pair(first, second - 1)
fun Pair<Int, Int>.right() = Pair(first + 1, second)
fun Pair<Int, Int>.left() = Pair(first - 1, second)