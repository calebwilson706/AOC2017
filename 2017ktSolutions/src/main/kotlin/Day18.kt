import java.io.File
import java.util.LinkedList

private const val zero : Long = 0
private val day18Instructions = File("/Users/calebjw/Documents/Developer/AdventOfCode/2017/Inputs/Day18Input.txt")
    .readLines()

object Day18 {
    fun part1() {
        val instructions = getInstructions()
        var programState = Part1ProgramState(mapOf(),0,0,false)
        while (programState.currentIndex < instructions.size) {
            val instruction = instructions[programState.currentIndex]
            programState = carryOutInstructionPart1(instruction, programState)

            if (programState.shouldTerminate) {
                break
            }
        }
    }

    fun part2() {
        val instructions = getInstructions()
        var programState = Part2OverallProgramState(
            program0 = Part2ProgramState(mutableMapOf("p" to 0, "1" to 1)),
            program1 = Part2ProgramState(mutableMapOf("p" to 1, "1" to 1))
        )

        while(programState.program0.canBeRan(instructions,programState.program1.output) || programState.program1.canBeRan(instructions,programState.program0.output)) {
            programState = carryOutInstructionPart2(instructions,programState,0)
            programState = carryOutInstructionPart2(instructions,programState,1)
        }

        println(programState.amountSetForProgram1)
    }

    private fun carryOutInstructionPart2(
        instructions : List<Day18FullInstruction>,
        overallState : Part2OverallProgramState,
        currentProgram : Int) :  Part2OverallProgramState {

        val (currentProgramState, otherProgramState) = if (currentProgram == 0) {
            Pair(overallState.program0, overallState.program1)
        } else {
            Pair(overallState.program1, overallState.program0)
        }

        if (!currentProgramState.canBeRan(instructions,otherProgramState.output)) {
            return overallState
        }
        val currentInstruction = instructions[currentProgramState.currentIndex]
        val numberInCurrentRegister = currentProgramState.registers[currentInstruction.register] ?: 0
        val instructionExtraParameterValue : Long? = when (currentInstruction.operator) {
            Day18Operators.SEND, Day18Operators.RECEIVE -> null
            else -> currentProgramState.registers[currentInstruction.extraParameter] ?: currentInstruction.extraParameter!!.toLong()
        }
        var amountSentForProgram1 = overallState.amountSetForProgram1

        when (currentInstruction.operator) {
            Day18Operators.SEND -> {
                currentProgramState.output.enqueue(numberInCurrentRegister)
                amountSentForProgram1 += currentProgram
            }
            Day18Operators.SET_REGISTER_TO -> currentProgramState.registers[currentInstruction.register] = instructionExtraParameterValue!!
            Day18Operators.ADD_TO_REGISTER -> currentProgramState.registers[currentInstruction.register] = numberInCurrentRegister + instructionExtraParameterValue!!
            Day18Operators.MULTIPLY_REGISTER_BY -> currentProgramState.registers[currentInstruction.register] = numberInCurrentRegister * instructionExtraParameterValue!!
            Day18Operators.MODULO_OF_REGISTER_AND_INPUT -> currentProgramState.registers[currentInstruction.register] = numberInCurrentRegister % instructionExtraParameterValue!!
            Day18Operators.RECEIVE -> currentProgramState.registers[currentInstruction.register] = otherProgramState.output.dequeue()
            Day18Operators.JUMP_IF_GREATER_THAN_ZERO -> {
                if (numberInCurrentRegister > 0) {
                    currentProgramState.currentIndex += (instructionExtraParameterValue!!.toInt() - 1)
                }
            }
        }
        currentProgramState.currentIndex += 1

        return if (currentProgram == 0) {
            Part2OverallProgramState(
                currentProgramState,otherProgramState,amountSentForProgram1
            )
        } else {
            Part2OverallProgramState(
                otherProgramState,currentProgramState,amountSentForProgram1
            )
        }
    }

    private fun carryOutInstructionPart1(instruction : Day18FullInstruction, currentState : Part1ProgramState) : Part1ProgramState {
        val registers = currentState.registers.toMutableMap()
        var output = currentState.output
        var index = currentState.currentIndex
        val numberInCurrentRegister = registers[instruction.register] ?: 0
        var shouldTerminate = currentState.shouldTerminate

        val instructionExtraParameterValue : Long? = when (instruction.operator) {
            Day18Operators.SEND, Day18Operators.RECEIVE -> null
            else -> registers[instruction.extraParameter] ?: instruction.extraParameter!!.toLong()
        }

        when (instruction.operator) {
            Day18Operators.SEND -> output = numberInCurrentRegister
            Day18Operators.SET_REGISTER_TO -> registers[instruction.register] = instructionExtraParameterValue!!
            Day18Operators.ADD_TO_REGISTER -> registers[instruction.register] = numberInCurrentRegister + instructionExtraParameterValue!!
            Day18Operators.MULTIPLY_REGISTER_BY ->  registers[instruction.register] = numberInCurrentRegister * instructionExtraParameterValue!!
            Day18Operators.MODULO_OF_REGISTER_AND_INPUT ->  registers[instruction.register] = numberInCurrentRegister % instructionExtraParameterValue!!
            Day18Operators.RECEIVE -> {
                if (numberInCurrentRegister != zero) {
                    println(output)
                    shouldTerminate = true
                }
            }
            Day18Operators.JUMP_IF_GREATER_THAN_ZERO -> {
                if (numberInCurrentRegister > 0) {
                    index += (instructionExtraParameterValue!!.toInt() - 1)
                }
            }
        }

        index++

        return Part1ProgramState(registers,output,index,shouldTerminate)
    }

    data class Part1ProgramState(val registers : Map<String, Long>, val output : Long, val currentIndex : Int, val shouldTerminate : Boolean)
    data class Part2ProgramState(val registers : MutableMap<String, Long>, val output : OutputQueue = OutputQueue(), var currentIndex : Int = 0) {
        fun canBeRan(instructions : List<Day18FullInstruction>, otherListOutput : OutputQueue) : Boolean {
            if (!instructions.indices.contains(currentIndex)) {
                return false
            }
            return !(otherListOutput.isEmpty() && instructions[currentIndex].operator == Day18Operators.RECEIVE)
        }
    }
    data class Part2OverallProgramState(val program0 : Part2ProgramState, val program1 : Part2ProgramState, val amountSetForProgram1 : Int = 0)
}



//Parsing

data class Day18FullInstruction(val operator : Day18Operators, val register : String, val extraParameter : String?)

enum class Day18Operators {
    SEND,
    SET_REGISTER_TO,
    ADD_TO_REGISTER,
    MULTIPLY_REGISTER_BY,
    MODULO_OF_REGISTER_AND_INPUT,
    RECEIVE,
    JUMP_IF_GREATER_THAN_ZERO
}

private fun getOperatorFromString(string : String) : Day18Operators {
    return when (string) {
        "snd" -> Day18Operators.SEND
        "set" -> Day18Operators.SET_REGISTER_TO
        "add" -> Day18Operators.ADD_TO_REGISTER
        "mul" -> Day18Operators.MULTIPLY_REGISTER_BY
        "mod" -> Day18Operators.MODULO_OF_REGISTER_AND_INPUT
        "rcv" -> Day18Operators.RECEIVE
        else -> Day18Operators.JUMP_IF_GREATER_THAN_ZERO
    }
}

private fun getInstructions() : List<Day18FullInstruction> =
    day18Instructions.map { instruction ->
        val parts = instruction.split(" ")
        val operator = getOperatorFromString(parts.first())
        val extraParameter = when (operator) {
            Day18Operators.SEND, Day18Operators.RECEIVE -> null
            else -> parts.last()
        }
        Day18FullInstruction(operator, parts[1], extraParameter)
    }

class OutputQueue {
    private val queue = LinkedList<Long>()

    fun enqueue(value : Long) = queue.push(value)
    fun dequeue(): Long = queue.removeLast()
    fun isEmpty() = queue.isEmpty()
}