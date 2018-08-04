TARGET		= ./nbody
OBJS		= main.o

CXX			= g++
CXXFLAGS	= -std=c++1z -Wall -O3 -fopenmp
LDFLAGS		= -fopenmp

OUT_DIR		= out/
NUM_DIGITS	= 10
FMT			= $(OUT_DIR)%0$(NUM_DIGITS)d

FMT_DAT		= $(FMT).dat
FMT_POV		= $(FMT).pov
FMT_PNG		= $(FMT).png

DAT2POV		= ./dat2pov.rb
RENDER		= ./render.rb

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

%.o : %.cc
	$(CXX) -c $< $(CXXFLAGS) -o $@

# command
default:
	make $(TARGET)

run: $(RUN_DEP)
	make clean_data
	$(TARGET) $(RUN_FLAGS)

plot: $(PLOT_GIF)

replot: clean_gif plot

full: clean run plot

autorun: run pov render gif mp4

pov:
	$(DAT2POV)

render:
	$(RENDER)

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
	g++ -o $@ $<

$(PLUMMER_DAT): $(MK_PLUMMER)
	$(MK_PLUMMER) -n $(PLUMMER_NUM) > $@

$(OUT_DIR):
	mkdir $@

$(PLOT_GIF):
	gnuplot -c anim.gp $(D_ANIM) $(ANIM_SIZE)

$(POVRAY_GIF):
	ffmpeg -r 30 -i $(FMT_PNG) -r 60 $(POVRAY_GIF)

$(POVRAY_MP4):
	ffmpeg -r 30 -i $(FMT_PNG) -vcodec libx264 -pix_fmt yuv420p -r 60 $(POVRAY_MP4)
