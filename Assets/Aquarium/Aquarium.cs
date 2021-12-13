using Humus;
using Organism.Bacteria;
using Organism.Plankton;
using UnityEngine;

namespace Aquarium
{
    public class Aquarium : MonoBehaviour
    {
        public Vector3Int size;
        public float wallThickness;
        public int initialPlankton;
        public int initialBacteria;

        private GameObject _northernWall;
        private GameObject _easternWall;
        private GameObject _southernWall;
        private GameObject _westernWall;
        private GameObject _bottomWall;

        private HumusContainer _humusContainer;
        private PlanktonContainer _planktonContainer;
        private BacteriaContainer _bacteriaContainer;

        void Start()
        {
            BuildWalls();
            BuildHumusContainer();
            _planktonContainer = GameObject.Find("PlanktonContainer").GetComponent<PlanktonContainer>();
            _bacteriaContainer = GameObject.Find("BacteriaContainer").GetComponent<BacteriaContainer>();
            Populate();
        }

        private void BuildWalls()
        {
            _northernWall = GameObject.Find("NorthernWall");
            _northernWall.transform.localScale = new Vector3(size.x + wallThickness, size.y + 1, wallThickness);
            _northernWall.transform.position = new Vector3(size.x, 0, size.z);

            _easternWall = GameObject.Find("EasternWall");
            _easternWall.transform.localScale = new Vector3(size.z + wallThickness, size.y + 1, wallThickness);
            _easternWall.transform.position = new Vector3(size.x, 0);

            _southernWall = GameObject.Find("SouthernWall");
            _southernWall.transform.localScale = new Vector3(size.x + wallThickness, size.y + 1, wallThickness);
            _southernWall.transform.position = new Vector3(0, 0);

            _westernWall = GameObject.Find("WesternWall");
            _westernWall.transform.localScale = new Vector3(size.z + wallThickness, size.y + 1, wallThickness);
            _westernWall.transform.position = new Vector3(0, 0, size.z);

            _bottomWall = GameObject.Find("BottomWall");
            _bottomWall.transform.localScale = new Vector3(size.z + wallThickness * 2, size.x + wallThickness * 2, wallThickness);
            _bottomWall.transform.position = new Vector3(-wallThickness, 0, -wallThickness);
        }

        private void BuildHumusContainer()
        {
            _humusContainer = GameObject.Find("HumusContainer").GetComponent<HumusContainer>();
            _humusContainer.initialSize = size;
            _humusContainer.Initialize();
        }
        
        private void Populate()
        {
            var cubes = GetRandomCubes(initialPlankton + initialBacteria);
            var i = 0;
            foreach (var cube in cubes)
            {
                var cubePosition = cube.transform.position;
                Debug.Log(cubePosition.x + " " + cubePosition.y + " " + cubePosition.z);
                var position = new Vector3(cubePosition.x + 0.5f, cubePosition.y + 0.5f, cubePosition.z + 0.5f);
                var rotation = Helper.getRandomRotationVector();
                if (i < initialPlankton)
                {
                    _planktonContainer.Add(position, rotation, (int) 5e4);
                }
                else
                {
                    _bacteriaContainer.Add(position, rotation, (int) 5e5);
                }
                i++;
            }
        }

        public GameObject[] GetRandomCubes(int count)
        {
            return _humusContainer.GetRandomCubes(count);
        }
    }
}