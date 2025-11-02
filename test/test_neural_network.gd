extends GdUnitTestSuite

var neural_network

func after_test():
	neural_network = null

func test_initialize_with_the_right_amount_of_layers():
	neural_network = NeuralNetwork.new(1,2)
	assert_int(neural_network.get_layers().size()).is_equal(2)
	
	neural_network = NeuralNetwork.new(1,2, [3])
	assert_int(neural_network.get_layers().size()).is_equal(3)
	
	neural_network = NeuralNetwork.new(1,2, [3, 2])
	assert_int(neural_network.get_layers().size()).is_equal(4)

func test_calculates_next_layer():
	neural_network = NeuralNetwork.new(1,2, [3])
	assert_bool(neural_network.get_layers()[0].has_next()).is_true()
	assert_bool(neural_network.get_layers()[1].has_next()).is_true()
	assert_bool(neural_network.get_layers()[2].has_next()).is_false()

func test_calculates_previous_layer():
	neural_network = NeuralNetwork.new(1,2, [3])
	assert_bool(neural_network.get_layers()[0].has_previous()).is_false()
	assert_bool(neural_network.get_layers()[1].has_previous()).is_true()
	assert_bool(neural_network.get_layers()[2].has_previous()).is_true()

func test_initialize_with_the_right_amount_of_nodes():
	neural_network = NeuralNetwork.new(1,2)
	assert_int(neural_network.get_nodes().size()).is_equal(3)
	assert_int(neural_network.get_layer(0).get_nodes().size()).is_equal(1)
	assert_int(neural_network.get_layer(1).get_nodes().size()).is_equal(2)
	
	neural_network = NeuralNetwork.new(1,2, [3])
	assert_int(neural_network.get_nodes().size()).is_equal(6)
	assert_int(neural_network.get_layer(1).get_nodes().size()).is_equal(3)
	assert_int(neural_network.get_layer(2).get_nodes().size()).is_equal(2)
	
	neural_network = NeuralNetwork.new(1,2, [3, 4])
	assert_int(neural_network.get_nodes().size()).is_equal(10)
	assert_int(neural_network.get_layer(2).get_nodes().size()).is_equal(4)
	assert_int(neural_network.get_layer(3).get_nodes().size()).is_equal(2)

func test_initialize_with_the_right_amount_of_connections():
	neural_network = NeuralNetwork.new(1,2)
	assert_int(neural_network.get_layer(0).get_node(0).get_outbound_connections().size()).is_equal(2)
	assert_int(neural_network.get_layer(1).get_node(0).get_inbound_connections().size()).is_equal(1)
	assert_int(neural_network.get_layer(1).get_node(0).get_outbound_connections().size()).is_equal(0)
	
	neural_network = NeuralNetwork.new(1,2, [3])
	assert_int(neural_network.get_layer(0).get_node(0).get_outbound_connections().size()).is_equal(3)
	assert_int(neural_network.get_layer(0).get_node(0).get_inbound_connections().size()).is_equal(0)
	assert_int(neural_network.get_layer(1).get_node(0).get_outbound_connections().size()).is_equal(2)
	assert_int(neural_network.get_layer(1).get_node(0).get_inbound_connections().size()).is_equal(1)

func test_clear_connections_in_a_node():
	neural_network = NeuralNetwork.new(1,2)
	assert_int(neural_network.get_layer(0).get_node(0).get_outbound_connections().size()).is_equal(2)
	assert_int(neural_network.get_layer(1).get_node(0).get_inbound_connections().size()).is_equal(1)
	neural_network.get_layer(0).get_node(0).clear()
	assert_int(neural_network.get_layer(0).get_node(0).get_outbound_connections().size()).is_equal(0)
	assert_int(neural_network.get_layer(1).get_node(0).get_inbound_connections().size()).is_equal(0)

func test_insertion_of_new_layer():
	neural_network = NeuralNetwork.new(1,2, [3])
	neural_network.insert_layer_at(2)
	assert_int(neural_network.get_layers().size()).is_equal(4)
	assert_int(neural_network.get_layer(2).get_nodes().size()).is_equal(0)
	assert_int(neural_network.get_layer(3).get_nodes().size()).is_equal(2)
