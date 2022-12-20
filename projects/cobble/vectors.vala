// vectors.vala

using GL;

public class Vector : GLib.Object
{
    // Fields
    public GLfloat x { get; private set; }
    public GLfloat y { get; private set; }
    public GLfloat z { get; private set; }
    public GLfloat a { get; private set; }

    public GLenum vecType { get; private set; }

    // Constructors
    public Vector.2f(float _x, float _y)
    {
        x = _x;
        y = _y;
        z = 0f;
        a = 0f;
        vecType = GL_FLOAT_VEC2;
    }
    
    public Vector.3f(float _x, float _y, float _z)
    {
        x = _x;
        y = _y;
        z = _z;
        a = 0f;
        vecType = GL_FLOAT_VEC3;
    }

    public Vector.4f(float _x, float _y, float _z, float _a)
    {   
        x = _x;
        y = _y;
        z = _z;
        a = _a;
        vecType = GL_FLOAT_VEC4;
    }

}