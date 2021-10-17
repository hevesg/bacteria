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
            _splitMass = (int) 1e5;
            
            _body = GameObject.CreatePrimitive(PrimitiveType.Capsule);
            _body.name = "Body";
            _body.transform.SetParent(gameObject.transform);
            _body.transform.localPosition = Vector3.zero;
            _body.transform.localRotation = Quaternion.Euler(0, 0, 90);

            _rigidbody = gameObject.AddComponent<Rigidbody>();
            _rigidbody.useGravity = false;
            _rigidbody.drag = 1;
            _rigidbody.angularDrag = 1;
            _rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ | RigidbodyConstraints.FreezePositionY;
            _rigidbody.centerOfMass = Vector3.zero;
            _rigidbody.inertiaTensorRotation = Quaternion.identity;
            _rigidbody.isKinematic = false;
            _rigidbody.detectCollisions = true;
        }

        protected void Start()
        {
            _container = gameObject.transform.parent.GetComponent<PlanktonContainer>();
            _rigidbody.velocity = Vector3.zero;
            Jets(1e1f, 0, false);
        }

        void Update()
        {
            if (_humusCube != null)
            {
                GainEnergy(_humusCube.ProvideHumus((int) (1e4 * Time.deltaTime)));
            }
        }

        protected override void Split()
        {
            base.Split();
            _container.Add(this);
            Jets(1e0f, Random.Range(-1e2f, 1e2f), false);
        }

    }
}
