
#ifndef XLINK_H
#define XLINK_H



#include "dataPacket.h"

PLUGIN_API int XPluginStart(char *outName, char *outSig, char *outDesc);

/* XPluginStop
 *
 * Our cleanup routine deallocates our window.
 */
PLUGIN_API void	XPluginStop(void);

/* XPluginDisable
 *
 * We do not need to do anything when we are disabled, but we must provide the handler.
 */
PLUGIN_API void XPluginDisable(void);

/* XPluginEnable.
 *
 * We don't do any enable-specific initialization, but we must return 1 to indicate
 * that we may be enabled at this time.
 */
PLUGIN_API int XPluginEnable(void);

/* XPluginReceiveMessage
 *
 * We don't have to do anything in our receive message handler, but we must provide one.
 */
PLUGIN_API void XPluginReceiveMessage(
					XPLMPluginID	inFromWho,
					long			inMessage,
					void *			inParam);

// This draws the graphical data onto the XPLane viewport
// it should display the current data that has been pulled in from
// Simulink
void _drawUDPComCallback(
                                   XPLMWindowID         inWindowID,
                                   void *               inRefcon);
void _drawSimDataOverlayCallback(
                                   XPLMWindowID         inWindowID,
                                   void *               inRefcon);
void _drawInternalDataPeekCallback(
                                   XPLMWindowID         inWindowID,
                                   void *               inRefcon);

void _handleKeyCallback(           XPLMWindowID         inWindowID,
                                   char                 inKey,
                                   XPLMKeyFlags         inFlags,
                                   char                 inVirtualKey,
                                   void *               inRefcon,
                                   int                  losingFocus);

int _handleMouseClickCallback( XPLMWindowID         inWindowID,
                                   int                  x,
                                   int                  y,
                                   XPLMMouseStatus      inMouse,
                                   void *               inRefcon);

void _simMenuCallback(  void *               inMenuRef,
                       void *               inItemRef);

#endif
