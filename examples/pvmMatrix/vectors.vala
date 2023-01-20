// vectors.vala

using GL;


public class Vector : GLib.Object 
{
    //public GLenum vecType { get; set; }
    public char type;
}

public class Vec4 : Vector
{
    // Fields
    public GLfloat x { get; private set; }
    public GLfloat y { get; private set; }
    public GLfloat z { get; private set; }
    public GLfloat a { get; private set; }

    public Vec4(float _x, float _y, float _z, float _a)
    {   
        type = '4';
        x = _x;
        y = _y;
        z = _z;
        a = _a;
        //vecType = GL_FLOAT_VEC4;
    }

    public void add(Vec4 other)
    {
        x += other.x;
        y += other.y;
        z += other.z;
        a += other.a;
    }
    
    public void sub(Vec4 other)
    {
        x -= other.x;
        y -= other.y;
        z -= other.z;
        a -= other.a;
    }

    public void mul(Vec4 other)
    {
        x *= other.x;
        y *= other.y;
        z *= other.z;
        a *= other.a;
    }

    public void mul_mat4(Mat4 other)
    {
        x = (x * other.data[0]) + (x * other.data[1]) + 
            (x * other.data[2]) + (x * other.data[3]);
        y = (y * other.data[4+0]) + (y * other.data[4+1]) + 
            (y * other.data[4+2]) + (y * other.data[4+3]);
        z = (z * other.data[8+0]) + (z * other.data[8+1]) + 
            (z * other.data[8+2]) + (z * other.data[8+3]);
        a = (a * other.data[12+0]) + (a * other.data[12+1]) + 
            (a * other.data[12+2]) + (a * other.data[12+3]);
    }

    public void div(Vec4 other)
    {
        x /= other.x;
        y /= other.y;
        z /= other.z;
        a /= other.a;
    }
}

public class Vec3 : Vector
{
    public GLfloat x { get; private set; }
    public GLfloat y { get; private set; }
    public GLfloat z { get; private set; }
    
    public Vec3(float _x, float _y, float _z)
    {
        type = '3';
        x = _x;
        y = _y;
        z = _z;
        //vecType = GL_FLOAT_VEC3;
    }

    public Vec3.from_cross_product(Vec3 a, Vec3 b)
    {
        // The cross product of a x b ==
        //   len(a) * len(b) * sin(theta) * unit vector 
        // or... does this work?
        x = (a.y*b.z) - (a.z*b.y);
        y = (a.z*b.x) - (a.x*b.z);
        z = (a.x*b.y) - (a.y*b.x);
    }

    public float dot(Vec3 other)
    {
        return (float)(
            (x * other.x) +
            (y * other.y) +
            (z * other.z)
        );
    }

    public void negate()
    {
        x *= -1.0f;
        y *= -1.0f;
        z *= -1.0f;
    }

    public void print()
    {
        stdout.printf("X: %f\n", x);
        stdout.printf("Y: %f\n", y);
        stdout.printf("Z: %f\n", z);
        //stdout.printf("A: %f\n", a);
    }

    public void normalize()
    {
        //float d = fisqrt((x*x) + (y*y) + (z*z));
        //x *= d;
        //y *= d;
        //z *= d;
        float dd = (float)Math.sqrt((x*x) + (y*y) + (z*z));
        x /= dd;
        y /= dd;
        z /= dd;
        
    }
}

public class Vec2 : Vector
{
    public GLfloat x { get; private set; }
    public GLfloat y { get; private set; }
    
    public Vec2(float _x, float _y)
    {
        type = '2';
        x = _x;
        y = _y;
        //vecType = GL_FLOAT_VEC2;
    }
}    

public class Vec1 : Vector 
{
    public GLfloat x { get; private set; }
    
    public Vec1(float _x)
    {
        type = '1';
        x = _x;
        
    }
}

