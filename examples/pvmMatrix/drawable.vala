// drawable.vala 

using GL;

public class Drawable : GLib.Object
{
    public weak GLfloat[] vertices;
    private weak GLuint[] elements;

    public Drawable()
    {

    }
    ~Drawable()
    {

    }

    public void setVertices(GLfloat[] verts)
    {
        vertices = verts;
    }

    public void setElements(GLuint[] els)
    {
        elements = els;
    }
    public void bufferVertices()
    {
        glBufferData(GL_ARRAY_BUFFER, 
            (GLsizeiptr)sizeof(GLfloat) * vertices.length, 
            (GLvoid[])vertices, 
            GL_STATIC_DRAW);
            
    }
    public void bufferElements()
    {
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,
            (GLsizeiptr)sizeof(GLuint) * elements.length, 
            (GLvoid[])elements,
            GL_STATIC_DRAW);

    }
}