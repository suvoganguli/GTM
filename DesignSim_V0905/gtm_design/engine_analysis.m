% engine JetCar P70 analysis

% Nonlinear gain

Coeff_thrust   = [0.000028864242464  -0.001914835880159 0.105916926095459  -1.251646340183624 ];
Coeff_throttle = [0.000033035538475  -0.008354385314499 1.191126728328792 31.518959847101669];

throttle_range = [0:1:100];
RPM_ref_range = polyval(Coeff_throttle,throttle_range);
thrust_range  = polyval(Coeff_thrust,RPM_ref_range);

altitude_range = [0:100:5000]; % ft
dumTstep = 1;
duminT = [0:dumTstep:length(altitude_range)-1];
[dumT,dumX,dumY] = sim('plot_atmos',duminT(end),[],[duminT' altitude_range']);
thrust_out_scale = dumY;

figure(1);
subplot(211);
plot(throttle_range,thrust_range);
xlabel('Throttle (%)');
ylabel('Thrust (unscaled) (lbf)')
grid on
subplot(212);
plot(altitude_range,thrust_out_scale);
xlabel('h (ft)');
ylabel('Thrust Scale Factor');
grid on

% Dynamics

% increasing power
model1 = tf(1,[1.44 1]);  % throttle_lag >= 50
model2 = tf(1,[1.96 1]);  % throttle_lag < 50

% decreasing power
model3 = tf(1,[0.85 1]);  % throttle_lag >= 50
model4 = tf(1,[1.43 1]);  % throttle_lag < 50


tfinal = 10;
[y1,t1] = step(model1,tfinal);
[y2,t2] = step(model2,tfinal);
[y3,t3] = step(model3,tfinal);
[y4,t4] = step(model4,tfinal);
figure(2);
plot(t1,y1,t2,y2,t3,y3,t4,y4);
legend('p-up, >= 50','p-up, < 50','p-dn, >= 50','p-dn, < 50');



