TARGET		= ./nbody
OBJS		= main.o common.o

CXX			= g++
CXXFLAGS	= -std=c++1z -Wall -O3 -fopenmp
LDFLAGS		= -std=c++1z -fopenmp -lstdc++fs

OUT_DIR		= out/
NUM_DIGITS	= 10
FMT			= $(OUT_DIR)%0$(NUM_DIGITS)d

FMT_DAT		= $(FMT).dat
FMT_POV		= $(FMT).pov
FMT_PNG		= $(FMT).png

CHECK_ENERGY= ./check_energy
CHECK_ENERGY_OBJS = check_energy.o common.o
DAT2POV		= ./dat2pov.rb
RENDER		= ./render.rb
RENDER_SIZE_= 800x600

ifeq ($(RENDER_QUALITY),SD)
	RENDER_SIZE_ := 640x480
else ifeq ($(RENDER_QUALITY),HD)
	RENDER_SIZE_ := 1280x720
else ifeq ($(RENDER_QUALITY),FHD)
	RENDER_SIZE_ := 1920x1080
else ifeq ($(RENDER_QUALITY),4K)
	RENDER_SIZE_ := 3840x2160
endif

ifndef RENDER_SIZE
	RENDER_SIZE := $(subst x, ,$(RENDER_SIZE_))
endif
RENDER_WIDTH=$(firstword $(RENDER_SIZE))
RENDER_HEIGHT=$(lastword $(RENDER_SIZE))

MK_PLUMMER	= ./mk_plummer
PLUMMER_NUM	= 1000
PLUMMER_DAT	= plummer-$(PLUMMER_NUM).dat

DT			= 0.0001
TIME_MAX	= 100.0

INIT_DAT	= $(PLUMMER_DAT)
RUN_DEP		= $(TARGET) $(INIT_DAT) $(OUT_DIR)
RUN_FLAGS	= $(INIT_DAT) $(OUT_DIR) $(NUM_DIGITS) $(DT) $(TIME_MAX)

PLOT_GIF	= $(OUT_DIR)plot.gif
D_ANIM		= 1
ANIM_SIZE	= 10

POVRAY_GIF	= $(OUT_DIR)povray.gif
POVRAY_MP4	= $(OUT_DIR)povray.mp4

INPUT_FPS	= 60
OUTPUT_FPS	= 60

%.o : %.cc
	$(CXX) -c $< $(CXXFLAGS) -o $@

# command
default:
	make $(TARGET)

run: $(RUN_DEP)
	make clean_data
	$(TARGET) $(RUN_FLAGS)

check: $(CHECK_ENERGY)
	$(CHECK_ENERGY) $(OUT_DIR) > energy.log
	echo -e "set terminal png\nplot \"energy.log\" u 1:2 w l title \"運動エネルギー\"\nreplot \"energy.log\" u 1:3 w l title \"ポテンシャルエネルギー\"\nreplot \"energy.log\" u 1:4 w l title \"合計\"\nset output \"e.png\"\nreplot" | gnuplot

plot: $(PLOT_GIF)

replot: clean_gif plot

full: clean run plot

autorun: run pov render gif mp4

pov:
	$(DAT2POV) $(OUT_DIR)

render:
	$(RENDER) $(OUT_DIR) $(RENDER_WIDTH) $(RENDER_HEIGHT)

rerender:
	make pov
	make render

gif: $(POVRAY_GIF)

mp4: $(POVRAY_MP4)

clean: clean_gif clean_data
	rm -rf $(TARGET) mk_plummer
	rm -rf *.o

clean_data:
	find $(OUT_DIR) -type f -name "*.dat" | xargs rm -f

clean_gif:
	rm -rf $(PLOT_GIF)

$(TARGET): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

mk_plummer.cc:
	wget http://jun.artcompsci.org/kougi/keisan_tenmongakuII/programs/simpletree/mk_plummer.C
	mv mk_plummer.C $@

$(MK_PLUMMER): mk_plummer.cc
	$(CXX) -o $@ $<

$(PLUMMER_DAT): $(MK_PLUMMER)
	$(MK_PLUMMER) -n $(PLUMMER_NUM) > $@

$(OUT_DIR):
	mkdir $@

$(CHECK_ENERGY): $(CHECK_ENERGY_OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(PLOT_GIF):
	gnuplot -c anim.gp $(OUT_DIR) $(D_ANIM) $(ANIM_SIZE)

$(POVRAY_GIF):
	ffmpeg -r $(INPUT_FPS) -i $(FMT_PNG) -r $(OUTPUT_FPS) $(POVRAY_GIF)

$(POVRAY_MP4):
	ffmpeg -r $(INPUT_FPS) -i $(FMT_PNG) -vcodec libx264 -pix_fmt yuv420p -r $(OUTPUT_FPS) $(POVRAY_MP4) -vb 50000k -s:v $(RENDER_SIZE_)
