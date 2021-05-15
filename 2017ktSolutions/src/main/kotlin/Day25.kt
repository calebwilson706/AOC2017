object Day25 {

    fun part1() {
        val amountOfSteps = 12964419
        val state = DiagnosticsState('A',0, mutableMapOf())

        (0 until amountOfSteps).forEach { _ ->
            state.updateState()
        }

        print(state.currentList.values.count { it })
    }

    private data class DiagnosticsState(var currentState: Char, var currentIndex: Int, val currentList : MutableMap<Int, Boolean>) {
        fun updateState() {
            val stateToUse = states[currentState]!!
            val instructionsToUse = stateToUse.getInstructions(currentList[currentIndex] ?: false)
            currentList[currentIndex] = instructionsToUse.newValueAtIndex.toBool()
            currentIndex = instructionsToUse.transformIndex(currentIndex)
            currentState = instructionsToUse.nextState
        }
    }


    private data class InstructionsToCarryOutInState(
        val newValueAtIndex: Int,
        val transformIndex: (Int) -> Int,
        val nextState: Char
    )

    private data class State(
        val instructionsWhenCurrentIsZero: InstructionsToCarryOutInState,
        val instructionsWhenCurrentIsOne: InstructionsToCarryOutInState
    ) {
        fun getInstructions(currentItemValue : Boolean) = if (currentItemValue) instructionsWhenCurrentIsOne else instructionsWhenCurrentIsZero
    }

    private fun Int.toBool() = this == 1

    private fun moveLeft(currentIndex: Int) = currentIndex - 1
    private fun moveRight(currentIndex: Int) = currentIndex + 1

    private val states = mapOf<Char, State>(
        'A' to State(
            InstructionsToCarryOutInState(1, ::moveRight, 'B'),
            InstructionsToCarryOutInState(0, ::moveRight, 'F')
        ),
        'B' to State(
            InstructionsToCarryOutInState(0, ::moveLeft, 'B'),
            InstructionsToCarryOutInState(1, ::moveLeft, 'C')
        ),
        'C' to State(
            InstructionsToCarryOutInState(1, ::moveLeft, 'D'),
            InstructionsToCarryOutInState(0, ::moveRight, 'C')
        ),
        'D' to State(
            InstructionsToCarryOutInState(1, ::moveLeft, 'E'),
            InstructionsToCarryOutInState(1, ::moveRight, 'A')
        ),
        'E' to State(
            InstructionsToCarryOutInState(1, ::moveLeft, 'F'),
            InstructionsToCarryOutInState(0, ::moveLeft, 'D')
        ),
        'F' to State(
            InstructionsToCarryOutInState(1, ::moveRight, 'A'),
            InstructionsToCarryOutInState(0, ::moveLeft, 'E')
        )
    )
}