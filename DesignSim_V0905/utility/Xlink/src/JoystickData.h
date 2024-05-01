#ifndef JOYSTICKDATA_H
#define JOYSTICKDATA_H

#include <map>
#include <string>
#include <assert.h>
#include <PCSBSocketUDP.h>
#include <XPLM/XPLMDataAccess.h>

class JoystickData {

    private:
        static JoystickData *_singleton;

    public:
        JoystickData();
        ~JoystickData();

                //singleton accessors
        static JoystickData& getSingleton() { assert( _singleton); return *_singleton; }
        static JoystickData* getSingletonPtr() { assert( _singleton); return _singleton; }

        XPLMDataRef isJoystick;
        XPLMDataRef mouseSub;
        XPLMDataRef axesValues;  // float array from [0:100]

};

#endif
