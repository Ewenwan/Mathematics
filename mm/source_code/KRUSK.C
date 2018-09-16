#include "mex.h"
#include "stdlib.h"
#include "iostream.h"
typedef struct TR
{double fromvex,endvex;
 double length;
}edge;
void krusk(double *out,double *len,double *op,int mrows,int ncols)
{edge *T,*M,*N;
 int i,j,v,u,c,p,d,max=10000;
 edge k;
 p=0;
T=(edge *)malloc(mrows*(mrows-1)*sizeof(struct TR));
for(i=0;i<mrows;i++)
 for(j=0;j<mrows;j++)
if (*(op+i*ncols+j)<max)
{(T+p)->fromvex=i+1;
(T+p)->endvex=j+1;
(T+p)->length=*(op+i*ncols+j);
p++;
}

for(i=p-1;i>=0;--i)
{for(j=0;j<i;++j)
 {if ((T+j)->length>(T+j+1)->length)
	{k=*(T+j);
	*(T+j)=*(T+j+1);
	*(T+j+1)=k;
    }
} 
}
N=(edge *)malloc(mrows*(mrows-1)*sizeof(struct TR));
for(i=0;i<p;i++)
*(N+i)=*(T+i);
M=(edge *)malloc(mrows*(mrows-1)*sizeof(struct TR));
d=0;
for(i=0;i<p;i++)
{
if ((T+i)->fromvex!=(T+i)->endvex)
 {  *(M+d)=*(N+i);
    d++;
	if ((T+i)->endvex>(T+i)->fromvex)
	{ u=(T+i)->endvex;v=(T+i)->fromvex;}
	else
	{u=(T+i)->fromvex;v=(T+i)->endvex;}
	c=u;
	u=v;
	for(j=0;j<p;j++)
	 {if ((T+j)->fromvex==c)  
      (T+j)->fromvex=v;
      if ((T+j)->endvex==c)
     (T+j)->endvex=v;
	 }
   } 
   }
*len=0;
for(j=0;j<d;j++)
{*(out+j*2)=(M+j)->fromvex;
*(out+j*2+1)=(M+j)->endvex;
*len=*len+(M+j)->length;
}
}   

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{double *out;
 double *op;
 double *len;
 int mrows,ncols;
 op=mxGetPr(prhs[0]);
 mrows=mxGetM(prhs[0]);
 ncols=mxGetN(prhs[0]);
 plhs[0]=mxCreateDoubleMatrix(2,mrows-1,mxREAL);
 plhs[1]=mxCreateDoubleMatrix(1,1,mxREAL);
out=mxGetPr(plhs[0]);
 len=mxGetPr(plhs[1]);
krusk(out,len,op,mrows,ncols);
}
