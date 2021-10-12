using UnityEngine;

namespace Organism.Bacteria
{
    public class Bacteria : Organism
    {
        protected override void Awake()
        {
            base.Awake();
            _splitMass = (int) 1e6;
        }
        protected void Start()
        {
            _rigidbody.velocity = Vector3.zero;
            Debug.Log(Mass);
        }

        void Update()
        {
            if (Speed == 0)
            {
                Jets(1e-4f * Mass, Random.Range(-1e-4f, 1e-4f) * Mass, false);
            }
            
        }

        private void OnCollisionEnter(Collision other)
        {
            var go = other.gameObject;
            if (go.name == "Plankton")
            {
                var plankton = go.GetComponent<Plankton.Plankton>();
                GainEnergy(plankton.Mass);
                Destroy(go);
            }
        }

        protected override void UpdateBody()
        {
            var scale = Mathf.Pow((3 * _rigidbody.mass) / (8 * Mathf.PI), 1f / 3f);
            gameObject.transform.localScale = new Vector3(scale, scale, scale);
        }
        
        protected override void Split()
        {
            base.Split();
            Jets(1e-4f * Mass, Random.Range(-1e-4f, 1e-4f) * Mass, false);
        }
    }
}
