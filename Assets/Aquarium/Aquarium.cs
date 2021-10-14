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
            _humusContainer = AddHumusContainer();
            _planktonContainer = AddPlanktonContainer();
            _bacteriaContainer = AddBacteriaContainer();
        }

        void Start()
        {
            BuildWalls();
            /*var i = 0;
            for (var x = 0; x < size.x; x++)
            {
                for (var y = 0; y < 1; y++)
                {
                    for (var z = 0; z < size.z; z++)
                    {
                        if (i % 3 == 0)
                        {
                            AddPlankton(
                                new Vector3(x + 0.5f, y + 0.5f, z + 0.5f),
                                new Vector3(0, Random.Range(-180f, 180f), 0),
                                (int) 5e4
                            );
                        }

                        i++;
                    }
                }
            }*/

            //AddBacteria(new Vector3(size.x / 2, 0.5f, size.z / 2), Vector3.zero, 0, (int) 1e5);
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

        public GameObject[] GetRandomCubes(int count)
        {
            return _humusContainer.GetRandomCubes(count);
        }

        private HumusContainer AddHumusContainer()
        {
            var go = new GameObject("HumusContainer")
            {
                transform =
                {
                    localPosition = new Vector3(0, 0, 0),
                    localRotation = Quaternion.Euler(0, 0, 0)
                }
            };

            var container = go.AddComponent<HumusContainer>();
            container.initialSize = size;
            go.transform.SetParent(gameObject.transform);
            return container;
        }
        
        private PlanktonContainer AddPlanktonContainer()
        {
            var go = new GameObject("PlanktonContainer")
            {
                transform =
                {
                    localPosition = new Vector3(0, 0, 0),
                    localRotation = Quaternion.Euler(0, 0, 0)
                }
            };

            var container = go.AddComponent<PlanktonContainer>();
            container.initialPlankton = initialPlankton;
            go.transform.SetParent(gameObject.transform);
            return container;
        }
        
        private BacteriaContainer AddBacteriaContainer()
        {
            var go = new GameObject("BacteriaContainer")
            {
                transform =
                {
                    localPosition = new Vector3(0, 0, 0),
                    localRotation = Quaternion.Euler(0, 0, 0)
                }
            };

            var container = go.AddComponent<BacteriaContainer>();
            container.initialBacteria = initialBacteria;
            go.transform.SetParent(gameObject.transform);
            return container;
        }
    }
}