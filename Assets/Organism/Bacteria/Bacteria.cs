using UnityEngine;

namespace Organism.Bacteria
{
    public class Bacteria : Organism
    {
        private BacteriaContainer _container;
        private float _timeRemaining;

        protected override void Awake()
        {
            base.Awake();
            _timeRemaining = 0;
            gameObject.name = "Bacteria";
            _splitMass = (int) 1e6;
        }
        protected override void Start()
        {
            base.Start();
            _container = gameObject.transform.parent.GetComponent<BacteriaContainer>();
            _rigidbody.velocity = Vector3.zero;
        }

        protected void Update()
        {
            _timeRemaining -= Time.deltaTime;
            if (_timeRemaining <= 0)
            {
                _timeRemaining = 5f;
                Jets(1e-3f * Mass, Random.Range(-1e-5f, 1e-5f) * Mass, false);
            }
            
        }

        private void OnCollisionEnter(Collision other)
        {
            var go = other.gameObject;
            if (go.name == "Plankton")
            {
                var plankton = go.GetComponent<Plankton.Plankton>();
                GainEnergy(plankton.Mass);
                plankton.Dies();
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
            _container.Add(this);
            Jets(1e-4f * Mass, Random.Range(-1e-4f, 1e-4f) * Mass, false);
        }
    }
}
