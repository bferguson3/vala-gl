// shaderprogram.vala 

using GL;

public class ShaderProgram : GLib.Object
{
    // vals 
    public GLuint program { get; private set; }
    public GLint posAttrib { get; private set; }
    private weak Shader vertexShader;
    private weak Shader fragmentShader;
    //public GLint[] attributes { get; private set; }

    // con 
    public ShaderProgram()
    {
        program = glCreateProgram();
        //SetPosAttrib();
    }

    public ShaderProgram.fromShaders(Shader vert, Shader frag)
    {
        program = glCreateProgram();
        
        vertexShader = vert;
        fragmentShader = frag;
        
        glAttachShader(program, vertexShader.shader);
        glAttachShader(program, fragmentShader.shader);
        
        // ??? figure out what to do with this 
        glBindFragDataLocation(program, 0, "outColor");

        //SetPosAttrib();
    }

    public void setShaders(Shader vert, Shader frag)
    {
        vertexShader = vert;
        fragmentShader = frag;
        
        glAttachShader(program, vertexShader.shader);
        glAttachShader(program, fragmentShader.shader);

        glBindFragDataLocation(program, 0, "outColor");
    }
    // des 
    ~ShaderProgram()
    {
        //stdout.printf("ShaderProgram %p deleted.\n", (void*)program);
        glDeleteProgram(program);
    }

    // funcs
    public GLint AddAttrib(string name) //"position")
    {
        GLint newattr = glGetAttribLocation(program, name); //"position");
        
        return newattr;
    }

    public void linkAndUse()
    {
        glLinkProgram(program);
        glUseProgram(program);
        
        //SetPosAttrib();
        //AddAttrib("position");
    }

    public void link()
    {
        glLinkProgram(program);
    }

    public void use()
    {
        glUseProgram(program);

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

    public void SetUniform4f(string name, Vector4 v)  
    {
        glUniform4f(glGetUniformLocation(program, name), 
            (GLfloat)v.x, 
            (GLfloat)v.y,
            (GLfloat)v.z,
            (GLfloat)v.a);

    }

    public void SetUniform3f(string name, Vector3 v)  
    {
        glUniform3f(glGetUniformLocation(program, name), 
            (GLfloat)v.x, 
            (GLfloat)v.y, 
            (GLfloat)v.z);

    }

    public void SetUniform2f(string name, Vector2 v)  
    {
        glUniform2f(glGetUniformLocation(program, name), 
            (GLfloat)v.x, 
            (GLfloat)v.y);

    }
    
    public void SetUniform1f(string name, Vector1 v)  
    {
        glUniform1f(glGetUniformLocation(program, name), 
            (GLfloat)v);
        
    }
}