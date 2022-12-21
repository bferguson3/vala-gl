// helloColor and OOP

using GL;

private static double deltaTime;
private static Vector bgColor;

static int main(string[] args)
{
    GLuint p = 0;   // fix for vala include order 
    // Init GLFW
    if(!GLFW.glinit())
    {
        stderr.printf("GLFW init failed!\n");
        return -1;
    }

    // WINDOW SETUP
    var myNewWindow = SetupWindow();
    
    // VERTEX SETUP
    VertexAttributeArray vao = new VertexAttributeArray(); // create vertex attribute array 
    vao.bind();                             // <- from now on, glVertexAttribPointer points to vao
    /* When you want to switch vertex layouts, use a new VAO! */
    VertexBuffer vbuffer = new VertexBuffer();      // create vertex buffer & bind it to &vao
    vbuffer.bind();                                 // < future calls to bufferData go here!
    
    // SHADER SETUP
    // Load shader data from file
    Shader vs2 = new Shader("simple.vs", GL_VERTEX_SHADER);
    Shader fs2 = new Shader("simple.fs", GL_FRAGMENT_SHADER);
    ShaderProgram sp = new ShaderProgram.fromShaders(vs2, fs2); // bind, link and attach the shaders
    sp.linkAndUse();        
    
    var posAttr = sp.AddAttrib("position");
    var colAttr = sp.AddAttrib("color");
    sp.SetVertexShape(posAttr, 2, GL_FLOAT, 5, 0); // configure the shader to use n(a,b).f format, 
    sp.SetVertexShape(colAttr, 3, GL_FLOAT, 5, 2); // and n(c,d,e).f
    
    // define a triangle set of vertices and buffer it 
    Test_BufferTri();
    
    Vector bgColor = new Vector.3f(0.2f, 0.2f, 0.2f);
    glClearColor(bgColor.x, bgColor.y, bgColor.z, 1.0f);

    double runTime = 0;
    // Main Loop 
    while(!myNewWindow.should_close)
    {
        double frame_start = GLFW.get_time();
        ////
        
        GLFW.poll_events(); // while not exit...

        // Scene update: 
        // animate triangle
        float fade = (float)
            (Math.sin(runTime) + 1.25f)
            / 2.0f;
        sp.SetUniform("alpha", new Vector.1f(fade)); // fade color 
        
        // Scene draw:
        // clear screen
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        // draw objects
        glDrawArrays(GL_TRIANGLES, 0, 3); // triangle, from vertex 0 to 3
        // flip()
        myNewWindow.swap_buffers();


        ////
        double frame_end = GLFW.get_time();
        deltaTime = frame_end - frame_start;
        runTime += deltaTime;
    }
    // Cleanup: objects clean up themselves!
    
    GLFW.glterminate();

    return 0;
}

GLFW.Window SetupWindow()
{
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
    return myNewWindow;
}

void Test_BufferTri()
{
    // and buffer the triangle
    const GLfloat vertices[] = {
        0.0f,  0.5f, 1.0f, 0.0f, 0.0f, // v1, x y r g b
        0.5f, -0.5f, 0.0f, 0.0f, 1.0f, // v2, x y r g b
        -0.5f,-0.5f, 0.0f, 1.0f, 0.0f  // v3, x y r g b
    };
     
    glBufferData(GL_ARRAY_BUFFER, 
                (GLsizeiptr)sizeof(GLfloat) * vertices.length, 
                (GLvoid[])vertices, 
                GL_STATIC_DRAW);
}
