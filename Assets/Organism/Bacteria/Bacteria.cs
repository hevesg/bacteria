using Aquarium;
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
            _timeRemaining = 5f;
            gameObject.name = "Bacteria";
            _splitMass = (int) 1e6;
        }
        protected override void Start()
        {
            base.Start();
            _container = gameObject.transform.parent.GetComponent<BacteriaContainer>();
            _rigidbody.velocity = Vector3.zero;
        }

        protected override void Update()
        {
            base.Update();
            _timeRemaining -= Time.deltaTime;
            if (_timeRemaining <= 0)
            {
                _timeRemaining = 5f;
                Jets(1e5f, Puddle.getRandomTorque(1e3f));
            }
            
        }

        private void OnCollisionEnter(Collision other)
        {
            var go = other.gameObject;
            if (go.name == "Plankton" && status == Status.Alive)
            {
                var plankton = go.GetComponent<Plankton.Plankton>();
                //plankton.IsEatenBy(this);
                //plankton.Dies();
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
            Jets(1e4f, Puddle.getRandomTorque(1e-1f), false);
        }
    }
}
