// vectors.vala

using GL;

public class Vector : GLib.Object 
{
    //public GLenum vecType { get; set; }
}

public class Vector4 : Vector
{
    // Fields
    public GLfloat x { get; private set; }
    public GLfloat y { get; private set; }
    public GLfloat z { get; private set; }
    public GLfloat a { get; private set; }

    public Vector4(float _x, float _y, float _z, float _a)
    {   
        x = _x;
        y = _y;
        z = _z;
        a = _a;
        //vecType = GL_FLOAT_VEC4;
    }

}

public class Vector3 : Vector
{
    public GLfloat x { get; private set; }
    public GLfloat y { get; private set; }
    public GLfloat z { get; private set; }
    
    public Vector3(float _x, float _y, float _z)
    {
        x = _x;
        y = _y;
        z = _z;
        //vecType = GL_FLOAT_VEC3;
    }
}

public class Vector2 : Vector
{
    public GLfloat x { get; private set; }
    public GLfloat y { get; private set; }
    
    public Vector2(float _x, float _y)
    {
        x = _x;
        y = _y;
        //vecType = GL_FLOAT_VEC2;
    }
}    

public struct Vector1 : GLfloat 
{
    
}

