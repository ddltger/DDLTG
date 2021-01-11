
#ifndef DDLTGFONT_H
#define DDLTGFONT_H
#include <hb.h>

namespace Ddltg {

class DDLTGFont
{
public:
    DDLTGFont();
    ~DDLTGFont();
    void initFace(char* fontPath);
};
}
#endif
