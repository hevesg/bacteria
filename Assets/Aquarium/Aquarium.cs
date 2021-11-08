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

        private HumusContainer _humusContainer;
        private PlanktonContainer _planktonContainer;
        private BacteriaContainer _bacteriaContainer;

        private void Awake()
        {
            QualitySettings.vSyncCount = 0;
            Application.targetFrameRate = 60;
        }

        void Start()
        {
            BuildWalls();
            BuildHumusContainer();
            BuildPlanktonContainer();
            BuildBacteriaContainer();
        }

        private void BuildWalls()
        {
            _northernWall = GameObject.Find("NorthernWall");
            _northernWall.transform.localScale = new Vector3(size.x + wallThickness, size.y, wallThickness);
            _northernWall.transform.position = new Vector3(size.x, 0, size.z);

            _easternWall = GameObject.Find("EasternWall");
            _easternWall.transform.localScale = new Vector3(size.z + wallThickness, size.y, wallThickness);
            _easternWall.transform.position = new Vector3(size.x, 0);

            _southernWall = GameObject.Find("SouthernWall");
            _southernWall.transform.localScale = new Vector3(size.x + wallThickness, size.y, wallThickness);
            _southernWall.transform.position = new Vector3(0, 0);

            _westernWall = GameObject.Find("WesternWall");
            _westernWall.transform.localScale = new Vector3(size.z + wallThickness, size.y, wallThickness);
            _westernWall.transform.position = new Vector3(0, 0, size.z);
        }

        private void BuildHumusContainer()
        {
            _humusContainer = GameObject.Find("HumusContainer").GetComponent<HumusContainer>();
            _humusContainer.initialSize = size;
            _humusContainer.Initialize();
        }

        private void BuildPlanktonContainer()
        {
            _planktonContainer = GameObject.Find("PlanktonContainer").GetComponent<PlanktonContainer>();
            _planktonContainer.initialChildren = initialPlankton;
            _planktonContainer.Initialize();
        }

        private void BuildBacteriaContainer()
        {
            _bacteriaContainer = GameObject.Find("BacteriaContainer").GetComponent<BacteriaContainer>();
            _bacteriaContainer.initialChildren = initialBacteria;
            _bacteriaContainer.Initialize();
        }

        public GameObject[] GetRandomCubes(int count)
        {
            return _humusContainer.GetRandomCubes(count);
        }
    }
}