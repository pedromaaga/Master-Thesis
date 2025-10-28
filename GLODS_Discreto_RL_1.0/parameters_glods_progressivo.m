%
% Initialization.
%                  
list = 2; % 0-4 variable: 0 if the algorithm initializes the list of
          % points with a single one; 1 if a latin hypercube sampling
          % strategy is considered for initialization; 2 if 
          % random sampling is used; 3 if points are considered 
          % equally spaced in a line segment, joining the 
          % variable upper and lower bounds, jointly with
          % the central point; 4 if the algorithm is
          % initialized with a list provided by the user.
%
user_list_size = 1;  % 0-1 variable: 1 if the user sets below the size of 
                     % the initial list of points; 0 if the initial size
                     % equals the problem dimension.                    
nPini          = 30; % Number of points to be considered in the initialization.
% End of parameters_glods.
%
    alfa_ini = 128; % Initial step size. 