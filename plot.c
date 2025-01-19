#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void splot(double **E, double T, int niter, int m, int n) {
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    
    // Only rank 0 should do the plotting
    if (rank != 0) return;

    // Create data file
    FILE *fp = fopen("cardiac_data.tmp", "w");
    if (!fp) {
        printf("Error: Cannot create data file\n");
        return;
    }

    // Write data in matrix format for gnuplot
    for (int i = 1; i < m-1; i++) {
        for (int j = 1; j < n-1; j++) {
            fprintf(fp, "%d %d %lf\n", j, i, E[i][j]);
        }
        fprintf(fp, "\n");  // Empty line between rows for gnuplot
    }
    fclose(fp);

    // Create gnuplot script
    FILE *gp = popen("gnuplot -persist", "w");
    if (!gp) {
        printf("Error: Cannot open gnuplot\n");
        return;
    }

    // Send commands to gnuplot
    fprintf(gp, "set terminal x11\n");  // Use X11 terminal
    fprintf(gp, "set title 'Cardiac Simulation T=%g, Iteration=%d'\n", T, niter);
    fprintf(gp, "set xlabel 'X'\n");
    fprintf(gp, "set ylabel 'Y'\n");
    fprintf(gp, "set pm3d map\n");
    fprintf(gp, "set palette defined (0 'blue', 0.5 'white', 1 'red')\n");
    fprintf(gp, "splot 'cardiac_data.tmp' using 1:2:3 with pm3d notitle\n");
    
    // Ensure all commands are sent
    fflush(gp);
    
    // Close gnuplot
    pclose(gp);

    // Clean up temporary files
    remove("cardiac_data.tmp");
}