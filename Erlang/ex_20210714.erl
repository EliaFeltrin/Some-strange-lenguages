% Consider a main process which takes two lists: one of function names, and one of lists of parameters (the
% first element of with contains the parameters for the first function, and so forth). For each function, the
% main process must spawn a worker process, passing to it the corresponding argument list. If one of the
% workers fails for some reason, the main process must create another worker running the same function.
% The main process ends when all the workers are done.

fspawn(Names, Params) ->
    