#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <assert.h>
#include <PCSBSocketUDP.h>
#include <XPLM/XPLMDataAccess.h>


class DataManager {

    protected:
        static DataManager* _singleton;

    public:

        DataManager();

        ~DataManager();

        //singleton accessors
        static DataManager& getSingleton() { assert( _singleton); return *_singleton; }
        static DataManager* getSingletonPtr() { assert( _singleton); return _singleton; }

        PCSBSocketUDP socket;
        XPLMDataRef lat;	    // latitude as a double
        XPLMDataRef lon;	    // longitude as a double
        XPLMDataRef elev;	    // elevation as a double
        XPLMDataRef x_local;	// local x coord as a double
        XPLMDataRef y_local;	// local y coord as a double
        XPLMDataRef z_local;	// local z coord as a double
        XPLMDataRef phi;		// phi rotation as a float
        XPLMDataRef theta;		// theta rotation as a float
        XPLMDataRef psi;		// psi rotation as a float
        XPLMDataRef lAileron[4];	// aileron commands in float[2]
        XPLMDataRef lElevator[4];       // elevator commands in float[2]
        XPLMDataRef lRudder[4];         // rudder commands in float[2]
        XPLMDataRef lFlap[4];	        // flap commands in float[2]
        XPLMDataRef lSpoiler[4];        // spoiler commands in float[2]
        XPLMDataRef lGearDown;          // Gear handle status
	XPLMDataRef lGearRatio;          // Gear handle status
};

#endif
