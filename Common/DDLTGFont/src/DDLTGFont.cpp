#include "DDLTGFont.h"
#include <ft2build.h>
#include <hb.h>
#include <hb-ft.h>
#include FT_FREETYPE_H
#include <fstream>

namespace Ddltg {

DDLTGFont::DDLTGFont()
{
    
}

DDLTGFont::~DDLTGFont()
{
    
}

void DDLTGFont::initFace(char* fontPath)
{
    std::ifstream ifile;
    ifile.open(fontPath);
    if(ifile.is_open())
    {
        int i = 0;
    }else
    {
        int p = 0;
    }
}

}

