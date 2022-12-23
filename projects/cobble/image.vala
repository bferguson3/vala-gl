// image.vala 

using FreeImage;

public class Image : GLib.Object 
{

    public BYTE* data { get; private set; }
    public uint width { get; private set; }
    public uint height { get; private set; }
    private uint bpp;

    private FIBITMAP* _me;

    public Image(string filename)
    {
        FREE_IMAGE_FORMAT fif = FreeImage.GetFileType(filename, 0);
        FIBITMAP* newbmp = null;
        
        newbmp = FreeImage.Load(fif, filename, 0);
        
        if(newbmp == null)
            stdout.printf("Image loading from file failed.\n");
        //FreeImage.FREE_IMAGE_TYPE ft = FreeImage.GetImageType(newbmp);
        width = GetWidth(newbmp);
        height = GetHeight(newbmp);
        bpp = GetBPP(newbmp);
        data = GetBits(newbmp);

        FlipVertical(newbmp); // flip to top-down
        
        // Expand in memory!
        _me = ConvertTo32Bits(newbmp); //newbmp;
    }

    ~Image()
    {
        FreeImage.Unload(_me);
    }

    // Indexed/8bpp images
    public BYTE GetPixel(uint x, uint y)
    {
        BYTE p = 0;
        GetPixelIndex(_me, x, y, &p);
        return p;
    }

    // RGBA/32bpp images 
    public RGBQUAD GetColor(uint x, uint y)
    {
        FreeImage.RGBQUAD q = { 0, 0, 0, 0};
        FreeImage.GetPixelColor(_me, x, y, &q);
        return q;    
    }

    public void print()
    {
        for(uint y = 0; y < height; y++)
        {
            for(uint i = 0; i < width; i++)
            {
                //stdout.printf("%u", GetPixel(i, y));
                char o = '.';
                if(GetColor(i, y).rgbBlue/26 > 0)
                    o = '1';
                stdout.printf("%c", o);
            }
            stdout.printf("\n");
        }
    }
}