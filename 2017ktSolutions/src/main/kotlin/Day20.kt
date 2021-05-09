import java.io.File
import kotlin.math.abs

private val day20BufferPoints = File("/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day20Input.txt")
    .readLines()

object Day20 {
    fun part1() {
        val myPoints = getInitialBufferPoints()

        println(myPoints.indices.minByOrNull {
            val pointAccelerations = myPoints[it].accelerations
            abs(pointAccelerations.x) + abs(pointAccelerations.y) + abs(pointAccelerations.z)
        })
    }

    fun part2() {
        var myPoints = getInitialBufferPoints()
        var passesSinceChangesMade = 0

        while (passesSinceChangesMade < 10) {
            val previousSize = myPoints.size
            myPoints = myPoints.map { updateBufferPoint(it) }
            myPoints = myPoints.filter { pointToFilter ->
                myPoints.count { it.positions == pointToFilter.positions } == 1
            }
            passesSinceChangesMade = if (previousSize != myPoints.size) 0 else passesSinceChangesMade + 1
        }

        println(myPoints.size)
    }


    private fun updateBufferPoint(initial : Day20BufferPoint) : Day20BufferPoint {
        val initialVelocities = initial.velocities
        val initialAccelerations = initial.accelerations
        val initialPositions = initial.positions

        val newVelocities = Day20BufferSetOfValues(
            initialVelocities.x + initialAccelerations.x,
            initialVelocities.y + initialAccelerations.y,
            initialVelocities.z + initialAccelerations.z
        )

        val newPositions = Day20BufferSetOfValues(
            initialPositions.x + newVelocities.x,
            initialPositions.y + newVelocities.y,
            initialPositions.z + newVelocities.z
        )

        return Day20BufferPoint(newPositions,newVelocities,initialAccelerations)
    }

}

data class Day20BufferPoint(
    val positions : Day20BufferSetOfValues,
    val velocities : Day20BufferSetOfValues,
    val accelerations : Day20BufferSetOfValues)

data class Day20BufferSetOfValues(val x : Int, val y : Int, val z : Int)

fun getInitialBufferPoints() : List<Day20BufferPoint> {
    val selectNumberRegexString = "(-?[0-9]+)"
    val enclosedNumberSet = "<$selectNumberRegexString,$selectNumberRegexString,$selectNumberRegexString>"
    val regex = "p=$enclosedNumberSet, v=$enclosedNumberSet, a=$enclosedNumberSet".toRegex()

    return day20BufferPoints.map {
        val (xp,yp,zp,xv,yv,zv,xa,ya,za) = regex.find(it)!!.destructured
        Day20BufferPoint(
            threeNumbersAsStringsToSetOfValues(xp,yp,zp),
            threeNumbersAsStringsToSetOfValues(xv,yv,zv),
            threeNumbersAsStringsToSetOfValues(xa,ya,za)
        )
    }
}

fun threeNumbersAsStringsToSetOfValues(x : String,y : String,z : String) = Day20BufferSetOfValues(x.toInt(),y.toInt(),z.toInt())