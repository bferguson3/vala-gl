// sprite 

using Cobble;

public class Sprite : Drawable
{
    private GL.GLfloat _vertices[VERTEX_LENGTH * 4];   // for now
    private GL.GLuint  _elements[6];     // for now
    
    public int x { public get; private set; }
    public int y { public get; private set; }
    public int w { public get; private set; }
    public int h { public get; private set; }

    public Sprite(int myTexWidth, int myTexHeight)
    {
        x = (SCREEN_WIDTH  / 2) - (myTexWidth  / 2); 
        y = (SCREEN_HEIGHT / 2) - (myTexHeight / 2);
        
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
        _elements = {
            0, 1, 2,
            2, 3, 1
        };    

        setVertices(_vertices);
        setElements(_elements);
        setSize(myTexWidth, myTexHeight);
    }

    public void setSize(int _w, int _h)
    {
        w = _w;
        h = _h;
        
        //base.setSize(_w, _h);
        
        //XYPos pos = new XYPos(x, y);
        //setPos(pos.x, pos.y);
        setXPos(x); 
        setYPos(y);
    }

    private void setXPos(int _x)
    {
        int _dx = _x - x;
        _vertices[VERT_X_INDEX + 0] += _dx * PIXEL_WIDTH;
        _vertices[VERT_X_INDEX + (VERTEX_LENGTH * 1)] += _dx * PIXEL_WIDTH;
        _vertices[VERT_X_INDEX + (VERTEX_LENGTH * 2)] += _dx * PIXEL_WIDTH;
        _vertices[VERT_X_INDEX + (VERTEX_LENGTH * 3)] += _dx * PIXEL_WIDTH;
        x = _x;
    }

    private void setYPos(int _y)
    {
        int _dy = _y - y;
        _vertices[VERT_Y_INDEX + 0] -= _dy * PIXEL_HEIGHT;
        _vertices[VERT_Y_INDEX + (VERTEX_LENGTH * 1)] -= _dy * PIXEL_HEIGHT;
        _vertices[VERT_Y_INDEX + (VERTEX_LENGTH * 2)] -= _dy * PIXEL_HEIGHT;
        _vertices[VERT_Y_INDEX + (VERTEX_LENGTH * 3)] -= _dy * PIXEL_HEIGHT;
        y = _y;
    }

    public void setPos(XYPos pos)
    {
        int _dx = pos.x - x;
        int _dy = pos.y - y;
        
        _vertices[VERT_X_INDEX + 0] += _dx * PIXEL_WIDTH;
        _vertices[VERT_X_INDEX + (VERTEX_LENGTH * 1)] += _dx * PIXEL_WIDTH;
        _vertices[VERT_X_INDEX + (VERTEX_LENGTH * 2)] += _dx * PIXEL_WIDTH;
        _vertices[VERT_X_INDEX + (VERTEX_LENGTH * 3)] += _dx * PIXEL_WIDTH;
        
        _vertices[VERT_Y_INDEX + 0] -= _dy * PIXEL_HEIGHT;
        _vertices[VERT_Y_INDEX + (VERTEX_LENGTH * 1)] -= _dy * PIXEL_HEIGHT;
        _vertices[VERT_Y_INDEX + (VERTEX_LENGTH * 2)] -= _dy * PIXEL_HEIGHT;
        _vertices[VERT_Y_INDEX + (VERTEX_LENGTH * 3)] -= _dy * PIXEL_HEIGHT;
        
        x = pos.x;
        y = pos.y;       
    }

    public XYPos getPos()
    {
        return new XYPos(x, y);
    }

    public void draw()
    {
        bufferVertices();
        bufferElements();
    }

    public void buffer()
    {
        draw();
    }
}