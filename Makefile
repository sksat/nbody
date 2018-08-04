TARGET		= ./nbody
OBJS		= main.o

CXX			= g++
CXXFLAGS	= -std=c++1z -Wall -O3 -fopenmp
LDFLAGS		= -fopenmp

OUT_DIR		= out/
FMT			= $(OUT_DIR)%010d

FMT_DAT		= $(FMT).dat
FMT_POV		= $(FMT).pov
FMT_PNG		= $(FMT).png

DAT2POV		= ./dat2pov.rb
RENDER		= ./render.rb

PLUMMER_NUM	= 1000
PLUMMER_DAT	= plummer-$(PLUMMER_NUM).dat

INIT_DAT	= $(PLUMMER_DAT)
RUN_DEP		= $(TARGET) $(INIT_DAT)
RUN_FLAGS	= $(INIT_DAT)

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

pov:
	$(DAT2POV)

render:
	make pov
	$(RENDER)

gif: $(POVRAY_GIF)

mp4: $(POVRAY_MP4)

clean: clean_gif
	rm -rf $(TARGET) mk_plummer
	rm -rf *.o
	rm -rf *.dat

clean_data:
	rm -rf $(OUT_DIR)*.dat

clean_gif:
	rm -rf $(PLOT_GIF)

$(TARGET): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

mk_plummer.cc:
	wget http://jun.artcompsci.org/kougi/keisan_tenmongakuII/programs/simpletree/mk_plummer.C
	mv mk_plummer.C $@

$(PLUMMER_DAT): ./mk_plummer
	$< -n $(PLUMMER_NUM) > $@

$(OUT_DIR):
	mkdir $@

$(PLOT_GIF):
	gnuplot -c anim.gp $(D_ANIM) $(ANIM_SIZE)

$(POVRAY_GIF):
	ffmpeg -r 30 -i $(FMT_PNG) -r 60 $(POVRAY_GIF)

$(POVRAY_MP4):
	ffmpeg -r 30 -i $(FMT_PNG) -vcodec libx264 -pix_fmt yuv420p -r 60 $(POVRAY_MP4)
