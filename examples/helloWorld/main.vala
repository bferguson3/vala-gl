// helloWorld

using GL;

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
    // MacOS bullshit:
    GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MAJOR, 4);
    GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MINOR, 1);
    GLFW.set_hint(GLFW.WindowHint.OPENGL_FORWARD_COMPAT, GL_TRUE);
    GLFW.set_hint(GLFW.WindowHint.OPENGL_PROFILE, GLFW.OpenGLProfile.CORE);
    // Normal window setup:
    GLFW.set_hint_bool(GLFW.WindowHint.RESIZABLE, false); // no resize 
    GLFW.set_hint(GLFW.WindowHint.SAMPLES, 2);            // no AA

    var myNewWindow = new GLFW.Window(640, 400, "Hello World", null, null);
    myNewWindow.make_context_current();

    // Main Loop 
    while(!myNewWindow.should_close)
    {
        GLFW.poll_events(); // This is necessary to render the window.

        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        myNewWindow.swap_buffers();
    }
    
    GLFW.glterminate();

    return 0;
}
