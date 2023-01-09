// endianness-test.vala 

ENDIANNESS_LITTLE_ENDIAN = 0;
ENDIANNESS_BIG_ENDIAN    = 1;

public static int get_endianness()
{
    int n = 1;
    if(*(uint8*)&n == 1)
        return ENDIANNESS_LITTLE_ENDIAN;
    else 
        return ENDIANNESS_BIG_ENDIAN;
}

public static bool is_little_endian()
{
    int n = 1;
    if(*(uint8*)&n == 1)
        return true;
    return false;
}

public static bool is_big_endian()
{
    int n = 1;
    if(*(uint8*)&n + (sizeof(int) - 1) == 1)
        return true;
    return false;
}

public static int main(string[] args)
{
    int n = 1;
    // little endian if true
    if(*(uint8*)&n == 1)
        stdout.printf("Little endian detected.\n");
    else 
        stdout.printf("Big endian detected.\n");
    return 0;
}