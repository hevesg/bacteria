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
            _energyConsumed = 0;
            initialEnergy = 0;
            _rigidbody = gameObject.GetComponent<Rigidbody>();
            status = Status.Alive;
        }

        protected virtual void Start()
        {
            _body = transform.GetChild(0);
            UpdateBody();
        }

        private void OnTriggerEnter(Collider other)
        {
            TransferQuantity(other);
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
                    if (Mass > _splitMass && status == Status.Alive)
                    {
                        StartCoroutine(PrepareToSplit());
                    }
                    UpdateBody();
                }
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
            float duration = 0.2f;
            float timeElapsed = 0;

            while (timeElapsed < duration)
            {
                _body.localPosition = Vector3.Lerp(Vector3.zero, Vector3.back, timeElapsed / duration);
                _body.localScale = Vector3.Lerp(new Vector3(1,1,1), new Vector3(0.8f,2,0.8f), timeElapsed / duration);
                timeElapsed += Time.deltaTime;
                yield return null;
            }

            if (status == Status.Splitting)
            {
                _body.localPosition = Vector3.zero;
                _body.localScale = new Vector3(1,1,1);
                Split(); 
            }

            status = Status.Alive;
        }
    }
}
