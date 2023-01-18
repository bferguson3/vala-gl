// sprite 

using Cobble;
using GL;

public class Sprite : Drawable
{
    private GL.GLfloat _vertices[SPRITE_VERTEX_LENGTH * 4];   // for now
    //private GL.GLuint  _elements[6];     // for now
    public int index { public get; private set; } // sprite index 

    private weak Texture tex { public get; private set; }
    
    public int x { public get; private set; }
    public int y { public get; private set; }
    public int w { public get; private set; }
    public int h { public get; private set; }

    public Sprite(Texture t, int myTexWidth, int myTexHeight)
    {
        x = (SCREEN_WIDTH  / 2) - (myTexWidth  / 2); 
        y = (SCREEN_HEIGHT / 2) - (myTexHeight / 2);
        /*
        _vertices = {
            ((float)(myTexWidth/2) * PIXEL_WIDTH * -1), ((float)(myTexHeight/2) * PIXEL_HEIGHT),       // pos 
            1.0f, 1.0f, 1.0f,   // color
             0.0f, 0.0f,        // uv Top-left
            ((float)(myTexWidth/2) * PIXEL_WIDTH),      ((float)(myTexHeight/2) * PIXEL_HEIGHT),       // pos 
            1.0f, 1.0f, 1.0f,   // color
             1.0f, 0.0f,        // uv Top-right
            ((float)(myTexWidth/2) * PIXEL_WIDTH * -1), ((float)(myTexHeight/2) * PIXEL_HEIGHT * -1),    // pos
             1.0f, 1.0f, 1.0f,   // color
             0.0f, 1.0f,         // uv Bottom-left
            ((float)(myTexWidth/2) * PIXEL_WIDTH),      ((float)(myTexHeight/2) * PIXEL_HEIGHT * -1),    // pos 
            1.0f, 1.0f, 1.0f,   // color
             1.0f, 1.0f           // uv Bottom-right
        };
         */
         _vertices = {
            -0.5f, -0.5f,       // pos 
            1.0f, 1.0f, 1.0f,   // color
             0.0f, 0.0f,        // uv Top-left
            0.5f,-0.5f,       // pos 
            1.0f, 1.0f, 1.0f,   // color
             1.0f, 0.0f,        // uv Top-right
            -0.5f, 0.5f,    // pos
             1.0f, 1.0f, 1.0f,   // color
             0.0f, 1.0f,         // uv Bottom-left
            0.5f,  0.5f,    // pos 
            1.0f, 1.0f, 1.0f,   // color
             1.0f, 1.0f           // uv Bottom-right
        };

        setVertices(_vertices);
        //setElements(_elements);
        setSize(myTexWidth, myTexHeight);
        tex = t;
        //index = g_SpritesDrawn;
        //g_SpritesDrawn++;
    }

    public Sprite.Copy(Sprite s)
    {
        x = s.x;
        y = s.y;
        w = s.w;
        h = s.h;
        _vertices = s.vertices;
        setVertices(_vertices);
        setSize(s.w, s.h);
        tex = s.tex;
        //index = g_SpritesDrawn;
        //g_SpritesDrawn++;
    }

    ~Sprite()
    {
        float[] _verts = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f,
            0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f,
            0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f,
            0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
        setVertices(_verts);
        bufferVertices();
        //g_SpritesDrawn--; //fixme 
    }

    public void SetTexture(Texture t)
    {
        tex = t;
    }

    public void printVerts()
    {
        for(int i = 0; i < vertices.length; i++)
        {
            stdout.printf("%f\n", vertices[i]);
        }    
    }
    
    public void draw()
    {
        if(tex != null)
            tex.bufferToSize(w, h);
        else 
            stderr.printf("COBBLE ERROR: Sprite %u texture is null\n", index);
            
        bufferVertices();
    }

    public void setIndex(int i)
    {
        index = i;
    }

    public void setSize(int _w, int _h)
    {
        w = _w;
        h = _h;
        
        setXPos(x); 
        setYPos(y);
    }

    public void setXPos(int _x)
    {
        int   _dx = _x - x;
        float _pw = _dx * PIXEL_WIDTH;
        
        _vertices[VERT_X_INDEX + 0] += _pw;
        _vertices[VERT_X_INDEX + (SPRITE_VERTEX_LENGTH * 1)] += _pw;
        _vertices[VERT_X_INDEX + (SPRITE_VERTEX_LENGTH * 2)] += _pw;
        _vertices[VERT_X_INDEX + (SPRITE_VERTEX_LENGTH * 3)] += _pw;
        
        x = _x;

        bufferVertices();
    }

    public void setYPos(int _y)
    {
        int   _dy = _y - y;
        float _ph = _dy * PIXEL_HEIGHT;

        _vertices[VERT_Y_INDEX + 0] -= _ph;
        _vertices[VERT_Y_INDEX + (SPRITE_VERTEX_LENGTH * 1)] -= _ph;
        _vertices[VERT_Y_INDEX + (SPRITE_VERTEX_LENGTH * 2)] -= _ph;
        _vertices[VERT_Y_INDEX + (SPRITE_VERTEX_LENGTH * 3)] -= _ph;
        
        y = _y;

        bufferVertices();
    }

    public void setPos(XYPos pos)
    {
        int _x = pos.x;
        int _y = pos.y;
        
        int _dx = _x - x;
        int _dy = _y - y;
        
        float _pw = _dx * PIXEL_WIDTH;
        float _ph = _dy * PIXEL_HEIGHT;
        
        _vertices[VERT_X_INDEX + 0] += _pw;
        _vertices[VERT_X_INDEX + (SPRITE_VERTEX_LENGTH * 1)] += _pw;
        _vertices[VERT_X_INDEX + (SPRITE_VERTEX_LENGTH * 2)] += _pw;
        _vertices[VERT_X_INDEX + (SPRITE_VERTEX_LENGTH * 3)] += _pw;
        
        _vertices[VERT_Y_INDEX + 0] -= _ph;
        _vertices[VERT_Y_INDEX + (SPRITE_VERTEX_LENGTH * 1)] -= _ph;
        _vertices[VERT_Y_INDEX + (SPRITE_VERTEX_LENGTH * 2)] -= _ph;
        _vertices[VERT_Y_INDEX + (SPRITE_VERTEX_LENGTH * 3)] -= _ph;
        
        x = _x;    
        y = _y; 
        
        bufferVertices();
    }

    public XYPos getPos()
    {
        return new XYPos(x, y);
    }

    public void bufferVertices()
    {
        glBufferSubData(GL_ARRAY_BUFFER, 
            (GLsizeiptr)sizeof(GLfloat) * _vertices.length * index, 
            (GLsizeiptr)sizeof(GLfloat) * _vertices.length, 
            (GLvoid[])_vertices
        );
       
    }

    public float[] getVerts()
    {
        return _vertices;
    }

    public void buffer()
    {
        bufferVertices();
        //bufferElements();
    }
}
