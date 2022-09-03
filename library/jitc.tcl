namespace eval ::jitc {
	namespace export *

	apply [list {} {
		variable includepath	{}
		variable librarypath	{}
		variable prefix
		variable packagedir
		variable re2cpath
		variable packccpath
		variable lemonpath
		variable tccpath

		set dir	[file normalize [file dirname [info script]]]
		#puts stderr "in build dir: [file exists [file join $dir ../generic/jitc.c]], dir is ($dir)"
		if {[file exists [file join $dir ../generic/jitc.c]]} {
			set packagedir	[file dirname $dir]
			set tccpath		[file join $packagedir local/lib/tcc]
			set re2cpath	[file join $packagedir local/bin/re2c]
			set packccpath	[file join $packagedir local/bin/packcc]
			set lemonpath	[file join $packagedir local/bin/lemon]

			lappend includepath	[file join $packagedir generic]
			lappend includepath	[file join $packagedir local/lib/tcc/include]
			lappend librarypath	[file join $packagedir local/lib/tcc]
		} else {
			set packagedir	$dir
			set tccpath		$packagedir
			set re2cpath	[file join $packagedir re2c]
			set packccpath	[file join $packagedir packcc]
			set lemonpath	[file join $packagedir lemon]

			lappend includepath	[file join $packagedir include]
			lappend librarypath	$packagedir
		}

		foreach path [list \
			[tcl::pkgconfig get includedir,runtime] \
			[tcl::pkgconfig get includedir,install] \
		] {
			if {$path ni $includepath} {
				lappend includepath $path
			}
		}

		foreach path [list \
			[tcl::pkgconfig get libdir,runtime] \
			[tcl::pkgconfig get libdir,install] \
		] {
			if {$path ni $librarypath} {
				lappend librarypath $path
			}
		}

		set prefix	[file join {*}[lrange [file split [info nameofexecutable]] 0 end-2]]

		set path	[file join $prefix include]
		if {$path ni $includepath} {
			lappend includepath $path
		}

		set path	[file join $prefix lib]
		if {$path ni $librarypath} {
			lappend librarypath $path
		}

		load [file join $packagedir libjitc0.1.so] jitc
	} [namespace current]]

	proc packageinclude {} { #<<<
		variable packagedir
		set packagedir
	}

	#>>>
	proc re2c args { #<<<
		variable packagedir
		variable re2cpath

		if {[llength $args] == 0} {
			error "source argument is required"
		}
		set source	[lindex $args end]
		set options	[lrange $args 0 end-1]
		exec echo $source | $re2cpath - {*}$options
	}

	#>>>
	proc packcc args { #<<<
		variable packagedir
		variable packccpath
		error "Not implemented yet"

		if {[llength $args] == 0} {
			error "source argument is required"
		}
		set source	[lindex $args end]
		set options	[lrange $args 0 end-1]
		in_builddir {
			exec echo $source | $packccpath -l -o  {*}$options
		}
	}

	#>>>
	proc lemon args { #<<<
		variable packagedir
		variable lemonpath
		error "Not implemented yet"

		if {[llength $args] == 0} {
			error "source argument is required"
		}
		set source	[lindex $args end]
		set options	[lrange $args 0 end-1]
		in_builddir {
			exec echo $source | $lemonpath -q {*}$options
		}
	}

	#>>>
}

# vim: ft=tcl foldmethod=marker foldmarker=<<<,>>> ts=4 shiftwidth=4
