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
        private int _energyConsumed;
        protected int _splitMass;
        
        private Transform _body;
        protected Rigidbody _rigidbody;

        protected Status status;

        public int Energy { get; set; }

        public int Mass
        {
            get => (int) (_rigidbody.mass * 1e6);
            set => _rigidbody.mass = (float) (value / 1e6);
        }
        
        public int EnergyConsumed => _energyConsumed;

        public float Speed => _rigidbody.velocity.magnitude;
        
        protected virtual void Awake()
        {
            initialEnergy = 0;
            _rigidbody = gameObject.GetComponent<Rigidbody>();
            status = Status.Alive;
        }

        protected virtual void Start()
        {
            Energy = initialEnergy;
            _energyConsumed = Energy;
            _body = transform.GetChild(1);
            _body.gameObject.SetActive(false);
            UpdateBody();
        }

        protected virtual void Update()
        {
            BurnsEnergy((int) (Mass * Time.deltaTime * 1e-2f) + 1);
            Rots();
        }

        private void OnTriggerEnter(Collider other)
        {
            TransferQuantity(other);
            if (other.gameObject.name == "Air")
            {
                _rigidbody.useGravity = true;
                _rigidbody.drag = 0;
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (other.gameObject.name == "Air")
            {
                _rigidbody.useGravity = false;
                _rigidbody.drag = 1;
            }
        }

        public void Jets(float force, Vector3 torque, bool useEnergy = true)
        {
            if (useEnergy)
            {
             BurnsEnergy((int) (force + torque.magnitude));   
            } 
            _rigidbody.AddRelativeForce(Vector3.forward * force);
            _rigidbody.AddRelativeTorque(torque);
        }

        protected void GainEnergy(int energy)
        {
            if (status == Status.Alive)
            {
                Energy += energy;
                if (energy > 0)
                {
                    _energyConsumed += energy;
                }
                if (Energy > Mass)
                {
                    Mass = Energy;
                    if (Mass > _splitMass)
                    {
                        StartCoroutine(PrepareToSplit());
                    }
                    UpdateBody();
                }
            }
        }

        private void BurnsEnergy(int energy)
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

        private void Rots()
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

        public void IsEatenBy(Organism organism)
        {
            Debug.Log("Extra " + (_energyConsumed - Mass) + "\t" + "Mass " + Mass);
            status = Status.Eaten;
            _humusCube.Quantity += _energyConsumed - Mass;
            organism.GainEnergy(Mass);
        }

        protected abstract void UpdateBody();
        
        protected virtual void Split() {
            Energy = Mass;
        }

        private void TransferQuantity(Collider other)
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
            _body.gameObject.SetActive(true);
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
                _body.gameObject.SetActive(false);
                Split(); 
                status = Status.Alive;
            }
        }
    }
}
