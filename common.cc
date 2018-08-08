#include <iostream>
#include "common.hpp"

void err_exit(const std::string& msg){
	std::cerr << msg << std::endl;
	exit(-1);
}

void load_data(const std::string& fname, simdata_t& data){
	std::ifstream file(fname);

	if(!file) err_exit("cannot open file: \"" + fname + "\"");
	file >> data.num >> data.time;
	if(file.fail()) err_exit("fail");

	if(flag_print)
		std::cout << "number of particle: " << data.num << std::endl
			<< "simulation time: " << data.time << std::endl;

	data.planet.reserve(data.num);

	if(flag_print) std::cout << "loading...\t";
	for(size_t n=0; n<data.num; n++){
		auto& p = data.planet[n];
		file >> p.mass
			>> p.pos.x >> p.pos.y >> p.pos.z
			>> p.vel.x >> p.vel.y >> p.vel.z;
		if(file.fail()) err_exit("failed.");
	}
	if(flag_print) std::cout << "finished." << std::endl;
}

void save_data(const std::size_t& count, const simdata_t& data){
	std::stringstream ss;
	ss << out_dir
		<< std::setfill('0') << std::setw(num_digits) << count
		<< ".dat";

	std::ofstream file(ss.str());
	file << data.num << std::endl
		<< data.time << std::endl;

	for(size_t n=0; n<data.num; n++){
		const auto& p = data.planet[n];
		file << p.mass << " "
			<< p.pos.x << " " << p.pos.y << " " << p.pos.z << " "
			<< p.vel.x << " " << p.vel.y << " " << p.vel.z
			<< std::endl;
	}
}
