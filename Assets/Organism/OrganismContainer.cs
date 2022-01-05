using Aquarium;
using UnityEngine;

namespace Organism
{
    public abstract class OrganismContainer<T> : MonoBehaviour where T : Organism
    {
        public GameObject childPrefab;
        
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
            go.transform.position = position;
            go.transform.rotation = Quaternion.Euler(rotation);
            go.transform.parent = gameObject.transform;
            return go;
        }

        public GameObject Add(T original)
        {
            var organism = Create(original.Energy);
            var tf = original.transform;
            organism.transform.SetParent(tf);
            organism.transform.localPosition = Vector3.back * 2;
            organism.transform.localRotation = Quaternion.identity;
            organism.transform.SetParent(gameObject.transform);
            
            organism.GetComponent<T>().Jets(-1e4f, Puddle.getRandomTorque(1e2f), false);
            return organism;
        }
    }
}