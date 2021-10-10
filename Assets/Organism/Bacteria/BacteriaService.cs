using System.Collections.Generic;
using UnityEngine;

namespace Organism.Bacteria
{
    public class BacteriaService
    {
        private readonly List<Bacteria> _bacterias;

        public BacteriaService()
        {
            _bacterias = new List<Bacteria>();
        }

        public List<Bacteria> Bacterias => _bacterias;

        public Bacteria Create(Vector3 position, Vector3 rotation, int energy = 0, int mass = (int) 10e3)
        {
            var go = new GameObject("Bacteria")
            {
                transform =
                {
                    localPosition = new Vector3(position.x, position.y, position.z),
                    localRotation = Quaternion.Euler(rotation.x, rotation.y, rotation.z)
                }
            };

            var body = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            body.name = "Body";
            Object.Destroy(body.GetComponent<SphereCollider>());
            body.AddComponent<CapsuleCollider>();
            body.transform.SetParent(go.transform);
            body.transform.localPosition = Vector3.zero;
            body.transform.localRotation = Quaternion.Euler(0, 0, 90);
            body.transform.localScale = new Vector3(1, 2, 1);

            var rb = go.AddComponent<Rigidbody>();
            rb.useGravity = false;
            rb.drag = 1;
            rb.angularDrag = 2;
            rb.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ | RigidbodyConstraints.FreezePositionY;
            rb.centerOfMass = Vector3.zero;
            rb.inertiaTensorRotation = Quaternion.identity;
            rb.isKinematic = false;
            rb.detectCollisions = true;
            
            var bacteria = go.AddComponent<Bacteria>();
            bacteria.Energy = energy;
            bacteria.Mass = mass;
            
            Add(bacteria);
            return bacteria;
        }

        public void Add(Bacteria plankton)
        {
            _bacterias.Add(plankton);
        }

        public void Remove(Bacteria plankton)
        {
            _bacterias.Remove(plankton);
        }

    }
}