TARGET	= nbody
OBJS	= main.o

CXX		= g++
CXXFLAGS= -std=c++1z -Wall -O3 -fopenmp
LDFLAGS	= -fopenmp

PLUMMER_NUM	= 1000
PLUMMER_DAT	= plummer-$(PLUMMER_NUM).dat

INIT_DAT	= $(PLUMMER_DAT)
RUN_DEP		= $(TARGET) $(INIT_DAT)
RUN_FLAGS	= $(INIT_DAT)

PLOT_GIF	= out.gif
D_ANIM		= 1
ANIM_SIZE	= 10

%.o : %.cc
	$(CXX) -c $< $(CXXFLAGS) -o $@

# command
default:
	make $(TARGET)

run: $(RUN_DEP)
	make clean_data
	./$(TARGET) $(RUN_FLAGS)

plot: $(PLOT_GIF)

replot: clean_gif plot

full: clean run plot

render:
	./dat2pov.rb
	./render.rb

clean: clean_gif
	rm -rf $(TARGET) mk_plummer
	rm -rf *.o
	rm -rf *.dat

clean_data:
	rm -rf out*.dat

clean_gif:
	rm -rf $(PLOT_GIF)

$(TARGET): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

mk_plummer.cc:
	wget http://jun.artcompsci.org/kougi/keisan_tenmongakuII/programs/simpletree/mk_plummer.C
	mv mk_plummer.C $@

$(PLUMMER_DAT): mk_plummer
	./$< -n $(PLUMMER_NUM) > $@

$(PLOT_GIF):
	gnuplot -c anim.gp $(D_ANIM) $(ANIM_SIZE)
