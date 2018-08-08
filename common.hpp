#ifndef UTIL_HPP_
#define UTIL_HPP_

#include <iostream>
#include <iomanip>
#include <sstream>
#include <fstream>
#include <vector>
#include <sksat/math/vector.hpp>

using Float = double;

struct planet_t {
	sksat::math::vector<Float> pos, vel, acc[2];
	Float mass;
};

struct simdata_t {
	std::size_t num; // number of particle
	Float time; // simulation time
	std::vector<planet_t> planet;
};

inline std::string out_dir		= "out/";
inline std::size_t num_digits	= 10;

void err_exit(const std::string& msg);

void load_data(const std::string& fname, simdata_t& data);
void save_data(const std::size_t& count, const simdata_t& data);

#endif
