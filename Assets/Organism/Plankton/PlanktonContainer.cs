using System.Linq;
using UnityEngine;
using UnityEngine.Serialization;

namespace Organism.Plankton
{
    public class PlanktonContainer : MonoBehaviour
    {
        public Vector3Int initialSize;
        public int initialPlankton;
        
        private Vector3Int _size;

        private void Awake()
        {
            initialSize = new Vector3Int(1, 1, 1);
            initialPlankton = 1;
        }

        private void Start()
        {
            _size = initialSize;
            var childCount = gameObject.transform.childCount;
            if (initialPlankton > childCount)
            {
                initialPlankton = childCount;
            }
        }

        public GameObject Add(Vector3 position, Vector3 rotation, int energy = 0)
        {
            var go = new GameObject("Plankton")
            {
                transform =
                {
                    localPosition = new Vector3(position.x, position.y, position.z),
                    localRotation = Quaternion.Euler(rotation.x, rotation.y, rotation.z)
                }
            };

            var plankton = go.AddComponent<Plankton>();
            plankton.initialEnergy = energy;
            
            go.transform.SetParent(gameObject.transform);
            return go;
        }
    }
}