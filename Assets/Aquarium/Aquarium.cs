using Organism.Bacteria;
using Organism.Plankton;
using UnityEngine;

namespace Aquarium
{
    public class Aquarium : MonoBehaviour
    {
        public int initialPlankton;
        public int initialBacteria;
        
        private PlanktonContainer _planktonContainer;
        private BacteriaContainer _bacteriaContainer;
        private Camera _camera;

        private void Awake()
        {
            _camera = Camera.main;
        }

        void Start()
        {
            _planktonContainer = GameObject.Find("PlanktonContainer").GetComponent<PlanktonContainer>();
            _bacteriaContainer = GameObject.Find("BacteriaContainer").GetComponent<BacteriaContainer>();
            Populate();
        }

        private void Update()
        {
            _camera.transform.position = _bacteriaContainer.transform.GetChild(0).transform.position + new Vector3(30, 10, 0);
            _camera.transform.LookAt(_bacteriaContainer.transform.GetChild(0));
        }

        private void Populate()
        {
            for (var i = 0; i < initialPlankton + initialBacteria; i++)
            {
                var position = new Vector3(
                    Puddle.GETRandomRange(200),
                    Random.Range(-2, -18),
                    Puddle.GETRandomRange(200)
                    );
                if (i < initialPlankton)
                {
                    _planktonContainer.Add(position, Random.rotation.eulerAngles, Puddle.Instance.RemoveFertility((int) 5e4));
                }
                else
                {
                    _bacteriaContainer.Add(position, Random.rotation.eulerAngles, Puddle.Instance.RemoveFertility((int) 5e5));
                }
            }
        }
    }
}