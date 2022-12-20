// vertexbuffer.vala 

using GL;

public class VertexBuffer : GLib.Object
{
    // fields 
    private GLuint buffer;

    // constructor
    public VertexBuffer()
    {
        glGenBuffers(1, (GLuint[])&buffer);
    }

    // destructor 
    ~VertexBuffer()
    {
        //stdout.printf("VertexBuffer %p deleted.\n", (void*)buffer);
        glDeleteBuffers(1, (GLuint[])&buffer);
    }

    // methods
    public void bind()
    {
        glBindBuffer(GL_ARRAY_BUFFER, buffer);
    }

}