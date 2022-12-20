// helloTriangle

using GL;

static int main(string[] args)
{
    GLuint init_gl;
    // Init GLFW
    if(!GLFW.glinit())
    {
        stderr.printf("GLFW init failed!\n");
        return -1;
    }
    // MacOS bullshit:
    GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MAJOR, 4);
    GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MINOR, 1);
    GLFW.set_hint(GLFW.WindowHint.OPENGL_FORWARD_COMPAT, GL_TRUE);
    GLFW.set_hint(GLFW.WindowHint.OPENGL_PROFILE, GLFW.OpenGLProfile.CORE);
    // Normal window setup:
    GLFW.set_hint_bool(GLFW.WindowHint.RESIZABLE, false); // no resize 
    GLFW.set_hint(GLFW.WindowHint.SAMPLES, 2);            // no AA

    var myNewWindow = new GLFW.Window(640, 400, "Hello Triangle", null, null);
    myNewWindow.make_context_current();

    // create vertex attribute array 
    GLuint vao = 0; 
    glGenVertexArrays((GLsizei)1, (GLuint[])&vao);
    glBindVertexArray(vao); // <- from now on, glVertexAttribPointer points to vao
    
    // Load shader data from file
    GLuint vshader = LoadShader("./simple.vs", GL_VERTEX_SHADER);
    GLuint fshader = LoadShader("./simple.fs", GL_FRAGMENT_SHADER);
    
    // bind, link and attach the shaders
    GLuint shaderprog = glCreateProgram();
    glAttachShader(shaderprog, vshader);
    glAttachShader(shaderprog, fshader);
    glBindFragDataLocation(shaderprog, 0, "outColor");
    glLinkProgram(shaderprog);
    glUseProgram(shaderprog);
    

    const GLfloat vertices[] = {
        0.0f,  0.5f, // v1, x y 
        0.5f, -0.5f, // v2, x y 
        -0.5f,-0.5f  // v3, x y 
    };
    // create vertex buffer 
    GLuint vbuffer = 0;
    glGenBuffers(1, (GLuint[])&vbuffer);
    // and bind the triangle
    glBindBuffer(GL_ARRAY_BUFFER, vbuffer);
    glBufferData(GL_ARRAY_BUFFER, 
                (GLsizeiptr)sizeof(GLfloat) * vertices.length, 
                (GLvoid[])vertices, 
                GL_STATIC_DRAW);
    
    // configure the shader to use n(x,y)f format 
    GLint posAttrib = glGetAttribLocation(shaderprog, "position");
    glEnableVertexAttribArray(posAttrib);
    glVertexAttribPointer(posAttrib, 
                        2, 
                        GL_FLOAT, 
                        (GLboolean)GL_FALSE, 
                        (GLsizei)(2 * sizeof(GLfloat)), 
                        null);
    
                        
    // Main Loop 
    while(!myNewWindow.should_close)
    {
        GLFW.poll_events(); // while not exit...

        glClearColor(0.2f, 0.2f, 0.2f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        glDrawArrays(GL_TRIANGLES, 0, 3); // triangle, from vertex 0 to 3
        
        myNewWindow.swap_buffers();
    }
    // Cleanup:
    glDeleteProgram(shaderprog);
    glDeleteShader(fshader);
    glDeleteShader(vshader);
    
    glDeleteBuffers(1, (GLuint[])&vbuffer);
    glDeleteVertexArrays(1, (GLuint[])&vao);

    GLFW.glterminate();
    return 0;
}

static GLuint LoadShader(string path, GLuint shaderType)
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

static string LoadShaderText(string path)
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

static void PrintShaderError(GLuint shader)
{
    stdout.printf("Shader compilation failed!.\n");
    GLubyte errorbuff[512];
    glGetShaderInfoLog(shader, 512, null, errorbuff);
    stdout.printf((string)errorbuff);
}