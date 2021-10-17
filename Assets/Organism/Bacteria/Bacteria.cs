using UnityEngine;

namespace Organism.Bacteria
{
    public class Bacteria : Organism
    {
        private BacteriaContainer _container;

        protected override void Awake()
        {
            base.Awake();
            _splitMass = (int) 1e6;
            
            _body = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            _body.name = "Body";
            Destroy(_body.GetComponent<SphereCollider>());
            _body.AddComponent<CapsuleCollider>();
            _body.transform.SetParent(gameObject.transform);
            _body.transform.localPosition = Vector3.zero;
            _body.transform.localRotation = Quaternion.Euler(0, 0, 90);
            _body.transform.localScale = new Vector3(1, 2, 1);

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
        protected void Start()
        {
            _container = gameObject.transform.parent.GetComponent<BacteriaContainer>();
            _rigidbody.velocity = Vector3.zero;
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
                plankton.Kill();
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
            // _container.Add(this);
            Jets(1e-4f * Mass, Random.Range(-1e-4f, 1e-4f) * Mass, false);
        }
    }
}
