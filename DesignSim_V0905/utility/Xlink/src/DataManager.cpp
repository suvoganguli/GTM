#include "DataManager.h"
#include "netports.h"

DataManager* DataManager::_singleton = 0;

DataManager::DataManager()
        : socket(PLUGIN_PORT), lat(0),lon(0),elev(0),
            x_local(0), y_local(0), z_local(0),
	  phi(0), theta(0), psi(0)
{
    assert(!_singleton);
    _singleton = static_cast< DataManager* >( this );
}

DataManager::~DataManager() {
    assert(_singleton);
    _singleton = 0;
}
