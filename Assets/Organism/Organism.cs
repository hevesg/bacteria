using UnityEngine;
using Random = UnityEngine.Random;

namespace Organism
{
    abstract public class Organism : MonoBehaviour
    {
        protected Aquarium.Aquarium _aquarium;
        
        protected int _energy;
        protected int _energyConsumed;
        protected int _splitMass;
        
        protected Rigidbody rb;

        public int Energy
        {
            get => _energy;
            set => _energy = value;
        }

        public int Mass
        {
            get => (int) (rb.mass * 10e6);
            set
            {
                rb.mass = (float) (value / 10e6);
            }
        }
        
        public int EnergyConsumed => _energyConsumed;

        public float Speed => rb.velocity.magnitude;

        public float Rotation => gameObject.transform.rotation.eulerAngles.y;

        public void Jets(float force, float torque, bool useEnergy = true)
        {
            if (useEnergy)
            {
             BurnEnergy((int) (force + Mathf.Abs(torque)));   
            } 
            var rotationInRads = Mathf.Deg2Rad * Rotation;
            rb.AddForce(new Vector3(Mathf.Cos(rotationInRads) * force, 0, -Mathf.Sin(rotationInRads) * force));
            rb.AddTorque(new Vector3(0, torque, 0));
        }
        protected virtual void Awake()
        {
            Debug.Log("Awake");
            rb = gameObject.GetComponent<Rigidbody>();
            _energyConsumed = 0;
        }

        protected virtual void Start()
        {
            _aquarium = gameObject.transform.parent.gameObject.GetComponent<Aquarium.Aquarium>();
            UpdateBody();
        }

        void Update()
        {
        
        }

        protected void GainEnergy(int energy)
        {
            _energy += energy;
            if (energy > 0)
            {
                _energyConsumed += energy;
            }
            if (_energy > Mass)
            {
                Mass = _energy;
                if (Mass > _splitMass)
                {
                    Split();
                }
                UpdateBody();
            }
        }

        protected void BurnEnergy(int energy)
        {
            if (energy > Energy)
            {
                Energy = 0;
            }
            else
            {
                Energy -= energy;
            }
        }

        abstract protected void UpdateBody();
        
        protected virtual void Split() {
            _energy /= 2;
            Mass /= 2;
        }

    }
}
