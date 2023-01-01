// elementbuffer.vala

using GL;

public class ElementBuffer : GLib.Object 
{
    private GLuint buffer;

    public ElementBuffer()
    {
        glGenBuffers(1, (GLuint[])buffer);
    }

    ~ElementBuffer()
    {
        glDeleteBuffers(1, (GLuint[])buffer);
    }

    public void bind()
    {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer);
    }
}
    