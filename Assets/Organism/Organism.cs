using System.Collections;
using Humus;
using UnityEngine;

namespace Organism
{
    abstract public class Organism : MonoBehaviour
    {
        protected enum Status
        {
            Dead, Alive, Eaten, Splitting
        }
        
        public int initialEnergy;
        protected HumusCube _humusCube;
        private int _energy;
        private int _energyConsumed;
        protected int _splitMass;
        
        private Transform _body;
        protected Rigidbody _rigidbody;

        protected Status status;

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
            initialEnergy = 0;
            _rigidbody = gameObject.GetComponent<Rigidbody>();
            status = Status.Alive;
        }

        protected virtual void Start()
        {
            _energy = initialEnergy;
            _energyConsumed = _energy;
            _body = transform.GetChild(1);
            UpdateBody();
        }

        protected virtual void Update()
        {
            BurnsEnergy((int) (Mass * Time.deltaTime / 1e2) + 1);
            Rots();
        }

        private void OnTriggerEnter(Collider other)
        {
            TransferQuantity(other);
        }

        public void Jets(float force, float torque, bool useEnergy = true)
        {
            if (useEnergy)
            {
             BurnsEnergy((int) (force + Mathf.Abs(torque)));   
            } 
            var rotationInRads = Mathf.Deg2Rad * Rotation;
            _rigidbody.AddForce(new Vector3(Mathf.Sin(rotationInRads) * force, 0, Mathf.Cos(rotationInRads) * force));
            _rigidbody.AddTorque(new Vector3(0, torque, 0));
        }

        protected void GainEnergy(int energy)
        {
            if (status == Status.Alive)
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
                        StartCoroutine(PrepareToSplit());
                    }
                    UpdateBody();
                }
            }
        }

        protected void BurnsEnergy(int energy)
        {
            if (status == Status.Alive)
            {
                if (energy > Energy)
                {
                    Energy = 0;
                    status = Status.Dead;
                }
                else
                {
                    Energy -= energy;
                }
            }
        }

        protected void Rots()
        {
            if (status == Status.Dead)
            {
                var quantity = (int) (Mass * Time.deltaTime) + 1;
                if (quantity > _energyConsumed)
                {
                    quantity = _energyConsumed;
                }

                _humusCube.Quantity += quantity;
                _energyConsumed -= quantity;
                if (_energyConsumed <= 0)
                {
                    Dies();
                }
            }
        }

        public int isEatenBy(Organism organism)
        {
            status = Status.Eaten;
            _humusCube.Quantity += _energyConsumed - Mass;
            return Mass;
        }

        abstract protected void UpdateBody();
        
        protected virtual void Split() {
            _energy = Mass;
        }

        protected void TransferQuantity(Collider other)
        {
            if (other.gameObject.name == "Humus")
            {
                var humusCube = other.gameObject.GetComponent<HumusCube>();
                if (_humusCube)
                {
                    _humusCube.TransferQuantityTo(humusCube, (int) (Speed * Mass / 1e2f));
                }
                _humusCube = humusCube;
            }
        }

        public void Dies()
        {
            Destroy(gameObject);
            Destroy(_rigidbody);
            Destroy(this);
        }

        private IEnumerator PrepareToSplit()
        {
            status = Status.Splitting;
            float duration = 0.5f;
            float timeElapsed = 0;
            float initialMass = Mass;

            while (timeElapsed < duration)
            {
                _body.localPosition = Vector3.Lerp(Vector3.zero, Vector3.back * 2, timeElapsed / duration);
                Mass = (int) Mathf.Lerp(initialMass, initialMass / 2, timeElapsed / duration);
                UpdateBody();
                timeElapsed += Time.deltaTime;
                yield return null;
            }

            if (status == Status.Splitting)
            {
                _body.localPosition = Vector3.zero;
                Split(); 
            }

            status = Status.Alive;
        }
    }
}
