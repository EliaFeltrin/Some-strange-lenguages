% Create a function node_wait that implements nodes in a tree-like topology. Each node, which is a
% separate agent, keeps track of its parent and children (which can be zero or more), and contains a value.
% An integer weight is associated to each edge between parent and child.
% A node waits for two kind of messages:
% • {register_child, ...}, which adds a new child to the node (replace the dots with appropriate values),
% • {get_distance, Value}, which causes the recipient to search for Value among its children, by
% interacting with them through appropriate messages. When the value is found, the recipient
% answers with a message containing the minimum distance between it and the node containing
% "Value", considering the sum of the weights of the edges to be traversed. If the value is not found,
% the recipient answers with an appropriate message. While a node is searching for a value among
% its children, it may not accept any new children registrations. E.g., if we send {get_distance, a} to
% the root process, it answers with the minimum distance between the root and the closest node
% containing the atom a (which is 0 if a is in the root).
-module(ex_20210622).


node_wait(Parent, Elem, Children) ->
    receive 
        {register_child, Child, Weight} ->
            node_wait(Parent, Elem, [{Child, Weight } | Children]);
        {get_distance, Value} ->
            if
                Value =:= Elem -> 
                    Parent ! {distance, Elem, self(), 0},
                    node_wait(Parent, Elem, Children);
                length(Children) =:= 0 ->
                    Parent ! {distance, Elem, self(), notFound};
                true ->
                    Distances = [ 
                        receive
                            {distance, Elem, Child, PLength} -> PLength
                        end || Child <- Children
                    ],
                    ValidDists = lists:filter(fun erlang:isInteger/1, Distances),
                    if
                        length(ValidDists) > 0 ->
                            Parent ! {distance, Elem, self(), lists:min(ValidDists)};
                        true ->
                            Parent ! {distance, Elem, self(), notFound}
                    end
            end
    end.


% DI CERTO NON HO VOGLIA DI TESTARLO,  COMPILA E VA BENE COSI'

                

