function [positions, trace] = Plot_jansen(ti, t_estimates, input_angle_step_size, cycles)
%[positions] = PLOT_JANSEN(angles): 
%function to plot the 4-Legged Jansen Mechanism and trace of joint P from a 
%starting crank angle over a number of crank angles, as determined by the
%step size and number of cycles
%
%Input ti = starting crank angle (rad)
%Input t_estimates = [t1_0,t2_0,t3_0,t4_0,t5_0,t6_0,t7_0,t8_0] angle initial estimates (rad)

%Input input_angle_step_size = step size (rad)
%Input cycles = number of desired cycles to simulate pseudo-statically 
%Output positions = [[tJointA_x tJointA_y] 
%                    [tJointB_x tJointB_y] 
%                    [tJointC_x tJointC_y] 
%                    [tJointD_x tJointD_y] 
%                    [tJointE_x tJointE_y]
%                    [tJointF_x tJointF_y]
%                    [tJoint0_x tJoint0_y] 
%                    [tJoint1_x tJoint1_y]] final positions for theta leg joints A:F , 0 & 1

% -------------------------------------------------------------------------

% Check input and output arguments
% Argument check
if (nargin ~= 4), error('Incorrect number of input arguments.'); end
if (nargout ~= 2), error('Incorrect number of output arguments.'); end


% Close all open figures
close all

% Assign inital estimates
t1_0 = t_estimates(1);
t2_0 = t_estimates(2);
t3_0 = t_estimates(3);
t4_0 = t_estimates(4);
t5_0 = t_estimates(5);
t6_0 = t_estimates(6);
t7_0 = t_estimates(7);
t8_0 = t_estimates(8);

% Preallocate trace matrix
trace = zeros(2, floor(2*cycles*pi/input_angle_step_size));

% Counter for trace indexing
count = 1;

% Loop through input angles, 
for tinput = ti:input_angle_step_size:ti + 2*cycles*pi + input_angle_step_size
    % Calculate angles using NR
    [t1, t2, t3, t4, t5, t6, t7, t8] = jansen_S_N_R(tinput, t1_0, t2_0, t3_0, t4_0, t5_0, t6_0, t7_0, t8_0);
    angles = [tinput, t1, t2, t3, t4, t5, t6, t7, t8];    
  
    % Find position of nodes from angles
    [positions] = find_joint_position(angles)

    % Find positions of nodes from angles
    tjointA = [positions(1,1) , positions(1,2)];
    tjointB = [positions(2,1) , positions(2,2)];
    tjointC = [positions(3,1) , positions(3,2)];
    tjointD = [positions(4,1) , positions(4,2)];
    tjointE = [positions(5,1) , positions(5,2)];
    tjointF = [positions(6,1) , positions(6,2)];
    tjoint0 = [positions(7,1) , positions(7,2)];
    tjoint1 = [positions(8,1) , positions(8,2)];    
    
    % In-loop plotting; clear previous plot; set axis for correct scaling
    drawnow
    clf        
    axis([-150 150 -115 115])
    
    % Plot trace inbetween "far" legs and "near" legs
    trace(1,count) = tjointF(1);
    trace(2,count) = tjointF(2);
    line(trace(1,1:count), trace(2,1:count));    
    
    patch('Faces', [1 2 3], 'Vertices', [tjoint1; tjointB; tjointC])
    patch('Faces', [1 2 3], 'Vertices', [tjointD; tjointE; tjointF])

    line([tjoint0(1) tjointA(1)], [tjoint0(2) tjointA(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20, 'MarkerEdgeColor', [0 0 0])
    line([tjointA(1) tjointB(1)], [tjointA(2) tjointB(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)
    line([tjointB(1) tjointC(1)], [tjointB(2) tjointC(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)
    line([tjointE(1) tjointD(1)], [tjointE(2) tjointD(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)
    line([tjointA(1) tjointD(1)], [tjointA(2) tjointD(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)
    line([tjointB(1) tjoint1(1)], [tjointB(2) tjoint1(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)
    line([tjoint1(1) tjointD(1)], [tjoint1(2) tjointD(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)
    line([tjoint1(1) tjointC(1)], [tjoint1(2) tjointC(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20, 'MarkerEdgeColor', [0 0 0])
    line([tjointE(1) tjointF(1)], [tjointE(2) tjointF(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)
    line([tjointD(1) tjointF(1)], [tjointD(2) tjointF(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)
    line([tjointC(1) tjointE(1)], [tjointC(2) tjointE(2)], 'Color',[0.5 0.5 0.5], 'LineWidth', 1, 'Marker', '.', 'MarkerSize', 20)

    % Update initial estimates for NR for next input angles
    t1_0 = t1;
    t2_0 = t2;
    t3_0 = t3;
    t4_0 = t4;
    t5_0 = t5;
    t6_0 = t6;
    t7_0 = t7;
    t8_0 = t8;   

    % Incremenet counter for trace indexing
    count = count + 1;
end
end

