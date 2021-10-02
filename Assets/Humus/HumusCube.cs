using System.Collections.Generic;
using UnityEngine;

namespace Humus
{
    public class HumusCube
    {
        private int _quantity;
        private readonly List<HumusCube> _neighbors;
        private readonly Vector3Int _position;
        private static float _fullShareSeconds = 5;

        internal HumusCube(int initialQuantity, Vector3Int position)
        {
            _quantity = initialQuantity;
            _position = position;
            _neighbors = new List<HumusCube>();
        }
        
        public int Quantity => _quantity;
        
        public Vector3Int Position => _position;

        public int ProvideHumus(int quantity)
        {
            if (quantity > Quantity)
            {
                var availability = Quantity;
                _quantity = 0;
                return availability;
            }
            _quantity -= quantity;
            return quantity;
        }

        internal void AddNeighbor(HumusCube humusCube)
        {
            _neighbors.Add(humusCube);
        }

        internal void ShareWithNeighbor(float deltaTime)
        {
            var neighbor = GetRandomNeighbor();
            var deltaQuantity = (int) ((_quantity - neighbor._quantity) * (deltaTime / _fullShareSeconds) / 2);
            _quantity -= deltaQuantity;
            neighbor._quantity += deltaQuantity;
        }

        private HumusCube GetRandomNeighbor()
        {
            return _neighbors[Random.Range(0, _neighbors.Count - 1)];
        }
    }
}