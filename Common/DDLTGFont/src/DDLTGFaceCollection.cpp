#include "DDLTGFaceCollection.h"

namespace Ddltg {
FaceCollection LoadFaces(FT_Library ft, const vector<string> &face_names) {
  FaceCollection faces;

  for (auto &face_name : face_names) {
    FT_Face face;
    if (FT_New_Face(ft, face_name.c_str(), 0, &face)) {
      fprintf(stderr, "Could not load font\n");
      exit(EXIT_FAILURE);
    }

    if (FT_HAS_COLOR(face)) {
      if (FT_Select_Size(face, 0)) {
        fprintf(stderr, "Could not request the font size (fixed)\n");
        exit(EXIT_FAILURE);
      }
    } else {
      if (FT_Set_Pixel_Sizes(face, kFontPixelWidth, kFontPixelHeight)) {
        fprintf(stderr, "Could not request the font size (in pixels)\n");
        exit(EXIT_FAILURE);
      }
    }

    // The face's size and bbox are populated only after set pixel
    // sizes/select size have been called
    FT_Long width, height;
    if (FT_IS_SCALABLE(face)) {
      width = FT_MulFix(face->bbox.xMax - face->bbox.xMin,
                        face->size->metrics.x_scale) >>
              6;
      height = FT_MulFix(face->bbox.yMax - face->bbox.yMin,
                         face->size->metrics.y_scale) >>
               6;
    } else {
      width = (face->available_sizes[0].width);
      height = (face->available_sizes[0].height);
    }
    faces.push_back(make_tuple(face, (int)width, (int)height));
  }

  return faces;
}
}
