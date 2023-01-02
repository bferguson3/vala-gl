// cobble.vala

using GL;

namespace Cobble
{
    const uint8 VERTEX_LENGTH = 7;
    const int RES_IMG_FORMAT = GL.GL_RGBA8;

    int SCREEN_WIDTH  = 640;
    int SCREEN_HEIGHT = 200;
    float PIXEL_WIDTH  = 1.0f; // 0.00625f; // In one coordinate plane (1/160)f
    float PIXEL_HEIGHT = 1.0f;  //0.010f;   // (1/100)f

    const uint8 VERT_X_INDEX = 0;
    const uint8 VERT_Y_INDEX = 1;

    static int g_drawableElementsCounter = 0;
    static int g_drawableElementsNo = 0;
    static int g_drawableVerticesCounter = 0;
    static int g_drawableVerticesNo = 0;

    static uint frameCtr  = 0;
    static double deltaTime;
    static Vector3 bgColor;
    static double runTime;
    static double secondCtr = 0;

    public static GLuint cobble_start()
    {
        FreeImage.Initialise(0);
    
        // Init GLFW    
        if(!GLFW.glinit())
        {
            stderr.printf("GLFW init failed!\n");
            return -1;
        }
        return 0;
    }


    public static void cobble_draw()
    {
        if(g_drawableElementsCounter > 0)
        {
            glDrawElements(GL_TRIANGLES, 
                g_drawableElementsNo, 
                GL_UNSIGNED_INT, 
                (GLvoid[]?)0);
        }
        else 
        {
            stderr.printf("COBBLE DRAW ERROR: Nothing in element buffer!!\n");
        }
    }

    public static void set_resolution(int w, int h)
    {
        SCREEN_WIDTH = w;
        SCREEN_HEIGHT = h;
        PIXEL_WIDTH  = (1.0f / (SCREEN_WIDTH /2));   
        PIXEL_HEIGHT = (1.0f / (SCREEN_HEIGHT/2)); 
    }

    static GLFW.Window SetupWindow()
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
        //myNewWindow.set_size(640, 400);
        myNewWindow.make_context_current();
        
        set_resolution(640, 200);
        
        return myNewWindow;
    }

}

