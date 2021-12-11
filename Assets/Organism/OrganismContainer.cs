using UnityEngine;

namespace Organism
{
    public abstract class OrganismContainer<T> : MonoBehaviour where T : Organism
    {
        public int initialChildren;
        public GameObject childPrefab;
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

        public GameObject Get(int energy)
        {
            var go = Instantiate(childPrefab, Vector3.zero, Quaternion.identity);
            var organism = go.GetComponent<T>();
            organism.initialEnergy = energy;
            organism.Mass = energy;
            return go;
        }
        
        public GameObject Add(Vector3 position, Vector3 rotation, int energy)
        {
            var go = Get(energy);
            go.transform.localPosition = position;
            go.transform.localRotation = Quaternion.Euler(rotation);
            go.transform.SetParent(gameObject.transform);
            return go;
        }

        public GameObject Add(T original)
        {
            var organism = Get(original.Energy);
            organism.transform.parent = original.transform;
            organism.transform.localPosition = Vector3.back * 2;
            organism.transform.localRotation = Quaternion.identity;
            organism.transform.SetParent(gameObject.transform);
            
            organism.GetComponent<T>().Jets(-1f, Random.Range(-1e-1f, 1e-1f), false);
            return organism;
        }
    }
}