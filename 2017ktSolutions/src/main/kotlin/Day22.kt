import java.io.File

private val day22InputStringLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day22Input.txt")
    .readLines()

object Day22 {
    private val startingPoint = Pair(day22InputStringLines.first().length / 2, day22InputStringLines.size / 2)

    fun part1() {
        var currentDirection = CompassDirections.NORTH
        val myActiveMap = getInitialMap().toMutableMap()
        var currentPoint = startingPoint
        var amountOfBurstsCausingInfection = 0

        (0 until 10000).forEach { _ ->
            currentDirection = currentDirection.getNextDirectionPart1(myActiveMap.getCharacterAt(currentPoint))
            myActiveMap.toggleCharacterAt(currentPoint)
            if (myActiveMap.getCharacterAt(currentPoint) == '#') amountOfBurstsCausingInfection += 1
            currentPoint = currentPoint.move(currentDirection)
        }

        println(amountOfBurstsCausingInfection)
    }

    fun part2() {
        var currentDirection = CompassDirections.NORTH
        val myActiveMap = getInitialMapPart2().toMutableMap()
        var currentPoint = startingPoint
        var amountOfBurstsCausingInfection = 0

        (0 until 10000000).forEach { _ ->
            val currentStatus = myActiveMap.getStateAt(currentPoint)
            if (currentStatus == StatesOfAPoint.WEAK) amountOfBurstsCausingInfection += 1
            currentDirection = currentDirection.getNextDirectionPart2(currentStatus)
            myActiveMap[currentPoint] = currentStatus.getNextStatus()
            currentPoint = currentPoint.move(currentDirection)
        }

        println(amountOfBurstsCausingInfection)
    }

    private fun CompassDirections.getNextDirectionPart1(currentCharacter: Char) = if (currentCharacter == '.') turnLeft() else turnRight()

    private fun CompassDirections.getNextDirectionPart2(currentState: StatesOfAPoint): CompassDirections {
        return when(currentState) {
            StatesOfAPoint.CLEAN -> turnLeft()
            StatesOfAPoint.WEAK -> this
            StatesOfAPoint.INFECTED -> turnRight()
            StatesOfAPoint.FLAGGED -> reverse()
        }
    }

    private fun Map<Pair<Int, Int>, Char>.getCharacterAt(point: Pair<Int, Int>) = this[point] ?: '.'

    private fun Map<Pair<Int, Int>, StatesOfAPoint>.getStateAt(point: Pair<Int, Int>) = this[point] ?: StatesOfAPoint.CLEAN

    private fun MutableMap<Pair<Int, Int>, Char>.toggleCharacterAt(point: Pair<Int, Int>) {
        this[point] = if (this[point] == '#') '.' else '#'
    }

    private fun getInitialMap() : Map<Pair<Int, Int>, Char> {
        val workingMap = mutableMapOf<Pair<Int, Int>, Char>()
        for (x in day22InputStringLines.first().indices) {
            for (y in day22InputStringLines.indices) {
                workingMap[Pair(x,y)] = day22InputStringLines[day22InputStringLines.lastIndex - y][x]
            }
        }
        return workingMap
    }

    private fun getInitialMapPart2() : Map<Pair<Int, Int>, StatesOfAPoint> {
        val workingMap = mutableMapOf<Pair<Int, Int>, StatesOfAPoint>()
        for (x in day22InputStringLines.first().indices) {
            for (y in day22InputStringLines.indices) {
                workingMap[Pair(x,y)] = if (day22InputStringLines[day22InputStringLines.lastIndex - y][x] == '.') StatesOfAPoint.CLEAN else StatesOfAPoint.INFECTED
            }
        }
        return workingMap
    }

}

enum class CompassDirections {
    NORTH,SOUTH,EAST,WEST;

    fun turnLeft(): CompassDirections {
        return when(this) {
            NORTH -> WEST
            SOUTH -> EAST
            EAST -> NORTH
            WEST -> SOUTH
        }
    }

    fun turnRight(): CompassDirections {
        return when(this) {
            NORTH -> EAST
            SOUTH -> WEST
            EAST -> SOUTH
            WEST -> NORTH
        }
    }

    fun reverse(): CompassDirections {
        return when(this) {
            NORTH -> SOUTH
            SOUTH -> NORTH
            EAST -> WEST
            WEST -> EAST
        }
    }
}

fun Pair<Int, Int>.move(direction : CompassDirections) = when (direction) {
    CompassDirections.NORTH -> Pair(first, second + 1)
    CompassDirections.SOUTH -> Pair(first, second - 1)
    CompassDirections.EAST -> Pair(first + 1, second)
    CompassDirections.WEST -> Pair(first - 1, second)
}

enum class StatesOfAPoint {
    CLEAN,WEAK,INFECTED,FLAGGED;

    fun getNextStatus() = when (this) {
        CLEAN -> WEAK
        WEAK -> INFECTED
        INFECTED -> FLAGGED
        FLAGGED -> CLEAN
    }
}