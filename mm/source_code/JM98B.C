/*
98年全国大学生数学建模竞赛B题"水灾巡视问题"模拟退火算法。
这是一个推销员问题，本题有53个点，所有可能性大约为exp(53),目前没有好方法求出精确解，既然求不出精确解，我们使用模拟退火法求出一个较优解,将所有结点编号为1到53,1到53的排列就是系统的结构,结构的变化规则是:从1到53的排列中随机选取一个子排列,将其反转或将其移至另一处,能量E自然是路径总长度。具体算法描述如下：
步1：设定初始温度T，给定一个初始的巡视路线。
步2：步3 --8循环K次
步3：步 4--7循环M次
步4：随机选择路线的一段
步5：随机确定将选定的路线反转或移动，即两种调整方式：反转、移动。
步6：计算代价D，即调整前后的总路程的长度之差
步7：按照如下规则确定是否做调整：
如果D<0,则调整
如果D>0,则按照EXP(-D/T)的概率进行调整
步8:T*0.9-->T,降温
*/

#include <stdio.h>
#include <math.h>
#define TFACTR  0.9
#define MAX 10000.0
#define MBIG 1000000000
#define MSEED 161803398
#define MZ 0
#define FAC (1.0/MBIG)
float weight[54][54];
int iorder[54];
void anneal (int ncity)

{ int irbit(unsigned long *iseed);

int metrop(float de,float t);
float ran(long *idum);
float reverse_len(int ncity,int n[]);
void reverse(int ncity,int n[]);
float transe_len(int ncity,int n[]);
void transe(int ncity,int n[]);
int ans,nover,nlimit,i1,i2;
int i,j,nsucc,nn,idec;
unsigned long k;
static int n[7];
long idum;
unsigned long iseed;
float path,de,t,T;
nlimit=100*ncity;/*max succ try numbers */
path =0.0;

for(i=1;i<ncity;i++){ /* primitive path length */
		 i1=iorder[i];
		 i2=iorder[i+1];
		  path+=weight[i1][i2];
		 }
       i1=iorder[ncity];
       i2=iorder[1];
	 path+=weight[i1][i2];
	idum=-1;
	iseed=111;
      T=2.8 ;
	for(j=1;j<=30;j++){
		     nsucc=0;
	     for(k=1;k<=20000;k++){
				     do { n[1]=1+(int)(ncity*ran(&idum));
				      n[2]=1+(int)((ncity-1)*ran(&idum));
				      if(n[2]>=n[1]) ++n[2];
				      nn=1+((n[1]-n[2]+ncity-1)%ncity);
				      } while (nn<3);
	      idec=irbit(&iseed);

	      if(idec==0){
			 n[3]=n[2]+(int) (abs(nn-2)*ran(&idum))+1;
			 n[3]=1+((n[3]-1)%ncity);
			 de=transe_len(ncity,n);
			 ans=metrop(de,T);
			 if (ans){ ++nsucc;
				   path+=de;
				   transe(ncity,n);
				   }
			    }
		 else {
			       de=reverse_len(ncity,n);
			       ans=metrop(de,T);
			       if (ans) {++nsucc;
				  path+=de;
				  reverse(ncity,n);
				  }
		       }
		if(nsucc>=nlimit) break;
			}

	      printf("\n %s %10.6f %s %10.6f   j=%d","T=",T,"path len=",path,j);
	      printf("successful moves: %6d\n",nsucc);

	     for(i=1;i<=53;i++) printf("\%5d",iorder[i]);




	      T*=TFACTR;
	      if(nsucc==0) return;
	      }


	  }

float reverse_len(int ncity,int n[])
	{
	 float de;
         int xx[5],yy[5];
	 int j,ii;
	 n[3]=1+((n[1]+ncity-2)%ncity);
	 n[4]=1+(n[2]%ncity);
	 for(j=1;j<=4;j++) {
			     xx[j]=iorder[n[j]];
			}
		     de=-weight[xx[1]][xx[3]];
		     de-=weight[xx[2]][xx[4]];
		     de+=weight[xx[1]][xx[4]];
		     de+=weight[xx[2]][xx[3]];

		      return de;
		      }

  void reverse (int ncity,int n[])
  {  int nn,j,k,l,itmp;
   nn=(1+((n[2]-n[1]+ncity)%ncity))/2;
   for(j=1;j<=nn;j++){ k=1+((n[1]+j-2)%ncity);
		       l=1+((n[2]-j+ncity)%ncity);
		       itmp=iorder[k];
		       iorder[k]=iorder[l];
		       iorder[l]=itmp;
		       }
    }

   float transe_len(int ncity,int n[])
   {
       float /*xx[7],yy[7],*/ de;
       int j,ii,xx[7];
       n[4]=1+(n[3]%ncity);
       n[5]=1+((n[1]+ncity-2)%ncity);
       n[6]=1+(n[2]%ncity);
       for(j=1;j<=6;j++){
			 /*ii=iorder[n[j]];
			 xx[j]=x[ii];
			 yy[j]=y[ii];*/
                     xx[j]=iorder[n[j]];
			 }
    de=-weight[xx[2]][xx[6]];
    de-=weight[xx[1]][xx[5]];
    de-=weight[xx[3]][xx[4]];
    de+=weight[xx[1]][xx[3]];
    de+=weight[xx[2]][xx[4]];
    de+=weight[xx[5]][xx[6]];
       return de;
       }
    void transe(int ncity,int n[])
    {
      int m1,m2,m3,nn,j,jj,jorder[100];
      m1=1+((n[2]-n[1]+ncity) %ncity); /* n[1] to n[2] city numbers*/
      m2=1+((n[5]-n[4]+ncity) %ncity); /*n[4] to n[5]  */

      m3=1+((n[3]-n[6]+ncity) %ncity);  /*n[3].. n[6]  .....*/
      nn=1;
      for(j=1;j<=m1;j++)
		     {jj=1+((j+n[1]-2)%ncity);
		     jorder[nn++]=iorder[jj];
		     }
       if(m2>0) for(j=1;j<=m2;j++)
			 { jj=1+((j+n[4]-2)%ncity);
			 jorder[nn++]=iorder[jj];
			 }
	if(m3>0) for(j=1;j<=m3;j++){ jj=1+((j+n[6]-2)%ncity);
				     jorder[nn++]=iorder[jj];
				     }
	 for(j=1;j<=ncity;j++)
	 iorder[j]=jorder[j];
	 }
 int metrop(float de,float t)
 {
      float ran(long *idum);
      static long gljdum=1;
      return de<0.0 ||ran(&gljdum)<exp(-de/t);
  }
float ran(long *idum)
{static int inext,inextp;
 static long ma[56];
 static int iff=0;
 long mj,mk;
 int i,ii,k;
 if(*idum<0||iff==0) {
		      iff=1;
		      mj=MSEED-(*idum<0?-*idum:*idum);
		      mj%=MBIG;
		      ma[55]=mj;
		      mk=1;
		      for(i=1;i<54;i++){
					ii=(21*i)%55;
					ma[ii]=mk;
					mk=mj-mk;
					if(mk<MZ)mk+=MBIG;
					mj=ma[ii];
			}
			for(k=1;k<=4;k++)
			     for(i=1;i<=55;i++){
				   ma[i]-=ma[1+(i+30)%55];
				   if(ma[i]<MZ) ma[i]+=MBIG;
				   }
			 inext=0;
			 inextp=31;
			 *idum=1;
		     }
    if(++inext==56)inext=1;
    if(++inextp==56) inextp=1;
    mj=ma[inext]-ma[inextp];
    if(mj<MZ) mj+=MBIG;
    ma[inext]=mj;
    return mj*FAC;
    }
 int irbit(unsigned long *iseed)
 {
     unsigned long newbit;
      newbit=(*iseed &131072)>>17
	    ^(*iseed&16)>>4
	      ^(*iseed &2)>>1
	      ^(*iseed &1);
	      *iseed=(*iseed<<1)|newbit;
	      return newbit;
}
main()
{

    int ncity=53;
  int i,j,k,l;
  for(i=0;i<=53;i++) iorder[i]=i;
  for(i=1;i<=53;i++)
  for(j=1;j<=53;j++)
  weight[i][j]=0;

weight[53][1]=6;
weight[53][50]=10.1;
weight[1][38]=11.2;
weight[3][39]=8.2;
 weight[5][39]=11.3;
 weight[6][48]=9.5;
 weight[8][40]=8;
weight[11][40]=14.2;
weight[12][42]=7.8;
weight[13][44]=16.4;
weight[15][44]=8.8;
weight[17][46]=9.8;
weight[19][20]=9.3;
weight[20][25]=6.5;
weight[21][46]=4.1;
weight[23][49]=7.9;
weight[25][49]=8.8;
weight[27][28]=7.9;
weight[29][51]=7.2;
weight[31][32]=8.1;
weight[33][35]=20.3;
weight[34][37]=17.6;
weight[44][45]=15.8;
weight[53][2]=9.2;
weight[53][52]=12.9;
weight[2][3]=4.8;
weight[4][8]=20.4;
weight[5][48]=11.4;
weight[7][39]=15.1;
weight[9][40]=7.8;
weight[11][42]=6.8;
weight[12][43]=10.2;
weight[13][45]=9.8;
weight[16][17]=6.8;
weight[18][44]=8.2;
weight[19][45]=8.1;
weight[20][47]=5.5;
weight[22][23]=10;
weight[24][27]=18.8;
weight[26][27]=7.8;
weight[28][50]=12.1;
weight[29][52]=7.9;
weight[31][33]=7.3;
weight[33][36]=7.4;
weight[36][37]=12.2;
weight[48][49]=14.2;
weight[53][38]=11.5;
weight[1][36]=10.3;
weight[2][5]=8.3;
weight[4][39]=12.7;
weight[6][7]=7.3;
weight[7][40]=7.2;
weight[9][41]=5.6;
weight[11][45]=13.2;
weight[13][14]=8.6;
weight[14][15]=15;
weight[16][44]=11.8;
weight[18][45]=8.2;
weight[19][47]=7.2;
weight[21][23]=9.1;
weight[22][46]=10.1;
weight[24][49]=13.2;
weight[26][49]=10.5;
weight[28][51]=8.3;
weight[30][32]=10.3;
weight[31][52]=9.2;
weight[34][35]=8.2;
weight[36][52]=8.8;
weight[53][48]=19.8;
weight[1][37]=5.9;
weight[3][38]=7.9;
weight[5][6]=9.7;
weight[6][47]=11.8;
weight[7][47]=14.5;
weight[10][41]=10.8;
weight[12][41]=12.2;
weight[13][42]=8.6;
weight[14][43]=9.9;
weight[17][22]=6.7;
weight[18][46]=9.2;
weight[20][21]=7.9;
weight[21][25]=7.8;
weight[23][24]=8.9;
weight[25][48]=12;
weight[26][50]=10.5;
weight[29][50]=15.2;
weight[30][51]=7.7;
weight[32][35]=14.9;
weight[34][36]=11.5;
weight[37][38]=11;
for(i=1;i<=53;i++)
for(j=1;j<=53;j++)
if(weight[i][j]!=0)weight[j][i]=weight[i][j];
for(i=1;i<=53;i++)
for(j=1;j<=53;j++)
if(weight[i][j]==0) weight[i][j]=MAX;
  for(k=1;k<=53;k++)
   for(i=1;i<=53;i++)
   for(j=1;j<=53;j++)

if(!(i==j)&&!(i==k)&&!(k==j))
  if( weight[i][k]+weight[k][j]<weight[i][j])
    weight[i][j]=weight[i][k]+weight[k][j] ;
 printf("\n");



anneal(ncity);

for(i=1;i<=53;i++) printf("\%5d",iorder[i]);
}








