using UnityEngine;

namespace Organism.Bacteria
{
    public class BacteriaContainer : MonoBehaviour
    {
        public int initialBacteria;
        public GameObject childObject;
        protected Aquarium.Aquarium _aquarium;

        private void Awake()
        {
            initialBacteria = 1;
        }

        public void Initialize()
        {
            _aquarium = gameObject.GetComponentInParent<Aquarium.Aquarium>();
            
            foreach (var cube in _aquarium.GetRandomCubes(initialBacteria))
            {
                var cubePosition = cube.transform.position;
                var position = new Vector3(cubePosition.x + 0.5f, cubePosition.y + 0.5f, cubePosition.z + 0.5f);
                Add(position, new Vector3(0, Random.Range(-180f, 180f), 0),
                    (int) 5e5);
            }
        }
        
        public GameObject Add(Vector3 position, Vector3 rotation, int energy = 0)
        {
            var go = Instantiate(childObject, position, Quaternion.Euler(rotation));
            var bacteria = go.GetComponent<Bacteria>();
            bacteria.initialEnergy = energy;
            bacteria.Mass = energy;
            go.transform.SetParent(gameObject.transform);
            return go;
        }
        
        public GameObject Add(Bacteria original)
        {
            var originalTransform = original.gameObject.transform;
            var originalPosition = originalTransform.position;
            var originalRotation = originalTransform.rotation.eulerAngles;
            var position = new Vector3(originalPosition.x + 0.05f, originalPosition.y, originalPosition.z + 0.05f);
            var rotation = new Vector3(originalRotation.x, originalRotation.y - 180f, originalRotation.z);
            var bacteria = Add(
                position, rotation, original.Energy
            );
            bacteria.GetComponent<Bacteria>().Jets(10f, Random.Range(-100f, 100f), false);
            return bacteria;
        }
     }
}