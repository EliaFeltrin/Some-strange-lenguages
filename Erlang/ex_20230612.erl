% Consider the following implementation of mergesort and write a parallel version of it.
% mergesort([L]) -> [L];
% mergesort(L) ->
% {L1, L2} = lists:split(length(L) div 2, L),
% merge(mergesort(L1), mergesort(L2)).
% merge(L1, L2) -> merge(L1, L2, []).
% merge([], L2, A) -> A ++ L2;
% merge(L1, [], A) -> A ++ L1;
% merge([H1|T1], [H2|T2], A) when H2 >= H1 -> merge(T1, [H2|T2], A ++ [H1]);
% merge([H1|T1], [H2|T2], A) when H1 > H2 -> merge([H1|T1], T2, A ++ [H2]).
-module(ex_20230612).
-export([mergesort/1]).

mergesort(L) -> 
    mergesort(L, self()),
    SPID = self(),
    receive
        {SPID, OL} -> OL
    end.

%mergesort(L, CallerPID) when length(L) =:= 1 -> CallerPID ! {self(), L}.
mergesort(L, CallerPID) ->
    Me = self(),
    case length(L) of
        1 -> 
            CallerPID ! {Me, L};
        _ ->
            {L1, L2} = lists:split(length(L) div 2, L),
            Left = spawn(?MODULE, fun() -> mergesort(L1, CallerPID) end),
            Right = spawn(?MODULE, fun() -> mergesort(L2, CallerPID) end),
            receive 
                {Left, LV} -> receive 
                    {Right, RV} ->  CallerPID ! {Me, merge(LV, RV)}
                end
            end
    end.
   
merge(L1, L2) -> merge(L1, L2, []).
merge([], L2, A) -> A ++ L2;
merge(L1, [], A) -> A ++ L1;
merge([H1|T1], [H2|T2], A) when H2 >= H1 -> merge(T1, [H2|T2], A ++ [H1]);
merge([H1|T1], [H2|T2], A) when H1 > H2 -> merge([H1|T1], T2, A ++ [H2]).