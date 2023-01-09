// vertexbuffer.vala 

using Cobble;
using GL;

public class VertexBuffer : GLib.Object
{
    // fields 
    private GLuint buffer;

    // constructor
    public VertexBuffer()
    {
        glGenBuffers(1, (GLuint[])buffer);
    }

    public VertexBuffer.forSpriteCount(uint size)
    {
        glGenBuffers(1, (GLuint[])buffer);
        glBindBuffer(GL_ARRAY_BUFFER, buffer);
        glBufferData(GL_ARRAY_BUFFER, 
            (GLsizeiptr)sizeof(GLfloat) * size * SPRITE_VERTEX_LENGTH, 
            null, 
            GL_STATIC_DRAW);
    }

    // destructor 
    ~VertexBuffer()
    {
        //stdout.printf("VertexBuffer %p deleted.\n", (void*)buffer);
        glDeleteBuffers(1, (GLuint[])buffer);
    }

    // methods
    public void bind()
    {
        glBindBuffer(GL_ARRAY_BUFFER, buffer);
    }

}