using System.Collections.Generic;
using Humus;
using Organism.Plancton;
using UnityEngine;

namespace Aquarium
{
    public class Aquarium : MonoBehaviour
    {
        public Vector3Int size;
        public float wallThickness;
        public GameObject planctonPrefab;
        
        private GameObject _northernWall;
        private GameObject _easternWall;
        private GameObject _southernWall;
        private GameObject _westernWall;

        private HumusContainer _humusContainer;
        private List<Plancton> _planctons;

        private void Awake()
        {
            _humusContainer = new HumusContainer(new Vector3Int(size.x, 1, size.z));
            _planctons = new List<Plancton>();
        }

        void Start()
        {
            BuildWalls();
            var i = 0;
            for (var x = 0; x < size.x; x++) 
            {
                for (var y = 0; y < 1; y++)
                {
                    for (var z = 0; z < size.z; z++)
                    {
                        if (i % 3 == 0)
                        {
                            AddPlancton(new Vector3(x + 0.5f, y + 0.5f, z + 0.5f));
                        }
                        i++;
                    }
                }
            }
        }

        void Update()
        {
            _humusContainer.ShareWithNeighbor(Time.deltaTime);
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

        public void AddPlancton(Plancton plancton)
        {
            var go = plancton.gameObject;
            var transformPosition = go.transform.position;
            transformPosition.x -= 0.5f;
            transformPosition.z -= 0.5f;
            go.transform.parent = gameObject.transform;
            plancton.Jets(100f, Random.Range(-1f, 1f), false);
            _planctons.Add(plancton.GetComponent<Plancton>());
            Debug.Log(_planctons.Count);
        }
        private void AddPlancton(Vector3 position)
        {
            var plancton = Instantiate(planctonPrefab, position, Quaternion.Euler(0, Random.Range(-180f, 180f), 0));
            plancton.transform.parent = gameObject.transform;
            plancton.GetComponent<Plancton>().Energy = 0;
            plancton.GetComponent<Plancton>().Mass = (int) (10e1);
            _planctons.Add(plancton.GetComponent<Plancton>());
        }

        public HumusCube GetHumusCubeAt(Vector3 position)
        {
            return _humusContainer.FindAt(position);
        }

    }
}
