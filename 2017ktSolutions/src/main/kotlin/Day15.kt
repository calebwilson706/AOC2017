object Day15 {
    private const val aStartValue : Long = 116
    private const val bStartValue : Long = 299
    private const val aFactor : Long = 16807
    private const val bFactor : Long = 48271

    private const val divider : Long = 2147483647

    fun part1() {
        val myValues = mutableMapOf('a' to aStartValue, 'b' to bStartValue)
        var total = 0

        (0 until 40000000).forEach { _ ->
            if (myValues.getLastSixteenBinaryDigits('a') == myValues.getLastSixteenBinaryDigits('b')) {
                total += 1
            }
            myValues.nextValue('a', aFactor)
            myValues.nextValue('b', bFactor)
        }

        println(total)
    }

    fun part2() {
        val pairLimit = 5000000
        val zero : Long = 0
        val myValues = mutableMapOf('a' to aStartValue, 'b' to bStartValue)
        val validNumbers = mutableMapOf('a' to mutableListOf<Long>(), 'b' to mutableListOf<Long>())

        while (validNumbers['a']!!.size < pairLimit || validNumbers['b']!!.size < pairLimit) {

            myValues.nextValue('a', aFactor)
            myValues.nextValue('b', bFactor)

            val currentAValue = myValues['a']!!
            if (currentAValue % 4 == zero) {
                validNumbers['a']!!.add(currentAValue)
            }

            val currentBValue = myValues['b']!!
            if (currentBValue % 8 == zero) {
                validNumbers['b']!!.add(currentBValue)
            }

        }

        println((0 until pairLimit).fold(0) { accumulator, index ->
            accumulator + if (validNumbers.getLastSixteenDigitsOfCurrentItem('a', index) == validNumbers.getLastSixteenDigitsOfCurrentItem('b', index)) {
                1
            } else {
                0
            }
        })
    }


    private fun Map<Char, Long>.getLastSixteenBinaryDigits(character : Char) = this[character]!!.getLastSixteenBinaryDigitsOfLong()

    private fun MutableMap<Char, Long>.nextValue(character : Char, factor : Long) {
        this[character] = (this[character]!! * factor) % divider
    }

    private fun Long.getLastSixteenBinaryDigitsOfLong() = this.toString(2).takeLast(16)

    private fun Map<Char, MutableList<Long>>.getLastSixteenDigitsOfCurrentItem(character : Char, index : Int) = this[character]!![index].getLastSixteenBinaryDigitsOfLong()
}