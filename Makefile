CC = mpicc
CXX = mpic++
CFLAGS = -O3 -fopenmp
CXXFLAGS = -O3 -fopenmp
LDFLAGS = -lm

all: cardiacsim

cardiacsim: cardiac.o plot.o
	$(CXX) $(CXXFLAGS) -o cardiacsim cardiac.o plot.o $(LDFLAGS)

cardiac.o: cardiac.c
	$(CXX) $(CXXFLAGS) -c cardiac.c

plot.o: plot.c
	$(CC) $(CFLAGS) -c plot.c

clean:
	rm -f cardiacsim *.o *.tmp

















# muradtadesse@muradtadesse-HP-Pavilion-Laptop-14-bf1xx:~/Desktop/MSc in AI/Year 2 Semester 1/DAI/Assignments/Assignment 3$ mpirun -n 4 ./cardiacsim -n 400 -t 200 -x 2 -y 2 -p 50 -nt 2
# number of processes : 4
# Grid Size       : 400
# Duration of Sim : 200
# Time step dt    : 0.0223951
# Process geometry: 2 x 2

# Size of local grid          : 40000
# Number of Iterations        : 8931
# Elapsed Time (sec)          : 9.61357
# Sustained Gflops Rate       : 4.16192
# Sustained Bandwidth (GB/sec): 4.75648


