module My.Flow
  (
    -- * Function application
    (|>)
  , (<|)
  , apply
    -- * flipped fmap
  , (|$>)
    -- * Function composition
  , (.>)
  , (<.)
  , compose
    -- * Strict function application
  , (!>)
  , (<!)
  , apply',
  ) where

import Prelude ( Functor
               , (<$>)
               , seq
               )

infixl 1 |>
(|>) :: a -> (a -> b) -> b
x |> f = apply x f

infixr 1 <|
(<|) :: (a -> b) -> a -> b
f <| x = apply x f

apply :: a -> (a -> b) -> b
apply x f = f x

infixl 1 |$>
(|$>) :: Functor f => f a -> (a -> b) -> f b
x |$> f = f <$> x

infixl 9 .>
(.>) :: (a -> b) -> (b -> c) -> (a -> c)
f .> g = compose f g

infixr 9 <.
(<.) :: (b -> c) -> (a -> b) -> (a -> c)
g <. f = compose f g

compose :: (a -> b) -> (b -> c) -> (a -> c)
compose f g x = g (f x)

infixl 0 !>
(!>) :: a -> (a -> b) -> b
x !> f = apply' x f

infixr 0 <!
(<!) :: (a -> b) -> a -> b
f <! x = apply' x f

apply' :: a -> (a -> b) -> b
apply' x f = seq x (apply x f)
