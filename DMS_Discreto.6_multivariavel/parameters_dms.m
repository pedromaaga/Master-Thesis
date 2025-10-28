%
% Initialization.
%
list = 2;   % 0-4 variable: 0 if the algorithm initializes the iterate
            % list with a single point; 1 if a latin hypercube sampling
            % strategy is considered for initialization; 2 if 
            % random sampling is used; 3 if points are considered 
            % equally spaced in the line segment, joining the 
            % variable upper and lower bounds; 4 if the algorithm is
            % initialized with a list provided by the optimizer;
%
user_list_size = 1;  % 0-1 variable: 1 if the user sets below the iterate 
                     % list initial size; 0 if the iterate list initial size
                     % equals the problem dimension.
%                     
nPini = 300; % Number of points to consider in the iterate
            % list initialization, when its size is defined 
            % by the user.            
%
    alfa_ini  = 16;    % Initial step size.