import ExpTest (sumThree)

result = sumThree 5

-- CLASSES
-- this is already implemented, but as an exaple
{--
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool
    -- default implementation
    x /= y = not (x == y)
--} 

data Tree a = Leaf a | Branch (Tree a) (Tree a)

-- this means: "a implmente Eq, and also Tree will"
instance (Eq a) => Eq (Tree a) where
    Leaf a == Leaf b = a == b
    (Branch l1 r1) == (Branch l2 r2) =  l1 == l2 && r1 == r2
    _ == _ = False 

instance (Show a) => Show (Tree a) where
    show (Leaf a) = show a
    show (Branch l r) = "<< " ++ show l ++ "| " ++ show r ++ " >>"


-- treeFoldr f z Empty = z DOVREBBE ESSERCI MA NON GLI PIACE EMPTY
treeFoldr f z (Leaf x) = f x z
treeFoldr  f z (Branch l r) = treeFoldr f (treeFoldr f z r) l
instance Foldable Tree where
    foldr = treeFoldr
-- foldl is not needed since it can be expressed i term of foldr

t1 = Branch (Leaf 1) (Leaf 2)
t2 = Branch (Leaf 1) (Leaf 2)
t3 = Branch (Leaf 2) (Leaf 1)


--FUNCTOR: a way to apply a function in a context 
--first example: let's try to manage errors
data Result a = Err | Ok a deriving (Eq, Ord, Show)

safediv :: Int -> Int -> Result Int
safediv m n = 
    if m == 0 
        then Err 
        else Ok $ n `div` m

instance Functor Result where
    fmap f (Ok x) = Ok $ f x 
    fmap _ Err = Err

instance Functor Tree where
    -- fmap _ Empty = Empty IT SHOUL BE THERE BUT HASKELL COMPLAINS
    fmap f (Leaf a) = Leaf $ f a
    fmap f (Branch l r) = Branch (fmap f l) (fmap f r)

{--
GOLDEN  RULES FOR FMAP:
    fmap id = id
    fmap (f . g) = fmap f . fmap g
--}

-- NOW THE PROBLEM IS:
--  (+) <$> (Ok 5) is unuseful.If u try ((+) <$> (Ok 5)) <$> (Ok 3) haskell complains
-- so use Applicative!

instance Applicative Result where
    --(<*>) :: Result (a -> b) -> Result a -> Result b
    (Ok f) <*> (Ok x) = Ok $ f x
    _ <*> Err = Err
    Err <*> _ = Err

    pure = Ok -- MANDATORY


{--APPLICATIVE RULES
    pure id <*> v = v                            -- Identity
    pure f <*> pure x = pure (f x)               -- Homomorphism
    u <*> pure y = pure ($ y) <*> u              -- Interchange
    pure (.) <*> u <*> v <*> w = u <*> (v <*> w) -- Composition
--}
