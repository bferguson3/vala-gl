// COBBLE 
// a retro game engine written in vala 

//using GLFW; // <- make sure you have this bad boy!
using GL;
using Cobble;

static int main(string[] args)
{
    GLuint GL_COBBLE_START = cobble_start();
    if(GL_COBBLE_START == -1) return 0xff;
    
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
    //sp.link();
    sp.linkAndUse();

    VertexBuffer vbuffer = new VertexBuffer();      // create vertex buffer & bind it to &vao
    ElementBuffer ebuff  = new ElementBuffer();

    Sprite square = new Sprite(320, 100);
    
    vbuffer.bind();                                 // < future calls to bufferData go here!    
    ebuff.bind();

    var posAttr = sp.AddAttrib("position");
    var colAttr = sp.AddAttrib("color");
    var texAttr = sp.AddAttrib("texcoord");
    sp.SetVertexShape(posAttr, 2, GL_FLOAT, VERTEX_LENGTH, 0); // configure the shader to use n(a,b).f format, 
    sp.SetVertexShape(colAttr, 3, GL_FLOAT, VERTEX_LENGTH, 2); // and n(c,d,e).f
    sp.SetVertexShape(texAttr, 2, GL_FLOAT, VERTEX_LENGTH, 5); // + n(f,g).f

    bgColor = new Vector3(0.2f, 0.2f, 0.2f);
    glClearColor(bgColor.x, bgColor.y, bgColor.z, 1.0f);
    
    // load in the image and then free it, after buffering
    Image img = new Image("test.png");
    Texture tex = new Texture(img);
    tex.buffer();
    img = null; 
    
    square.setPos(new XYPos(0, 0));
    
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
        sp.SetUniform1f("alpha", (Vector1)fade); // fade color 
        
        // Scene draw:
        // clear screen
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // test move by 1 virtual pixel at a time (vpx)
        XYPos newpos = new XYPos(square.x + 1, square.y + 1);
        //square.setXPos(sx); square.setYPos(sy); 
        square.setPos(newpos);
        square.draw(); // rename this back to buffer?
        
        // draw objects
        cobble_draw();
        
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
    GLFW.set_hint_bool(GLFW.WindowHint.RESIZABLE, true);  // resize 
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
