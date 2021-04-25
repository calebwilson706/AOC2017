object Day6 {

    private val startingMemoryNumbers = listOf(2,8,8,5,4,2,3,1,5,5,1,2,15,13,5,14)
    private val startOfLoopNumbers = listOf(0,13,12,10,9,8,7,5,3,2,1,1,1,10,6,5)

    fun part1() {
        solution(startingMemoryNumbers)
    }

    fun part2() {
        //found start of loop from part 1
        solution(startOfLoopNumbers)
    }

    fun part2programmatic() {
        val alreadyAttemptedDistributions = mutableMapOf<String, Int>()
        var amountOfCycles = 0
        var currentDistribution = startingMemoryNumbers

        while (alreadyAttemptedDistributions[currentDistribution.formStringDistribution()] == null) {
            alreadyAttemptedDistributions[currentDistribution.formStringDistribution()] = amountOfCycles
            currentDistribution = currentDistribution.getNextDistribution()
            amountOfCycles += 1
        }

        println(amountOfCycles - alreadyAttemptedDistributions[currentDistribution.formStringDistribution()]!!)
    }

    private fun solution(startingList : List<Int>) {
        val alreadyAttemptedDistributions = mutableMapOf<String, Int>()
        var amountOfCycles = 0
        var currentDistribution = startingList

        while (alreadyAttemptedDistributions[currentDistribution.formStringDistribution()] == null) {
            alreadyAttemptedDistributions[currentDistribution.formStringDistribution()] = 1
            currentDistribution = currentDistribution.getNextDistribution()
            amountOfCycles += 1
        }

        println(amountOfCycles)
    }

    private fun List<Int>.formStringDistribution() = this.foldRight("", { acc, new ->
        "$acc-$new"
    }).dropLast(1)

    private fun List<Int>.getNextDistribution(): List<Int> {
        val mutableCopyOfCurrent = this.toMutableList()

        val largest = this.maxOrNull()!!
        val indexOfLargestItem = this.indexOf(largest)

        mutableCopyOfCurrent[indexOfLargestItem] = 0

        val amountToAddToOthers = largest / this.size
        var amountExtraToAdd = largest % this.size

        val baseArray = MutableList(this.size) { amountToAddToOthers }

        mutableCopyOfCurrent.forEachIndexed { index, element -> baseArray[index] += element }

        var currentIndex = indexOfLargestItem + 1

        while (amountExtraToAdd > 0) {

            if (currentIndex >= this.size) {
                currentIndex = 0
            }

            baseArray[currentIndex] += 1
            amountExtraToAdd -= 1
            currentIndex += 1

        }

        return baseArray
    }

}