#include "JoystickData.h"

JoystickData* JoystickData::_singleton = 0;

JoystickData::JoystickData() :
  isJoystick(0),
  mouseSub(0),
  axesValues(0)
{
    assert(!_singleton);
    _singleton = static_cast< JoystickData* >( this );

}

JoystickData::~JoystickData() {
    assert(_singleton);
    _singleton = 0;
}

