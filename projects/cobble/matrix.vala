// matrix.vala 

using Math;

public class Matrix : GLib.Object 
{
    public char type;
}

public class Mat4 : Matrix 
{
    public float data[16];
    
    public Mat4()
    {
        type = '4';
        //stdout.printf("%f\n", data.y[0].x[0]);
    }
    //If there is a single scalar parameter to a matrix constructor, 
    //it is used to initialize all the components on the matrix's diagonal, 
    //with the remaining components initialized to 0.0f

    public Mat4.fromArray(float[] d)
    {
        type = '4';
        int di = 0;
        for(int yi = 0; yi < 4; yi++)
            for(int xi = 0; xi < 4; xi++)
            {
                //data.y[yi].x[xi] = d[di];
                data[(yi*4)+xi] = d[di];
                di++;
            }

    }

    public Mat4.Copy(Mat4 m)
    {
        type = '4';
        for(int i = 0; i < 16; i++)
            data[i] = m.data[i];
    }

    public Mat4.Identity(float v)
    {
        type = '4';
        for(int y = 0; y < 4; y++)
        {
            for(int x = 0; x < 4; x++)
            {
                //data.y[y].x[x] = 1.0f;
                data[(y*4)+x] = 0.0f;
            }
        }

        for(int i = 0; i < 4; i++)
        {
            //data.y[i].x[i] = v;
            data[(i*4)+i] = v;
        }
        
    }

    public void scale(float xs, float ys, float zs)
    { // FIXME ? 
        data[0] *= xs;
        data[1] *= xs;
        data[2] *= xs;

        data[4] *= ys;
        data[5] *= ys;
        data[6] *= ys;

        data[8] *= zs;
        data[9] *= zs;
        data[10] *= zs;
    }

    public void setDataRow(int r, Vec4 vals)
    {
        data[(r*4)+0] = vals.x;
        data[(r*4)+1] = vals.y;
        data[(r*4)+2] = vals.z;
        data[(r*4)+3] = vals.a;
    }

    public void mul(Mat4 other)
    { // maybe broken? FIXME
        // row 0 
        float _data[16];
        
        for(int i = 0; i < 4; i++)
        {
            _data[0 + (i*4)] = (data[0 + (i*4)] * other.data[0]) + 
                (data[0 + (i*4)+1] * other.data[0+4]) + 
                (data[0 + (i*4)+2] * other.data[0+8]) + 
                (data[0 + (i*4)+3] * other.data[0+12]);
            _data[1 + (i*4)] = (data[0 + (i*4)] * other.data[1]) + 
                (data[0 + (i*4)+1] * other.data[1+4]) + 
                (data[0 + (i*4)+2] * other.data[1+8]) + 
                (data[0 + (i*4)+3] * other.data[1+12]);
            _data[2 + (i*4)] = (data[0 + (i*4)] * other.data[2]) + 
                (data[0 + (i*4)+1] * other.data[2+4]) + 
                (data[0 + (i*4)+2] * other.data[2+8]) + 
                (data[0 + (i*4)+3] * other.data[2+12]);
            _data[3 + (i*4)] = (data[0 + (i*4)] * other.data[3]) + 
                (data[0 + (i*4)+1] * other.data[3+4]) + 
                (data[0 + (i*4)+2] * other.data[3+8]) + 
                (data[0 + (i*4)+3] * other.data[3+12]);
        }
        
        data = _data;
    }

    public void rotate(float r, Vec3 axis)
    {

        // specifically for X rotation
        
        Mat4 rot;
        if(axis.x == 1.0f)
            rot = new Mat4.fromArray(get_xrot_formula(r));
        else if (axis.y == 1.0f)
            rot = new Mat4.fromArray(get_yrot_formula(r));
        else if (axis.z == 1.0f)
            rot = new Mat4.fromArray(get_zrot_formula(r));
        else 
        {
            stderr.printf("Warning: Cobble only supports normalized rotations.\n");
            return;
        }

        mul(rot);
        
    }


    private float[] get_zrot_formula(float r)
    { 
        /*
        float formula[16] = { 
            (float)cos(theta), (float)sin(theta)*-1, (float)sin(theta),  0.0f, 
            (float)sin(theta), (float)cos(theta), (float)sin(theta)*-1,  0.0f, 
            (float)sin(theta)*-1, (float)sin(theta), (float)cos(theta),   0.0f, 
            0.0f,              0.0f,             0.0f,                   1.0f
        };
         */
        // the X Y or Z aspect of the matrix will be inverse normalized. 
        // a rotation axis of 0, 0, 1.0 will normalize x and y of the fomula matrix to 1 and z to 0. 
        
        float formula[16] = { 
            (float)cos(r), (float)sin(r)*-1, 0.0f,  0.0f, 
            (float)sin(r), (float)cos(r),    0.0f,  0.0f, 
            0.0f, 0.0f,  1.0f, 0.0f, 
            0.0f, 0.0f,  0.0f, 1.0f
        };
         
        return formula;
    }

    public void translate(float x, float y, float z)
    {
        float _ar[16] = {
            1.0f, 0.0f, 0.0f, x, 
            0.0f, 1.0f, 0.0f, y, 
            0.0f, 0.0f, 1.0f, z, 
            0.0f, 0.0f, 0.0f, 1.0f
        };
        var _m = new Mat4.fromArray(_ar);
        mul(_m);
    }

    private float[] get_yrot_formula(float theta)
    { 
        
        float formula[16] = { 
            (float)cos(theta), 0.0f, (float)sin(theta),  0.0f, 
            0.0f, 1.0f,    (float)sin(theta)*-1,  0.0f, 
            (float)sin(theta)*-1, 0.0f,  (float)cos(theta), 0.0f, 
            0.0f, 0.0f,  0.0f, 1.0f
        };
         
        return formula;
    }

    private float[] get_xrot_formula(float theta)
    { 
        
        float formula[16] = { 
            1.0f, 0.0f, 0.0f,  0.0f, 
            0.0f, (float)cos(theta),    (float)sin(theta)*-1,  0.0f, 
            0.0f, (float)sin(theta),  (float)cos(theta), 0.0f, 
            0.0f, 0.0f,  0.0f, 1.0f
        };
         
        return formula;
    }
    
    public void print()
    {
        //data.y[0].x[0] = 3.3f;
        for(int yi = 0; yi < 4; yi++){
            for(int xi = 0; xi < 4; xi++)
            {
                //stdout.printf("%f \n", data.y[yi].x[xi]);
                stdout.printf("%f ", data[(yi*4)+xi]);
            }
            stdout.printf("\n");
        }
    }
}