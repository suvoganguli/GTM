function [DnCals, UpCals]=Cal_Uplink();
%function [DnCals, UpCals]=Cal_Uplink();

%%%%%%%%%  following are uplink cal tables computed from aircraft on 6-27-08  %%%%%%%%
UpCals.AILLC   = [77.00    156.20   235.40   314.60   393.80   473.00   552.20   631.40   710.60   789.80   869.00   ];
DnCals.AILL    = [23.13    19.85    15.57    11.24    6.90     2.24     -2.81    -7.55    -12.04   -16.39   -20.13   ];
UpCals.AILRC   = [77.00    156.20   235.40   314.60   393.80   473.00   552.20   631.40   710.60   789.80   869.00   ];
DnCals.AILR    = [-20.18   -17.62   -14.08   -10.29   -6.21    -2.25    1.97     6.48     11.09    15.70    20.19    ];

UpCals.SPLLIBC = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
DnCals.SPLLIB  = [0.00     1.50     3.00     4.50     6.00     7.50     9.00     10.50    12.00    13.50    15.00    ];
UpCals.SPLLOBC = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
DnCals.SPLLOB  = [0.00     4.50     9.00     13.50    18.00    22.50    27.00    31.50    36.00    40.50    45.00    ];
UpCals.SPLRIBC = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
DnCals.SPLRIB  = [0.00     1.50     3.00     4.50     6.00     7.50     9.00     10.50    12.00    13.50    15.00    ];
UpCals.SPLROBC = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
DnCals.SPLROB  = [0.00     4.50     9.00     13.50    18.00    22.50    27.00    31.50    36.00    40.50    45.00    ];

UpCals.ELLOBC  = [75.00    160.00   245.00   330.00   415.00   500.00   585.00   670.00   755.00   840.00   925.00   ];
DnCals.ELLOB   = [-33.76   -28.44   -21.96   -14.73   -8.14    -1.97    4.74     10.87    16.74    22.71    27.85    ];
UpCals.ELLIBC  = [75.00    160.00   245.00   330.00   415.00   500.00   585.00   670.00   755.00   840.00   925.00   ];
DnCals.ELLIB   = [-33.78   -28.45   -21.99   -14.73   -8.18    -1.99    4.71     10.84    16.71    22.61    27.84    ];
UpCals.ELROBC  = [75.00    160.00   245.00   330.00   415.00   500.00   585.00   670.00   755.00   840.00   925.00   ];
DnCals.ELROB   = [-30.08   -25.63   -19.38   -12.92   -6.32    -0.29    6.47     12.48    18.60    24.43    28.89    ];
UpCals.ELRIBC  = [75.00    160.00   245.00   330.00   415.00   500.00   585.00   670.00   755.00   840.00   925.00   ];
DnCals.ELRIB   = [-30.07   -25.63   -19.36   -12.91   -6.32    -0.28    6.51     12.50    18.60    24.43    28.92    ];

UpCals.RUDUPC  = [194.00   255.20   316.40   377.60   438.80   500.00   561.20   622.40   683.60   744.80   806.00   ];
DnCals.RUDUP   = [27.80    23.27    16.78    10.32    4.00     -1.90    -8.02    -14.01   -19.59   -24.51   -29.84   ];
UpCals.RUDLOC  = [194.00   255.20   316.40   377.60   438.80   500.00   561.20   622.40   683.60   744.80   806.00   ];
DnCals.RUDLO   = [27.82    23.29    16.79    10.33    4.02     -1.90    -8.02    -14.00   -19.57   -24.50   -29.83   ];

% eliminated 10/27/08
%UpCals.STABC   = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
%DnCals.STAB    = [-5.00    -3.50    -2.00    -0.50    1.00     2.50     4.00     5.50     7.00     8.50     10.00    ];

UpCals.THROTLC = [330.00  389.00  448.00  507.00  566.00  625.00  684.00  743.00  802.00  861.00  920.00  ];
DnCals.ENGTL   = [0.00     10.00    20.00    30.00    40.00    50.00    60.00    70.00    80.00    90.00    100.00   ];
UpCals.THROTRC = [330.00  389.00  448.00  507.00  566.00  625.00  684.00  743.00  802.00  861.00  920.00  ];
DnCals.ENGTR   = [0.00     10.00    20.00    30.00    40.00    50.00    60.00    70.00    80.00    90.00    100.00   ];

UpCals.GEARC   = [250.00  298.00  346.00  394.00  442.00  490.00  538.00  586.00  634.00  682.00  730.00  ];
DnCals.GEAR    = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
% added 10/23/08
UpCals.LINK0   = [0 400 800 1200 1600 2000 2400 2800 3200 3600 4000];
DnCals.LINK0   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];


UpCals.FLAPLIC = [470.00  514.30  558.60  602.90  647.20  691.50  735.80  780.10  824.40  868.70  906.00];
DnCals.FLAPLIB = [0.00  3.00  6.00  9.00  12.00  15.00  18.00  21.00  24.00  27.00  30.00];
UpCals.FLAPLOC = [470.00  514.30  558.60  602.90  647.20  691.50  735.80  780.10  824.40  868.70  906.00];
DnCals.FLAPLOB = [0.00  3.00  6.00  9.00  12.00  15.00  18.00  21.00  24.00  27.00  30.00];
UpCals.FLAPRIC = [470.00  514.30  558.60  602.90  647.20  691.50  735.80  780.10  824.40  868.70  906.00];
DnCals.FLAPRIB = [0.00  3.00  6.00  9.00  12.00  15.00  18.00  21.00  24.00  27.00  30.00];
UpCals.FLAPROC = [470.00  514.30  558.60  602.90  647.20  691.50  735.80  780.10  824.40  868.70  906.00];
DnCals.FLAPROB = [0.00  3.00  6.00  9.00  12.00  15.00  18.00  21.00  24.00  27.00  30.00];

UpCals.BRAKEC  = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
DnCals.BRAKE   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
UpCals.STEERC  = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
DnCals.STEER   = [-30.00   -24.00   -18.00   -12.00   -6.00    0.00     6.00     12.00    18.00    24.00    30.00    ];
UpCals.ENGML   = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
DnCals.ENGML   = [0.00     0.20     0.40     0.60     0.80     1.00     1.20     1.40     1.60     1.80     2.00     ];
UpCals.ENGMR   = [100.00  180.00  260.00  340.00  420.00  500.00  580.00  660.00  740.00  820.00  900.00  ];
DnCals.ENGMR   = [0.00     0.20     0.40     0.60     0.80     1.00     1.20     1.40     1.60     1.80     2.00     ];

% added 10/23/08
UpCals.PWM24   = [250.00  298.00  346.00  394.00  442.00  490.00  538.00  586.00  634.00  682.00  730.00  ];
DnCals.PWM24   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
UpCals.PWM25   = [250.00  298.00  346.00  394.00  442.00  490.00  538.00  586.00  634.00  682.00  730.00  ];
DnCals.PWM25   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
UpCals.PWM26   = [250.00  298.00  346.00  394.00  442.00  490.00  538.00  586.00  634.00  682.00  730.00  ];
DnCals.PWM26   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
UpCals.PWM27   = [250.00  298.00  346.00  394.00  442.00  490.00  538.00  586.00  634.00  682.00  730.00  ];
DnCals.PWM27   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
UpCals.PWM28   = [250.00  298.00  346.00  394.00  442.00  490.00  538.00  586.00  634.00  682.00  730.00  ];
DnCals.PWM28   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
UpCals.PWM29   = [250.00  298.00  346.00  394.00  442.00  490.00  538.00  586.00  634.00  682.00  730.00  ];
DnCals.PWM29   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
UpCals.PWM30   = [250.00  298.00  346.00  394.00  442.00  490.00  538.00  586.00  634.00  682.00  730.00  ];
DnCals.PWM30   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];
UpCals.LINK1   = [0 400 800 1200 1600 2000 2400 2800 3200 3600 4000];
DnCals.LINK1   = [0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00     ];

