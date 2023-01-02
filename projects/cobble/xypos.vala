// xypos.vala 

public class XYPos : GLib.Object 
{
    public int x { public get; private set; } 
    public int y { public get; private set; }

    public XYPos(int _x, int _y)
    {
        x = _x;
        y = _y;
    }
}