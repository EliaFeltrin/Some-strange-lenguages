{--We want to implement a binary tree where in each node is stored data, together with the number of nodes
contained in the subtree of which the current node is root.
1. Define the data structure.
2. Make it an instance of Functor, Foldable, and Applicative.--}

--1.
data Bntree a = Tnil | Bntree Int a (Bntree a) (Bntree a) deriving (Eq, Show)

--2.
instance Functor Bntree where
    fmap _ Tnil = Tnil
    fmap f (Bntree c v l r) = Bntree c (f v) (fmap f l) (fmap f r)

instance Foldable Bntree where
    foldr f i (Tnil) = i
    foldr f i (Bntree c v l r) = f (f (foldr f i r) l) v

