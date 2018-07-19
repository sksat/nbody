#include <iostream>
#include <chrono>

void main_loop();

int main(int argc, char **argv){
	using namespace std::chrono;
	using clock = high_resolution_clock;

	std::cout<<"simulation start"<<std::endl;

	clock::time_point begin, end;
	begin = clock::now();
	main_loop();
	end = clock::now();

	auto diff = duration_cast<milliseconds>(end - begin);

	std::cout<<"time "
		<< static_cast<double>(diff.count())/1000<<" sec"<<std::endl;
	std::cout<<"simulation end"<<std::endl;
}

void main_loop(){
	for(int i=0;i<100000;i++) std::cout<<i<<std::endl;
}
