using Aquarium;
using UnityEngine;

namespace Organism.Plankton
{
    public class Plankton : Organism
    {
        private PlanktonContainer _container;

        protected override void UpdateBody()
        {
            var scale = Mathf.Pow((3 * _rigidbody.mass) / (10 * Mathf.PI), 1f / 3f);
            gameObject.transform.localScale = new Vector3(scale, scale, scale);
        }

        protected override void Awake()
        {
            base.Awake();
            gameObject.name = "Plankton";
            _splitMass = (int) 1e5;
        }

        protected override void Start()
        {
            base.Start();
            _container = gameObject.transform.parent.GetComponent<PlanktonContainer>();
            _rigidbody.velocity = Vector3.zero;
        }

        protected override void Update()
        {
            base.Update(); 
            GainEnergy(Puddle.Instance.RemoveFertility(
                (int) (Mass * Time.deltaTime * 1e-1f * (-transform.position.y / 20)) + 1)
            );
        }

        protected override void Split()
        {
            base.Split();
            _container.Add(this);
            Jets(1e4f, Puddle.getRandomTorque(1e2f), false);
        }

    }
}
