{--A deque, short for double-ended queue, is a list-like data structure that supports efficient element
insertion and removal from both its head and its tail. Recall that Haskell lists, however, only support O(1)
insertion and removal from their head.
Implement a deque data type in Haskell by using two lists: the first one containing elements from the
initial part of the list, and the second one containing elements form the final part of the list, reversed.
In this way, elements can be inserted/removed from the first list when pushing to/popping the deque's
head, and from the second list when pushing to/popping the deque's tail.
1) Write a data type declaration for Deque.
2) Implement the following functions:
•toList: takes a Deque and converts it to a list
•fromList: takes a list and converts it to a Deque
•pushFront: pushes a new element to a Deque's head
•popFront: pops the first element of a Deque, returning a tuple with the popped element and the new Deque
•pushBack: pushes a new element to the end of a Deque
•popBack: pops the last element of a Deque, returning a tuple with the popped element and the new Deque
3) Make Deque an instance of Eq and Show.
4) Make Deque an instance of Functor, Foldable, Applicative and Monad.
You may rely on instances of the above classes for plain lists.--}

--1.
data Deque a = Deque [a] [a]

--2.
toList :: Deque a -> [a]
toList (Deque ls1 ls2) = ls1 ++ (reverse ls2)

fromList :: [a] -> Deque a
fromList ls =
    let halfL = (length ls) `div` 2 in
        Deque (take halfL ls) (reverse (drop halfL ls))

pushFront :: a -> Deque a -> Deque a
pushFront x (Deque h t) = Deque (x:h) t

pushBack :: a -> Deque a -> Deque a
pushBack x (Deque h t) = Deque h (x:t)

popFront :: Deque a -> (a, Deque a)
popFront (Deque (x:h) t) = (x, Deque h t) 
popFront (Deque [] []) = error "empty deque"
popFront (Deque [] [x]) = (x, Deque [] [])
popFront (Deque [] lst) = popFront $ fromList $ reverse lst 

popBack :: Deque a -> (a, Deque a)
popBack (Deque h (x:t)) = (x, Deque h t)
popBack (Deque [] []) = error "empty deque"
popBack (Deque [x] []) = (x, Deque [] [])
popBack (Deque lst []) = popBack $ fromList lst

--3.
instance (Eq a) => Eq (Deque a) where
    x == y = toList x == toList y

instance (Show a) => Show (Deque a) where
    show x = show $ toList x

--4.
instance Functor Deque where
    --fmap f (Deque h t) = fromList (map f (h ++ (reverse t)))
    fmap f d = fromList (map f (toList d))

instance Foldable Deque where
    foldr f i d = foldr f i $toList d

instance Applicative Deque where
    pure x = Deque [x][]
    fs <*> d = fromList $ toList fs <*> toList d

instance Monad Deque where
    -- NON HO CAPITO
    d >>= f = fromList $ concatMap (toList . f) $ toList d