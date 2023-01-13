// COBBLE 
// a retro game engine written in vala 

//using GLFW; // <- make sure you have this bad boy!
using GL;
//using Math;
using Cobble;

static int main(string[] args)
{
    /************
    * Cobble
    ************/
    cobble_start();
    
    cobbleWindow = setup_window();
    set_resolution(320, 240);
    
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
    //tex2.buffer();
    Sprite square = new Sprite(tex2, 16, 24);
    //square.setPos(new XYPos(160-32, 120-32));
    //Sprite sq2 = new Sprite(tex2, 16, 24);
    //Sprite t3 = new Sprite.Copy(sq2);

    add_sprite(square); // buffers vertices when added 
    //add_sprite_at_index(sq2, 2);
    //add_sprite(t3);

    /************
    * TILE MAP SHIT 
    ************/
    unbind_all();

    sp.use(); // tie to uniform calls
    var transUnif = sp.AddUniform("model");
    
    Mat4 rotMat = new Mat4.Identity(1.0f); // create a new identity matrix: 1, 0, 0, 0 > 0, 1, 0, 0 ...
    //rotMat.rotate(180.0f, new Vec3(0.0f, 0.0f, 1.0f)); // rotate 180 degrees (right) on the Z axis 
    rotMat.scale(0.5f, 0.5f, 0.5f);
    sp.SetUniformMatrix(transUnif, rotMat);
    
    /*
    tm = new TileMap(20, 12, 16, 16);
    TEMPTEX = new Texture(new Image("test4.png"));
    tmbuff = new VertexBuffer.forTileMap(tm);
    tmvao = new VertexAttributeArray();
    tmvao.bind();
    sp.use();
    tmbuff.bind();
                        //name, len, type, stride, offset
    tmvao.SetVertexShape(posAttr, 2, GL_FLOAT, 7, 0); // configure the shader to use n(a,b).f format, 
    tmvao.SetVertexShape(colAttr, 3, GL_FLOAT, 7, 2); // and n(c,d,e).f
    tmvao.SetVertexShape(texAttr, 2, GL_FLOAT, 7, 5); // + n(f,g).f
     */

    unbind_all();
    // 4 verts 

    
    /* SETUP VIEW  */
    var view = lookAt(1.2f, 1.2f, 1.2f,  // 1 meter up, 1 meter back?
        0.0f, 0.0f, 0.0f, 
        0.0f, 1.0f, 0.0f);
    var viewUnif = sp.AddUniform("view");
    

    var proj = perspective(rads(45.0f), 1280.0f / 720.0f , 0.1f, 10.0f);
    
    proj.print();
    view.print();
    //rotMat.print();

    var pvmmat = new Mat4.Copy(rotMat);
    pvmmat.mul(view);
    pvmmat.mul(proj);
    //pvmmat.print();
    var alphaAttr = sp.AddUniform("alpha");
    var pvm = sp.AddUniform("pvm");
    // clean up for draw 
    unbind_all();
    //img = null; 
    float rot = 1.0f;
    // Main Loop 
    while(!cobbleWindow.should_close)
    {
        frame_start = GLFW.get_time();
        ////
        GLFW.poll_events(); // while not exit...
        //rot += 1.0f;
        float fade = (float)(Math.sin(runTime) + 1.25f)/ 2.0f;
        sp.use();
        sp.SetUniform(alphaAttr, new Vec1(fade));
        var pmat = new Mat4.Copy(rotMat);
        rot+=0.1f;
        pmat.rotate(rot, new Vec3(0.0f, 0.0f, 1.0f));
        pmat.mul(view);
        pmat.mul(proj);
        sp.SetUniformMatrix(pvm, pmat);
        

        cobble_draw(); 
        
        // Print FPS
        fps();
    }
    // Cleanup: objects clean up themselves!
    
    GLFW.glterminate();
    FreeImage.DeInitialise();

    return 0;
}

