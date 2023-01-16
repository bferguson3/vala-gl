// cobble.vala

using GL;

namespace Cobble
{
    const uint8 SPRITE_VERTEX_LENGTH = 7;
    const int RES_IMG_FORMAT = GL.GL_RGBA8;

    int SCREEN_WIDTH  = 640;
    int SCREEN_HEIGHT = 200;
    float PIXEL_WIDTH  = 1.0f; // 0.00625f; // In one coordinate plane (1/160)f
    float PIXEL_HEIGHT = 1.0f;  //0.010f;   // (1/100)f

    const uint8 VERT_X_INDEX = 0;
    const uint8 VERT_Y_INDEX = 1;

    static int g_SpritesDrawn = 0;

    static uint frameCtr  = 0;
    static double deltaTime;
    static Vec3 bgColor;
    static double runTime;
    static double secondCtr = 0;

    weak Sprite cobble_sprites[64];
    VertexBuffer vbuffer;
    VertexAttributeArray vao;
    GLFW.Window cobbleWindow;
    double frame_start;

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


    public static void set_resolution(int w, int h)
    {
        SCREEN_WIDTH = w;
        SCREEN_HEIGHT = h;
        PIXEL_WIDTH  = (1.0f / (SCREEN_WIDTH /2));   
        PIXEL_HEIGHT = (1.0f / (SCREEN_HEIGHT/2)); 
    }

    static GLFW.Window setup_window()
    {
        // MacOS bullshit:
        GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MAJOR, 4);
        GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MINOR, 1);
        GLFW.set_hint(GLFW.WindowHint.OPENGL_FORWARD_COMPAT, GL_TRUE);
        GLFW.set_hint(GLFW.WindowHint.OPENGL_PROFILE, GLFW.OpenGLProfile.CORE);
        // Normal window setup:
        GLFW.set_hint_bool(GLFW.WindowHint.RESIZABLE, true);  // resize 
        GLFW.set_hint(GLFW.WindowHint.SAMPLES, 2);            // no AA

	var myMonitor = GLFW.get_primary_monitor();
        var myNewWindow = new GLFW.Window(320, 240, "Hello World", null, null);
        myNewWindow.set_size(320, 240);
        myNewWindow.make_context_current();
	//myNewWindow.set_window_monitor(myMonitor, 0, 0, 320, 240, 60);

        
        //set_resolution(640, 200);
        
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

    void unbind_all()
    {
        glEnableVertexAttribArray(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);
        glUseProgram(0);
    }

    public static int add_sprite(Sprite s)
    {
        // add to public draw array 
        for(int i = 0; i < cobble_sprites.length; i++)
        {
            if(cobble_sprites[i] == null)
            {
                cobble_sprites[i] = s;
                cobble_sprites[i].setIndex(i);
                //cobble_sprites[i].setBuffers(vbuffer, null);
                cobble_sprites[i].vertexBuffer = vbuffer;
                stdout.printf("%p\n", cobble_sprites[i].vertexBuffer);
                cobble_sprites[i].bufferVertices();
                
                return i;
            }
        }
        return -1;
        //sceneSprites
    }

    public static void add_sprite_at_index(Sprite s, int index)
    {
        cobble_sprites[index] = s;
        cobble_sprites[index].setIndex(index);
        cobble_sprites[index].vertexBuffer = vbuffer;
        cobble_sprites[index].bufferVertices();
        
    }

    public static void cobble_draw()
    {
        // clear screen
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        // draw objects    
        
        // sprite vao 
        double spritestart = GLFW.get_time();
            vao.bind(); 
            vbuffer.bind();
            for(int i = 0; i < 64; i++)
            {
                if(cobble_sprites[i] != null)
                    cobble_sprites[i].draw(); // rebuffer vertices and texture 
                    glDrawArrays(GL_TRIANGLE_STRIP, 4 * i, 4);
            }
        double spriteend = GLFW.get_time();
        //stdout.printf("sprite time %f\n", spriteend-spritestart);
        
        unbind_all();

        cobbleWindow.swap_buffers(); // flip()
        ////
        double frame_end = GLFW.get_time();
        deltaTime = frame_end - frame_start;
        runTime += deltaTime;
    }

    public struct SpriteVertex { 
        public float x; 
        public float y; 
        // 
        public float r;
        public float g;
        public float b;
        // 
        public float u;
        public float v;
    }


    float fisqrt(float number)
    {
        // From Quake III 
        long i;
        float x2, y;
        const float threehalfs = 1.5f;

        x2 = number * 0.5f;
        y  = number;
        i  = *(long*)&y;                            // evil floating point bit level hacking
        i  = 0x5f3759df - (i >> 1 );                // what the fuck? 
        y  = *(float*)&i;
        y  = y * ( threehalfs - (x2 * y * y) );     

        return y;
    }

    public static float rads(float degs)
    {
        return (float)(degs * (float)Math.PI)/180.0f ;
    }

    // PERFECT. Matches glm:: 
    public Mat4 perspective(float rads, float aspectRatio, float nearClip, float farClip)
    {
        float ht = (float)Math.tan(rads/2);
        float f1, f2;
        f1 = nearClip + nearClip;
        f2 = farClip - nearClip;

        var _m = new Mat4();
        
        _m.data[0] = 1 / (ht * aspectRatio); 
        _m.data[5] = 1 / ht; 
        _m.data[10] = -(farClip + nearClip) / f2;
        _m.data[11] = -1.0f;
        _m.data[14] = (-f1 * farClip) / f2;

        return _m;
    }



    public Mat4 lookAt(float eyex, float eyey, float eyez, 
        float centerx, float centery, float centerz, 
        float upx, float upy, float upz)
    {
        var up = new Vec3(upx, upy, upz);
        var eye = new Vec3(eyex, eyey, eyez);
        
        var _f = new Vec3(centerx - eyex, centery - eyey, centerz - eyez);
        _f.normalize();
        
        var _s = new Vec3.from_cross_product(_f, up);
        _s.normalize();
        
        up = new Vec3.from_cross_product(_s, _f);
        
        Mat4 view = new Mat4.Identity(1.0f);
        view.setDataRow(0, new Vec4(_s.x, up.x, -_f.x, 0.0f));
        view.setDataRow(1, new Vec4(_s.y, up.y, -_f.y, 0.0f));
        view.setDataRow(2, new Vec4(_s.z, up.z, -_f.z, 0.0f));
        view.setDataRow(3, new Vec4(-_s.dot(eye), -up.dot(eye), _f.dot(eye), 1.0f));
        
        return view;
    }


}

