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

    public GLint AddUniform(string name)
    {
        GLint newuni = glGetUniformLocation(program, name);
        return newuni;
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
    
    public void SetUniformMatrix(GLint u, Matrix mat)
    {
        if (mat.type == '4')
        {
            var n = (Mat4)mat;
            glUniformMatrix4fv(u, 
                1, // count 
                0, // transpose - must be 0 or false 
                (GLfloat[])n.data); // data 
        }
        else { 
            stderr.printf("COBBLE ERROR: Uniform matrices other than 4fv not supported yet\n");
        }
        
    }

    public void SetUniform(GLint uniform, Vector v)
    {
        if(v.type == '1')
        {
            var v1 = (Vec1)v;
            glUniform1f(uniform, v1.x);
        }
        else { 
            stderr.printf("COBBLE ERROR: You didn't code uniforms other than 1vf, dolt.\n");
        }
    }

    public void SetUniform4f(string name, Vec4 v)  
    {
        glUniform4f(glGetUniformLocation(program, name), 
            (GLfloat)v.x, 
            (GLfloat)v.y,
            (GLfloat)v.z,
            (GLfloat)v.a);

    }

    public void SetUniform3f(string name, Vec3 v)  
    {
        glUniform3f(glGetUniformLocation(program, name), 
            (GLfloat)v.x, 
            (GLfloat)v.y, 
            (GLfloat)v.z);

    }

    public void SetUniform2f(string name, Vec2 v)  
    {
        glUniform2f(glGetUniformLocation(program, name), 
            (GLfloat)v.x, 
            (GLfloat)v.y);

    }
    
    public void SetUniform1f(string name, Vec1 v)  
    {
        glUniform1f(glGetUniformLocation(program, name), 
            (GLfloat)v.x);
        
    }
}