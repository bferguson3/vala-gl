// shaderprogram.vala 

using GL;

public class ShaderProgram : GLib.Object
{
    // vals 
    public GLuint program { get; private set; }
    public GLint posAttrib { get; private set; }
    private weak Shader vertexShader;
    private weak Shader fragmentShader;

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
        stdout.printf("ShaderProgram %p deleted.\n", (void*)program);
        glDeleteProgram(program);
    }

    // funcs
    private void SetPosAttrib()
    {
        posAttrib = glGetAttribLocation(program, "position");
        glEnableVertexAttribArray(posAttrib);
    }

    public void linkAndUse()
    {
        glLinkProgram(program);
        glUseProgram(program);
        
        SetPosAttrib();
    }

    public void link()
    {
        glLinkProgram(program);
    }

    public void use()
    {
        glUseProgram(program);

        SetPosAttrib();
    }
    
    public void SetVertexShape(int ct, GLenum type)
    {
        if(type == GL_FLOAT)
        {
            glVertexAttribPointer(posAttrib, 
                ct, 
                GL_FLOAT, 
                (GLboolean)GL_FALSE, 
                (GLsizei)(ct * sizeof(GLfloat)), 
                null);
        }
        else { 
            stdout.printf("Error! GL_FLOAT only supported.\n");
        }
    }
}