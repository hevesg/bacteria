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

        private GameObject _northernWall;
        private GameObject _easternWall;
        private GameObject _southernWall;
        private GameObject _westernWall;

        private HumusContainer _humusContainer;
        private PlanktonContainer _planktonContainer;
        private BacteriaService _bacteriaService;

        private void Awake()
        {
            QualitySettings.vSyncCount = 0;
            Application.targetFrameRate = 60;
            _humusContainer = AddHumusContainer();
            _planktonContainer = AddPlanktonContainer();
            //_bacteriaService = new BacteriaService();
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

        public void AddPlankton(Plankton original)
        {
            var originalTransform = original.gameObject.transform;
            var originalPosition = originalTransform.position;
            var originalRotation = originalTransform.rotation.eulerAngles;
            var position = new Vector3(originalPosition.x + 0.05f, originalPosition.y, originalPosition.z + 0.05f);
            var rotation = new Vector3(originalRotation.x, originalRotation.y - 180f, originalRotation.z);
            var plankton = _planktonContainer.Add(
                position, rotation, original.Energy
            );
            plankton.gameObject.transform.SetParent(gameObject.transform);
            //plankton.Jets(10f, Random.Range(-100f, 100f), false);
        }

        private void AddPlankton(Vector3 position, Vector3 rotation, int energy)
        {
            var plankton = _planktonContainer.Add(position, rotation, energy);
        }

        public void AddBacteria(Bacteria original)
        {
            var originalTransform = original.gameObject.transform;
            var originalPosition = originalTransform.position;
            var originalRotation = originalTransform.rotation.eulerAngles;
            var position = new Vector3(originalPosition.x + 0.05f, originalPosition.y, originalPosition.z + 0.05f);
            var rotation = new Vector3(originalRotation.x, originalRotation.y - 180f, originalRotation.z);
            var bacteria = _bacteriaService.Create(
                position, rotation, original.Energy, original.Mass
            );
            bacteria.gameObject.transform.SetParent(gameObject.transform);
            bacteria.Jets(10f, Random.Range(-100f, 100f), false);
        }

        private void AddBacteria(Vector3 position, Vector3 rotation, int energy, int mass)
        {
            var bacteria = _bacteriaService.Create(position, rotation, energy, mass);
            bacteria.gameObject.transform.SetParent(gameObject.transform);
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
            container.initialSize = size;
            container.initialPlankton = initialPlankton;
            go.transform.SetParent(gameObject.transform);
            return container;
        }
    }
}