using System.Collections;
using Aquarium;
using UnityEngine;

namespace Organism
{
    public abstract class Organism : MonoBehaviour
    {
        protected enum Status
        {
            Dead, Alive, Eaten, Splitting
        }

        protected enum Location
        {
            Water, Air
        }
        
        public int initialEnergy;
        private int _energyConsumed;
        protected int _splitMass;
        
        private Transform _body;
        protected Rigidbody _rigidbody;
        
        protected Status status;
        protected Location location;

        public int Energy { get; set; }

        public int Mass
        {
            get => (int) (_rigidbody.mass * 1e4);
            set => _rigidbody.mass = (float) (value / 1e4);
        }
        
        public int EnergyConsumed => _energyConsumed;

        public float Speed => _rigidbody.velocity.magnitude;
        
        protected virtual void Awake()
        {
            initialEnergy = 0;
            _rigidbody = gameObject.GetComponent<Rigidbody>();
            status = Status.Alive;
            location = Location.Water;
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
            switch (Time.frameCount % 3)
            {
                case 0:
                    BurnsEnergy((int) (Mass * Time.deltaTime * 1e-2f * 3) + 1);
                    break;
                case 1:
                    Rots();
                    break;
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.gameObject.name != "Air") return;
            _rigidbody.useGravity = true;
            _rigidbody.drag = 1f;
            location = Location.Air;
        }

        private void OnTriggerExit(Collider other)
        {
            if (other.gameObject.name != "Air") return;
            _rigidbody.useGravity = false;
            _rigidbody.drag = 5f;
            location = Location.Water;
        }

        public void Jets(float force, Vector3 torque, bool useEnergy = true)
        {
            if (location != Location.Water) return;
            if (useEnergy)
            {
                // BurnsEnergy((int) ((force + torque.magnitude) / 1e1f));   
            } 
            _rigidbody.AddRelativeForce(0, 0f, Vector3.forward.z * force);
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
                var quantity = (int) (Mass * Time.deltaTime * 3) + 1;
                if (quantity > _energyConsumed)
                {
                    quantity = _energyConsumed;
                }

                Puddle.Instance.AddFertility(quantity);
                _energyConsumed -= quantity;
                if (_energyConsumed <= 0)
                {
                    Dies();
                }
            }
        }

        public void IsEatenBy(Organism organism)
        {
            status = Status.Eaten;
            Puddle.Instance.AddFertility(_energyConsumed - Mass);
            organism.GainEnergy(Mass);
        }

        protected abstract void UpdateBody();
        
        protected virtual void Split() {
            Energy = Mass;
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
            float duration = 0.2f;
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
