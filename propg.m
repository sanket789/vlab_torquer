function xdot = propg(t,x)
q = x(1:4);
w = x(5:7);
% user input
lat = 19.08;
lon = 72.87;
[XYZ] = igrfmagm(550000, lat, lon, decyear(2016,1,1),12);
B_orb = 1e-9*(XYZ)'; %magnetic filed vector assumed get it from user in body frame 
                        % to do get this value using lat-long
I = 6e-3;   % current in amps 

MI = 0.15; % moment of inertia 1/6M*L*L with M=10kg and L = 0.3
N = 40;   % number of turns in each torquer N = 100;
W = [ 0 w(3) -w(2) w(1);
      -w(3) 0 w(1) w(2);
      w(2) -w(1) 0 w(3);
      -w(1) -w(2) -w(3) 0]; %quaternion propogation matrix
  
q0 = q(4); q1 = q(1); q2 = q(2); q3 = q(3);

TBI = [ q0^2 + q1^2 - q2^2 - q3^2,         2*q0*q3 + 2*q1*q2,         2*q1*q3 - 2*q0*q2;
           2*q1*q2 - 2*q0*q3, q0^2 - q1^2 + q2^2 - q3^2,         2*q0*q1 + 2*q2*q3;
           2*q0*q2 + 2*q1*q3,         2*q2*q3 - 2*q0*q1, q0^2 - q1^2 - q2^2 + q3^2]; %rotation matrix

B_b = TBI*B_orb; % convert orbit frame magnetic vector in body frame

tau_b = N*I*0.09*[ B_b(3)-B_b(2); B_b(1)-B_b(3); B_b(2)-B_b(1) ]; %calculate tau in orbit frame for cubic geomtry
% torquers are palced such that outwrd normals are in positive axes direction

wdot = tau_b/MI ;
qdot = 0.5*W*q;
tau_b'
xdot = [qdot;wdot];

end