% Define a program tripart which takes a list, two values x and y, with x < y, and three functions, taking
% one argument which must be a list.
% • tripart first partitions the list in three sublists, one containing values that are less than both x and
%   y, one containing values v such that x ≤ v ≤ y, and one containing values that are greater than both
%   x and y.
% • Three processes are then spawned in parallel, running the three given functions and passing the
%   three sublists in order (i.e. the first function must work on the first sublist and so on).
% • Lastly, the program must wait the termination of the three processes in the spawning order,
%   assuming that each one will return the pair {P, V}, where P is its PID and V the resulting value.
% • tripart must return the three resulting values in a list, with the resulting values in the same order
%   as the corresponding sublists.
-module(ex_20220616).
-export([tripart/6, f1/1, f2/1, f3/1]).

split(_, X, Y, _, _, _) when X > Y-1 -> error("X >= Y");
split([V|VS], X, Y, L, C, H) when V < X ->
    split(VS, X, Y, L ++ [V], C, H);
split([V|VS], X, Y, L, C, H) when V < Y+1 ->
    split(VS, X, Y, L, C ++ [V], H);
split([V|VS], X, Y, L, C, H) when V > Y ->
    split(VS, X, Y, L, C, H ++ [V]);
split([], _, _, L, C, H) ->
    [L, C, H].


tripart(_, X, Y, _, _, _) when X > Y-1 -> error("X >= Y");
tripart(Lst, X, Y, F1, F2, F3) ->
    register(master, self()),
    [A1, A2, A3] = split(Lst, X, Y, [], [], []),
    P1 = spawn(?MODULE, F1, [A1]),
    P2 = spawn(?MODULE, F2, [A2]),
    P3 = spawn(?MODULE, F3, [A3]),
    receive {P1, V1} ->
        receive {P2, V2} ->
            receive {P3, V3} ->
                [V1, V2, V3]
            end
        end
    end.

f1(Lst) -> 
    V = lists:map(fun(X) -> X+1 end, Lst),
    master ! {self(), V}.
f2(Lst) -> 
    V = lists:map(fun(X) -> X*2 end, Lst),
    master ! {self(), V}.
f3(Lst) -> 
    V = lists:map(fun(X) -> X-1 end, Lst),
    master ! {self(), V}.


% DIO SALAME IL PRIMO CHE FACCIO DA SOLO E L'UNICO CHE COMPILA
