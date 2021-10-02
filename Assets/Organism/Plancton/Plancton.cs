using Humus;
using UnityEngine;

namespace Organism.Plancton
{
    public class Plancton : Organism
    {

        private HumusCube _humusCube;

        protected override void UpdateBody()
        {
            var scale = Mathf.Pow((3 * rb.mass) / (10 * Mathf.PI), 1f / 3f);
            gameObject.transform.localScale = new Vector3(scale, scale, scale);
        }

        protected Plancton clone()
        {
            var go = gameObject;
            var plancton = Instantiate(go, go.transform.position, Quaternion.Euler(0, Rotation + 180, 0));
            var script = plancton.GetComponent<Plancton>();
            script.Energy = Energy;
            script.Mass = Mass;
            return script;
        }

        protected override void Awake()
        {
            base.Awake();
            _splitMass = (int) 10e5;
        }

        protected override void Start()
        {
            base.Start();
            _humusCube = _aquarium.GetHumusCubeAt(gameObject.transform.position);
        }

        void Update()
        {
            if (Speed > 0)
            {
                _humusCube = _aquarium.GetHumusCubeAt(gameObject.transform.position);
            }
            GainEnergy(_humusCube.ProvideHumus((int) (10e4 * Time.deltaTime)));
        }

        protected override void Split()
        {
            base.Split();
            _aquarium.AddPlancton(clone());
            Jets(100f, Random.Range(-1f, 1f), false);
        }

    }
}
