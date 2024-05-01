
struct XPtoSIM_dataPacket {
  float axisDeflection[16];      //[-1:1]
  int   buttonStatus;
};

struct SIMtoXP_dataPacket {
  double Latitude;       //Degrees
  double Longitude;      //Degrees
  double Elevation;      //Meters
  float	 Roll;		 //Degrees
  float	 Pitch;		 //Degrees
  float	 Yaw;		 //Degrees
  float  Aileron;        //Degrees
  float  Elevator;       //Degrees
  float  Rudder;         //Degrees
  float  Flap;           //Degrees
  float  Spoiler;        //Degrees
  int    GearDown;       // 0 or 1
  char   HUDlabels[90];  // 6 fixed length(15chars) HUDtext labels
  double HUDvalues[6];   // data for HUDtext display
};
