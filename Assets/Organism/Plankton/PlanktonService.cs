using System.Collections.Generic;
using UnityEngine;

namespace Organism.Plankton
{
    public class PlanktonService
    {
        private readonly List<Plankton> _planktons;
        private Vector3Int _size;

        public PlanktonService(Vector3Int size)
        {
            _planktons = new List<Plankton>();
            _size = size;
        }

        public List<Plankton> Planktons => _planktons;

        public Plankton Create(Vector3 position, Vector3 rotation, int energy = 0, int mass = (int) 10e3)
        {
            var go = new GameObject("Plankton")
            {
                transform =
                {
                    localPosition = new Vector3(position.x, position.y, position.z),
                    localRotation = Quaternion.Euler(rotation.x, rotation.y, rotation.z)
                }
            };

            var body = GameObject.CreatePrimitive(PrimitiveType.Capsule);
            body.name = "Body";
            body.transform.SetParent(go.transform);
            body.transform.localPosition = Vector3.zero;
            body.transform.localRotation = Quaternion.Euler(0, 0, 90);

            var rb = go.AddComponent<Rigidbody>();
            rb.useGravity = false;
            rb.drag = 1;
            rb.angularDrag = 2;
            rb.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ | RigidbodyConstraints.FreezePositionY;
            rb.centerOfMass = Vector3.zero;
            rb.inertiaTensorRotation = Quaternion.identity;
            rb.isKinematic = false;
            rb.detectCollisions = true;
            
            var plankton = go.AddComponent<Plankton>();
            plankton.Energy = energy;
            plankton.Mass = mass;

            Add(plankton);
            return plankton;
        }

        public void Add(Plankton plankton)
        {
            _planktons.Add(plankton);
        }

        public void Remove(Plankton plankton)
        {
            _planktons.Remove(plankton);
        }
    }
}