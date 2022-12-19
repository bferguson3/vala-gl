//using GLFW; // <- make sure you have this bad boy!
using GL;
using GLConstants;

static int main(string[] args)
{
    // Init GLFW
    if(!GLFW.glinit())
        stderr.printf("GLFW init failed!\n");

    // MacOS bullshit:
    GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MAJOR, 4);
    GLFW.set_hint(GLFW.WindowHint.CONTEXT_VERSION_MINOR, 1);
    GLFW.set_hint(GLFW.WindowHint.OPENGL_FORWARD_COMPAT, GL_TRUE);
    GLFW.set_hint(GLFW.WindowHint.OPENGL_PROFILE, GLFW.OpenGLProfile.CORE);
    // Normal window setup:
    GLFW.set_hint_bool(GLFW.WindowHint.RESIZABLE, false); // no resize 
    GLFW.set_hint(GLFW.WindowHint.SAMPLES, 0);            // no AA

    var myNewWindow = new GLFW.Window(1280, 720, "Hello World", null, null);
    
    myNewWindow.set_size(640, 400);
    myNewWindow.make_context_current();

    // Triangle test:
    const GLfloat vertices[] = {
        0.0f,  0.5f, // v1, x y 
        0.5f, -0.5f, // v2, x y 
        -0.5f,-0.5f  // v3, x y 
    };
    // Load shader data from file
    var vs_data = LoadShader("simple.vs");
    GLuint vshader = glCreateShader(GL_VERTEX_SHADER);
    GLint len = vs_data.length;
    glShaderSource(vshader, 1, (GLchar**)&vs_data, &len);
    glCompileShader(vshader);   // and compile it 
    // Get errors if any:
    GLint status = 0;
    glGetShaderiv(vshader, GL_COMPILE_STATUS, &status);
    if(status == GL_TRUE)
        stdout.printf("Vertex shader compiled successfully.\n");
    else 
    {
        // make this a callback?
        stdout.printf("Vertex shader FAILED.\n");
        char errorbuff[512];
        glGetShaderInfoLog(vshader, 512, null, errorbuff);
        stdout.printf((string)errorbuff);
    }

    // make a vertex buffer and bind the triangle
    GLuint vbuffer = 0;
    glGenBuffers(1, &vbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vbuffer);
    glBufferData(GL_ARRAY_BUFFER, (GLsizeiptr)sizeof(GLfloat) * vertices.length, vertices, GL_STATIC_DRAW);

    // Main Loop 
    while(!myNewWindow.should_close)
    {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        myNewWindow.swap_buffers();

        GLFW.poll_events();
    }
    
    GLFW.glterminate();
    return 0;
}

static string LoadShader(string path)
{
    var vs = File.new_for_path("simple.vs");
    Bytes data = vs.load_bytes();
    string vss = (string)data.get_data();
    return vss;
}