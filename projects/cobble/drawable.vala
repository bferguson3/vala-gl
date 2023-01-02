// drawable.vala 

using GL;
using Cobble;

public class Drawable : GLib.Object
{
    private weak GLfloat[] vertices;
    private weak GLuint[] elements;

    public Drawable()
    {

    }
    ~Drawable()
    {
        g_drawableElementsCounter--;
        g_drawableElementsNo = g_drawableElementsNo - elements.length;

        g_drawableVerticesCounter--;
        g_drawableVerticesNo = g_drawableVerticesNo - vertices.length;
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

    public void bufferVertices()
    {
        glBufferData(GL_ARRAY_BUFFER, 
            (GLsizeiptr)sizeof(GLfloat) * vertices.length, 
            (GLvoid[])vertices, 
            GL_STATIC_DRAW);

        g_drawableVerticesCounter++;
        g_drawableVerticesNo += vertices.length;
    }

    public void bufferElements()
    {
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,
            (GLsizeiptr)sizeof(GLuint) * elements.length, 
            (GLvoid[])elements,
            GL_STATIC_DRAW);
        
        g_drawableElementsCounter++;
        g_drawableElementsNo += elements.length;
    }
}