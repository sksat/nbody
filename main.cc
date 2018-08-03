#include <iostream>
#include <iomanip>
#include <sstream>
#include <fstream>
#include <vector>
#include <chrono>
#include <sksat/math/vector.hpp>

using Float = double; // 浮動小数点数

struct planet_t {
	sksat::math::vector<Float> pos, vel, acc;
	Float mass;
};

struct simdata_t {
	size_t num; // number of particle
	Float time; // simulation time
	std::vector<planet_t> planet;
};

constexpr Float time_max				= 1000.0;
constexpr Float dt						= 0.001;
constexpr size_t percentage_interval	= time_max / (dt*100) ;
constexpr size_t save_interval			= 100;

// util
void err_exit(const std::string& msg);

void load_data(const std::string& fname, simdata_t& data);
void save_data(const size_t &count, const simdata_t& data);
void main_loop(simdata_t& sim);

int main(int argc, char **argv){
	// init
	if(argc != 2) return -1;

	// load data
	simdata_t sim;
	load_data(argv[1], sim);

	// simulation
	using namespace std::chrono;
	using clock = high_resolution_clock;
	std::cout<<"simulation start"<<std::endl;

	clock::time_point begin, end;

	// main loop
	begin = clock::now();
	main_loop(sim);
	end = clock::now();

	auto diff = duration_cast<milliseconds>(end - begin);

	std::cout<<"time "
		<< static_cast<double>(diff.count())/1000<<" sec"<<std::endl;
	std::cout<<"simulation end"<<std::endl;
}

void err_exit(const std::string& msg){
	std::cerr<<msg<<std::endl;
	exit(-1);
}

void load_data(const std::string& fname, simdata_t& data){
	std::ifstream ifs(fname);

	if(!ifs) err_exit("cannot open file: \"" + fname + "\"");
	ifs >> data.num >> data.time;
	if(ifs.fail()) err_exit("fail");

	std::cout << "number of particle: " << data.num << std::endl
		<< "simulation time: " << data.time << std::endl;

	data.planet.reserve(data.num);

	std::cout << "loading...\t";
	for(size_t n=0;n<data.num;n++){
		auto& p = data.planet[n];
		ifs >> p.mass
			>> p.pos.x >> p.pos.y >> p.pos.z
			>> p.vel.x >> p.vel.y >> p.vel.z;
		if(ifs.fail()) err_exit("failed");
	}
	std::cout<<"finished"<<std::endl;
}

void save_data(const size_t& count, const simdata_t& data){
	std::stringstream ss;
	ss << "out-"
		<< std::setfill('0') << std::setw(10) << count
		<< ".dat";
	std::ofstream ofs(ss.str());
	ofs << data.num << std::endl
		<< data.time << std::endl;

	for(size_t n=0;n<data.num;n++){
		const auto& p = data.planet[n];
		ofs << p.mass << " "
			<< p.pos.x << " " << p.pos.y << " " << p.pos.z << " "
			<< p.vel.x << " " << p.vel.y << " " << p.vel.z
			<< std::endl;
	}
}

void main_loop(simdata_t &sim){
	size_t loop_count = 0;
	while(true){
		if(sim.time > time_max) break;

		if(loop_count % percentage_interval == 0){
			std::cout << std::setw(3) << loop_count/percentage_interval << "%\t"
				<< "time: " << std::setw(10) << sim.time << std::endl;
		}

		// time step
		for(size_t n1=0;n1<sim.num;n1++){
			// 重力相互作用なんてなかったんや
			auto& p1 = sim.planet[n1];
			p1.pos += p1.vel * dt;
		}

		if(loop_count % save_interval == 0){
			save_data(loop_count/save_interval, sim);
		}

		sim.time += dt;
		loop_count++;
	}
}
