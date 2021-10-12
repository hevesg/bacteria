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
            initialQuantity = (int) 1e5;
            
            _body = GameObject.CreatePrimitive(PrimitiveType.Cube);
            _body.name = "Body";
            _body.transform.SetParent(gameObject.transform);
            _body.transform.localPosition = new Vector3(0.5f, 0.5f, 0.5f);
            _body.transform.localRotation = Quaternion.Euler(0, 0, 0);
            _body.transform.localScale = new Vector3(1, 1, 1);
            
            Destroy(_body.GetComponent<BoxCollider>());
            var col = gameObject.AddComponent<BoxCollider>();
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
            _material.color = Color.black;
            _body.GetComponent<Renderer>().material = _material;
        }

        private void Start()
        {
            Quantity = initialQuantity;
            UpdateMaterial();
        }

        public int Quantity { get;  set; }
        
        public int ProvideHumus(int quantity)
        {
            if (quantity > Quantity)
            {
                var availability = Quantity;
                Quantity = 0;
                UpdateMaterial();
                return availability;
            }
            Quantity -= quantity;
            UpdateMaterial();
            return quantity;
        }

        private void UpdateMaterial()
        {
            _material.color = new Color(0, 0, 0, (float) Quantity / (float) 1e6);
        }

        public void TransferQuantityTo(HumusCube other, int quantity)
        {
            var transfer = (quantity > Quantity) ? Quantity : quantity;
            Debug.Log(transfer);
            Quantity -= transfer;
            other.Quantity += transfer;
        } 
    }
}