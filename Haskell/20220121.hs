{--
Consider a Tvtl (two-values/two-lists) data structure, which can store either two values of a given type, or
two lists of the same type.
Define the Tvtl data structure, and make it an instance of Functor, Foldable, and Applicative.
--}

data Tvtl a = Tv a a | Tl [a] [a] deriving (Eq, Show)

instance Functor Tvtl where
    fmap f (Tv x y) = Tv (f x) (f y)
    fmap f (Tl xs ys) = Tl (fmap f xs) (fmap f ys)

instance Foldable Tvtl where
    foldr f i (Tv x y) = f x (f y i)
    foldr f i (Tl xs ys) = foldr f (foldr f i ys) xs

(Tv a b) +++ (Tv c d)       = Tl [a, c] [b, d]
(Tv a b) +++ (Tl cs ds)     = Tl (a:cs) (b:ds)
(Tl as bs) +++ (Tv c d)     = Tl (as++[c]) (bs++[d])
(Tl as bs) +++ (Tv cs ds)   = Tl (as++[cs]) (bs++[ds])

tvtlconcat list     = foldr (+++) (Tl [] []) list
tvtlconcatmap f t   = tvtlconcat $ fmap f t               -- NB: first fmap, then concat

instance Applicative Tvtl where
    pure x = Tl [x][]
    x <*> y = tvtlconcatmap (\f -> fmap f y) x    



