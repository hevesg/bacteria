using UnityEngine;

namespace Organism.Plankton
{
    public class PlanktonContainer : MonoBehaviour
    {
        public Vector3Int initialSize;
        public int initialPlankton;
        protected Aquarium.Aquarium _aquarium;

        
        private Vector3Int _size;

        private void Awake()
        {
            initialSize = new Vector3Int(1, 1, 1);
            initialPlankton = 1;
        }

        private void Start()
        {
            _size = initialSize;
            _aquarium = gameObject.GetComponentInParent<Aquarium.Aquarium>();
            
            foreach (var cube in _aquarium.GetRandomCubes(initialPlankton))
            {
                var cubePosition = cube.transform.position;
                var position = new Vector3(cubePosition.x + 0.5f, cubePosition.y + 0.5f, cubePosition.z + 0.5f);
                Add(position, new Vector3(0, Random.Range(-180f, 180f), 0),
                    (int) 5e4);
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
            plankton.Initialize(energy);
            
            go.transform.SetParent(gameObject.transform);
            return go;
        }

        public GameObject Add(Plankton original)
        {
            var originalTransform = original.gameObject.transform;
            var originalPosition = originalTransform.position;
            var originalRotation = originalTransform.rotation.eulerAngles;
            var position = new Vector3(originalPosition.x + 0.05f, originalPosition.y, originalPosition.z + 0.05f);
            var rotation = new Vector3(originalRotation.x, originalRotation.y - 180f, originalRotation.z);
            var plankton = Add(
                position, rotation, original.Energy
            );
            plankton.GetComponent<Plankton>().Jets(10f, Random.Range(-100f, 100f), false);
            return plankton;
        }
    }
}