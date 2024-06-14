% Consider the apply operation (i.e.<*>) in Haskell's Applicative class.
% Define a parallel <*> for Erlang's lists.
-module(ex_20210208).
-export([test/0]).

fmap(F, [], PPID, Acc) -> PPID ! {fmapRes, Acc, self()};
fmap(F, [X|Xs], PPID, Acc) ->
    fmap(F, Xs, PPID, Acc ++ [F(X)]).

papp(F, L) ->
    Me = self(),
    Mappers = [spawn(fun() -> fmap(Fi, L, Me, []) end) || Fi <- F],
    Res = [receive {fmapRes, FmapRes, MPID} -> FmapRes end|| MPID <- Mappers],
    Res.

test() ->
    Fs = [fun(X) -> X+1 end, fun(X) -> X+2 end],
    L = [1,2],
    papp(Fs, L).

%ONLY GOD KNOWS IF VA BEN CUSITA