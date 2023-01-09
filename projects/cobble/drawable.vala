// drawable.vala 

using GL;
using Cobble;

public class Drawable : GLib.Object
{
    private weak GLfloat[] vertices;
    private weak GLuint[] elements;
    protected weak VertexBuffer vertexBuffer;
    protected weak ElementBuffer elementBuffer;

    public Drawable()
    {

    }

    ~Drawable()
    {
        //g_drawableElementsCounter--;
        //g_drawableElementsNo = g_drawableElementsNo - elements.length;

        //g_drawableVerticesCounter--;
        //g_drawableVerticesNo = g_drawableVerticesNo - vertices.length;
    }

    public void setBuffers(VertexBuffer vb, ElementBuffer eb)
    {
        vertexBuffer = vb;
        elementBuffer = eb;
    }

    public void setVertices(GLfloat[] verts)
    {
        vertices = verts;
    }

    public void setElements(GLuint[] els)
    {
        elements = els;
    }

    // For now, Drawable{} will not set vertices or elements, 
    //  since you may have many different type of drawables at once. 
    // For a screen position-relative textured quad, use the Sprite{} 
    //  subclass. 


    public virtual void bufferElements()
    {
        //elementBuffer.bind();

        glBufferData(GL_ELEMENT_ARRAY_BUFFER,
            (GLsizeiptr)sizeof(GLuint) * elements.length, 
            (GLvoid[])elements,
            GL_STATIC_DRAW);
        
        //glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        //g_drawableElementsCounter++;
        //g_drawableElementsNo += elements.length;
    }
}