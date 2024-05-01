//   MatlabToXplane Matlab mex-function to send data to the Xlink X-Plane plugin
//
//   This program is free software; you can redistribute it and/or modify it under 
//   the terms of the GNU General Public License as published by the Free Software 
//   Foundation; either version 2 of the License, or (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT ANY 
//   WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR 
//   A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License along with 
//   this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, 
//    Suite 330, Boston, MA 02111-1307 USA.

#include <string.h>
#include "mex.h"
#include "dataPacket.h"
#include "netports.h"
#include "PCSBSocketUDP.h"

PCSBSocketUDP *UDPSocket=NULL;

void SendUDP(double *pos, double *surf, char *HUDlabels, double *HUDvalues,int stage,
	     double *y1, double *y2 ){
  long recvMsgSize=1;
  int i;
  unsigned long XPlaneAddr;
  unsigned short XPlanePort;	
  SIMtoXP_dataPacket StatesToSend;
  XPtoSIM_dataPacket StatesToReceive;
  
  switch(stage){
  case 0: // Initialize
    if (UDPSocket!=NULL){
      mexPrintf("Socket Already Initialized\n");
      break;
    }
    UDPSocket = new PCSBSocketUDP(SIM_PORT);
    while (recvMsgSize>0){
      recvMsgSize=UDPSocket->ReadData(&StatesToReceive, sizeof(XPtoSIM_dataPacket),
    				  &XPlaneAddr,&XPlanePort);
    }
    for (i=0;i<16;i++){y1[i]=0; y2[i]=0;}
    break;
  case 1:
    if (UDPSocket==NULL){
      mexPrintf("Socket Not Initialized\n");
      break;
    }
    // Send Position Information
    StatesToSend.Latitude   = (double)pos[0];
    StatesToSend.Longitude  = (double)pos[1];
    StatesToSend.Elevation  = (double)pos[2];
    StatesToSend.Roll	   = (float) pos[3];
    StatesToSend.Pitch	   = (float) pos[4];
    StatesToSend.Yaw	   = (float) pos[5];
    StatesToSend.Aileron    = (float) surf[0];     
    StatesToSend.Elevator   = (float) surf[1];     
    StatesToSend.Rudder     = (float) surf[2];     
    StatesToSend.Flap       = (float) surf[3];     
    StatesToSend.Spoiler    = (float) surf[4];     
    StatesToSend.GearDown   = (int)   surf[5];
    memcpy(StatesToSend.HUDlabels,HUDlabels,90*sizeof(char)); 
    memcpy(StatesToSend.HUDvalues,HUDvalues,6*sizeof(double));
    UDPSocket->WriteData(&StatesToSend, sizeof(SIMtoXP_dataPacket), 
			 ntohl(inet_addr(PLUGIN_ADDR)), PLUGIN_PORT);
   // Receive JoyStick Commands
   while(recvMsgSize>0){  //Read all available
     recvMsgSize=UDPSocket->ReadData(&StatesToReceive,sizeof(XPtoSIM_dataPacket),
				     &XPlaneAddr,&XPlanePort);
     if(recvMsgSize == sizeof(XPtoSIM_dataPacket)){// If msg is valid
       for (i=0;i<16;i++){
	 y1[i]=(double)( StatesToReceive.axisDeflection[i] );
	 y2[i]=(double)( (StatesToReceive.buttonStatus&(1<<i))>>i);
       }
     
      }
   }
    break;
  case 2:
    if (UDPSocket==NULL){
      mexPrintf("Socket Already Closed\n");
      break;
    }
    delete UDPSocket;
    UDPSocket=NULL;
    for (i=0;i<16;i++){y1[i]=0; y2[i]=0;}
    break;
  }
}


void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
{
  double   *pos, *surf, *values, *stage, *y1, *y2;
  char *labels;
  int i;
  if (nrhs != 5) {mexErrMsgTxt("Matlab2XPlane requires five input arguments.");}
  if (nlhs != 2) {mexErrMsgTxt("Matlab2XPlane requires two output arguments.");}
  pos = (double *) mxGetPr(prhs[0]);
  surf = (double *) mxGetPr(prhs[1]);
  labels = (char *) mxGetPr(prhs[2]);
  values= (double *) mxGetPr(prhs[3]);
  stage = (double *) mxGetPr(prhs[4]);
  plhs[0] = mxCreateDoubleMatrix(16, 1, mxREAL); 
  plhs[1] = mxCreateDoubleMatrix(16, 1, mxREAL); 
  y1=mxGetPr(plhs[0]);
  y2=mxGetPr(plhs[1]);
  SendUDP(pos,surf,labels,values,(int)stage[0],  y1,y2);
  return;
}



