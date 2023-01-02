// cobble.vala

using GL;

namespace Cobble
{
    const uint8 VERTEX_LENGTH = 7;
    const int RES_IMG_FORMAT = GL.GL_RGBA8;

    const int SCREEN_WIDTH  = 640;
    const int SCREEN_HEIGHT = 200;
    const float PIXEL_WIDTH  = (1.0f / (SCREEN_WIDTH /2));    // 0.00625f; // In one coordinate plane (1/160)f
    const float PIXEL_HEIGHT = (1.0f / (SCREEN_HEIGHT/2));   //0.010f;   // (1/100)f

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
}

