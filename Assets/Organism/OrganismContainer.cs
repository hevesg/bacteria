using UnityEngine;

namespace Organism
{
    public abstract class OrganismContainer<T> : MonoBehaviour where T : Organism
    {
        public int initialChildren;
        public GameObject childObject;
        protected Aquarium.Aquarium _aquarium;

        protected void Awake()
        {
            initialChildren = 0;
        }
        
        public void Initialize()
        {
            _aquarium = gameObject.GetComponentInParent<Aquarium.Aquarium>();
            
            foreach (var cube in _aquarium.GetRandomCubes(initialChildren))
            {
                var cubePosition = cube.transform.position;
                var position = new Vector3(cubePosition.x + 0.5f, cubePosition.y + 0.5f, cubePosition.z + 0.5f);
                Add(position, new Vector3(0, Random.Range(-180f, 180f), 0),
                    (int) 5e4);
            }
        }
        
        public GameObject Add(Vector3 position, Vector3 rotation, int energy = 0)
        {
            var go = Instantiate(childObject, position, Quaternion.Euler(rotation));
            var organism = go.GetComponent<T>();
            organism.initialEnergy = energy;
            organism.Mass = energy;
            go.transform.SetParent(gameObject.transform);
            return go;
        }

        public GameObject Add(T original)
        {
            var originalTransform = original.gameObject.transform;
            var originalPosition = originalTransform.position;
            var originalRotation = originalTransform.rotation.eulerAngles;
            var position = new Vector3(originalPosition.x + 0.05f, originalPosition.y, originalPosition.z + 0.05f);
            var rotation = new Vector3(originalRotation.x, originalRotation.y - 180f, originalRotation.z);
            var organism = Add(
                position, rotation, original.Energy
            );
            organism.GetComponent<T>().Jets(1e1f, Random.Range(-100f, 100f), false);
            return organism;
        }
    }
}