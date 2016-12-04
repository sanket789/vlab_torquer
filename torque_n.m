%%
% User input for magnetic field is in propg.m file
% Todo: get this input from lat-long data.
%
clear
clc
x_init = [0;0;0;1;-0.3;0.2; 0.3]; %If you change initial angles in x_init initial co-ordinates p1,p2.. has to be changed
tspan = [0 30]; %for 5 seconds
a = 0.15;
p1 = [-a -a -a];%Vertices of cube initial 
p2 = [-a -a a];
p3 = [-a a a];
p4 = [-a a -a];
p5 = [a -a -a];
p6 = [a -a a];
p7 = [a a a];
p8 = [a a -a];

P = [p1' p2' p3' p4' p5' p6' p7' p8'];
[t,x] = ode45(@propg, tspan, x_init);
%%
for j = 1:length(t)   % generate the cube at each step for particular bidy frame using quaternions at that instant
    j;
    state = x(j,:);
    q = state(1:4);
    q0 = q(4); q1 = q(1); q2 = q(2); q3 = q(3);

    TBI = [ q0^2 + q1^2 - q2^2 - q3^2,         2*q0*q3 + 2*q1*q2,         2*q1*q3 - 2*q0*q2;
           2*q1*q2 - 2*q0*q3, q0^2 - q1^2 + q2^2 - q3^2,         2*q0*q1 + 2*q2*q3;
           2*q0*q2 + 2*q1*q3,         2*q2*q3 - 2*q0*q1, q0^2 - q1^2 - q2^2 + q3^2];

       P_n = TBI*P;
       new_plot = [P_n(:,1) P_n(:,2) P_n(:,6) P_n(:,5) P_n(:,1) P_n(:,4) P_n(:,8) P_n(:,7) ...
            P_n(:,3) P_n(:,4) P_n(:,8) P_n(:,5) P_n(:,6) P_n(:,7) P_n(:,3) P_n(:,2)]';
       
       plot3(new_plot(:,1),new_plot(:,2),new_plot(:,3),'Marker','o');  % plot cube axes=('..') can be 
                                                          % changed to get
                                                          % better view
                                                         % look " help axes"
       grid on
       xlabel('x'); ylabel('y'); zlabel('z');
       axis('equal')
       
       axis([-0.3 0.3 -0.3 0.3 -0.3 0.3]);
       drawnow; %draw the figure
       pause(tspan(2)/length(t)); %pause to get real time fill
       %pause(0.05)
end