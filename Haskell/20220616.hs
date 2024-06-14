{--Consider the "fancy pair" data type (called Fpair), which encodes a pair of the same type a, and may
optionally have another component of some "showable" type b, e.g. the character '$'.
Define Fpair, parametric with respect to both a and b.
1) Make Fpair an instance of Show, where the implementation of show of a fancy pair e.g. encoding
(x, y, '$') must return the string "[x$y]", where x is the string representation of x and y of y. If the third
component is not available, the standard representation is "[x, y]".
2) Make Fpair an instance of Eq — of course the component of type b does not influence the actual
value, being only part of the representation, so pairs with different representations could be equal.
3) Make Fpair an instance of Functor, Applicative and Foldable.--}

data Fpair s a = Fpair s a a | Pair a a 

--1.
instance (Show a, Show s) => Show (Fpair s a) where
    show (Fpair s a b) = "[" ++ (show a) ++ (show s) ++ (show b) ++ "]"
    show (Pair a b) = "[" ++ (show a) ++ ", " ++ (show b) ++ "]"

--2.
tolist (Fpair _ a b) = (a, b)
tolist (Pair a b) = (a, b)

instance (Eq a) => Eq (Fpair s a) where
    x == y = (tolist x) == (tolist y)


--3.
instance Functor (Fpair s) where
    fmap f (Pair a b) = Pair (f a) (f b)
    fmap f (Fpair s a b) = Fpair s (f a) (f b)

instance Foldable (Fpair s) where
    foldr f i (Pair a b) = f a (f b i)
    foldr f i (Fpair _ a b) = f a (f b i)

instance Applicative (Fpair s) where
    pure x = Pair x x
    (Pair f g) <*> (Pair a b)       = Pair (f a) (g b)
    (Pair f g) <*> (Fpair s a b)    = Fpair s (f a) (g b)
    (Fpair s f g) <*> (Pair a b)    = Fpair s (f a) (g b)
    (Fpair s f g) <*> (Fpair t a b) = Fpair t (f a) (g b)


 