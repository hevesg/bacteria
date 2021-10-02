using System;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Humus
{
    public class HumusContainer
    {
        private readonly Vector3Int _size;
        private readonly float _cubeSize;
        private readonly List<HumusCube> _humusCubes;

        public HumusContainer(Vector3Int size, float cubeSize = 1f)
        {
            _size = size;
            _cubeSize = cubeSize;
            _humusCubes = new List<HumusCube>(); 
            InstantiateCubes();
        }

        public void ShareWithNeighbor(float deltaTime)
        {
            GetRandomCube().ShareWithNeighbor(deltaTime * _humusCubes.Count);
        }
        public HumusCube FindAt(int x, int y, int z)
        {
            if (x >= 0 && x < _size.x && y >= 0 && y < _size.y && z >= 0 && z < _size.z)
            {
                return _humusCubes[_size.y * _size.z * x + _size.z * y + z];
            }
            throw new Exception("Provided index [" + x +", " + y + ", " + z + "] doesn't exist");
        }

        public HumusCube FindAt(Vector3 position)
        {
            return FindAt((int) (position.x / _cubeSize), (int) (position.y / _cubeSize), (int) (position.z / _cubeSize));
        }

        private HumusCube GetRandomCube()
        {
            return _humusCubes[Random.Range(0, _humusCubes.Count - 1)];
        }

        private void InstantiateCubes()
        {
            for (var x = 0; x < _size.x; x++) 
            {
                for (var y = 0; y < _size.y; y++)
                {
                    for (var z = 0; z < _size.z; z++)
                    {
                        _humusCubes.Add(new HumusCube((int) 10e5, new Vector3Int(x, y, z)));
                    }
                }
            }

            AllocateNeighbors();
        }

        private void AllocateNeighbors()
        {
            foreach (var humusCube in _humusCubes)
            {
                var x = humusCube.Position.z;
                var y = humusCube.Position.y;
                var z = humusCube.Position.z;

                if (x > 0)
                {
                    humusCube.AddNeighbor(FindAt(x - 1, y, z));
                }

                if (y > 0)
                {
                    humusCube.AddNeighbor(FindAt(x, y - 1, z));
                }

                if (z > 0)
                {
                    humusCube.AddNeighbor(FindAt(x, y, z - 1));
                }

                if (x < _size.x - 1)
                {
                    humusCube.AddNeighbor(FindAt(x + 1, y, z));
                }

                if (y < _size.y - 1)
                {
                    humusCube.AddNeighbor(FindAt(x, y + 1, z));
                }
                
                if (z < _size.z - 1)
                {
                    humusCube.AddNeighbor(FindAt(x, y, z + 1));
                }
            }
        }
    }
}
