%% Analysis (effect of large Ma term)

if do_Ma_analysis
    Alon    = londyn.a;
    Blon    = londyn.b;
    Alon_sp = Alon([3 2],[3 2]);   % q w
    Blon_sp = Blon([3 2],1);       % q w <- de
    
    ub_trim = mws_designpoint.StatesInp(1); % fps
    vb_trim = mws_designpoint.StatesInp(2); % fps
    wb_trim = mws_designpoint.StatesInp(3); % fps
    tas_fps = norm([ub_trim,vb_trim,wb_trim],2); % fps
    K.alpha_trim = atan(wb_trim/ub_trim)*180/pi; % deg
    
    T_wtoalp = [1 0;0 tas_fps];
    Alon_sp2 = inv(T_wtoalp) * Alon_sp * (T_wtoalp);  % q alp
    Blon_sp2 = inv(T_wtoalp) * Blon_sp;               % q alp <- de
    sys_sp2  = ss(Alon_sp2,Blon_sp2,eye(2),[0 0]');
    
    Alon    = londyn.a;
    Blon    = londyn.b;
    Alon_sp = Alon([3 2],[3 2]);   % q w
    Blon_sp = Blon([3 2],1);       % q w <- de
    
    ub_trim = mws_designpoint.StatesInp(1); % fps
    vb_trim = mws_designpoint.StatesInp(2); % fps
    wb_trim = mws_designpoint.StatesInp(3); % fps
    tas_fps = norm([ub_trim,vb_trim,wb_trim],2); % fps
    K.alpha_trim = atan(wb_trim/ub_trim)*180/pi; % deg
    
    T_wtoalp = [1 0;0 tas_fps];
    Alon_sp2 = inv(T_wtoalp) * Alon_sp * (T_wtoalp);  % q alp
    Blon_sp2 = inv(T_wtoalp) * Blon_sp;               % q alp <- de
    sys_sp2  = ss(Alon_sp2,Blon_sp2,eye(2),[0 0]');
    
    sim('sys_sp2_clp');
    
    subplot(324), hold on;
    plot(tout,qout,'r--'); grid on
    
    % Make Ma = 1/10th    
    
    % sys_sp2.b(2) = 0;  % Zd = 0    
    sys_sp2.a(1,2) = sys_sp2.a(1,2)/10;  % Ma/fac
    
    sim('sys_sp2_clp');
    
    subplot(324), hold on;
    plot(tout,qout,'m-.'); grid on
    
end
