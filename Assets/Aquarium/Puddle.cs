using System;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Aquarium
{
    public sealed class Puddle
    {
        public static int FrameModulus = 3;

        private int _fertility;
        
        private static readonly Lazy<Puddle> Lazy =
            new Lazy<Puddle>(() => new Puddle());

        public static Puddle Instance => Lazy.Value;

        private Puddle()
        {
            _fertility = (int) 1e8;
        }

        public int Fertility => _fertility;

        public void SetFertility(int value)
        {
            _fertility = value;
        }
        
        public void AddFertility(int value)
        {
            _fertility += value;
        }
        
        public int RemoveFertility(int value)
        {
            if (value > _fertility)
            {
                value = _fertility;
            }
            _fertility -= value;
            return value;
        }
        
        public static float GETRandomRange(float range)
        {
            return Random.Range(-range, range);
        }

        public static Vector3 getRandomTorque(float force)
        {
            return new Vector3(
                GETRandomRange(force),
                GETRandomRange(force),
                GETRandomRange(force)
            );
        }

    }
}