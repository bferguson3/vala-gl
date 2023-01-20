// COBBLE 
// a retro game engine written in vala 

//using GLFW; // <- make sure you have this bad boy!
using GL;
using Cobble;

Mat4 proj;
ShaderProgram screenShader;

static int main(string[] args)
{
    GLuint a;
    /************
    * Cobble
    ************/
    cobble_start();
    
    cobbleWindow = setup_window();
    bgColor = new Vec3(0.2f, 0.2f, 0.2f);
    glClearColor(bgColor.x, bgColor.y, bgColor.z, 1.0f);
    
    
    /************
    * SHADER SETUP
    ************/
    // Load shader data from file
    Shader vs2 = new Shader("simple.vs", GL_VERTEX_SHADER);
    Shader fs2 = new Shader("simple.fs", GL_FRAGMENT_SHADER);
    ShaderProgram sp = new ShaderProgram.fromShaders(vs2, fs2); // bind, link and attach the shaders
    sp.linkAndUse();
    

    /************
    * VERTEX SETUP
    ************/
    vao  = new VertexAttributeArray(); // create vertex attribute array 
    vbuffer = new VertexBuffer.forSpriteCount(64);     
    vao.bind();    
    vbuffer.bind();
    var posAttr = sp.AddAttrib("position");
    var colAttr = sp.AddAttrib("color");
    var texAttr = sp.AddAttrib("texcoord");
    vao.SetVertexShape(posAttr, 2, GL_FLOAT, SPRITE_VERTEX_LENGTH, 0); // configure the shader to use n(a,b).f format, 
    vao.SetVertexShape(colAttr, 3, GL_FLOAT, SPRITE_VERTEX_LENGTH, 2); // and n(c,d,e).f
    vao.SetVertexShape(texAttr, 2, GL_FLOAT, SPRITE_VERTEX_LENGTH, 5); // + n(f,g).f
    
    
    Texture tex = new Texture(new Image("test3.png"));

    /************
    * COBBLE SPRITE SETUP  
    ************/
    
    // load in the image to a new texture 
    vao.bind();
    sp.use();
    vbuffer.bind();
    Texture tex2 = new Texture(new Image("test4.png"));
    tex2.bufferToSize(16, 16);
    Sprite square = new Sprite(tex2, 16, 24);
    add_sprite(square); // buffers vertices when added 
    //add_sprite_at_index(sq2, 2);
    unbind_all();

    sp.use(); // tie to uniform calls
    Mat4 model = new Mat4.Identity(1.0f); // create a new identity matrix: 1, 0, 0, 0 > 0, 1, 0, 0 ...
    model.scale(0.5f, 0.5f, 0.5f);
    
    /////////////////////////////
    /*** FRAME BUFFER SETUP  ***/
    /////////////////////////////
    // Make a totally new VAO and VB
    var fbo = new FrameBuffer();
    var screen_vao = new VertexAttributeArray();
    var screen_vbo = new VertexBuffer();
    make_framebuffer(fbo, screen_vao, screen_vbo);
    
    unbind_all();

    /* SETUP CAMERA AND PROJECTION */
    ////////////////////////////////
    sp.use();
    var view = lookAt(1.0f, 1.0f, 2.0f,  // 1 meter up, 1 meter back?
        0.0f, 0.0f, 0.0f, 
        0.0f, 1.0f, 0.0f);
    proj = perspective(rads(45.0f), SCREEN_WIDTH / SCREEN_HEIGHT , 0.1f, 100.0f);
    var alphaAttr = sp.AddUniform("alpha");
    var mvp = sp.AddUniform("mvp");

    // clean up for draw 
    unbind_all();
    
    //img = null; 
    float rot = -1.0f;
    
    // Main Loop 
    while(!cobbleWindow.should_close)
    {
        frame_start = GLFW.get_time();
        ////
        GLFW.poll_events(); // while not exit...
        
        // ENABLE FRAME BUFFER AND DRAW TO IT 
        // :
        fbo.bind();
        glEnable(GL_DEPTH_TEST);
            // clear screen
            cls();
            set_render_res(SCREEN_WIDTH, SCREEN_HEIGHT); // low res 
            // draw objects    
            float fade = (float)(Math.sin(runTime) + 1.25f)/ 2.0f;
            sp.use();
            sp.SetUniform(alphaAttr, new Vec1(fade));   // apply fade var
            var pmat = new Mat4.Copy(model);
            rot -= 0.1f;
            pmat.rotate(rot, new Vec3(0.0f, 0.0f, 1.0f)); // rotate model matrix around Z -6.0r/s
            pmat.mul(view); 
            pmat.mul(proj); 
            sp.SetUniformMatrix(mvp, pmat);
            
            // sprite vao 
            vao.bind(); 
            vbuffer.bind();
            for(int i = 0; i < 64; i++)
            {
                if(cobble_sprites[i] != null)
                    cobble_sprites[i].draw(); // rebuffer vertices and texture 
                    glDrawArrays(GL_TRIANGLE_STRIP, 4 * i, 4);
            }
        // buffer drawing complete. 
        
        // Now render the buffer as a quad on screen.
        draw_framebuffer(fbo, screen_vao);
        //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        
        unbind_all();

        cobbleWindow.swap_buffers(); // flip()
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

void cls()
{
    glClearColor(bgColor.x, bgColor.y, bgColor.z, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void set_render_res(int x, int y)
{
    glViewport(0, 0, x, y);
}

void draw_framebuffer(FrameBuffer _fbo, VertexAttributeArray _vao)
{
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    cls();
    glDisable(GL_DEPTH_TEST);         // just in case :)
    
    int x, y;
    cobbleWindow.get_framebuffer_size(out x, out y);
    
    set_render_res(x, y);
    
    screenShader.use();                     // enable fb shader 
    _vao.bind();                // enable fb vao 
    glBindTexture(GL_TEXTURE_2D, _fbo.tcb);	
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);   // render the texture 
    /// End FBO render
    
}

void make_framebuffer(FrameBuffer _fbo, VertexAttributeArray _vao, VertexBuffer _vbo)
{
    // link the simple shader
    Shader ss_v = new Shader("ss_v.vs", GL_VERTEX_SHADER);
    Shader ss_f = new Shader("ss_f.fs", GL_FRAGMENT_SHADER);
    screenShader = new ShaderProgram.fromShaders(ss_v, ss_f);
    screenShader.linkAndUse();
    // set up attributes
    _vbo.bind();
    var ss_posAttr = screenShader.AddAttrib("position");
    var ss_texAttr = screenShader.AddAttrib("texcoord");
    _vao.bind();
    _vao.SetVertexShape(ss_posAttr, 2, GL_FLOAT, 4, 0); // configure the shader to use n(a,b).f format, 
    _vao.SetVertexShape(ss_texAttr, 2, GL_FLOAT, 4, 2); // + n(f,g).f
    // Buffer the screen quad the one time we need it 
    _vbo.bind();
    float[] screen_quad_verts = {
        -1.0f, -1.0f,       // pos 
         0.0f, 0.0f,        // uv Top-left
        1.0f,-1.0f,       // pos 
         1.0f, 0.0f,        // uv Top-right
        -1.0f, 1.0f,    // pos
         0.0f, 1.0f,         // uv Bottom-left
        1.0f,  1.0f,    // pos 
         1.0f, 1.0f           // uv Bottom-right
    };
    glBufferData(GL_ARRAY_BUFFER, 
        screen_quad_verts.length * sizeof(float), 
        (GLvoid[])screen_quad_verts, 
        GL_STATIC_DRAW);   
}