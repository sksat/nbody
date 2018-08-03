TARGET	= nbody
OBJS	= main.o

CXX		= clang++
CXXFLAGS= -std=c++1z -Wall -O3

PLUMMER_NUM	= 1000
PLUMMER_DAT	= plummer-$(PLUMMER_NUM).dat

INIT_DAT	= $(PLUMMER_DAT)
RUN_DEP		= $(TARGET) $(INIT_DAT)
RUN_FLAGS	= $(INIT_DAT)

PLOT_GIF	= out.gif

%.o : %.cc
	$(CXX) -c $< $(CXXFLAGS) -o $@

# command
default:
	make $(TARGET)

run: $(RUN_DEP)
	./$(TARGET) $(RUN_FLAGS)

plot: $(PLOT_GIF)

full: clean run plot

clean:
	rm -rf $(TARGET) mk_plummer
	rm -rf *.o
	rm -rf *.dat
	rm -rf *.gif

$(TARGET): $(OBJS)
	$(CXX) -o $@ $(OBJS)

mk_plummer.cc:
	wget http://jun.artcompsci.org/kougi/keisan_tenmongakuII/programs/simpletree/mk_plummer.C
	mv mk_plummer.C $@

$(PLUMMER_DAT): mk_plummer
	./$< -n $(PLUMMER_NUM) > $@

$(PLOT_GIF):
	gnuplot anim.gp
