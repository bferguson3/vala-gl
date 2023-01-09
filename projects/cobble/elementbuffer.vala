// elementbuffer.vala

using GL;

public class ElementBuffer : GLib.Object 
{
    private GLuint buffer;

    public ElementBuffer()
    {
        glGenBuffers(1, (GLuint[])buffer);
    }

    public ElementBuffer.forSpriteCount(uint size)
    {
        glGenBuffers(1, (GLuint[])buffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, 
            (GLsizeiptr)sizeof(GLfloat) * size * 6, // 6 elements per quad 
            null, 
            GL_STATIC_DRAW);
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
    