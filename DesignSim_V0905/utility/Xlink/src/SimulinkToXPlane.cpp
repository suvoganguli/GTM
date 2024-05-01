//   SimulinktoXPlane - A Simulink mex-function to send and receive
//   data from the Xlink X-Plane plugin
//
//   This program is free software; you can redistribute it and/or
//   modify it under the terms of the GNU General Public License as
//   published by the Free Software Foundation; either version 2 of
//   the License, or (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//   General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with this program; if not, write to the Free Software
//   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
//   02111-1307 USA.
//
//    Note: 
//      Parts of this code are based XP-NetinputSF-ToXplane by Duncan 
//      Greer, see 
//         http://sourceforge.net/project/showfiles.php?group_id=92502
//      which in turn was based on the original Aircraft Simulation
//      and Testing Environment (ASATE) written by Iain McManus and
//      James Hutchins.
//
//      Parts of this code are based on code examples provided by the
//      creators of the X-Plane Plugin System (SDK), Ben Sputnik and
//      Sandy Barbour.
//      
//      Current version is authored by Dave Cox and Dan Hill.
//


 #define S_FUNCTION_NAME  SimulinkToXPlane
 #define S_FUNCTION_LEVEL 2
 #define NUMINPUTS 4
 #define NUMOUTPUTS 2
 #define NUMPARAMS 0

 #include <simstruc.h>  //required include

 #include "dataPacket.h"
 #include "netports.h"
 #include "PCSBSocketUDP.h"

 static void mdlInitializeSizes(SimStruct *S)
 {
  ssSetNumSFcnParams(S, NUMPARAMS);  /* Number of expected parameters */
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
	 return;
  }
  for(int para = 0; para < NUMPARAMS; ++para)
    ssSetSFcnParamTunable(S, para, SS_PRM_NOT_TUNABLE);
  ssSetNumContStates(S, 0);   /* number of continuous states   */
  ssSetNumDiscStates(S, 0);   /* number of discrete states		*/
  int q;
  if (!ssSetNumInputPorts(S, NUMINPUTS)) return;
  if (!ssSetNumOutputPorts(S, NUMOUTPUTS)) return;
  for(q = 0; q < NUMINPUTS; ++q)
    {
      ssSetInputPortRequiredContiguous(S, q, true);
    }
  //vector input 0 (port number), 
  ssSetInputPortWidth(S,  0, 6);//lat,lon,alt,Roll,Pitch,Yaw,
  ssSetInputPortDataType(S,  0, SS_DOUBLE); 
  ssSetInputPortDirectFeedThrough(S,  0, 1);

  ssSetInputPortWidth(S,  1, 6);// Surfaces
  ssSetInputPortDataType(S,  1, SS_DOUBLE); 
  ssSetInputPortDirectFeedThrough(S,  1, 1);

  ssSetInputPortWidth(S,  2, 90);// HUD Text
  ssSetInputPortDataType(S,  2, SS_UINT8); 
  ssSetInputPortDirectFeedThrough(S,  2, 1);

  ssSetInputPortWidth(S,  3, 6);// HUD Values
  ssSetInputPortDataType(S,  3, SS_DOUBLE); 
  ssSetInputPortDirectFeedThrough(S,  3, 1);

  ssSetOutputPortWidth(S,  0, 16);//Joystick Axes
  ssSetOutputPortDataType(S,  0, SS_DOUBLE); 
  ssSetOutputPortWidth(S,  1, 16);//Buttons
  ssSetOutputPortDataType(S,  1, SS_DOUBLE); 

  ssSetNumSampleTimes(   S, 1);   // number of sample times
  //Set size of the work vectors.
  ssSetNumRWork(         S, 0);   //number of real work vector elements
  ssSetNumIWork(         S, 0);   //number of integer work vector elements
  ssSetNumPWork(         S, 2);   //number of pointer work vector elements
  ssSetNumModes(         S, 0);   //number of mode work vector elements
  ssSetNumNonsampledZCs( S, 0);   //number of nonsampled zero crossings
  ssSetOptions(S, 
	       SS_OPTION_WORKS_WITH_CODE_REUSE |
	       SS_OPTION_USE_TLC_WITH_ACCELERATOR);
 } /* end mdlInitializeSizes */



 static void mdlInitializeSampleTimes(SimStruct *S)
 {
   //Register one pair for each sample time
   ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
   ssSetOffsetTime(S, 0, 0.0);
   ssSetModelReferenceSampleTimeDefaultInheritance(S); 
 } /* end mdlInitializeSampleTimes */


 #define MDL_START
 static void mdlStart(SimStruct *S)
 {
   long recvMsgSize=1;
   unsigned long XPlaneAddr;
   unsigned short XPlanePort;	
   XPtoSIM_dataPacket StatesToReceive;
   PCSBSocketUDP	*socket		= new PCSBSocketUDP(SIM_PORT);
   ssGetPWork(S)[0] = socket;
   while (recvMsgSize>0){
     recvMsgSize=socket->ReadData(&StatesToReceive, sizeof(XPtoSIM_dataPacket),
				  &XPlaneAddr,&XPlanePort);
   }
 }



 static void mdlOutputs(SimStruct *S, int_T tid)
 {
   real_T   *y1   = ssGetOutputPortRealSignal(S,0);
   real_T   *y2   = ssGetOutputPortRealSignal(S,1);
   const real_T   *u1   = ssGetInputPortRealSignal(S,0);
   const real_T   *u2   = ssGetInputPortRealSignal(S,1);
   const void     *u3   = ssGetInputPortSignal(S,2);
   const real_T   *u4   = ssGetInputPortRealSignal(S,3);
   int i=0; 
   long recvMsgSize=1;
   unsigned long XPlaneAddr;
   unsigned short XPlanePort;	

   PCSBSocketUDP *socket	=   static_cast<PCSBSocketUDP*>(ssGetPWork(S)[0]);
   SIMtoXP_dataPacket StatesToSend;
   XPtoSIM_dataPacket StatesToReceive;

   // Send Position Information
   StatesToSend.Latitude   = (double)u1[0];
   StatesToSend.Longitude  = (double)u1[1];
   StatesToSend.Elevation  = (double)u1[2];
   StatesToSend.Roll	   = (float) u1[3];
   StatesToSend.Pitch	   = (float) u1[4];
   StatesToSend.Yaw	   = (float) u1[5];
   StatesToSend.Aileron    = (float) u2[0];     
   StatesToSend.Elevator   = (float) u2[1];     
   StatesToSend.Rudder     = (float) u2[2];     
   StatesToSend.Flap       = (float) u2[3];     
   StatesToSend.Spoiler    = (float) u2[4];     
   StatesToSend.GearDown   = (int)   u2[5];
   memcpy(StatesToSend.HUDlabels,u3,90*sizeof(char)); 
   memcpy(StatesToSend.HUDvalues,u4,6*sizeof(double));
   socket->WriteData(&StatesToSend, sizeof(SIMtoXP_dataPacket), ntohl(inet_addr(PLUGIN_ADDR)), PLUGIN_PORT);

   // Receive JoyStick Commands
   while(recvMsgSize>0){  //Read all available
     recvMsgSize=socket->ReadData(&StatesToReceive, sizeof(XPtoSIM_dataPacket),&XPlaneAddr,&XPlanePort);
     if(recvMsgSize == sizeof(XPtoSIM_dataPacket)){
       for (i=0;i<16;i++){
	 y1[i]=(double)( StatesToReceive.axisDeflection[i] );
	 y2[i]=(double)( (StatesToReceive.buttonStatus&(1<<i))>>i );
       }
      }
   }
 }



static void mdlTerminate(SimStruct *S)
{
  PCSBSocketUDP	*socket			= static_cast<PCSBSocketUDP		*>(ssGetPWork(S)[0]);
  delete socket;
}
 
  /*=============================*
 * Required S-function trailer *
 *=============================*/
 
 #ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
 #include "simulink.c"      /* MEX-file interface mechanism */
 #else
 #include "cg_sfun.h"       /* Code generation registration function */
 #endif
