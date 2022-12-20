//using GLFW; // <- make sure you have this bad boy!
using GL;

static int main(string[] args)
{
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

    var myNewWindow = new GLFW.Window(1280, 720, "Hello World", null, null);
    
    myNewWindow.set_size(640, 400);
    myNewWindow.make_context_current();

    // create vertex attribute array 
    GLuint vao = 0; 
    glGenVertexArrays((GLsizei)1, (GLuint[])&vao);
    glBindVertexArray(vao); // <- from now on, glVertexAttribPointer points to vao
    
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
    
    // Load shader data from file
    Shader vs2 = new Shader("simple.vs", GL_VERTEX_SHADER);
    Shader fs2 = new Shader("simple.fs", GL_FRAGMENT_SHADER);
    
    // bind, link and attach the shaders
    GLuint shaderprog = glCreateProgram();
    glAttachShader(shaderprog, vs2.shader);
    glAttachShader(shaderprog, fs2.shader);
    glBindFragDataLocation(shaderprog, 0, "outColor");
    glLinkProgram(shaderprog);
    glUseProgram(shaderprog);
    
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
    
    // Shaders delete auto OK 
    
    //glDeleteBuffers(1, &ebo) element array buffer for later
    
    // delete the vertex buffer
    glDeleteBuffers(1, (GLuint[])&vbuffer);
    // delete this last because it holds the vertex attribute array. 
    glDeleteVertexArrays(1, (GLuint[])&vao);

    GLFW.glterminate();
    
    return 0;
}
