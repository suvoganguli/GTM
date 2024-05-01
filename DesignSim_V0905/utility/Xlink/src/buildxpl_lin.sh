#!/bin/sh

# Build Plugin
rm -f *.o
g++ -Wall -c -DLIN -fPIC Xlink.cpp DataManager.cpp JoystickData.cpp SMLog.cpp ./networking/PCSBSocketUDP.lin.cpp -I./ -I./networking/ -I./SDK/CHeaders/
g++ -DLIN -shared Xlink.o DataManager.o JoystickData.o SMLog.o PCSBSocketUDP.lin.o -o ../bin/Plugin/Xlink/lin.xpl





