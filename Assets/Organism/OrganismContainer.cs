using UnityEngine;

namespace Organism
{
    public abstract class OrganismContainer<T> : MonoBehaviour where T : Organism
    {
        public GameObject childPrefab;
        protected Aquarium.Aquarium _aquarium;

        protected void Start()
        {
            _aquarium = gameObject.GetComponentInParent<Aquarium.Aquarium>();
        }

        private GameObject Create(int energy)
        {
            var go = Instantiate(childPrefab, Vector3.zero, Quaternion.identity);
            var organism = go.GetComponent<T>();
            organism.initialEnergy = energy;
            organism.Mass = energy;
            return go;
        }
        
        public GameObject Add(Vector3 position, Vector3 rotation, int energy)
        {
            var go = Create(energy);
            go.transform.localPosition = position;
            go.transform.localRotation = Quaternion.Euler(rotation);
            go.transform.SetParent(gameObject.transform);
            return go;
        }

        public GameObject Add(T original)
        {
            var organism = Create(original.Energy);
            organism.transform.parent = original.transform;
            organism.transform.localPosition = Vector3.back * 2;
            organism.transform.localRotation = Quaternion.identity;
            organism.transform.SetParent(gameObject.transform);
            
            organism.GetComponent<T>().Jets(-1f, Random.Range(-1e-1f, 1e-1f), false);
            return organism;
        }
    }
}