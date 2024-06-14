data Result a = Ok a | Err deriving (Eq, Show)

-- we want to make a super-simple calculator that manages integer division, whic is an unsafe operation
data Expr = Val Int | Div Expr Expr deriving (Eq, Show) 

--in order to do computation
eval :: Expr -> Int
eval (Val n) = n
eval (Div expr1 expr2) = (eval expr1) `div` (eval expr2)

-- of course, if we define
ex1 = (Div (Val 4) (Val 2))
ex2 = (Div (Val 4) (Val 0))
-- and we try eval ex2 we'll get an error. So we need to use safediv

safediv :: Int -> Int -> Result Int
safediv n m =
    if m == 0 
        then Err
        else Ok (n `div` m) 

-- so we can define 
--eval' :: Expr -> Result Int
--eval' (Val n) = Ok n
--eval' (Div expr1 expr2) = (eval expr1) `safediv` (eval expr2)

-- ok nice, but with
ex3 = (Div ex2 (Val 2))
ex4 = (Div (Val 2) ex2)
-- eval' ex3 and eval' ex4 will barks with "divide by zero"

-- so you need to redefine eval' 
eval' :: Expr -> Result Int
eval' (Val n) = Ok n
eval' (Div expr1 expr2) = 
    case eval' expr1 of
        Err -> Err
        Ok n -> case eval' expr2 of
            Err -> Err
            Ok m -> safediv n m

-- this is a quite expensive implementation, due to the varius case that are applied.
-- so, let's define
bind :: Result Int -> (Int -> Result Int) -> Result Int
bind res f = 
    case res of
        Err -> Err
        Ok x -> f x

-- then we can re-implement eval:
eval'' :: Expr -> Result Int
eval'' (Val n) = Ok n
eval'' (Div expr1 expr2) =
    bind (eval'' expr1) (\n -> eval'' expr2 `bind` \m -> safediv n m)

-- nicer, but still not great in case of long computations. 
-- It'll fantastic to have something like
mEval :: Expr -> Result Int
mEval (Val n) = Ok n
mEval (Div expr1 expr2) = do
    n <- mEval expr1
    m <- mEval expr2
    safediv n m

-- now, let's try to implment a real MONAD
-- we need result to implement both Functor and Applicative
instance Functor Result where
    fmap f (Ok n) = Ok $ f n
    fmap _ Err = Err

instance Applicative Result where
    pure a = Ok a

    Ok f <*> Ok n = f <$> Ok n
    _ <*> Err = Err
    Err <*> _ = Err

-- for Monads, we need to define the function >>= (bind)
instance Monad Result where
    Ok x >>= f  = f x
    Err >>= _   = Err 


-- MONADS HAVE RULES!
-- 1. LEFT IDENTITY: `return x >>= f` is the same as `f x`
-- 2. RIGHT IDENTITY: `m >>= return` is the same as `m`
-- 3. ASSOCIATIVITY: Doing `(m >>= f) >>= g` is like doing
--                   `m >>= (\x -> f x >>= g)`

greet :: String -> String
greet name = "Hello " ++ name ++ "!"


-- It bridges the values from the PURE world to the
-- IMPURE world.
-- Unfortunately, you can't really write real programs
-- without side-effect. Haskell lets you relegate
-- side-effects to monads.

-- SAME IDEA, works for other EFFECTS:
-- I/O, Mutable State, Networking, Error Handling...
-- Hello World (as a monad)
--main = do
--  putStrLn "Hi, what's your name?"
--  msg <- greet <$> getLine
--  putStrLn msg

-- it can be write in the ugly way:
--main = putStrLn "Hi, what's your name?" >> (getLine >>= (\name -> putStrLn $ greet name))
main = putStrLn "Hi, what's your name?" >> (getLine >>= (putStrLn . greet))
