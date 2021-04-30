import java.io.File
import kotlin.math.abs

private val day11Input = File("/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day11Input.txt")
    .readText()

data class HexPoint(val x : Int, val y : Int, val z : Int) {

    fun getNextPoint(direction : String) : HexPoint {
        return when (direction) {
            "n" -> HexPoint(x,y + 1,z - 1)
            "ne" -> HexPoint(x + 1,y,z - 1)
            "se" -> HexPoint(x + 1,y - 1,z)
            "s" -> HexPoint(x,y - 1,z + 1)
            "sw" -> HexPoint(x - 1,y,z + 1)
            "nw" -> HexPoint(x - 1,y + 1,z)
            else -> this
        }
    }

    fun distanceFromStart() = distancesFromOrigin().maxOrNull()!!

    private fun distancesFromOrigin() : List<Int> {
        return listOf(
            abs(x),
            abs(y),
            abs(z)
        )
    }

}


object Day11 {

    private val inputDirections = day11Input.split(",")

    fun part1() {
        val finalPoint = getFinalPoint()
        println(finalPoint.distanceFromStart())
    }

    fun part2() {
        println(inputDirections.fold(Pair(HexPoint(0,0,0),0)) { (currentPoint, currentMax), direction ->
            val newPoint = currentPoint.getNextPoint(direction)
            Pair(newPoint, maxOf(currentMax,newPoint.distanceFromStart()))
        }.second)
    }

    private fun getFinalPoint() : HexPoint {
        return inputDirections.fold(HexPoint(0,0,0)) { currentPoint, direction ->
            currentPoint.getNextPoint(direction)
        }
    }

}