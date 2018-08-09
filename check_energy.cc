#include <iostream>
#include <fstream>
#include <filesystem>
#include <cmath>
#include "common.hpp"

using Float = double;

void check_energy(const std::string& fname);

int main(int argc, char **argv){
	if(argc != 2) return -1;
	flag_print = false;

	if(std::filesystem::is_regular_file(argv[1]))
		check_energy(argv[1]);
	else if(std::filesystem::is_directory(argv[1])){
		std::size_t n = 0;
		for(auto& f : std::filesystem::directory_iterator(argv[1])){
			if(!std::filesystem::is_regular_file(f)) continue;
			std::string fname = f.path();
			auto ext = fname.substr(fname.length()-4);
			if(ext != ".dat") continue;
			std::cout << n << " ";
			check_energy(fname);
			n++;
		}
	}
}

void check_energy(const std::string& fname){
	simdata_t data;
	Float ke = 0.0;
	Float pe = 0.0;
	load_data(fname, data);

	for(std::size_t n1=0; n1<data.num; n1++){
		auto& p1 = data.planet[n1];
		auto& vel= p1.vel;
		auto v2  = vel.x*vel.x + vel.y*vel.y + vel.z*vel.z;
		ke += p1.mass * v2;
		for(std::size_t n2=0; n2<data.num; n2++){
			if(n1 == n2) continue;
			auto& p2 = data.planet[n2];
			auto r   = p2.pos - p1.pos;
			auto r2  = r.x*r.x + r.y*r.y + r.z*r.z;
			if(r2!=0.0) pe += -1.0 * (p1.mass * p2.mass / std::sqrt(r2));
		}
	}
	ke = 0.5 * ke;
	pe = 0.5 * pe;
	//std::cerr << "ke: " << ke << ", pe: " << pe << std::endl;
	std::cout << ke << " " << pe << " " << ke + pe << std::endl;
}
