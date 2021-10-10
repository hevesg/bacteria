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
                for (var y = 0; y < 1; y++)
                {
                    for (var z = 0; z < _size.z; z++)
                    {
                        var humusCube = Create(new Vector3(x, y, z), (int) 1e6);
                        humusCube.transform.SetParent(gameObject.transform);
                    }
                }
            }
        }

        private GameObject Create(Vector3 position, int quantity)
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
            return go;
        }
    }
}
