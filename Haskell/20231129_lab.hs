import Control.Monad.State

type Stack = [Int]

pop :: Stack -> (Int, Stack)
pop(x:xs) = (x, xs)

push :: Int -> Stack -> ((), Stack)
push a xs = ((), a:xs)

-- let's define a function that do something on the stack
stackManip :: Stack -> (Int, Stack)
stackManip s = 
    let ((), stack1) = push 5 s
        (a, stack2) = pop stack1
    in pop stack2

ex1 :: [Int]
ex1 = [1, 2, 3, 4]

popM :: State Stack Int
popM = state pop

pushM :: Int -> State Stack () 
pushM a = state $ \stack ->   ((), a : stack)

stackManipM :: Stack -> (Int, Stack)
stackManipM = do
    push 3
    a <- pop
    pop

---------------

data RobotState = RobotState {
    position :: (Int, Int),
    holdingObject :: Bool
} deriving (Show)

moveTo :: (Int, Int) -> State RobotState ()             --remember that this is a function that returns a tuple ((), RobotState)
moveTo newPos = modify (\s -> s {position = newPos})    --modify allow to return an object equal to the input one except for the parameter

pickUpObject :: State RobotState ()
pickUpObject = modify (\s -> s {holdingObject = True})

resetRob :: State RobotState ()
resetRob = put $ RobotState (0,0) False

robotAction :: State RobotState () 
robotAction = do
    moveTo (3,4)
    pickUpObject
    moveTo (1,2)
    resetRob

-- rs0 = RobotState (0, 0) False it's the same of
rs0 = RobotState {  position = (0, 0), holdingObject = False }
rs1 = runState robotAction rs0

---------------------------------------------------------------------------
{--
Consider the binary tree data structure as seen in class.
1. Define a function btrees which takes a value x and returns an infinite list of binary trees, where:
  1. all the leaves contain x,
  2. each tree is complete,
  3. the first tree is a single leaf, and each tree has one level more than its previous one in the list.
2. Define an infinite list of binary trees, which is like the previous one, but the first leaf contains the integer 1, and each subsequent tree contains leaves that have the value of the previous one incremented by one.
E.g. [Leaf 1, (Branch (Leaf 2)(Leaf 2), ...]
3. Define an infinite list containing the count of nodes of the trees in the infinite list of the previous point. E.g. [1, 3, ...]
Write the signatures of all the functions you define.
--}

data Tree a = Leaf a | Branch (Tree a) (Tree a) deriving (Show)

--1.
bTrees :: a -> [Tree a]
bTrees x = Leaf x : [Branch sub sub | sub <- bTrees x]

--2.
instance Functor Tree where
    fmap f (Leaf x) = Leaf $ f x
    fmap f (Branch l r) = Branch (fmap f l) (fmap f r)

bTrees' :: [Tree Int]
bTrees' = Leaf 1 : [Branch ((+1) <$> sub) ((+1) <$> sub) | sub <- bTrees']

--3.
count :: [Int]
count = [2^x - 1 | x <- [1 ..]]
