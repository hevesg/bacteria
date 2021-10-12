using System.Linq;
using UnityEngine;

namespace Humus
{
    public class HumusContainer : MonoBehaviour
    {
        public Vector3Int initialSize;
        
        private Vector3Int _size;
        
        private void Awake()
        {
            initialSize = new Vector3Int(1, 1, 1);
        }

        private void Start()
        {
            _size = initialSize;
            for (var x = 0; x < _size.x; x++) 
            {
                for (var y = 0; y < _size.y; y++)
                {
                    for (var z = 0; z < _size.z; z++)
                    {
                        Add(new Vector3(x, y, z), (int) 1e5);
                    }
                }
            }
        }

        public GameObject[] GetRandomCubes(int count)
        {
            var gameObjects = new GameObject[count];
            var list = Enumerable.Range(0, gameObject.transform.childCount - 1).ToList();
            list.Sort((a, b)=> 1 - 2 * Random.Range(0, 1));
            for (var i = 0; i < count; i++)
            {
                gameObjects[i] = gameObject.transform.GetChild(list[i]).gameObject;
            }
            return gameObjects;
        }

        private void Add(Vector3 position, int quantity)
        {
            var go = new GameObject("Humus")
            {
                transform =
                {
                    localPosition = new Vector3(position.x, position.y, position.z),
                    localRotation = Quaternion.Euler(0, 0, 0)
                }
            };
            var humusCube = go.AddComponent<HumusCube>();
            humusCube.initialQuantity = quantity;
            
            go.transform.SetParent(gameObject.transform);
        }
    }
}
