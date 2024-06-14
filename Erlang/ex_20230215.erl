% Consider the following non-deterministic pushdown automaton (PDA), where Z is the initial stack symbol and represents the empty string:
% SEE PDF IMAGE
% Write a concurrent Erlang program that simulates only the given PDA, and each state of the PDA is implemented
% as an independent parallel process.

-module(ex_20230215).
-export([start/0, read_string/1]).



q0f() ->
    receive
        {[a|Xs], [z|Ys]} -> q1 ! {Xs, [a] ++ [z] ++ Ys}
    end,
    q0f().

q1f() ->
    receive
        {[a|Xs], [a|Ys]} -> q1 ! {Xs, [a] ++ [a] ++ Ys};
        {[b|Xs], [a|Ys]} -> q2 ! {Xs, Ys}, q3 ! {Xs, [a] ++ Ys} 
    end, 
    q1f().

q2f() ->
    receive
        {[b|Xs], [a|Ys]} -> q2 ! {Xs, Ys};
        {[], [z|Ys]} -> q5 ! {[], Ys}
    end,
    q2f().

q3f() ->
    receive
        {[b|Xs], [a|Ys]} -> q4 ! {Xs, Ys}
    end,
q3f().

q4f() ->
    receive
        {[b|Xs], [a|Ys]} -> q3 ! {Xs, [a] ++ Ys};
        {[], [z|Ys]} -> q5 ! {[], Ys}     
    end,
q4f().

q5f() ->
    receive 
        {[], _} -> io:format("input accepted~n")
    end.

start() ->
    register(q0, spawn(fun() -> q0f() end)),
    register(q1, spawn(fun() -> q1f() end)),
    register(q2, spawn(fun() -> q2f() end)),
    register(q3, spawn(fun() -> q3f() end)),
    register(q4, spawn(fun() -> q4f() end)),
    register(q5, spawn(fun() -> q5f() end)),
    register(master, self()).
    
read_string(L) ->
    q0 ! {L, []},
    terminated.

% OVVIAMENTE NON HO VOGLI DI CERCARE UNA SEQUENZA PER TESTARTLO, MA DOVREBBE ESSERE GIUSTO