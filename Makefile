TARGET	= nbody
OBJS	= main.o

CXX		= clang++
CXXFLAGS= -std=c++1z -Wall -O3

%.o : %.cc
	$(CXX) -c $< $(CXXFLAGS) -o $@

# command
default:
	make $(TARGET)

run: $(TARGET)
	./$(TARGET)

$(TARGET): $(OBJS)
	$(CXX) -o $@ $(OBJS)
