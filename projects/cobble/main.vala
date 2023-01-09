// COBBLE 
// a retro game engine written in vala 

//using GLFW; // <- make sure you have this bad boy!
using GL;
using Cobble;

static int main(string[] args)
{
    cobble_start();
    
    // WINDOW SETUP
    var cobbleWindow = SetupWindow();
    
    bgColor = new Vector3(0.2f, 0.2f, 0.2f);
    glClearColor(bgColor.x, bgColor.y, bgColor.z, 1.0f);
    
                // SHADER SETUP
    // Load shader data from file
    Shader vs2 = new Shader("simple.vs", GL_VERTEX_SHADER);
    Shader fs2 = new Shader("simple.fs", GL_FRAGMENT_SHADER);
    ShaderProgram sp = new ShaderProgram.fromShaders(vs2, fs2); // bind, link and attach the shaders
    sp.link();
    
    // VERTEX SETUP
    VertexAttributeArray vao  = new VertexAttributeArray(); // create vertex attribute array 
    VertexBuffer vbuffer = new VertexBuffer.forSpriteCount(64);     
    
    vao.bind();    
    
    Sprite square = new Sprite(320, 100);
    square.setPos(new XYPos(0, 0));
    Sprite sq2 = new Sprite(200, 200);
    sq2.setPos(new XYPos(200, 100));

    square.bufferVertices();
    sq2.bufferVertices();
    sq2.setPos(new XYPos(80, 180));
    sq2.bufferVertices();
    
    var posAttr = sp.AddAttrib("position");
    var colAttr = sp.AddAttrib("color");
    var texAttr = sp.AddAttrib("texcoord");
    vao.SetVertexShape(posAttr, 2, GL_FLOAT, SPRITE_VERTEX_LENGTH, 0); // configure the shader to use n(a,b).f format, 
    vao.SetVertexShape(colAttr, 3, GL_FLOAT, SPRITE_VERTEX_LENGTH, 2); // and n(c,d,e).f
    vao.SetVertexShape(texAttr, 2, GL_FLOAT, SPRITE_VERTEX_LENGTH, 5); // + n(f,g).f
    
    
    // load in the image to a new texture 
    Texture tex = new Texture(new Image("test.png"));
    Texture tex2 = new Texture(new Image("test2.png"));

    unbind_all();

    //img = null; 

    // Main Loop 
    while(!cobbleWindow.should_close)
    {
        double frame_start = GLFW.get_time();
        ////
        
        GLFW.poll_events(); // while not exit...

        // clear screen
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        sp.use();
        // animate square // test move by 1 virtual pixel at a time (vpx)
        //
        float fade = (float)(Math.sin(runTime) + 1.25f)/ 2.0f;
        sp.SetUniform1f("alpha", (Vector1)fade); // fade color 
        
        // draw objects    
        vao.bind(); 
        
        // if we move a sprite, then we need to re-buffer its vertices 
        vbuffer.bind();
        XYPos newpos = new XYPos(sq2.x + 1, sq2.y);
        sq2.setPos(newpos);
        sq2.bufferVertices();
        
        // otherwise, just sample its texture and draw it as an array offset 
        // TODO bind the texture etc to the sprite itself.
        int sprite_index = 0;
        tex.buffer(); 
        glDrawArrays(GL_TRIANGLE_STRIP, 4 * (sprite_index++), 4);
        tex2.buffer();
        glDrawArrays(GL_TRIANGLE_STRIP, 4 * (sprite_index++), 4);
        
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