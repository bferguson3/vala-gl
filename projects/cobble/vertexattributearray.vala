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
        //stdout.printf("VertexAttributeArray %p deleted.\n", (void*)_vao);
        glDeleteVertexArrays(1, (GLuint[])&_vao);
    }

    // methods
    public void bind()
    {
        glBindVertexArray(_vao);
    }

    public void SetVertexShape(GLint attr,
        uint8 pointSize, 
        GLenum type, 
        uint8 sizeOfAttributes, 
        uint8 offset)
    {
        glEnableVertexAttribArray(attr);
        
        if(type == GL_FLOAT)
        {
            var ofs = (void*)(offset * sizeof(GLfloat));
            glVertexAttribPointer(attr, 
                pointSize, 
                GL_FLOAT, 
                (GLboolean)GL_FALSE, 
                (GLsizei)(sizeOfAttributes * sizeof(GLfloat)), 
                ofs);
        }
        else 
        { 
            stderr.printf("Error! GL_FLOAT only supported.\n");
        }
    }

}