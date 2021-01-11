//
//  TTDisplayLayer.m
//  TTDemoApp
//
//  Created by zing on 2020/11/2.
//

#import "TTFontState.h"
#import <ft2build.h>
#import <hb.h>
#import <hb-ft.h>
#import FT_FREETYPE_H

@interface TTFontState()
{
    FT_Library ft_library;
    FT_Face ft_face;
    FT_Error ft_error;
    
    FT_UInt kFontPixelWidth;
    FT_UInt kFontPixelHeight;
}

@end

@implementation TTFontState

-(void)initFont: (NSString*) path
{
    FT_UInt FONT_SIZE = 32;
    char *fontfile = (char*)[path UTF8String];
    assert(FT_Init_FreeType(&ft_library) == 0);
    assert(FT_New_Face(ft_library, fontfile, 0, &ft_face) == 0);
    
    // For Harfbuzz, load using OpenType (HarfBuzz FT does not support bitmap font)
    hb_blob_t *hb_blob = hb_blob_create_from_file(fontfile);
    hb_face_t *hb_face = hb_face_create(hb_blob, 0);
    hb_font_t *hb_font = hb_font_create(hb_face);
    hb_font_set_scale(hb_font, FONT_SIZE*64, FONT_SIZE*64);
    
    // Create  HarfBuzz buffer
    hb_buffer_t *hb_buffer = hb_buffer_create();

    // Set buffer to LTR direction, common script and default language
    hb_buffer_set_direction(hb_buffer, HB_DIRECTION_TTB);
    hb_buffer_set_script(hb_buffer, HB_SCRIPT_COMMON);
    hb_buffer_set_language(hb_buffer, hb_language_get_default());
    
    // Add text and layout it
    hb_buffer_add_utf8(hb_buffer, "緳", -1, 0, -1);
    hb_shape(hb_font, hb_buffer, NULL, 0);
    
    unsigned int count = hb_buffer_get_length (hb_buffer);
    hb_glyph_info_t *infos = hb_buffer_get_glyph_infos (hb_buffer, nullptr);
    hb_glyph_position_t *positions = hb_buffer_get_glyph_positions (hb_buffer, nullptr);

      for (unsigned int i = 0; i < count; i++)
      {
        hb_glyph_info_t *info = &infos[i];
        hb_glyph_position_t *pos = &positions[i];

        printf ("cluster %d glyph 0x%x at   (%d,%d)+(%d,%d)\n",
            info->cluster,
            info->codepoint,
            pos->x_offset,
            pos->y_offset,
            pos->x_advance,
            pos->y_advance);

      }

      hb_buffer_destroy (hb_buffer);
      hb_font_destroy (hb_font);
      hb_face_destroy (hb_face);
}

@end
