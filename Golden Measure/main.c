#include "main.h"
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

void golden_measure(){
    int i, j, k;
    float result;
    //loop controls how many times the MM is performed.
    for (int c = 0; c < 1000; c++){
        for(j = 0; j < N; j++){
            for(i = 0; i < N; i++){
                result = 0;
                for(k = 0; k < N; k++){
                    result += A[N*i + k] * B[N*k + j];
                }
            OutputGM[N*j + i] = result;
        }
    }
}

 
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
void Fill(float* A,int write){
    
    int i, j;
           
    for(j = 0; j < N; j++){
        for(i = 0; i < N; i++){
            float res= i+j;
            A[N*j + i] = res;
            //print to screen to show matrix entries.
            if (write==1){                
                printf("%d ",i+j);
             }
            
        }
    }
    

    
}
//------------------------------------------------------------------------------

int main(){
 
 
 N = 24;
 size_t BufferSize = N*N*sizeof(float);

 // Allocate CPU RAM
 A = (float*)malloc(BufferSize);
 B = (float*)malloc(BufferSize);

 OutputGM = (float*)malloc(BufferSize);

//Fill matrices with floats, do not need to be complicated as 
 Fill(A,1);
 Fill(B,0);

 // Process the matrices
 tic();
 golden_measure();
 double time= toc()/1e-3;
 printf("Golden measure time for size %d: %lg ms\n",N,time);

 return 0;
}
//------------------------------------------------------------------------------
