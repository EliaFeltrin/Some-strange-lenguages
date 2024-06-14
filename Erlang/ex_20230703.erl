% 1. Define a “deep reverse” function, which takes a “deep” list, i.e. a list containing possibly lists of any
% depths, and returns its reverse.
% E.g. deeprev([1,2,[3,[4,5]],[6]]) is [[6],[[5,4],3],2,1].
% 2. Define a parallel version of the previous function.
-module(ex_20230703).
-export([deeprev/1, pdp/1]).
%[], [[X|Xs]|Y], [X|Xs]

flat([], Acc) -> Acc;
flat([X|Xs], Acc) ->
    flat(Xs, Acc ++ flat(X, []));
flat(X, Acc) -> Acc ++ [X].
    

deeprev([]) -> [];
deeprev([X|Xs]) ->
    deeprev(Xs) ++ [deeprev(X)];
deeprev(X) -> X.
    
pdph([], PID) -> PID ! {self(), []};
pdph([X|Xs], PID) ->
    Me = self(),
    RPID = spawn(fun() -> pdph(X,  Me) end),
    LPID = spawn(fun() -> pdph(Xs, Me) end),
    receive 
        {RPID, RVal} ->
            receive
                {LPID, LVal} -> PID ! {self(), LVal ++ [RVal]}
            end
    end;
pdph(X, PID) -> PID ! {self(), X}.

pdp(L) ->
    Me = self(),
    pdph(L, Me),
    receive
        {Me, RL} -> RL
    end.
    Me = self(),

%c(ex_20230703).
%ex_20230703:pdp([1,2,[3,[4,5]],[6]]).
