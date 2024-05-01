//   Xlink - An X-Plane Plugin to receive aircraft data from Matlab(R) Simulink(TM)
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
//      Parts of this code are based XP-Netinput by Duncan Greer, see 
//         http://sourceforge.net/project/showfiles.php?group_id=92502&package_id=188784
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

#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <string>
#include <cmath>
#include <map>
// XPML200 needs to be defined for Version 2 of the SDK
#ifdef IBM
   #define XPLM200 =0
#else
   #define XPLM200 =1
#endif
#include <XPLM/XPLMPlugin.h>
#include <XPLM/XPLMDisplay.h>
#include <XPLM/XPLMGraphics.h>
#include <XPLM/XPLMMenus.h>
#include <XPLM/XPLMUtilities.h>
#include <PCSBSocketUDP.h>

#include "SMLog.h"
#include "Xlink.h"
#include "netports.h"
#include "DataManager.h"
#include "JoystickData.h"


// These are the data structures to be sent via UDP
SIMtoXP_dataPacket recvPacket;
XPtoSIM_dataPacket sendPacket;

// Classes for the XPlane and Joystick datarefs.
DataManager *dataMan;
JoystickData *joystickData;

// Overlay Windows
XPLMWindowID simInternalDataPeekWindow = NULL;
XPLMWindowID simSimDataOverlayWindow = NULL;
XPLMWindowID simUDPComWindow = NULL;

// Commands handlers for custom button reads
XPLMCommandRef XlinkCommand[16];

SMLog *debugLog;

std::string   menuClickBuffer = "Menu Click: n/a";

// Plugin State Flags
bool socketON = false;
bool showInternalDataPeek = false;
bool showSimDataOverlay = false;

// Assign identifiers to buttons
int ButtonNum[16]={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};


// Internal Functions
int UDPcom();
int XlinkCommandHandler(XPLMCommandRef        inCommand,
			XPLMCommandPhase     inPhase,
			void *   );


// Required Functions for XPlane Plugin
PLUGIN_API int XPluginStart(char *outName, char *outSig, char *outDesc)
{
  char strBuffer1[100],strBuffer2[100];
  int i;
  /* First we must fill in the passed in buffers to describe our
   * plugin to the plugin-system. */
  debugLog = new SMLog();
  SMLog::getSingleton().initialize("SIMtoXPlane_debug.log");

  SMLog::getSingleton().logMessage("Initializing Log...preparing for Datamanager.");
  dataMan = new DataManager();

  SMLog::getSingleton().logMessage("Initializing joystick data state monitor.");
  joystickData = new JoystickData();


  strcpy(outName, "Xlink");
  strcpy(outSig, "sim.Xlink");
  strcpy(outDesc, "Receives flight simulation data from Simulink, returns Joystick commands");

  //getscreen resolution
  XPLMDataRef width = XPLMFindDataRef("sim/graphics/view/window_width");
  XPLMDataRef height= XPLMFindDataRef("sim/graphics/view/window_height");  

  // Register handelers for joystick buttons
  for (i=0;i<16;i++){
    sprintf(strBuffer1,"Xlink/ButtonPress%02d",i);
    sprintf(strBuffer2,"Joystick Button-%02d Xlink",i);
    XlinkCommand[i]=XPLMCreateCommand(strBuffer1,strBuffer2);
    XPLMRegisterCommandHandler(XlinkCommand[i], XlinkCommandHandler, 1,ButtonNum+i);
  }


  // Initialize the joystick Data references in XPlane
  JoystickData &ref   = JoystickData::getSingleton();
  ref.isJoystick      = XPLMFindDataRef("sim/joystick/has_joystick");
  ref.mouseSub        = XPLMFindDataRef("sim/joystick/mouse_is_joystick");
  ref.axesValues      = XPLMFindDataRef("sim/joystick/joystick_axis_values");

  //initialize the core data refs
  DataManager &dRef = DataManager::getSingleton();
  dRef.lon    = XPLMFindDataRef("sim/flightmodel/position/longitude");
  dRef.lat    = XPLMFindDataRef("sim/flightmodel/position/latitude");
  dRef.elev   = XPLMFindDataRef("sim/flightmodel/position/elevation");
  dRef.x_local= XPLMFindDataRef("sim/flightmodel/position/local_x");
  dRef.y_local= XPLMFindDataRef("sim/flightmodel/position/local_y");
  dRef.z_local= XPLMFindDataRef("sim/flightmodel/position/local_z");
  dRef.phi    = XPLMFindDataRef("sim/flightmodel/position/phi");
  dRef.theta  = XPLMFindDataRef("sim/flightmodel/position/theta");
  dRef.psi    = XPLMFindDataRef("sim/flightmodel/position/psi");

  // Get surface data references, these change for every aircraft - here set to B777
  dRef.lElevator[0]   = XPLMFindDataRef("sim/flightmodel/controls/hstab1_elv1def");//Elevator deflection
  dRef.lElevator[1]   = XPLMFindDataRef("sim/flightmodel/controls/hstab1_elv2def");//Elevator deflection
  dRef.lElevator[2]   = XPLMFindDataRef("sim/flightmodel/controls/hstab2_elv1def");//Elevator deflection
  dRef.lElevator[3]   = XPLMFindDataRef("sim/flightmodel/controls/hstab2_elv2def");//Elevator deflection
  dRef.lRudder[0]     = XPLMFindDataRef("sim/flightmodel/controls/vstab1_rud1def");//Rudder deflection
  dRef.lRudder[1]     = XPLMFindDataRef("sim/flightmodel/controls/vstab1_rud2def");//Rudder deflection
  dRef.lRudder[2]     = XPLMFindDataRef("sim/flightmodel/controls/vstab2_rud1def");//Rudder deflection
  dRef.lRudder[3]     = XPLMFindDataRef("sim/flightmodel/controls/vstab2_rud2def");//Rudder deflection
  dRef.lAileron[0]    = XPLMFindDataRef("sim/flightmodel/controls/wing1l_ail1def");//Aileron deflection
  dRef.lAileron[1]    = XPLMFindDataRef("sim/flightmodel/controls/wing3l_ail2def");//Aileron deflection
  dRef.lAileron[2]    = XPLMFindDataRef("sim/flightmodel/controls/wing1r_ail1def");//Aileron deflection
  dRef.lAileron[3]    = XPLMFindDataRef("sim/flightmodel/controls/wing3r_ail2def");//Aileron deflection
  dRef.lFlap[0]       = XPLMFindDataRef("sim/flightmodel/controls/wing1l_fla1def");//Flap deflection
  dRef.lFlap[1]       = XPLMFindDataRef("sim/flightmodel/controls/wing2l_fla1def");//Flap deflection
  dRef.lFlap[2]       = XPLMFindDataRef("sim/flightmodel/controls/wing1r_fla1def");//Flap deflection
  dRef.lFlap[3]       = XPLMFindDataRef("sim/flightmodel/controls/wing2r_fla1def");//Flap deflection
  dRef.lSpoiler[0]    = XPLMFindDataRef("sim/flightmodel/controls/wing2l_spo1def");//Spoiler deflection
  dRef.lSpoiler[1]    = XPLMFindDataRef("sim/flightmodel/controls/wing2l_spo2def");//Spoiler deflection
  dRef.lSpoiler[2]    = XPLMFindDataRef("sim/flightmodel/controls/wing2r_spo1def");//Spoiler deflection
  dRef.lSpoiler[3]    = XPLMFindDataRef("sim/flightmodel/controls/wing2r_spo2def");//Spoiler deflection
  dRef.lGearDown      = XPLMFindDataRef("sim/cockpit/switches/gear_handle_status");// Gear switch Status 
  dRef.lGearRatio     = XPLMFindDataRef("sim/aircraft/parts/acf_gear_deploy");// Gear Deploy Ratio


  /* Now we create a window.  We pass in a rectangle in left, top,
   * right, bottom screen coordinates.  We pass in three callbacks. */
  SMLog::getSingleton().logMessage("Creating a new render window");
  simInternalDataPeekWindow = XPLMCreateWindow((int)(XPLMGetDatai(width)*.02),
					       (int)(XPLMGetDatai(height)*.7),
					       (int)(XPLMGetDatai(width)*.02)+155,
					       (int)(XPLMGetDatai(height)*.7)-450, /* Area of the window. */
					       1,				   /* Start visible. */
					       _drawInternalDataPeekCallback,	   /* Callbacks */
					       _handleKeyCallback,
					       _handleMouseClickCallback,
					       NULL);


  simSimDataOverlayWindow = XPLMCreateWindow((int)(XPLMGetDatai(width)*.02),
					     (int)(XPLMGetDatai(height)*.95),
					     (int)(XPLMGetDatai(width)*.02+200),
				   	     (int)(XPLMGetDatai(height)*.95)-120,  /* Area of the window. */
					       1,				  /* Start visible. */
					       _drawSimDataOverlayCallback,	  /* Callbacks */
					       _handleKeyCallback,
					       _handleMouseClickCallback,
					       NULL);
  simUDPComWindow = XPLMCreateWindow(10,10,15,5,                  /* Area of the window. */
				     1,				/* Start visible. */
				     _drawUDPComCallback,		/* Callbacks */
				     _handleKeyCallback,
				     _handleMouseClickCallback,
				     NULL);


  XPLMMenuID	simMenu;
  int		simMainSubItem;

  //creating a menu message item
  simMainSubItem = XPLMAppendMenuItem(XPLMFindPluginsMenu(),	/* Put in plugins menu */
				      "Xlink",		        /* Item Title */
				      0,			/* Item Ref */
				      1);			/* Force English */

  /* Now create a submenu attached to our menu item. */
  simMenu = XPLMCreateMenu("Xlink",
			   XPLMFindPluginsMenu(),
			   simMainSubItem, 			/* Menu Item to attach to. */
			   _simMenuCallback,	                /* The handler */
			   0);					/* Handler Ref */

  // make submenu items
  XPLMAppendMenuItem(simMenu, "Xlink Flightpath", (void *) 101, 1);
  XPLMAppendMenuItem(simMenu, "Internal Data Overlay", (void *) 102, 1);
  XPLMAppendMenuItem(simMenu, "Sim Data Overlay", (void *) 103, 1);
  SMLog::getSingleton().logMessage("done with setup");

  /* We must return 1 to indicate successful initialization, otherwise we
   * will not be called back again. */
  return 1;
}

/*
 * XPluginStop
 *
 * Our cleanup routine deallocates our window.
 *
 */
PLUGIN_API void	XPluginStop(void)
{
  SMLog::getSingleton().logMessage("destructing Internal Data Peek window");
  XPLMDestroyWindow(simInternalDataPeekWindow);
  SMLog::getSingleton().logMessage("destructing joystick data");
  delete joystickData;
  SMLog::getSingleton().logMessage("destructing data manager");
  delete dataMan;
  SMLog::getSingleton().logMessage("destructing log");
  delete debugLog;
}

/*
 * XPluginDisable
 *
 * We do not need to do anything when we are disabled, but we must provide the handler.
 *
 */
PLUGIN_API void XPluginDisable(void){}

/*
 * XPluginEnable.
 *
 * We don't do any enable-specific initialization, but we must return 1 to indicate
 * that we may be enabled at this time.
 *
 */
PLUGIN_API int XPluginEnable(void){  return 1;}


/*
 * XPluginReceiveMessage
 *
 * We don't have to do anything in our receive message handler, but we must provide one.
 *
 */
PLUGIN_API void XPluginReceiveMessage(XPLMPluginID	inFromWho,
				      long			inMessage,
				      void *			inParam){ }



//
//
// Section of internal functions  for the plugins
//
//
int XlinkCommandHandler(XPLMCommandRef       inCommand,
                         XPLMCommandPhase     inPhase,
                         void *               inRefcon){
  int *n, bitset;

  //Get Button Number, create bit setting mask
  n=(int *)inRefcon;
  bitset=(1<<n[0]);

  // toggle bit with XOR on button press
  //if (inPhase==0) sendPacket.buttonStatus = sendPacket.buttonStatus ^ bitset;

  // momentary bitmap with button press
  if (inPhase==1) sendPacket.buttonStatus |= bitset;
  if (inPhase==2) sendPacket.buttonStatus &= (~bitset);
  return 1;
}

// Send and receive UDP messages
int UDPcom(){
  DataManager &manRef = DataManager::getSingleton();
  JoystickData &jRef = JoystickData::getSingleton();
  long recvMsgSize = 1, retVal;
  int i;
  float GearRatio[10],sign;
  unsigned long simulinkAddr;
  unsigned short simulinkPort;
  double local_x,local_y,local_z;

  // Read socket
  if(!socketON) return 0;
  while(recvMsgSize>0){
    recvMsgSize = manRef.socket.ReadData((void*)&recvPacket,
					 sizeof(SIMtoXP_dataPacket),
					 &simulinkAddr, &simulinkPort);
  // If good message, process
    if(recvMsgSize == sizeof(SIMtoXP_dataPacket)){

      XPLMWorldToLocal(recvPacket.Latitude, recvPacket.Longitude, recvPacket.Elevation,
		       &local_x, &local_y, &local_z);

      //Write both the lat/long/elv set and the local coordinate set
      XPLMSetDatad(manRef.lat,	   recvPacket.Latitude);
      XPLMSetDatad(manRef.lon,	   recvPacket.Longitude);
      XPLMSetDatad(manRef.elev,	   recvPacket.Elevation);
      XPLMSetDatad(manRef.x_local, local_x);
      XPLMSetDatad(manRef.y_local, local_y);
      XPLMSetDatad(manRef.z_local, local_z);
      XPLMSetDataf(manRef.phi,	   recvPacket.Roll);
      XPLMSetDataf(manRef.theta,   recvPacket.Pitch);
      XPLMSetDataf(manRef.psi,	   recvPacket.Yaw );

      //Setting Surfaces
      for (i=0;i<4;i++){
        if (i<2) sign=-1; else sign=1; // left two then right two
	XPLMSetDataf( manRef.lAileron[i],  sign*recvPacket.Aileron );
	XPLMSetDataf( manRef.lElevator[i], recvPacket.Elevator );
	XPLMSetDataf( manRef.lRudder[i],   recvPacket.Rudder);
	XPLMSetDataf( manRef.lFlap[i],     recvPacket.Flap );
	XPLMSetDataf( manRef.lSpoiler[i],  recvPacket.Spoiler );
      }

      XPLMSetDatai( manRef.lGearDown,    recvPacket.GearDown );
      // lGearDown reflects cockpit switch, lGearRatio sets actual position of each gear
      for (i=0;i<10;i++) GearRatio[i]=(float)recvPacket.GearDown;
      XPLMSetDatavf(manRef.lGearRatio,GearRatio,0,10);
    }
    //
    //Send a packet to Sim with JoyStick data
    //
    // Get the first 16 axes values
    XPLMGetDatavf( jRef.axesValues, sendPacket.axisDeflection, 0, 16 );
    // send the data back to simulink
    retVal = manRef.socket.WriteData(&sendPacket,
				     sizeof(XPtoSIM_dataPacket),
				     ntohl(inet_addr(SIM_ADDR)),
				     SIM_PORT);
    if( retVal == -1 ) {
      SMLog::getSingleton().logMessage("Error: unable to send Joystick packet to client");
    }
  }
  return 1;
}



void _drawUDPComCallback(
                     XPLMWindowID         inWindowID,
		     void *               inRefcon)
{
  if (!socketON){return;}
  UDPcom();
}


void _drawSimDataOverlayCallback(
                                   XPLMWindowID         inWindowID,
                                   void *               inRefcon)
{
  char strBuffer[100],title[30]="Sim Data Overlay",label[20];
  int		left, top, right, bottom, i;
  float	color[] = { .3, 1, .4 }; 	/* RGB  */

  // If window display is on show internal variables, otherwise return
  if( !showSimDataOverlay ){ return; }        

  XPLMGetWindowGeometry(inWindowID, &left, &top, &right, &bottom);
  XPLMDrawTranslucentDarkBox(left, top, right, bottom);
  XPLMDrawString(color, left + 5, top-10, title, NULL, xplmFont_Basic);
  for (i=0;i<6;i++){
    memcpy(label,recvPacket.HUDlabels+15*i,15*sizeof(char));
    label[15]=0; //Just being sure...
    if (label[0]!=0){ //Only ones with labels
      sprintf( strBuffer, "%15s:%9.2f",label,recvPacket.HUDvalues[i]);
      XPLMDrawString(color, left+5, top-15*i-30, strBuffer, NULL, xplmFont_Basic);
    }
  }

}



void _drawInternalDataPeekCallback(
                                   XPLMWindowID         inWindowID,
                                   void *               inRefcon)
{
  char strBuffer[100],title[30]="Internal Data Overlay";
  int		left, top, right, bottom;
  float	color[] = { 1.0, 1.0, 1.0 }; 	/* RGB White */

  // If window display is on show internal variables, otherwise return
  if( !showInternalDataPeek ){ return; }        

  DataManager &dataref = DataManager::getSingleton();
  JoystickData &joyref = JoystickData::getSingleton();

  XPLMGetWindowGeometry(inWindowID, &left, &top, &right, &bottom);

  XPLMDrawTranslucentDarkBox(left, top, right, bottom);

  XPLMDrawString(color, left + 5, top-10, title, NULL, xplmFont_Basic);
  XPLMDrawString(color, left + 5, top-25 , (char*)((socketON) ? "Socket: On":"Socket: OFF" ), NULL, xplmFont_Basic);

  sprintf( strBuffer, "Lat: %.6f", XPLMGetDataf(dataref.lat));
  XPLMDrawString(color, left+5, top-45, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Lon: %.6f", XPLMGetDataf(dataref.lon));
  XPLMDrawString(color, left+5, top-60, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Elev: %.4f", XPLMGetDataf(dataref.elev));
  XPLMDrawString(color, left+5, top-75, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Loc X: %.3f", XPLMGetDataf(dataref.x_local));
  XPLMDrawString(color, left+5, top-90, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Loc Y: %.3f", XPLMGetDataf(dataref.y_local));
  XPLMDrawString(color, left+5, top-105, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Loc Z: %.3f", XPLMGetDataf(dataref.z_local));
  XPLMDrawString(color, left+5, top-120, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Phi: %.3f", XPLMGetDataf(dataref.phi));
  XPLMDrawString(color, left+5, top-135, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Theta: %.3f", XPLMGetDataf(dataref.theta));
  XPLMDrawString(color, left+5, top-150, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Psi: %.3f", XPLMGetDataf(dataref.psi));
  XPLMDrawString(color, left+5, top-165, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Aileron: %.3f", XPLMGetDataf(dataref.lAileron[0]));
  XPLMDrawString(color, left+5, (top-210), strBuffer, NULL, xplmFont_Basic);
  
  sprintf( strBuffer, "Elevator: %.3f",XPLMGetDataf(dataref.lElevator[0]));
  XPLMDrawString(color, left+5, (top-225), strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Flap: %.3f", XPLMGetDataf(dataref.lFlap[0]));
  XPLMDrawString(color, left+5, (top-240), strBuffer, NULL, xplmFont_Basic);
  
  sprintf( strBuffer, "Rudder: %.3f", XPLMGetDataf(dataref.lRudder[0]));
  XPLMDrawString(color, left+5, top-255, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "GearDown: %d", XPLMGetDatai(dataref.lGearDown));
  XPLMDrawString(color, left+5, top-270, strBuffer, NULL, xplmFont_Basic);

  sprintf( strBuffer, "Button: 0x%04X", sendPacket.buttonStatus);
  XPLMDrawString(color, left+5, top-300, strBuffer, NULL, xplmFont_Basic);

  for (int i=0; i<8; i++){
    sprintf( strBuffer, "Axis-%d: %.3f", i+1,*((float *)joyref.axesValues+i));
    XPLMDrawString(color, left+5, top-(330+i*15), strBuffer, NULL, xplmFont_Basic);
  }

}





void _handleKeyCallback(
			XPLMWindowID         inWindowID,
			char                 inKey,
			XPLMKeyFlags         inFlags,
			char                 inVirtualKey,
			void *               inRefcon,
			int                  losingFocus)
{
}

//
// Handling mouse input
//
int _handleMouseClickCallback( XPLMWindowID         inWindowID,
			       int                  x,
			       int                  y,
			       XPLMMouseStatus      inMouse,
			       void *               inRefcon)
{
  return 1;  //lets XPlane know the click was processed
}



void _simMenuCallback(  void *               inMenuRef,
			void *               inItemRef)
{
  int index = (int) inItemRef;
  int itmp[10];
  char buffer[100];
  XPLMDataRef overRide;
  //processing click to recognize
  sprintf( buffer, "Menu Click: %d", index);
  switch(index) {
  case 101: 
    socketON = !socketON;  // toggle UDP socket read status
    //set overrides on the flightpath
    overRide = XPLMFindDataRef("sim/operation/override/override_planepath");
    XPLMGetDatavi(overRide,itmp,0,10);
    itmp[0]= (int)socketON;
    XPLMSetDatavi( overRide, itmp,0,10);
    //set overrides control surfaces
    overRide = XPLMFindDataRef("sim/operation/override/override_control_surfaces");
    XPLMSetDatai( overRide, (int)socketON );
    //set overrides  on the gear_brake subsystem
    overRide = XPLMFindDataRef("sim/operation/override/override_gearbrake");
    XPLMSetDatai( overRide, (int)socketON );
    break;
  case 102:
    showInternalDataPeek = !showInternalDataPeek;
    break;
  case 103:
    showSimDataOverlay = !showSimDataOverlay;
    break;
  };
  menuClickBuffer = buffer;
}





