using System.Collections.Generic;
using UnityEngine;

namespace Humus
{
    public class HumusCube : MonoBehaviour
    {
        public int initialQuantity;
        private ParticleSystem _particles;
        private List<HumusCube> _neighbours;

        private void Awake()
        {
            gameObject.name = "Humus";
            initialQuantity = (int) 1e5;
            _particles = GetComponent<ParticleSystem>();
            _neighbours = new List<HumusCube>();
        }

        private void Start()
        {
            Quantity = initialQuantity;
        }

        private void FixedUpdate()
        {
            foreach (var neighbour in _neighbours)
            {
                var delta = Quantity - neighbour.Quantity;
                if (delta > 10)
                {
                    TransferQuantityTo(neighbour, (int) (delta * Time.deltaTime));
                }
            }
            UpdateMaterial();
        }

        public int Quantity { get;  set; }
        public List<HumusCube> Neighbours => _neighbours;

        public int ProvideHumus(int quantity)
        {
            if (quantity > Quantity)
            {
                var availability = Quantity;
                Quantity = 0;
                return availability;
            }
            Quantity -= quantity;
            return quantity;
        }

        private void UpdateMaterial()
        {
            _particles.startColor = new Color(0, 0, 0, (float) Quantity / (float) 1e6);
        }

        public void TransferQuantityTo(HumusCube other, int quantity)
        {
            var transfer = (quantity > Quantity) ? Quantity : quantity;
            Quantity -= transfer;
            other.Quantity += transfer;
        }

        public void AddNeighbor(HumusCube neighbour)
        {
            _neighbours.Add(neighbour);
        }

        private HumusCube GetRandomNeighbour()
        {
            if (_neighbours.Count > 0)
            {
                return _neighbours[Random.Range(0, _neighbours.Count)];
            }
            return null;
        }
    }
}