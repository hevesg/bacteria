using UnityEngine;

namespace Organism.Mitochondria
{
    public class Mitochondria : MonoBehaviour
    {
        private float _x;
        private float _y;
        private float _z;

        private void Awake()
        {
            _x = Helper.getRandomAngle() * 2;
            _y = Helper.getRandomAngle() * 2;
            _z = Helper.getRandomAngle() * 2;
        }

        void FixedUpdate()
        {
            transform.Rotate(new Vector3(_x, _y, _z) * Time.deltaTime);
        }
    }
}
