% We want to implement a parallel foldl, parfold(F, L, N), where the binary operator F is associative, and N
% is the number of parallel processes in which to split the evaluation of the fold. Being F associative,
% parfold can evaluate foldl on the N partitions of L in parallel. Notice that there is no starting (or
% accumulating) value, differently from the standard foldl.
% You may use the following libray functions:
% lists:foldl(<function>, <starting value>, <list>)
% lists:sublist(<list>, <init>, <length>), which returns the sublist of <list> starting at position
% <init> and of length <length>, where the first position of a list is 1.
-module(ex_20220901).
-export([parfold/3, divide/3]).

divide(L, N, Acc) when N =:= 0 -> Acc; 
divide(L, N, Acc) ->
    Len = length(L) div N,
    divide(lists:sublist(L, Len + 1, length(L) - Len), N - 1, Acc ++ [lists:sublist(L, 1, Len)]).

doFoldl(F, [X|Xs]) ->
    V = lists:foldl(F, X, Xs),
    helper ! {parRes, self(), V}.


parfold(_, L, N) when N > length(L) -> error("SOSSSS");
parfold(F, L, N) ->
    SubLs = divide(L, N, []),
    register(helper, self()),
    S = [spawn(?MODULE, doFoldl, [F, SubL]) || SubL <- SubLs],
    [R|Rs] = [receive {parRes, P, V} -> V end || P <- S],
    lists:foldl(F, R, Rs).

% DOVREBBERE ESSERE GIUSTO, C'E' UN ERRORE A RUNTIME A LINEA 26 A QUANTO PARE 