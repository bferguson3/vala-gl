// texture.vala 

using GL;

public class Texture : GLib.Object 
{
    public GLuint texture { get; private set; }
    public Image? myImage { get; private set; }

    public Texture(Image img)
    {
        // make new texture from timg and bind it to texture rendering pipeline
        glGenTextures(1, (GLuint[])texture); // new()
        myImage = img; 
    }

    public void bufferToSize(int _w, int _h)
    {
        glBindTexture(GL_TEXTURE_2D, texture); // < future calls to TexImage go to this texture. 
        
        
        glTexImage2D(GL_TEXTURE_2D,             // type
                    0,                          // level (for mipmaps)
                    RES_IMG_FORMAT,             // external format GL_RGBA8
                    _w, 
                    _h,                    // w, h
                    0,                          // must be 0
                    GL_BGRA, GL_UNSIGNED_BYTE,  // internal format and type : NOTE:
                    // Endienness is all wonky here, so GL_BGRA!
                    (GLbyte[]?)myImage.data);       // pointer to data 
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
                
        glGenerateMipmap(GL_TEXTURE_2D); // done after glTexImage2D
    }

    public virtual void buffer()
    {
        glBindTexture(GL_TEXTURE_2D, texture); // < future calls to TexImage go to this texture. 
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
        glTexImage2D(GL_TEXTURE_2D,             // type
                    0,                          // level (for mipmaps)
                    RES_IMG_FORMAT,             // external format GL_RGBA8
                    (GLsizei)myImage.width, 
                    (GLsizei)myImage.height,                    // w, h
                    0,                          // must be 0
                    GL_BGRA, GL_UNSIGNED_BYTE,  // internal format and type : NOTE:
                    // Endienness is all wonky here, so GL_BGRA!
                    (GLbyte[]?)myImage.data);       // pointer to data 

        glGenerateMipmap(GL_TEXTURE_2D); // done after glTexImage2D
    }
        

    ~Texture()
    {
        //stdout.printf("Texture %d deleted.\n", (int)texture);
        glDeleteTextures(1, (GLuint[]?)texture);
    }
}