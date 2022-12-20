// vertexattributearray.vala 

using GL;

public class VertexAttributeArray : GLib.Object
{
    // fields 
    private GLuint _vao;

    // constructor
    public VertexAttributeArray()
    {
        glGenVertexArrays(1, (GLuint[])&_vao);
    }

    // destructor 
    ~VertexAttributeArray()
    {
        stdout.printf("VertexAttributeArray %p deleted.\n", (void*)_vao);
        glDeleteVertexArrays(1, (GLuint[])&_vao);
    }

    // methods
    public void bind()
    {
        glBindVertexArray(_vao);
    }

}