using GL;

public class Shader : GLib.Object
{
    // fields 
    public GLuint shader { get; private set; }

    // constructor
    public Shader(string path, GLuint shaderType)
    {
        shader = LoadShader(path, shaderType);
    }


    // destrcutor 
    ~Shader()
    {
        //stdout.printf("Shader %p deleted.\n", (void*)shader);
        glDeleteShader(shader);
    }


    // methods
    private GLuint LoadShader(string path, GLuint shaderType)
    { 
        var vs_data = LoadShaderText(path);

        GLuint vshader = glCreateShader(shaderType);
        GLint len = vs_data.length;
        
        glShaderSource(vshader, 1, (string[])&vs_data, (GLint[])&len);
        glCompileShader(vshader);   // and compile it 
        
        // Get errors if any:
        GLint status = 0;
        glGetShaderiv(vshader, GL_COMPILE_STATUS, (GLint[])&status);
        
        if(status == GL_TRUE)
        {
            stdout.printf("Shader %p compiled successfully.\n", (void*)vshader);
            return vshader;
        }
        else 
        {
            PrintShaderError(vshader);
            return GL_FALSE;
        }
    }


    
    private string LoadShaderText(string path)
    {
        var vs = File.new_for_path(path);
        
        char _tmp[1] = { 0 };
        Bytes data = new Bytes((uint8[])_tmp);
        
        try 
        { 
            data = vs.load_bytes(); 
        } catch(Error e) 
        { 
            stderr.printf("%s\n", e.message); 
        }
        
        string vss = (string)data.get_data();
        return vss;
    }



    private void PrintShaderError(GLuint shader)
    {
        stdout.printf("Shader compilation failed!.\n");
        GLubyte errorbuff[512];
        glGetShaderInfoLog(shader, 512, (GLsizei[])null, errorbuff);
        stdout.printf((string)errorbuff);
    }

}

    