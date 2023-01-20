// framebuffer.vala 
using GL;
using Cobble;

public class FrameBuffer : GLib.Object 
{
    //
    public GLuint fbo;
    public GLuint tcb;
    public GLuint rbo;
    //public Texture tex;
    
    // NOTE : THIS IS DEPENDANT ON CURRENT SCREEN WIDTH AND HEIGHT. IT MUST BE RE-GENERATED!
    public FrameBuffer()
    {
        glGenFramebuffers(1, (GLuint[])fbo);
        glBindFramebuffer(GL_FRAMEBUFFER, fbo);
        // make empty color attachment texture 
        glGenTextures(1, (GLuint[])tcb);
        glBindTexture(GL_TEXTURE_2D, tcb);
        // TODO rgb byte order here?
        glTexImage2D(GL_TEXTURE_2D, // tex type 
            0, // mip level 
            GL_RGB, // internal format 
            320, 240, // size 
            0, // border (must be 0)
            GL_RGB, // format 
            GL_UNSIGNED_BYTE, // data format 
            null); // data pointer 
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glFramebufferTexture2D(GL_FRAMEBUFFER, 
            GL_COLOR_ATTACHMENT0,
            GL_TEXTURE_2D, 
            tcb, 
            0); 
        // rbo - depth, stencil 
        glGenRenderbuffers(1, (GLuint[])rbo);
        glBindRenderbuffer(GL_RENDERBUFFER, rbo);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, 320, 240);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, rbo);

        if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
            stderr.printf("FRAMEBUFFER ERROR\n");
        
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        
    }

    public void bind()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    }

    public void bind_render()
    {
        glBindRenderbuffer(GL_RENDERBUFFER, rbo);
    }

    ~FrameBuffer()
    {
        glDeleteFramebuffers(1, (GLuint[])fbo);
        glDeleteRenderbuffers(1, (GLuint[])rbo);
    }

}