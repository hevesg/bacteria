using UnityEngine;

public class Helper
{

    public static float getRandomAngle()
    {
        return Random.Range(-180f, 180f);
    }
    
    public static Vector3 getRandomRotationVector()
    {
        return new Vector3(getRandomAngle(), getRandomAngle(), getRandomAngle());
    }

    public static Vector3 getRandomTorque(float force)
    {
        return new Vector3(
            Random.Range(-force, force),
            Random.Range(-force, force),
            Random.Range(-force, force)
            );
    }
}
