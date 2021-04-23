object Day3 {
    private const val socket = 347991

    fun part1() {
        val myPoint = getPointOfNumberInSpiralMatrix(socket)
        println(kotlin.math.abs(myPoint.first) + kotlin.math.abs(myPoint.second) - 1)
    }

    fun part2() {
        val numberAfterSocket = getFirstNumberInDynamicSpiralLargerThan(socket)
        println(numberAfterSocket)
    }

    private fun getPointOfNumberInSpiralMatrix(n : Int): Pair<Int, Int> {
        var maxMoves = 1
        var runningAmountOfMoves = 0
        var runningAmountOfDirectionChanges = 0
        var currentDirection = Directions.RIGHT
        var currentPoint = Pair(0, 0)

        (1..n).forEach { _ ->

            if (runningAmountOfMoves == maxMoves) {
                currentDirection = currentDirection.changeDirections()
                runningAmountOfMoves = 0
                runningAmountOfDirectionChanges += 1
            }

            if (runningAmountOfDirectionChanges == 2) {
                runningAmountOfDirectionChanges = 0
                maxMoves += 1
            }

            currentPoint = currentDirection.getNextPoint(original = currentPoint)

            runningAmountOfMoves += 1
        }

        return currentPoint

    }

    private fun getFirstNumberInDynamicSpiralLargerThan(limit : Int) : Int {
        var maxMoves = 1
        var runningAmountOfMoves = 0
        var runningAmountOfDirectionChanges = 0
        var currentDirection = Directions.RIGHT
        var currentPoint = Pair(0, 0)
        val previousPoints = mutableMapOf<Pair<Int, Int>, Int>()
        previousPoints[Pair(0, 0)] = 1

        while (true) {

            val currentPointsTotal = totalNeighboursUp(previousPoints, currentPoint)

            if (currentPointsTotal > limit) {
                return currentPointsTotal
            } else {
                previousPoints[currentPoint] = currentPointsTotal
            }

            if (runningAmountOfMoves == maxMoves) {
                currentDirection = currentDirection.changeDirections()
                runningAmountOfMoves = 0
                runningAmountOfDirectionChanges += 1
            }

            if (runningAmountOfDirectionChanges == 2) {
                runningAmountOfDirectionChanges = 0
                maxMoves += 1
            }

            currentPoint = currentDirection.getNextPoint(original = currentPoint)

            runningAmountOfMoves += 1
        }

    }

    private fun Directions.changeDirections() : Directions {
        return when (this) {
            Directions.RIGHT -> Directions.UP
            Directions.DOWN -> Directions.RIGHT
            Directions.LEFT -> Directions.DOWN
            Directions.UP -> Directions.LEFT
        }

    }

    private fun totalNeighboursUp(inMap : Map<Pair<Int, Int>, Int>, point : Pair<Int, Int>) : Int {
        var total = 0

        for (x in (point.first - 1)..(point.first + 1)) {
            for (y in (point.second - 1)..(point.second + 1)) {
                total += inMap[Pair(x, y)] ?: 0
            }
        }

        return total
    }

    private fun Directions.getNextPoint(original : Pair<Int, Int>) : Pair<Int, Int> {
        return when (this) {
            Directions.RIGHT -> Pair(original.first + 1, original.second)
            Directions.DOWN -> Pair(original.first, original.second - 1)
            Directions.LEFT -> Pair(original.first - 1, original.second)
            Directions.UP -> Pair(original.first, original.second + 1)
        }
    }
}


enum class Directions {
    RIGHT,DOWN,LEFT,UP;
}

