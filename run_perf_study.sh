#!/bin/bash
# Save as run_perf_study.sh

echo "Starting Performance Studies..."

# Part A: Strong scaling study (N=1024, T=100)
echo "Part A: Strong Scaling Study" > scaling_results.txt
echo "Processes,Geometry,Gflops" >> scaling_results.txt

# Single process
mpirun -n 1 ./cardiacsim -n 1024 -t 100 -x 1 -y 1 -p 0 | grep "Sustained Gflops Rate" | awk '{print "1,1x1,"$4}' >> scaling_results.txt

# 2 processes
mpirun -n 2 ./cardiacsim -n 1024 -t 100 -x 2 -y 1 -p 0 | grep "Sustained Gflops Rate" | awk '{print "2,2x1,"$4}' >> scaling_results.txt
mpirun -n 2 ./cardiacsim -n 1024 -t 100 -x 1 -y 2 -p 0 | grep "Sustained Gflops Rate" | awk '{print "2,1x2,"$4}' >> scaling_results.txt

# 4 processes
mpirun -n 4 ./cardiacsim -n 1024 -t 100 -x 2 -y 2 -p 0 | grep "Sustained Gflops Rate" | awk '{print "4,2x2,"$4}' >> scaling_results.txt

# Part B: Communication overhead study
echo "Part B: Communication Overhead Study" > comm_overhead.txt
echo "N,With_Comm,Without_Comm,Overhead_Percent" >> comm_overhead.txt

N=1024
while [ $N -ge 100 ]; do
    # With communication
    WITH_COMM=$(mpirun -n 4 ./cardiacsim -n $N -t 100 -x 2 -y 2 -p 0 | grep "Sustained Gflops Rate" | awk '{print $4}')
    
    # Without communication
    WITHOUT_COMM=$(mpirun -n 4 ./cardiacsim -n $N -t 100 -x 2 -y 2 -p 0 -c 1 | grep "Sustained Gflops Rate" | awk '{print $4}')
    
    # Calculate overhead
    OVERHEAD=$(echo "scale=2; ($WITHOUT_COMM-$WITH_COMM)/$WITHOUT_COMM*100" | bc)
    echo "$N,$WITH_COMM,$WITHOUT_COMM,$OVERHEAD" >> comm_overhead.txt
    
    # Shrink N by factor of 1.4
    N=$(echo "scale=0; $N/1.4" | bc)
done

# Part C: MPI+OpenMP study (adjusted for your system)
echo "Part C: Hybrid MPI+OpenMP Study" > hybrid_results.txt
echo "Processes,Threads,Gflops" >> hybrid_results.txt

for p in 2 4; do
    for t in 2 4; do
        mpirun -n $p ./cardiacsim -n 1024 -t 100 -x $p -y 1 -nt $t -p 0 | grep "Sustained Gflops Rate" | awk '{print "'$p','$t',"$4}' >> hybrid_results.txt
    done
done

echo "Performance studies completed. Results saved in scaling_results.txt, comm_overhead.txt, and hybrid_results.txt"