// image.vala 

using FreeImage;

public class Image : GLib.Object 
{

    public BYTE* data { get; private set; }
    public uint width { get; private set; }
    public uint height { get; private set; }
    private uint bpp;

    private FIBITMAP* bmp;

    public Image(string filename)
    {
        FREE_IMAGE_FORMAT fif = FreeImage.GetFileType(filename, 0);
        
        bmp = FreeImage.Load(fif, filename, 0);
        
        if(bmp == null)
            stdout.printf("Image loading from file failed.\n");
        //FreeImage.FREE_IMAGE_TYPE ft = FreeImage.GetImageType(newbmp);
        width = GetWidth(bmp);
        height = GetHeight(bmp);
        bpp = GetBPP(bmp);
        FlipVertical(bmp); // flip to top-down
        
        // Expand in memory!
        FIBITMAP* hold = bmp; 
        bmp = ConvertTo32Bits(hold);
        FreeImage.Unload(hold);

        data = GetBits(bmp);
    }

    ~Image()
    {
        stdout.printf("Image %p deleted.\n", bmp);
        FreeImage.Unload(bmp);
    }

    // Indexed/8bpp images
    public BYTE GetPixel(uint x, uint y)
    {
        BYTE p = 0;
        GetPixelIndex(bmp, x, y, &p);
        return p;
    }

    // RGBA/32bpp images 
    public RGBQUAD GetColor(uint x, uint y)
    {
        FreeImage.RGBQUAD q = { 0, 0, 0, 0};
        FreeImage.GetPixelColor(bmp, x, y, &q);
        return q;    
    }

    public void print()
    {
        //for (int z = 0; z < (width*height); z++)
        //    stdout.printf("%d", bmp[z]);

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