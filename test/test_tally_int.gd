extends GdUnitTestSuite

var tally: TallyInt

func before_test():
	tally = TallyInt.new()

func after_test():
	tally = null

func test_initialize_with_zero():
	assert_int(tally.current).is_equal(0)
	assert_int(tally.cumulative).is_equal(0)

func test_initialize_with_positive_value():
	var tally: TallyInt = TallyInt.new(1, 2)
	assert_int(tally.current).is_equal(1)
	assert_int(tally.cumulative).is_equal(2)

func test_initialize_with_negative_value():
	var tally: TallyInt = TallyInt.new(-1)
	assert_int(tally.current).is_equal(0)
	assert_int(tally.cumulative).is_equal(0)

func test_increase_cumulative_when_current_increases():
	tally.current = 10
	assert_int(tally.current).is_equal(10)
	assert_int(tally.cumulative).is_equal(10)

func test_not_increase_cumulative_when_current_decreases():
	tally.current = 10
	tally.current = 5
	assert_int(tally.current).is_equal(5)
	assert_int(tally.cumulative).is_equal(10)

func test_clone():
	tally.current += 5
	var clone = tally.clone()
	tally.current = 10
	assert_int(clone.current).is_equal(5)
	assert_int(tally.current).is_equal(10)

func test_splits_and_returns_new_tally():
	tally.current = 3
	var split = tally.split()
	assert_int(tally.current).is_equal(1)
	assert_int(tally.cumulative).is_equal(1)
	assert_int(split.current).is_equal(2)
	assert_int(split.cumulative).is_equal(2)

func test_add_value():
	tally.add(5)
	assert_int(tally.current).is_equal(5)
	assert_int(tally.cumulative).is_equal(5)

func test_remove_value():
	tally = TallyInt.new(10)
	tally.remove(5)
	assert_int(tally.current).is_equal(5)
	assert_int(tally.cumulative).is_equal(10)
