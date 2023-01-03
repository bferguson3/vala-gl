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
        //glEnableVertexAttribArray(newattr);
        //attributes.resize(attributes.length + 1);
        //attributes[attributes.length - 1] = newattr;
        //return attributes[attributes.length - 1];
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

        //SetPosAttrib();
        //AddAttrib("position");
    }
    
    public void SetVertexShape(GLint attr,
        uint8 pointSize, 
        GLenum type, 
        uint8 sizeOfAttributes, 
        uint8 offset)
    {
        if(type == GL_FLOAT)
        {
            var ofs = (void*)(offset * sizeof(GLfloat));
            glVertexAttribPointer(attr, 
                pointSize, 
                GL_FLOAT, 
                (GLboolean)GL_FALSE, 
                (GLsizei)(sizeOfAttributes * sizeof(GLfloat)), 
                ofs);
        
            glEnableVertexAttribArray(attr);
        
        }
        else { 
            stderr.printf("Error! GL_FLOAT only supported.\n");
        }
    }

    public void SetUniform(string name, Vector v)
    {
        switch(v.vecType)
        {
            case GL_FLOAT:
                //var val = v.x;
                glUniform1f(glGetUniformLocation(program, name), 
                    v.x);
                break;
            case GL_FLOAT_VEC2:
                glUniform2f(glGetUniformLocation(program, name), 
                    (GLfloat)v.x, 
                    (GLfloat)v.y);
                break;
            case GL_FLOAT_VEC3:
                glUniform3f(glGetUniformLocation(program, name), 
                    (GLfloat)v.x, 
                    (GLfloat)v.y, 
                    (GLfloat)v.z);
                break;
            case GL_FLOAT_VEC4:
                glUniform4f(glGetUniformLocation(program, name), 
                    (GLfloat)v.x, 
                    (GLfloat)v.y,
                    (GLfloat)v.z,
                    (GLfloat)v.a);
                break;
            default:
                stderr.printf("Error! Uniform type not supported.\n");
                break;
        }
    }
}