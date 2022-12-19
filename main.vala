//using GLFW; // <- make sure you have this bad boy!
using GL;

static int main(string[] args)
{
    // Init GLFW
    if(!GLFW.glinit())
    {
        stderr.printf("GLFW init failed!\n");
    };

    GLFW.set_hint_bool(GLFW.WindowHint.RESIZABLE, false);
    GLFW.set_hint(GLFW.WindowHint.SAMPLES, 0);
    
    var myNewWindow = new GLFW.Window(1280, 720, "Hello World", null, null);
    
    myNewWindow.set_size(640, 400);
    myNewWindow.make_context_current();

    while(!myNewWindow.should_close)
    {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        myNewWindow.swap_buffers();

        GLFW.poll_events();
    }
    
    GLFW.glterminate();
    
    return 0;
}
