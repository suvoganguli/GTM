//-----------------------------------------------------------------------------
// SMLog.cpp
// This file implements the Log object. The code here for logging the
// message is credited to the guys at the Ogre3D project and their Log system.
// I've tailored it to handle more of SimuMerge's needs, but process is
// essentially what I was able to gleam from their code.
//-----------------------------------------------------------------------------
#include <ctime>
#include <iomanip>

#include "SMLog.h"

SMLog* SMLog::singleton = 0;

void SMLog::initialize( const std::string& name )
{
    filename = name;
    outFile.open( filename.c_str() );
}

void SMLog::logMessage( const std::string& message )
{
    //Access time for the data logging
    struct tm *localTime;
    time_t cTime;
    time( &cTime );
    localTime = localtime( &cTime );

    //Apply the message to log as "HH:MM:SS: Message\n"
    outFile << std::setw(2) << std::setfill('0') << localTime->tm_hour
            << ":" << std::setw(2) << std::setfill('0') << localTime->tm_min
            << ":" << std::setw(2) << std::setfill('0') << localTime->tm_sec
            << ": " << message << std::endl;

    //ensure the message is written
    outFile.flush();

    #if defined(_DEBUG)
    std::cout<< std::setw(2) << std::setfill('0') << localTime->tm_hour
            << ":" << std::setw(2) << std::setfill('0') << localTime->tm_min
            << ":" << std::setw(2) << std::setfill('0') << localTime->tm_sec
            << ": " << message << std::endl;
    #endif
}
