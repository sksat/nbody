#include <chrono>
#include <cmath>
#include "common.hpp"

Float time_max		= 1000.0;
Float dt		= 0.0001;

void main_loop(simdata_t& sim);

int main(int argc, char **argv){
	// init
	if(argc != 6) return -1;
	out_dir = argv[2];
	num_digits = std::atoi(argv[3]);
	dt = std::atof(argv[4]);
	time_max = std::atof(argv[5]);

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

void main_loop(simdata_t &sim){
	size_t loop_count = 0;
	bool lf_flag = 0;

	const size_t percentage_interval= time_max / (dt*100);
	const size_t save_interval		= 100;

	while(true){
		if(sim.time > time_max) break;

		if(loop_count % percentage_interval == 0){
			std::cout << std::setw(3) << loop_count/percentage_interval << "%\t"
				<< "time: " << std::setw(10) << sim.time << std::endl;
		}

		// calc acc
		#pragma omp parallel for
		for(size_t n1=0;n1<sim.num;n1++){
			auto& p1 = sim.planet[n1];
			auto& acc= p1.acc[lf_flag];
			acc = {};
			#pragma omp parallel for
			for(size_t n2=0;n2<sim.num;n2++){
				if(n1 == n2) continue;
				auto& p2 = sim.planet[n2];
				auto r = p2.pos - p1.pos;
				auto r2= r.x*r.x + r.y*r.y + r.z*r.z;
				auto r_= std::sqrt(r2);
				if(r_ == 0.0) continue;
				acc += r * (p2.mass / (r2 * r_));
			}
		}

		// time step
		#pragma omp parallel for
		for(size_t n=0;n<sim.num;n++){
			auto& p = sim.planet[n];

			//p.vel += p.acc[lf_flag] * dt;
			//p.pos += p.vel * dt;

			// leap flog
			p.pos += p.vel * dt + 0.5 * p.acc[lf_flag] * dt * dt;
			p.vel += 0.5 * (p.acc[!lf_flag] + p.acc[lf_flag]) * dt;
		}

		if(loop_count % save_interval == 0){
			save_data(loop_count/save_interval, sim);
		}

		sim.time += dt;
		loop_count++;
		lf_flag = !lf_flag;
	}
}
