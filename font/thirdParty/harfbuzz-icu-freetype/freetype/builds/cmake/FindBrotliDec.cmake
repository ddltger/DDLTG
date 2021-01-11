# FindBrotliDec.cmake
#
# Copyright (C) 2019-2020 by
# David Turner, Robert Wilhelm, and Werner Lemberg.
#
# Written by Werner Lemberg <wl@gnu.org>
#
# This file is part of the FreeType project, and may only be used, modified,
# and distributed under the terms of the FreeType project license,
# LICENSE.TXT.  By continuing to use, modify, or distribute this file you
# indicate that you have read the license and understand and accept it
# fully.
#
#
# Try to find libbrotlidec include and library directories.
#
# If found, the following variables are set.
#
#   BROTLIDEC_INCLUDE_DIRS
#   BROTLIDEC_LIBRARIES

set(FPHSA_NAME_MISMATCHED 1) # Disables a warning about the package variable name not matching this file name.

include(FindPkgConfig)
pkg_check_modules(PC_BROTLIDEC QUIET libbrotlidec)

if (PC_BROTLIDEC_VERSION)
  set(BROTLIDEC_VERSION "${PC_BROTLIDEC_VERSION}")
endif ()


find_path(BROTLIDEC_INCLUDE_DIRS
  NAMES brotli/decode.h
  HINTS ${PC_BROTLIDEC_INCLUDEDIR}
        ${PC_BROTLIDEC_INCLUDE_DIRS}
  PATH_SUFFIXES brotli)

find_library(BROTLIDEC_LIBRARIES
  NAMES brotlidec
  HINTS ${PC_BROTLIDEC_LIBDIR}
        ${PC_BROTLIDEC_LIBRARY_DIRS})


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  brotlidec
  REQUIRED_VARS BROTLIDEC_INCLUDE_DIRS BROTLIDEC_LIBRARIES
  FOUND_VAR BROTLIDEC_FOUND
  VERSION_VAR BROTLIDEC_VERSION)

mark_as_advanced(
  BROTLIDEC_INCLUDE_DIRS
  BROTLIDEC_LIBRARIES)

unset(FPHSA_NAME_MISMATCHED)
