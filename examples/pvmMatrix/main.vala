// projection - view - model matrix example

using GL;

const int RES_IMG_FORMAT = GL.GL_RGBA8;
int SCREEN_WIDTH  = 640;
int SCREEN_HEIGHT = 400;

static int main(string[] args)
{
    GLuint init_gl;
    // Init GLFW
    if(!GLFW.glinit())
    {
        stderr.printf("GLFW init failed!\n");
        return -1;
    }
    // MacOS bullshit:
    GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MAJOR, 4);
    GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MINOR, 1);
    GLFW.set_hint(GLFW.WindowHint.OPENGL_FORWARD_COMPAT, GL_TRUE);
    GLFW.set_hint(GLFW.WindowHint.OPENGL_PROFILE, GLFW.OpenGLProfile.CORE);
    // Normal window setup:
    GLFW.set_hint_bool(GLFW.WindowHint.RESIZABLE, false); // no resize 
    GLFW.set_hint(GLFW.WindowHint.SAMPLES, 2);            // no AA

    var myNewWindow = new GLFW.Window(640, 400, "Hello Matrices", null, null);
    myNewWindow.make_context_current();

    // create vertex attribute array 
    VertexAttributeArray vao = new VertexAttributeArray();
    vao.bind();
    // Load shader data from file
    Shader vs = new Shader("simple.vs", GL_VERTEX_SHADER);
    Shader fs = new Shader("simple.fs", GL_FRAGMENT_SHADER);
    ShaderProgram sp = new ShaderProgram.fromShaders(vs, fs); // bind, link and attach the shaders
    sp.linkAndUse();
    
    VertexBuffer vb = new VertexBuffer();
    vb.bind();

    GLfloat vertices[] = {
        -0.5f,  0.5f,       // pos 
         1.0f, 0.0f, 0.0f,  // color 
         0.0f, 0.0f,                   // uv Top-left
         0.5f,  0.5f,       // pos 
         0.0f, 1.0f, 0.0f,  // color
         1.0f, 0.0f,                   // uv Top-right
        -0.5f, -0.5f,       // pos
        1.0f, 1.0f, 1.0f,   // color
        0.0f, 1.0f,                   // uv Bottom-left
        0.5f, -0.5f,        // pos 
        0.0f, 0.0f, 1.0f,    // color 
        1.0f, 1.0f                    // uv Bottom-right
    };
    Drawable square = new Drawable();
    square.setVertices(vertices);
    square.bufferVertices();

    var posAttr = sp.AddAttrib("position");
    var colAttr = sp.AddAttrib("color");
    var texAttr = sp.AddAttrib("texcoord");
    vao.SetVertexShape(posAttr, 2, GL_FLOAT, 7, 0); // configure the shader to use n(a,b).f format, 
    vao.SetVertexShape(colAttr, 3, GL_FLOAT, 7, 2); // and n(c,d,e).f
    vao.SetVertexShape(texAttr, 2, GL_FLOAT, 7, 5); // + n(f,g).f
    
    Texture tex = new Texture(new Image("test3.png"));
    tex.buffer();   
    
    Mat4 model = new Mat4.Identity(1.0f); // create a new identity matrix
    model.scale(0.5f, 0.5f, 0.5f);  // shrink it 50%
    
    var view = lookAt(1.2f, 1.2f, 1.2f,  // 1 meter up, 1 meter back
        0.0f, 0.0f, 0.0f,                // focused on 0, 0, 0
        0.0f, 1.0f, 0.0f);               // up vector = Y axis 
    
    var proj = perspective(rads(45.0f), // Vertical FOV in degrees
        SCREEN_WIDTH / SCREEN_HEIGHT ,  // Horizontal FOV in ratio
        0.1f,                           // near clip 
        10.0f);                         // far clip 
    
    // get uniform targets from shader 
    var alphaAttr = sp.AddUniform("alpha");
    var pvm = sp.AddUniform("pvm");
    
    sp.SetUniform(alphaAttr, new Vec1(1.0f));

    
    float rot = -1.0f;
 
    // Main Loop 
    while(!myNewWindow.should_close)
    {
        GLFW.poll_events(); // while not exit...

        glClearColor(0.2f, 0.2f, 0.2f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        sp.use();
        
        var pmat = new Mat4.Copy(model);
        rot -= 0.1f;
        pmat.rotate(rot, new Vec3(0.0f, 0.0f, 1.0f));
        pmat.mul(view);
        pmat.mul(proj);
        sp.SetUniformMatrix(pvm, pmat);

        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
        
        myNewWindow.swap_buffers();
    }
    // Cleanup:
    
    GLFW.glterminate();
    return 0;
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

