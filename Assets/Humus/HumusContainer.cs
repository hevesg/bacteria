using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Humus
{
    public class HumusContainer : MonoBehaviour
    {
        public Vector3Int initialSize;
        public GameObject childObject;
        private Vector3Int _size;
        private Dictionary<Vector3Int, HumusCube> _dictionary;

        private void Awake()
        {
            initialSize = new Vector3Int(1, 1, 1);
            _dictionary = new Dictionary<Vector3Int, HumusCube>();
        }

        public void Initialize()
        {
            _size = initialSize;
            for (var x = 0; x < _size.x; x++) 
            {
                for (var y = 0; y < _size.y; y++)
                {
                    for (var z = 0; z < _size.z; z++)
                    {
                        _dictionary.Add(new Vector3Int(x, y, z), Add(new Vector3(x, y, z), (int) 1e5));
                    }
                }
            }

            AllocateNeighbors();
        }

        public GameObject[] GetRandomCubes(int count)
        {
            var gameObjects = new GameObject[count];
            var list = Enumerable.Range(0, gameObject.transform.childCount - 1).ToList();
            list.Sort((a, b)=> Random.Range(-1, 1));
            for (var i = 0; i < count; i++)
            {
                gameObjects[i] = gameObject.transform.GetChild(list[i]).gameObject;
            }
            return gameObjects;
        }

        private HumusCube Add(Vector3 position, int quantity)
        {
            var go = Instantiate(childObject, position, Quaternion.identity);
            go.name = "Humus";
            var humusCube = go.AddComponent<HumusCube>();
            humusCube.initialQuantity = quantity;
            go.transform.SetParent(gameObject.transform);
            return humusCube;
        }

        private HumusCube FindAt(int x, int y, int z)
        {
            return _dictionary[new Vector3Int(x, y, z)];
        }

        private void AllocateNeighbors()
        {
            foreach (KeyValuePair<Vector3Int, HumusCube> entry in _dictionary)
            {
                var x = entry.Key.x;
                var y = entry.Key.y;
                var z = entry.Key.z;

                if (x > 0)
                {
                    entry.Value.AddNeighbor(FindAt(x - 1, y, z));
                }

                if (y > 0)
                {
                    entry.Value.AddNeighbor(FindAt(x, y - 1, z));
                }

                if (z > 0)
                {
                    entry.Value.AddNeighbor(FindAt(x, y, z - 1));
                }

                if (x < _size.x - 1)
                {
                    entry.Value.AddNeighbor(FindAt(x + 1, y, z));
                }

                if (y < _size.y - 1)
                {
                    entry.Value.AddNeighbor(FindAt(x, y + 1, z));
                }

                if (z < _size.z - 1)
                {
                    entry.Value.AddNeighbor(FindAt(x, y, z + 1));
                }
            }
        }
    }
}
