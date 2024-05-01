---------Using the Xlink plugin with Xplane9---------

To install the plugin copy the ./bin/Plugin/Xlink folder over to 
  <X-Plane>/Resources/plugins
where <X-Plane> is the X-Plane 9 installation directory.

Next time you start Xplane there should be an Xlink menu item under
the plugins menu.  Options within this menu toggle on/off when
selected and, they include:

 - Receiving flight-path info from matlab via UPD messages
 - Displaying internal data in a text overlay
 - Display simulation data in a text overlay

Instruments in the vehicles cockpit and the vehicle HUD will not
display the correct information.  The plugin is best used with a
chase-plane view.  Keyboard commands +,-, and arrows control the
camera position in chase plane view.

The surfaces are mapped to X-Planes B777 vehicle, but should work with
most others as well.  The file ./img/Speed-Bird_paint_modified.png can
be used to replace the file 
  <X-Plane>/Aircraft/Heavy Metal/B777-200 British Airways/Speed-Bird_paint.png
to provide a vehicle that does not have British-Airways logos.

Joysticks axis are configured with X-Planes "Joystick and Equipment"
menu.  Joystick Buttons (or keyboard keys) can be also configured
under this way, with "custom commands" - Look for an Xlink item in the
"X-System" folder.

All necessary mfiles and simulink blocks are in the ./bin/mfiles
directory.  For usage information see the examples in the ./test
directory.  The three examples illustrate use of the following
commands:

  xplay.m - a batch style data replay utility.
  xsend.m - a send-position, return-joystick  matlab command
  Xlink.mdl  -  a simulink block for Xplane interaction


----------Compiling plugins and Sfunctions----------

In windows, the plugin has been compiled as a Code::Blocks project,
using the free mingw compiler bundled with Code::Blocks.  See

  http://www.codeblocks.org/

for details.  It should also be possible to compile with Microsoft
Visual C++, as a dll target.

In linux, the plugin has been compiled with the buildxpl.sh script.  

On mac, the plugin has been compiled as an Xcode project, carbon dynamic library
for OS-X 10.5.  

On all platforms the buildmex.m file, run from within matlab, should
build necessary mex files.

All compiled mexfiles, and dlls are placed in the ./bin/ directory.













