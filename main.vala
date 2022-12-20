//using GLFW; // <- make sure you have this bad boy!
using GL;

static int main(string[] args)
{
    GLuint p = 0;
    // Init GLFW
    if(!GLFW.glinit())
    {
        stderr.printf("GLFW init failed!\n");
        return -1;
    }

    // WINDOW SETUP
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

    // VERTEX SETUP
    VertexAttributeArray vao = new VertexAttributeArray(); // create vertex attribute array 
    vao.bind();                             // <- from now on, glVertexAttribPointer points to vao
        /* When you want to switch vertex layouts, use a new VAO! */
    VertexBuffer vbuffer = new VertexBuffer();      // create vertex buffer & bind it to &vao
    vbuffer.bind();                                 // < future calls to bufferData go here!
    
    // and buffer the triangle
    const GLfloat vertices[] = {
        0.0f,  0.5f, // v1, x y 
        0.5f, -0.5f, // v2, x y 
        -0.5f,-0.5f  // v3, x y 
    };
    glBufferData(GL_ARRAY_BUFFER, 
                (GLsizeiptr)sizeof(GLfloat) * vertices.length, 
                (GLvoid[])vertices, 
                GL_STATIC_DRAW);
    
                // SHADER SETUP
    // Load shader data from file
    Shader vs2 = new Shader("simple.vs", GL_VERTEX_SHADER);
    Shader fs2 = new Shader("simple.fs", GL_FRAGMENT_SHADER);
    ShaderProgram sp = new ShaderProgram.fromShaders(vs2, fs2); // bind, link and attach the shaders
    sp.linkAndUse();        // "position" attrib ptr initialized on "use". cant be done before use()
    sp.SetVertexShape(2, GL_FLOAT); // configure the shader to use n(x,y)f format, uses current VAO
    sp.SetUniform("triangleColor", GL_FLOAT_VEC3, new Vector.3f(1.0f, 0.0f, 0.0f)); // set color 
    
    Vector bgColor = new Vector.3f(0.2f, 0.2f, 0.2f);
    // Main Loop 
    while(!myNewWindow.should_close)
    {
        GLFW.poll_events(); // while not exit...

        glClearColor(bgColor.x, bgColor.y, bgColor.z, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        glDrawArrays(GL_TRIANGLES, 0, 3); // triangle, from vertex 0 to 3
        
        myNewWindow.swap_buffers();
    }
    // Cleanup: objects clean up themselves!
    
    GLFW.glterminate();

    return 0;
}
