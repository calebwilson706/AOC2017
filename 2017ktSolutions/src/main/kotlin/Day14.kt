import java.io.File
import java.math.BigInteger

private val day14InputHashes = File("/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day14CalculatedHashes.txt")
    .readText()
    .filter { it != '"'}
    .split(",")


object Day14 {
    private val binaryLines = day14InputHashes.map {
        it.map { char ->
            Integer.parseInt(char.toString(),16)
                .toString(2).padStart(4,'0')
        }.joinToString("")
    }

    fun part1() {
        println(binaryLines.fold(0) { acc, nextLine ->
            acc + nextLine.count { it == '1' }
        })

    }
}