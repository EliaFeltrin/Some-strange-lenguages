% Define a parallel lexer, which takes as input a string x and a chunk size n, and translates all the words in
% the strings to atoms, sending to each worker a chunk of x of size n (the last chunk could be shorter than
% n). You can assume that the words in the string are separated only by space characters (they can be more
% than one - the ASCII code for ' ' is 32); it is ok also to split words, if they overlap on different chunks.
% E.g.
% plex("this is a nice test", 6) returns [[this,i],[s,a,ni],[ce,te],[st]]
% For you convenience, you can use the library functions:
% • lists:sublist(List, Position, Size) which returns the sublist of List of size Size from
% position Position (starting at 1);
% • list_to_atom(Word) which translates the string Word into an atom.

-module(ex_20220210).
-export([plex/2]).

split(Lst, Start, End, Size) when Start < End ->
    [lists:sublist(Lst, Start, Size)] ++ split(Lst, Start+Size, End, Size);
split(_, _, _, _) -> [].


lex([X|Xs], []) when X =:= 32 ->
    lex(Xs, []);

lex([X|Xs], Word) when X =:= 32 ->
    [list_to_atom(Word)] ++ lex(Xs, []);

lex([X|Xs], Word) ->
    lex(Xs, Word ++ [X]);

lex([],[]) ->
    [];

lex([], Word) ->
    [list_to_atom(Word)].


run(PID, Data) ->
    PID ! {self(), lex(Data, [])}.

plex(Lst, CSize) ->
    Part = split(Lst, CSize, 1, length(Lst)),
    W = lists:map(fun(X) -> spawn(?MODULE, run, [self(), X]) end, Part),
    lists:map(fun(PID) -> receive 
                            {PID, Val} -> V
                            end, 
                W).


% DIO LADRO NON COMPILA E  DIO SOLO SA PERCHE'