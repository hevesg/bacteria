using Humus;
using UnityEngine;

namespace Organism.Plankton
{
    public class Plankton : Organism
    {

        private HumusCube _humusCube;

        protected override void UpdateBody()
        {
            var scale = Mathf.Pow((3 * rb.mass) / (10 * Mathf.PI), 1f / 3f);
            gameObject.transform.localScale = new Vector3(scale, scale, scale);
        }

        protected override void Awake()
        {
            base.Awake();
            _splitMass = (int) 1e5;
        }

        protected override void Start()
        {
            base.Start();
            _humusCube = _aquarium.GetHumusCubeAt(gameObject.transform.position);
            rb.velocity = Vector3.zero;
        }

        void Update()
        {
            if (Speed > 0)
            {
                _humusCube = _aquarium.GetHumusCubeAt(gameObject.transform.position);
            }
            GainEnergy(_humusCube.ProvideHumus((int) (1e4 * Time.deltaTime)));
        }

        protected override void Split()
        {
            base.Split();
            _aquarium.AddPlankton(this);
            Jets(10f, Random.Range(-10f, 10f), false);
        }

    }
}
