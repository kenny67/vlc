# Generated automatically from Makefile.in by configure.
# Generated automatically from Makefile.in by configure.
################################################################################
# vlc (VideoLAN Client) main makefile
# (c)1998 VideoLAN
################################################################################
# This makefile is the main makefile for the VideoLAN client.
################################################################################

CC = egcc

################################################################################
# Configuration
################################################################################

# Audio output settings
AOUT = dsp
#AOUT += esd
# Not yet supported
#AOUT += alsa
# Fallback method that should always work
AOUT += dummy

# Video output settings
VOUT = x11
#VOUT += fb
#VOUT += ggi
#VOUT += glide
# Not yet supported
#VOUT = beos
#VOUT += dga
# Fallback method that should always work
VOUT += dummy

# Interface settings
INTF = x11
#INTF += fb
#INTF += ggi
#INTF += glide
# Not yet supported
#INTF = beos
#INTF += dga
# Fallback method that should always work
INTF += dummy

# Target architecture
ARCH=X86
#ARCH=PPC
#ARCH=SPARC

# Target operating system
SYS=LINUX
#SYS=GNU
#SYS=BSD
#SYS=BEOS

# For x86 architecture, choose MMX support
ARCH += MMX
# For x86 architecture, optimize for Pentium Pro
# (choose NO if you get `Invalid instruction' errors)
ARCH += PPRO

# Decoder choice - ?? old decoder will be removed soon
#DECODER=old
DECODER=new

# Debugging mode on or off (set to 1 to activate)
DEBUG=0

#----------------- do not change anything below this line ----------------------

################################################################################
# Configuration pre-processing
################################################################################

# PROGRAM_OPTIONS is an identification string of the compilation options
PROGRAM_OPTIONS = $(SYS) $(ARCH)
ifeq ($(DEBUG),1)
PROGRAM_OPTIONS += DEBUG
endif

# PROGRAM_BUILD is a complete identification of the build
# ( we can't use fancy options with date since OSes like Solaris
# or FreeBSD have strange date implementations )
PROGRAM_BUILD = `date` $(USER)
# XXX: beos does not support hostname
#PROGRAM_BUILD = `date` $(USER)@`hostname`

# DEFINE will contain some of the constants definitions decided in Makefile, 
# including ARCH_xx and SYS_xx. It will be passed to C compiler.
DEFINE += -DARCH_$(shell echo $(ARCH) | cut -f1 -d' ')
DEFINE += -DSYS_$(SYS)
DEFINE += -DPLUGIN_PATH="\"$(PREFIX)/lib/videolan/vlc\""
DEFINE += -DPROGRAM_VERSION="\"0.1.99\""
DEFINE += -DPROGRAM_CODENAME="\"Onatopp\""
#DEFINE += -DPROGRAM_OPTIONS="\"$(shell echo $(PROGRAM_OPTIONS) | tr 'A-Z' 'a-z')\""
#DEFINE += -DPROGRAM_BUILD="\"$(PROGRAM_BUILD)\""
ifeq ($(DEBUG),1)
DEFINE += -DDEBUG
endif

################################################################################
# Tuning and other variables - do not change anything except if you know
# exactly what you are doing
################################################################################

#
# C headers directories
#
INCLUDE += -Iinclude -I/usr/local/include -I/usr/X11R6/include

#
# Libraries
#

ifeq ($(SYS),GNU)
LIB += -lthreads -ldl
endif

ifeq ($(SYS),BSD)
LIB += -pthread -lgnugetopt
LIB += -L/usr/local/lib
endif

ifeq ($(SYS),LINUX)
LIB += -lpthread -ldl
endif

ifeq ($SYS),BEOS)
LIB += -llibroot -llibgame -llibbe
endif

LIB += -lm

#
# C compiler flags: compilation
#
CCFLAGS += $(DEFINE) $(INCLUDE)
CCFLAGS += -Wall
CCFLAGS += -D_REENTRANT
CCFLAGS += -D_GNU_SOURCE

# Optimizations : don't compile debug versions with them
CCFLAGS += -O6
CCFLAGS += -ffast-math -funroll-loops -fargument-noalias-global
CCFLAGS += -fomit-frame-pointer

# Optimizations for x86 familiy
ifneq (,$(findstring X86,$(ARCH)))
CCFLAGS += -malign-double
#CCFLAGS += -march=pentium
# Eventual Pentium Pro optimizations
ifneq (,$(findstring PPRO,$(ARCH)))
ifneq ($(SYS), BSD)
CCFLAGS += -march=pentiumpro
endif
endif
# Eventual MMX optimizations for x86
ifneq (,$(findstring MMX,$(ARCH)))
CFLAGS += -DHAVE_MMX
endif
endif

# Optimizations for PowerPC
ifneq (,$(findstring PPC,$(ARCH)))
CCFLAGS += -mcpu=604e -mmultiple -mhard-float -mstring
endif

# Optimizations for Sparc
ifneq (,$(findstring SPARC,$(ARCH)))
CCFLAGS += -mhard-float
endif

#
# C compiler flags: dependancies
#
DCFLAGS += $(INCLUDE)
DCFLAGS += -MM

#
# C compiler flags: linking
#
LCFLAGS += $(LIB)
LCFLAGS += -Wall
#LCFLAGS += -s

#
# Additionnal debugging flags
#

# Debugging support
ifeq ($(DEBUG),1)
CFLAGS += -g
#CFLAGS += -pg
endif

#################################################################################
# Objects and files
#################################################################################

#
# C Objects
# 
interface_obj =  		interface/main.o \
						interface/interface.o \
						interface/intf_msg.o \
						interface/intf_cmd.o \
						interface/intf_ctrl.o \
						interface/intf_console.o

input_obj =         		input/input_vlan.o \
						input/input_file.o \
						input/input_netlist.o \
						input/input_network.o \
						input/input_ctrl.o \
						input/input_pcr.o \
						input/input_psi.o \
						input/input.o

audio_output_obj = 		audio_output/audio_output.o

video_output_obj = 		video_output/video_output.o \
						video_output/video_text.o \
						video_output/video_yuv.o

ac3_decoder_obj =		ac3_decoder/ac3_decoder_thread.o \
						ac3_decoder/ac3_decoder.o \
						ac3_decoder/ac3_parse.o \
						ac3_decoder/ac3_exponent.o \
						ac3_decoder/ac3_bit_allocate.o \
						ac3_decoder/ac3_mantissa.o \
						ac3_decoder/ac3_rematrix.o \
						ac3_decoder/ac3_imdct.o \
						ac3_decoder/ac3_downmix.o

audio_decoder_obj =		audio_decoder/audio_decoder_thread.o \
						audio_decoder/audio_decoder.o \
						audio_decoder/audio_math.o

spu_decoder_obj =		spu_decoder/spu_decoder.o

#??generic_decoder_obj =		generic_decoder/generic_decoder.o
# remeber to add it to OBJ 

ifeq ($(DECODER),old)
CFLAGS += -DOLD_DECODER
video_decoder_obj =		video_decoder_ref/video_decoder.o \
						video_decoder_ref/display.o \
						video_decoder_ref/getblk.o \
						video_decoder_ref/gethdr.o \
						video_decoder_ref/getpic.o \
						video_decoder_ref/getvlc.o \
						video_decoder_ref/idct.o \
						video_decoder_ref/motion.o \
						video_decoder_ref/mpeg2dec.o \
						video_decoder_ref/recon.o \
						video_decoder_ref/spatscal.o
else
video_parser_obj = 		video_parser/video_parser.o \
						video_parser/vpar_headers.o \
						video_parser/vpar_blocks.o \
						video_parser/vpar_synchro.o \
						video_parser/video_fifo.o

video_decoder_obj =		video_decoder/video_decoder.o \
						video_decoder/vdec_motion.o \
						video_decoder/vdec_motion_inner.o \
			                        video_decoder/vdec_idct.o
endif

misc_obj =			misc/mtime.o \
						misc/rsc_files.o \
						misc/netutils.o \
						misc/plugins.o \
						misc/decoder_fifo.o

C_OBJ = $(interface_obj) \
		$(input_obj) \
		$(audio_output_obj) \
		$(video_output_obj) \
		$(ac3_decoder_obj) \
		$(audio_decoder_obj) \
		$(spu_decoder_obj) \
		$(generic_decoder_obj) \
		$(video_parser_obj) \
		$(video_decoder_obj) \
		$(vlan_obj) \
		$(misc_obj)

#
# Assembler Objects
# 
ifneq (,$(findstring X86,$(ARCH)))
ifneq (,$(findstring MMX,$(ARCH)))
ifeq ($(DECODER),new)
ASM_OBJ = 			video_decoder/vdec_idctmmx.o \
						video_output/video_yuv_mmx.o
else
ASM_OBJ = 			video_decoder_ref/vdec_idctmmx.o \
						video_output/video_yuv_mmx.o
endif
endif
endif

#
# Plugins
#
intf_plugin =           $(INTF:%=plugins/intf/intf_%.so)
aout_plugin =           $(AOUT:%=plugins/aout/aout_%.so)
vout_plugin =           $(VOUT:%=plugins/vout/vout_%.so)

PLUGIN_OBJ = $(intf_plugin) $(aout_plugin) $(vout_plugin)

#
# Other lists of files
#
C_OBJ := $(C_OBJ:%.o=src/%.o)
ASM_OBJ := $(ASM_OBJ:%.o=src/%.o)
sources := $(C_OBJ:%.o=%.c) $(PLUGIN_OBJ:%.so=%.c)
dependancies := $(sources:%.c=.dep/%.d)

# All symbols must be exported
export

################################################################################
# Targets
################################################################################

#
# Virtual targets
#
all: vlc

clean:
	rm -f $(C_OBJ) $(ASM_OBJ) $(PLUGIN_OBJ)

distclean: clean
	rm -f **/*.o **/*.so **/*~ *.log
	rm -f Makefile include/defs.h config.cache config.log
	rm -f vlc gmon.out core
	rm -rf .dep

install:
	$(INSTALL) vlc $(PREFIX)/bin
	mkdir -p $(PREFIX)/lib/videolan/vlc
	$(INSTALL) $(PLUGIN_OBJ) $(PREFIX)/lib/videolan/vlc

show:
	@echo "Command line for C objects:"
	@echo $(CC) $(CCFLAGS) $(CFLAGS) -c -o "<dest.o>" "<src.c>"
	@echo
	@echo "Command line for assembler objects:"
	@echo $(CC) $(CFLAGS) -c -o "<dest.o>" "<src.S>"

FORCE:

#
# Real targets
#
vlc: $(C_OBJ) $(ASM_OBJ) $(PLUGIN_OBJ)
	$(CC) $(CCFLAGS) $(LCFLAGS) $(CFLAGS) --export-dynamic -rdynamic -o $@ $(C_OBJ) $(ASM_OBJ)	

#
# Generic rules (see below)
#
$(dependancies): %.d: FORCE
	@$(MAKE) -s --no-print-directory -f Makefile.dep $@

$(C_OBJ): %.o: Makefile.dep
$(C_OBJ): %.o: .dep/%.d
$(C_OBJ): %.o: %.c
	@echo "compiling $*.o from $*.c"
	@$(CC) $(CCFLAGS) $(CFLAGS) -c -o $@ $<

$(ASM_OBJ): %.o: Makefile.dep
$(ASM_OBJ): %.o: %.S
	@echo "assembling $*.o from $*.S"
	@$(CC) $(CFLAGS) -c -o $@ $<

$(PLUGIN_OBJ): %.so: Makefile.dep
$(PLUGIN_OBJ): %.so: .dep/%.d

# audio plugins
plugins/aout/aout_dummy.so plugins/aout/aout_dsp.so: %.so: %.c
		@echo "compiling $*.so from $*.c"
ifeq ($(SYS), BEOS)
		@$(CC) $(CCFLAGS) $(CFLAGS) -nostart -o $@ $<
else
		@$(CC) $(CCFLAGS) $(CFLAGS) -shared -o $@ $<
endif

plugins/aout/aout_esd.so: %.so: %.c
		@echo "compiling $*.so from $*.c"
ifeq ($(SYS), BSD)
		@$(CC) $(CCFLAGS) $(CFLAGS) -lesd -shared -o $@ $<
else
		@$(CC) $(CCFLAGS) $(CFLAGS) -laudiofile -lesd -shared -o $@ $<
endif

# video plugins
plugins/intf/intf_dummy.so plugins/vout/vout_dummy.so \
	plugins/intf/intf_fb.so plugins/vout/vout_fb.so: %.so: %.c
		@echo "compiling $*.so from $*.c"
ifeq ($(SYS), BEOS)
		@$(CC) $(CCFLAGS) $(CFLAGS) -nostart -o $@ $<
else
		@$(CC) $(CCFLAGS) $(CFLAGS) -shared -o $@ $<
endif

plugins/intf/intf_x11.so plugins/vout/vout_x11.so: %.so: %.c
		@echo "compiling $*.so from $*.c"
		@$(CC) $(CCFLAGS) $(CFLAGS) -I/usr/X11R6/include -L/usr/X11R6/lib -lX11 -lXext -shared -o $@ $<

plugins/intf/intf_glide.so plugins/vout/vout_glide.so: %.so: %.c
		@echo "compiling $*.so from $*.c"
		@$(CC) $(CCFLAGS) $(CFLAGS) -I/usr/include/glide -lglide2x -shared -o $@ $<

plugins/intf/intf_ggi.so plugins/vout/vout_ggi.so: %.so: %.c
		@echo "compiling $*.so from $*.c"
		@$(CC) $(CCFLAGS) $(CFLAGS) -lggi -shared -o $@ $<


################################################################################
# Note on generic rules and dependancies
################################################################################

# Note on dependancies: each .c file is associated with a .d file, which
# depends of it. The .o file associated with a .c file depends of the .d, of the
# .c itself, and of Makefile. The .d files are stored in a separate .dep/
# directory.
# The dep directory should be ignored by CVS.

# Note on inclusions: depending of the target, the dependancies files must
# or must not be included. The problem is that if we ask make to include a file,
# and this file does not exist, it is made before it can be included. In a
# general way, a .d file should be included if and only if the corresponding .o
# needs to be re-made.

# Two makefiles are used: the main one (this one) has regular generic rules,
# except for .o files, for which it calls the object Makefile. Dependancies
# are not included in this file.
# The object Makefile known how to make a .o from a .c, and includes
# dependancies for the target, but only those required.
