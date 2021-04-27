import java.io.File

private val day8InputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day8Input.txt")
    .readLines()

object Day8 {
    private val instructions = Day8InputParsing.getInstructionsDay8()

    fun part1() {
        println(getFinalMap(false).values.maxOrNull())
    }

    fun part2() {
        getFinalMap(true)
    }


    private fun getFinalMap(isPart2 : Boolean): MutableMap<String, Int> {
        val registers = mutableMapOf<String, Int>()
        var largestValue = 0

        instructions.forEach {
            if (shouldCarryOutInstruction(it.condition, registers)) {
                registers.carryOutNewInstruction(it) { newValue ->
                    largestValue = maxOf(largestValue, newValue)
                }
            }
        }

        if (isPart2) {
            println(largestValue)
        }

        return registers
    }

    private fun MutableMap<String, Int>.carryOutNewInstruction(
        fullInstruction : FullInstruction,
        changeLargestValue : (Int) -> Unit)
    {
        val originalValue = this[fullInstruction.register] ?: 0

        val newValue = originalValue + if (fullInstruction.instruction == "inc") {
            fullInstruction.number
        } else {
            fullInstruction.number
        }

        changeLargestValue(newValue)
        this[fullInstruction.register] = newValue
    }

    private fun shouldCarryOutInstruction(condition : Condition, registers : Map<String, Int>) : Boolean {
        val registerValue = registers[condition.register] ?: 0
        val comparingValue = condition.numberInCondition

        return when (condition.operator) {
            "==" -> registerValue == comparingValue
            ">"  -> registerValue > comparingValue
            "<"  -> registerValue < comparingValue
            ">=" -> registerValue >= comparingValue
            "<=" -> registerValue <= comparingValue
            else -> registerValue != comparingValue
        }
    }

}

object Day8InputParsing {

    fun getInstructionsDay8() = day8InputLines.map { getFullInstruction(it) }

    private fun getConditionFromString(string : String) : Condition {
        val componentsToStatement = string.split(" ")

        return Condition(
            componentsToStatement.first(),
            componentsToStatement[1],
            componentsToStatement.last().toInt()
        )
    }

    private fun getFullInstruction(string: String) : FullInstruction {
        val components = string.split(" if ")
        val operationPart = components.first()
        val condition = getConditionFromString(components.last())

        val partsOfOperationPart = operationPart.split(" ")

        return FullInstruction(
            partsOfOperationPart.first(),
            partsOfOperationPart[1],
            partsOfOperationPart.last().toInt(),
            condition
        )
    }
}

data class Condition(val register : String, val operator : String, val numberInCondition : Int)

data class FullInstruction(val register : String, val instruction : String, val number : Int, val condition : Condition)



