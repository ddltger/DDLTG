#ifndef DDLTG_FACE_COLLECTION_H_
#define DDLTG_FACE_COLLECTION_H_

#include <hb-ft.h>
#include <hb.h>

#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_LCD_FILTER_H

#include <cassert>
#include <string>
#include <tuple>
#include <vector>
#include "DDLTGConstants.h"

namespace Ddltg {
using std::get;
using std::make_tuple;
using std::string;
using std::tuple;
using std::vector;

using SizedFace = tuple<FT_Face, int, int>;
using FaceCollection = vector<SizedFace>;

FaceCollection LoadFaces(FT_Library ft, const vector<string> &face_names);

}


#endif  // SRC_FACE_COLLECTION_H_
