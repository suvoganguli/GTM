//------------------------------------------------------------------------
// SMLog
// This is a logging class that follows the singleton paradigm.
//
// AUTHOR: Dan Hill
// DATE: August 2007
// VERSION: 1.0 - Simple singleton logging system for debugging SimuMerge
//------------------------------------------------------------------------
#ifndef SMLOG_H_INCLUDED
#define SMLOG_H_INCLUDED

//#if defined (_WINDOWS)
#include <assert.h>
//#endif
#include <string>
#include <fstream>

#if defined(_DEBUG)
#include <iostream>
#endif

class SMLog {

    protected:

        //singleton class member
        static SMLog* singleton;

        //log data members
        std::string filename;
        std::ofstream outFile;

    public:

        SMLog()
        {
            assert( !singleton );
            // set up the singleton
            singleton = static_cast< SMLog* >( this );

        }

        // Singleton accessors
        static SMLog& getSingleton() { assert( singleton); return *singleton; }
        static SMLog* getSingletonPtr() { assert( singleton); return singleton; }

        // Log handling.  Ensure that a log is initialized and closed.
        void initialize( const std::string& name );
        void logMessage( const std::string& message );
        void close() { outFile.close(); }

        ~SMLog() {
            assert( singleton );
            singleton = 0;
        }

};

#endif // SMLOG_H_INCLUDED
