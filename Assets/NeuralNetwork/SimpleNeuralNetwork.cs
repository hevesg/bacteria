using System.Collections.Generic;
using UnityEngine;

namespace NeuralNetwork
{
    public class SimpleNeuralNetwork
    {
        private readonly int[] _layers;

        private float[][] _neurons;

        private float[][] _biases;

        private float[][][] _weights;

        private int[] _activations;

        public SimpleNeuralNetwork(IReadOnlyList<int> layers)
        {
            _layers = new int[layers.Count];
            for (var i = 0; i < layers.Count; i++)
            {
                _layers[i] = layers[i];
            }
            InitNeurons();
            InitBiases();
            InitWeights();
        }

        public float[] FeedForward(float[] inputs)
        {
            for (var i = 0; i < inputs.Length; i++)
            {
                _neurons[0][i] = inputs[i];
            }
            for (var i = 1; i < _layers.Length; i++)
            {
                var layer = i - 1;
                for (var j = 0; j < _neurons[i].Length; j++)
                {
                    var value = 0f;
                    for (var k = 0; k < _neurons[i - 1].Length; k++)
                    {
                        value += _weights[i - 1][j][k] * _neurons[i - 1][k];
                    }
                    _neurons[i][j] = Activate(value + _biases[i][j]);
                }
            }
            return _neurons[_neurons.Length - 1];
        }

        public void Mutate(int chance, float val)
        {
            foreach (var bias in _biases)
            {
                for (var j = 0; j < bias.Length; j++)
                {
                    bias[j] =
                        (UnityEngine.Random.Range(0f, chance) <= 5)
                            ? bias[j] += Random.Range(-val, val)
                            : bias[j];
                }
            }

            foreach (var weight in _weights)
            {
                foreach (var w in weight)
                {
                    for (var k = 0; k < w.Length; k++)
                    {
                        w[k] =
                            (UnityEngine.Random.Range(0f, chance) <= 5)
                                ? w[k] +=
                                    UnityEngine.Random.Range(-val, val)
                                : w[k];
                    }
                }
            }
        }

        private float Activate(float value)
        {
            return value / Mathf.Pow(1f + Mathf.Pow(value, 2), 0.5f);
        }

        private void InitNeurons()
        {
            var neuronsList = new List<float[]>();
            foreach (var layer in _layers)
            {
                neuronsList.Add(new float[layer]);
            }
            _neurons = neuronsList.ToArray();
        }

        private void InitBiases()
        {
            var biasList = new List<float[]>();
            foreach (var layer in _layers)
            {
                var bias = new float[layer];
                for (var j = 0; j < layer; j++)
                {
                    bias[j] = UnityEngine.Random.Range(-0.5f, 0.5f);
                }
                biasList.Add (bias);
            }
            _biases = biasList.ToArray();
        }

        private void InitWeights()
        {
            var weightsList = new List<float[][]>();
            for (var i = 1; i < _layers.Length; i++)
            {
                var layerWeightsList = new List<float[]>();
                var neuronsInPreviousLayer = _layers[i - 1];
                for (var j = 0; j < _neurons[i].Length; j++)
                {
                    var neuronWeights = new float[neuronsInPreviousLayer];
                    for (var k = 0; k < neuronsInPreviousLayer; k++)
                    {
                        neuronWeights[k] = UnityEngine.Random.Range(-0.5f, 0.5f);
                    }
                    layerWeightsList.Add (neuronWeights);
                }
                weightsList.Add(layerWeightsList.ToArray());
            }
            _weights = weightsList.ToArray();
        }
    }
}
