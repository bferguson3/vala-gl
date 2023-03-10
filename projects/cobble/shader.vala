using GL;

public class Shader : GLib.Object
{
    // fields 
    public GLuint shader { get; private set; }

    // constructor
    public Shader(string path, GLuint shaderType)
    {
        shader = LoadShader(path, shaderType);
        // Get errors if any:
        GLint status = 0;
        glGetShaderiv(shader, GL_COMPILE_STATUS, (GLint[])&status);
        
        if(status == GL_TRUE)
            stdout.printf("Shader %d compiled successfully.\n", (int)shader);
        else 
            PrintShaderError(shader);
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
        
        return vshader;
    }


    
    private string LoadShaderText(string path)
    {
        var vs = File.new_for_path(path);
        
        char _tmp[1] = { 0 };
        //Bytes data = new Bytes((uint8[])_tmp); // windows fix 
        uint8[] data;
        try 
        { 
            //data = vs.load_bytes(); // windows fix 
            vs.load_contents(null, out data, null);
        } catch(Error e) 
        { 
            stderr.printf("%s\n", e.message); 
        }
        
        //string vss = (string)data.get_data(); // windows fix 
        return (string)data;
    }



    private void PrintShaderError(GLuint shader)
    {
        stdout.printf("Shader compilation failed!.\n");
        GLubyte errorbuff[512];
        glGetShaderInfoLog(shader, 512, (GLsizei[])null, errorbuff);
        stdout.printf((string)errorbuff);
    }

}

    