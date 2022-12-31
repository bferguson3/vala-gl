// COBBLE 
// a retro game engine written in vala 

//using GLFW; // <- make sure you have this bad boy!
using GL;

private static double deltaTime;
private static Vector bgColor;
private double runTime;
private double secondCtr = 0;
private GLuint frameCtr  = 0;

static int main(string[] args)
{

    FreeImage.Initialise(0);
    
    //GLuint p = 0;   // fix for vala include order 
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
                // SHADER SETUP
    // Load shader data from file
    Shader vs2 = new Shader("simple.vs", GL_VERTEX_SHADER);
    Shader fs2 = new Shader("simple.fs", GL_FRAGMENT_SHADER);
    ShaderProgram sp = new ShaderProgram.fromShaders(vs2, fs2); // bind, link and attach the shaders
    sp.link();
    
    // define a triangle set of vertices and buffer it 
    // and buffer the triangle
    // vertex and element data: 
    GLfloat vertices[] = {
        -0.5f,  0.5f, 
         1.0f, 0.0f, 0.0f,  // Top-left
         0.5f,  0.5f, 
         0.0f, 1.0f, 0.0f,  // Top-right
        -0.5f, -0.5f, 
        1.0f, 1.0f, 1.0f,   // Bottom-left
        0.5f, -0.5f, 
        0.0f, 0.0f, 1.0f    // Bottom-right
    };
    GLuint elements[] = {
        0, 1, 2,
        2, 3, 1
    };    
    //Image timg = new Image("test.png");
    //timg.print();
    Texture tex = new Texture(new Image("test.png"));
    

    VertexBuffer vbuffer = new VertexBuffer();      // create vertex buffer & bind it to &vao
    ElementBuffer ebuff  = new ElementBuffer();

    Drawable square = new Drawable();
    square.setVertices(vertices);
    square.setElements(elements);

    vbuffer.bind();                                 // < future calls to bufferData go here!    
    square.bufferVertices();

    ebuff.bind();
    square.bufferElements();

    sp.use();        
    
    var posAttr = sp.AddAttrib("position");
    var colAttr = sp.AddAttrib("color");
    sp.SetVertexShape(posAttr, 2, GL_FLOAT, 5, 0); // configure the shader to use n(a,b).f format, 
    sp.SetVertexShape(colAttr, 3, GL_FLOAT, 5, 2); // and n(c,d,e).f
    
    bgColor = new Vector.3f(0.2f, 0.2f, 0.2f);
    glClearColor(bgColor.x, bgColor.y, bgColor.z, 1.0f);

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
        //glDrawArrays(GL_TRIANGLES, 0, 6); // triangle, from vertex 0 to 3
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, (GLvoid[]?)0);
        // flip()
        myNewWindow.swap_buffers();


        ////
        double frame_end = GLFW.get_time();
        deltaTime = frame_end - frame_start;
        runTime += deltaTime;
        // Print FPS
        fps();
    }
    // Cleanup: objects clean up themselves!
    
    GLFW.glterminate();
    FreeImage.DeInitialise();

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

void fps()
{
    secondCtr += deltaTime;
    frameCtr++; 
    if(secondCtr > 1.0f){
        stdout.printf("%u/", (uint)frameCtr);
        stdout.flush();
        frameCtr = 0;
        secondCtr -= 1.0f;
    }
}