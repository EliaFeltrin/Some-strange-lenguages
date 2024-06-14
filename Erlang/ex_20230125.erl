% Consider the following non-deterministic finite state automaton (FSA):
% q0 a q0
% q0 b q1
% q0 b q2
% q1 b q0
% q2 b q3
% q3 c q4 
% q4 FINISH
% Write a concurrent Erlang program that simulates the previous FSA, where each state is implemented as a process.
-module(ex_20230125).
-export([start/0, read_string/1]).



q0f() ->
    receive
        {[a|Xs]} -> q0 ! {Xs};
        {[b|Xs]} -> q1 ! {Xs}, q2 ! {Xs}
    end,
    q0f().

q1f() ->
    receive
        {[b|Xs]} -> q0 ! {Xs}
    end, 
    q1f().

q2f() ->
    receive
        {[b|Xs]} -> q3 ! {Xs}
    end,
    q2f().

q3f() ->
    receive
        {[c|Xs]} -> q4 ! {Xs}
    end,
q3f().

q4f() ->
    receive 
        {[]} -> io:format("input accepted~n")
    end.

start() ->
    register(q0, spawn(fun() -> q0f() end)),
    register(q1, spawn(fun() -> q1f() end)),
    register(q2, spawn(fun() -> q2f() end)),
    register(q3, spawn(fun() -> q3f() end)),
    register(q4, spawn(fun() -> q4f() end)),
    register(master, self()).
    
read_string(L) ->
    q0 ! {L},
    ok.

