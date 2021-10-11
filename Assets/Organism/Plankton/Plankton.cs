using Humus;
using UnityEngine;

namespace Organism.Plankton
{
    public class Plankton : Organism
    {
        private HumusCube _humusCube;

        protected override void UpdateBody()
        {
            var scale = Mathf.Pow((3 * _rigidbody.mass) / (10 * Mathf.PI), 1f / 3f);
            gameObject.transform.localScale = new Vector3(scale, scale, scale);
        }

        protected override void Awake()
        {
            base.Awake();
            _splitMass = (int) 1e5;
            
            _body = GameObject.CreatePrimitive(PrimitiveType.Capsule);
            _body.name = "Body";
            _body.transform.SetParent(gameObject.transform);
            _body.transform.localPosition = Vector3.zero;
            _body.transform.localRotation = Quaternion.Euler(0, 0, 90);

            _rigidbody = gameObject.AddComponent<Rigidbody>();
            _rigidbody.useGravity = false;
            _rigidbody.drag = 1;
            _rigidbody.angularDrag = 2;
            _rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ | RigidbodyConstraints.FreezePositionY;
            _rigidbody.centerOfMass = Vector3.zero;
            _rigidbody.inertiaTensorRotation = Quaternion.identity;
            _rigidbody.isKinematic = false;
            _rigidbody.detectCollisions = true;
        }

        protected override void Start()
        {
            base.Start();
            _rigidbody.velocity = Vector3.zero;
        }

        void Update()
        {
            if (Speed > 0)
            {
                // _humusCube = _aquarium.GetHumusCubeAt(gameObject.transform.position);
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
