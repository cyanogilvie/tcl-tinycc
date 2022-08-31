#include <stddef.h>
#include <string.h>
#include "tclstuff.h"
#include <libtcc.h>
#include "jitc.h"

// pointer to/from int from tclInt.h
#if !defined(INT2PTR)
#   define INT2PTR(p) ((void *)(ptrdiff_t)(p))
#endif
#if !defined(PTR2INT)
#   define PTR2INT(p) ((ptrdiff_t)(p))
#endif
#if !defined(UINT2PTR)
#   define UINT2PTR(p) ((void *)(size_t)(p))
#endif
#if !defined(PTR2UINT)
#   define PTR2UINT(p) ((size_t)(p))
#endif

extern Tcl_Mutex g_tcc_mutex;

struct jitc_intrep {
	TCCState*				s;
	Tcl_Obj*				symbols;
	Tcl_Obj*				cdef;
	Tcl_Obj*				debugfiles;
	Tcl_Interp*				interp;
};

enum {
	LIT_INCLUDE,
	LIT_LIB,
	LIT_SIZE
};
extern const char*	lit_str[];

struct interp_cx {
	Tcl_Obj*		lit[LIT_SIZE];
	Tcl_Obj*		libdir;				// Path to tcc libs and include dir
	Tcl_Obj*		prefix;				// Tcl runtime prefix
	Tcl_Obj*		stdincludepath;		// List of paths to add to includedirs when compiling against Tcl
	Tcl_Obj*		stdlibpath;			// List of paths to add to libdirs when compiling against Tcl
	Tcl_Obj*		tcllib;				// soname of the Tcl library for this runtime
};

int get_r_from_obj(Tcl_Interp* interp, Tcl_Obj* obj, struct jitc_intrep** rPtr);
