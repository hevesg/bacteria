using UnityEngine;

namespace Organism
{
    abstract public class Organism : MonoBehaviour
    {
        public int initialEnergy;
        private int _energy;
        private int _energyConsumed;
        protected int _splitMass;
        
        protected GameObject _body;
        protected Rigidbody _rigidbody;

        public int Energy
        {
            get => _energy;
            set => _energy = value;
        }

        public int Mass
        {
            get => (int) (_rigidbody.mass * 1e6);
            set => _rigidbody.mass = (float) (value / 1e6);
        }
        
        public int EnergyConsumed => _energyConsumed;

        public float Speed => _rigidbody.velocity.magnitude;

        public float Rotation => gameObject.transform.rotation.eulerAngles.y;

        protected virtual void Awake()
        {
            _energyConsumed = 0;
            initialEnergy = 0;
        }

        public void Jets(float force, float torque, bool useEnergy = true)
        {
            if (useEnergy)
            {
             BurnEnergy((int) (force + Mathf.Abs(torque)));   
            } 
            var rotationInRads = Mathf.Deg2Rad * Rotation;
            _rigidbody.AddForce(new Vector3(Mathf.Cos(rotationInRads) * force, 0, -Mathf.Sin(rotationInRads) * force));
            _rigidbody.AddTorque(new Vector3(0, torque, 0));
        }

        public void Initialize(int energy)
        {
            _energy += energy;
            Mass = _energy;
            UpdateBody();
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
