using System;
using UnityEngine;

namespace Humus
{
    public class HumusCube : MonoBehaviour
    {
        public int initialQuantity;
        private GameObject _body;
        private Material _material;

        private void Awake()
        {
            initialQuantity = (int) 1e6;
            
            _body = GameObject.CreatePrimitive(PrimitiveType.Cube);
            _body.name = "Body";
            _body.transform.SetParent(gameObject.transform);
            _body.transform.localPosition = new Vector3(0.5f, 0.5f, 0.5f);
            _body.transform.localRotation = Quaternion.Euler(0, 0, 0);
            _body.transform.localScale = new Vector3(1, 1, 1);
            
            var col = _body.GetComponent<BoxCollider>();
            col.isTrigger = true;

            _material = new Material(Shader.Find("Standard"));
            _material.SetFloat("_Mode", 2f);
            _material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
            _material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
            _material.SetInt("_ZWrite", 0);
            _material.DisableKeyword("_ALPHATEST_ON");
            _material.EnableKeyword("_ALPHABLEND_ON");
            _material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
            _material.renderQueue = 3000;
            _material.color = Color;
            _body.GetComponent<Renderer>().material = _material;
        }

        private void Start()
        {
            Quantity = initialQuantity;
            _material.color = Color;
        }

        public int Quantity { get; private set; }

        private Color Color => new Color(0, 0, 0, (float) Quantity / (float) 1e7);

        public int ProvideHumus(int quantity)
        {
            if (quantity > Quantity)
            {
                var availability = Quantity;
                Quantity = 0;
                _material.color = Color;
                return availability;
            }
            Quantity -= quantity;
            _material.color = Color;
            return quantity;
        }
    }
}