% Create a distributed hash table with separate chaining. The hash table will consist of an agent for each
% bucket, and a master agent that stores the buckets’ PIDs and acts as a middleware between them and the
% user. Actual key/value pairs are stored into the bucket agents.
% The middleware agent must be implemented by a function called hashtable_spawn that takes as its
% arguments (1) the hash function and (2) the number of buckets. When executed, hashtable_spawn
% spawns the bucket nodes, and starts listening for queries from the user. Such queries can be of two kinds:
% • Insert: {insert, Key, Value} inserts a new element into the hash table, or updates it if an
% element with the same key exists;
% • Lookup: {lookup, Key, RecipientPid} sends to the agent with PID “RecipientPid” a
% message of the form {found, Value}, where Value is the value associated with the given key, if
% any. If no such value exists, it sends the message not_found.
% The following code:

% main() ->
% HT = spawn(?MODULE, hashtable_spawn, [fun(Key) -> Key rem 7 end, 7]),
% HT ! {insert, 15, "Apple"},
% HT ! {insert, 8, "Orange"},
% timer:sleep(500),
% HT ! {lookup, 8, self()},
% receive
% {found, A1} -> io:format("~s~n", [A1])
% end,
% HT ! {insert, 8, "Pineapple"},
% timer:sleep(500),
% HT ! {lookup, 8, self()},
% receive
% {found, A2} -> io:format("~s~n", [A2])
% end.
% should print the following:
% Orange
% Pineapple

-module(ex_20220121).

hashtable_spawn(HashFun, NBuckets) ->
    BucketPIDs = [spawn(?MODULE, bucket, [[]]) || _ <- list:seq(0, NBuckets)],
    hs_loop(HashFun, NBuckets).

hs_loop(HashFun, NBuckets) ->
    receive
        {insert, Key, Value} -> 
            lists:nth(HashFun(Key) + 1, BucketPIDs) ! {insert, Key, Value},
            hs_loop(HashFun, NBuckets);
        {lookup, Key, AnswerPID} ->
            lists:nth(HashFun(Key) + 1, BucketPIDs) ! {lookup, Key, AnswerPID},
            hs_loop(HashFun, NBuckets)
    end.

bucket(Content) ->
    receive
        {insert, Key, Value} ->
            NewContent = lists:keystore(Key, 1, Content, {Key, Value}),
            bucket(NewContent);
        {lookup, Key, AnswerPID} ->
            case lists:keyfind(Key, 1, Content) of
                false -> 
                    AnswerPID ! not_found;
                {_, Val} ->
                    AnswerPID ! {found, Val}
            end,
            bucket(Content)
        end.
         

main() ->
HT = spawn(?MODULE, hashtable_spawn, [fun(Key) -> Key rem 7 end, 7]),
HT ! {insert, 15, "Apple"},
HT ! {insert, 8, "Orange"},
timer:sleep(500),
HT ! {lookup, 8, self()},
receive
{found, A1} -> io:format("~s~n", [A1])
end,
HT ! {insert, 8, "Pineapple"},
timer:sleep(500),
HT ! {lookup, 8, self()},
receive
{found, A2} -> io:format("~s~n", [A2])
end.