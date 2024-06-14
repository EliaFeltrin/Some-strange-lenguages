{-- Consider a data structure Gtree for general trees, i.e. trees containg some data in each node, and a
variable number of children.
1. Define the Gtree data structure.
2. Define gtree2list, i.e. a function which translates a Gtree to a list.
3. Make Gtree an instance of Functor, Foldable, and Applicative. --}

data Gtree a = Tnil | Gtree a [Gtree a] deriving (Show)

gtree2list :: Gtree a -> [a]
gtree2list Tnil = []
gtree2list (Gtree x xs) = x : concatMap gtree2list xs 

instance Functor Gtree where
    fmap _ Tnil = Tnil
    fmap f (Gtree x xs) = Gtree (f x) (fmap (fmap f) xs)

instance Foldable Gtree where
    -- foldr f i (Gtree x xs) = f (foldr f i xs) x  CHISSA' SE E' GIUSTO
    foldr f i t = foldr f i $ gtree2list t

t +++ Tnil = t
Tnil +++ t = t
(Gtree x xs) +++ t = Gtree x (xs ++ [t])
--(Gtree x xs) +++ (Gtree y ys) = Gtree y ((Gtree x []:xs) ++ ys)


gtconcat = foldr (+++) Tnil

gtconcatMap :: (a -> b) -> Gtree a -> Gtree b
gtconcatMap f t = gtconcat $ fmap f t 


t1 = Gtree 1 [Gtree 2 [Gtree 3 [Tnil], Gtree 4 [Tnil]], Gtree 5 [Tnil]]
t2 = Gtree 6 [Gtree 7 [Gtree 8 [Tnil], Gtree 9 [Tnil]], Gtree 0 [Tnil]]
list = [t1, t2]

instance Applicative Gtree where
    pure x = Gtree x []
    x <*> y = gtconcatMap (\f -> fmap f y) x

-- STA ROBA NON COMPILA E NEMMENO QUELLA DEL PROF