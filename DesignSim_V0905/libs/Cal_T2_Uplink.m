function [DnCals, UpCals]=Cal_T2_Uplink()
% function [DnCals, UpCals]=Cal_T2_Uplink()

% $Id: Cal_T2_Uplink.m 2084 2009-10-06 14:42:30Z jmcronau $
% ------  Following are uplink cal tables computed from aircraft on 06-Oct-2009 10:22:16------


UpCals.AILLC 	= [ 1200.00  1265.00  1330.00  1395.00  1460.00  1525.00  1590.00  1655.00  1720.00  1785.00  1850.00 ];
DnCals.AILL 	= [  -21.17   -17.09   -12.69    -8.73    -3.68     0.19     3.29     7.76    12.04    16.49    21.04 ];

UpCals.AILRC 	= [ 1880.00  1812.00  1744.00  1676.00  1608.00  1540.00  1472.00  1404.00  1336.00  1268.00  1200.00 ];
DnCals.AILR 	= [  -21.34   -16.64   -12.25    -8.05    -4.06     0.69     3.94     8.49    12.72    17.08    21.22 ];

UpCals.SPLLIBC 	= [ 1614	1630	1647	1664	1681	1698	1714	1731	1748	1765	1785 ];
DnCals.SPLLIB 	= [15.0     13.5	12.0	10.5	9.0 	7.5     6.0 	4.5     3.0     1.5     0.0 ];

UpCals.SPLLOBC 	= [ 1269	1319	1373	1427	1481	1534	1588	1642	1696	1750	1803 ];
DnCals.SPLLOB 	= [ 0.0 	4.5     9.0     13.5	18.0	22.5	27.0	31.5	36.0	40.5	45.0 ];

UpCals.SPLRIBC 	= [ 1604	1622	1640	1658	1676	1694	1712	1730	1748	1767	1785];
DnCals.SPLRIB 	= [ 15.0	13.5	12.0	10.5	9.0     7.5     6.0 	4.5     3.0     1.5     0.0 ];

UpCals.SPLROBC 	= [ 1248	1299	1349	1399	1449	1499	1548	1598	1648	1698	1748];
DnCals.SPLROB 	= [ 0.0 	4.5     9.0     13.5	18.0	22.5	27.0	31.5	36.0	40.5	45.0];


UpCals.ELLOBC 	= [ 1100.00  1180.00  1260.00  1340.00  1420.00  1500.00  1580.00  1660.00  1740.00  1820.00  1900.00 ];
DnCals.ELLOB 	= [  -30.84   -25.88   -20.17   -13.61    -8.51    -2.63     1.40     7.11    12.34    17.16    21.99 ];

UpCals.ELLIBC 	= [ 1175.00  1243.00  1311.00  1379.00  1447.00  1515.00  1583.00  1651.00  1719.00  1787.00  1855.00 ];
DnCals.ELLIB 	= [  -33.16   -26.72   -20.90   -14.57    -8.74    -2.29     2.50     7.95    12.89    17.57    22.08 ];

UpCals.ELROBC 	= [ 1100.00  1180.00  1260.00  1340.00  1420.00  1500.00  1580.00  1660.00  1740.00  1820.00  1900.00 ];
DnCals.ELROB 	= [  -31.88   -25.23   -20.20   -14.30    -7.80    -3.00     1.17     7.37    11.90    18.12    22.80 ];

UpCals.ELRIBC 	= [ 1175.00  1243.00  1311.00  1379.00  1447.00  1515.00  1583.00  1651.00  1719.00  1787.00  1855.00 ];
DnCals.ELRIB 	= [  -31.57   -24.85   -19.81   -13.60    -7.75    -2.11     1.46     7.13    12.48    16.91    21.48 ];

UpCals.RUDUPC 	= [ 1075.00  1154.00  1233.00  1312.00  1391.00  1470.00  1549.00  1628.00  1707.00  1786.00  1865.00 ];
DnCals.RUDU 	= [  -31.30   -25.45   -19.42   -13.82    -7.92    -1.42     2.96     9.06    15.58    21.73    28.49 ];

UpCals.RUDLOC 	= [ 1075.00  1154.00  1233.00  1312.00  1391.00  1470.00  1549.00  1628.00  1707.00  1786.00  1865.00 ];
DnCals.RUDL 	= [  -30.32   -25.03   -19.29   -13.37    -7.28    -0.77     3.29     9.64    16.60    23.29    29.93 ];

UpCals.THROTLC 	= [ 1339.00  1395.10  1451.20  1507.30  1563.40  1619.50  1675.60  1731.70  1787.80  1843.90  1900.00 ];
DnCals.ENGTL 	= [    0.00    10.00    20.00    30.00    40.00    50.00    60.00    70.00    80.00    90.00   100.00 ];

UpCals.THROTRC 	= [ 1339.00  1395.10  1451.20  1507.30  1563.40  1619.50  1675.60  1731.70  1787.80  1843.90  1900.00 ];
DnCals.ENGTR 	= [    0.00    10.00    20.00    30.00    40.00    50.00    60.00    70.00    80.00    90.00   100.00 ];

UpCals.GEARC 	= [ 1111.00  1189.90  1268.80  1347.70  1426.60  1505.50  1584.40  1663.30  1742.20  1821.10  1900.00 ];
DnCals.GEAR 	= [    1.00     0.90     0.80     0.70     0.60     0.50     0.40     0.30     0.20     0.10     0.00 ];

UpCals.LINK0 	= [    0.00   400.00   800.00  1200.00  1600.00  2000.00  2400.00  2800.00  3200.00  3600.00  4000.00 ];
DnCals.LINK0 	= [    0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00 ];

UpCals.FLAPLIC 	= [ 1910.00  1850.00  1790.00  1730.00  1670.00  1610.00  1550.00  1490.00  1430.00  1370.00  1310.00 ];
DnCals.FLAPLIB 	= [   0     1.61     5.09     8.92    11.84    15.45    19.08    22.29    25.37    28.84    30.49 ];

UpCals.FLAPLOC 	= [ 1910.00  1836.00  1762.00  1688.00  1614.00  1540.00  1466.00  1392.00  1318.00  1244.00  1170.00 ];
DnCals.FLAPLOB 	= [   0     1.65     5.24     8.52    12.45    15.49    18.77    21.89    24.95    27.44    29.94 ];

UpCals.FLAPRIC 	= [ 1910.00  1850.00  1790.00  1730.00  1670.00  1610.00  1550.00  1490.00  1430.00  1370.00  1310.00 ];
DnCals.FLAPRIB 	= [  0     2.42     5.86     8.91    12.50    16.39    19.37    22.64    25.84    29.08    31.74 ];

UpCals.FLAPROC 	= [ 1910.00  1836.00  1762.00  1688.00  1614.00  1540.00  1466.00  1392.00  1318.00  1244.00  1170.00 ];
DnCals.FLAPROB 	= [  0     1.44     4.73     8.08    11.42    14.75    17.98    20.88    23.67    26.82    29.82 ];

UpCals.BRAKEC 	= [ 1121.00  1199.80  1278.60  1357.40  1436.20  1515.00  1593.80  1672.60  1751.40  1830.20  1909.00 ];
DnCals.BRAKE 	= [    1.00     0.90     0.80     0.70     0.60     0.50     0.40     0.30     0.20     0.10     0.00 ];

UpCals.STEERC 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.STEER 	= [  -30.00   -24.00   -18.00   -12.00    -6.00     0.00     6.00    12.00    18.00    24.00    30.00 ];

UpCals.ENGML 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.ENGML 	= [    0.00     0.20     0.40     0.60     0.80     1.00     1.20     1.40     1.60     1.80     2.00 ];

UpCals.ENGMR 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.ENGMR 	= [    0.00     0.20     0.40     0.60     0.80     1.00     1.20     1.40     1.60     1.80     2.00 ];

UpCals.PWM24 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.PWM24 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];

UpCals.PWM25 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.PWM25 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];

UpCals.PWM26 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.PWM26 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];

UpCals.PWM27 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.PWM27 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];

UpCals.PWM28 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.PWM28 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];

UpCals.PWM29 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.PWM29 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];

UpCals.PWM30 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];
DnCals.PWM30 	= [ 1000.00  1100.00  1200.00  1300.00  1400.00  1500.00  1600.00  1700.00  1800.00  1900.00  2000.00 ];

UpCals.LINK1 	= [    0.00   400.00   800.00  1200.00  1600.00  2000.00  2400.00  2800.00  3200.00  3600.00  4000.00 ];
DnCals.LINK1 	= [    0.00     0.10     0.20     0.30     0.40     0.50     0.60     0.70     0.80     0.90     1.00 ];


MWS.UpCals_Eng=cell2mat(struct2cell(DnCals))';
MWS.UpCals_Pwm=cell2mat(struct2cell(UpCals))';