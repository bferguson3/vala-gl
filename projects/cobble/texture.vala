// texture.vala 

using GL;

public class Texture : GLib.Object 
{
    public GLuint texture { get; private set; }

    public Texture(Image img)
    {
        // make new texture from timg and bind it to texture rendering pipeline
        GLuint tex = 0;
        glGenTextures(1, (GLuint[])tex); // new()
        
        glBindTexture(GL_TEXTURE_2D, tex); // < future calls to TexImage go to this texture. 
        
        glTexImage2D(GL_TEXTURE_2D,             // type
                    0,                          // level (for mipmaps)
                    GL_RGBA8,                   // external format
                    (GLsizei)img.width, (GLsizei)img.height,                    // w, h
                    0,                          // must be 0
                    GL_RGBA, GL_UNSIGNED_BYTE,  // internal format and type
                    (GLvoid[]?)img.data); // pointer to data 

        texture = tex;
    }

    ~Texture()
    {
        //stdout.printf("Texture %d deleted.\n", (int)texture);
        glDeleteTextures(1, (GLuint[]?)texture);
    }
}