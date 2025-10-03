module FunctorApplicativeMonad.Monads.ReaderLib
  ( view
  , view'
  , main1
  , initEmail
  ) where

-- https://engineering.dollarshaveclub.com/the-reader-monad-example-motivation-542c54ccfaa8
import           Control.Monad.Reader (MonadIO (liftIO),
                                       MonadReader (local, reader), Reader,
                                       ReaderT (runReaderT), ask, asks,
                                       runReader)
import           Data.List            (intercalate)
import           Prelude              hiding (div)

type Html = String

type Email = String

div :: [Html] -> Html
div children = "<div>" ++ combine children ++ "</div>"

h1 :: [Html] -> Html
h1 children = "<h1>" ++ combine children ++ "</h1>"

p :: [Html] -> Html
p children = "<p>" ++ combine children ++ "</p>"

combine :: [Html] -> Html
combine = intercalate ""

view :: Email -> Html
view email = div [page email]

page :: Email -> Html
page email = div [topNav, content email]

topNav :: Html
topNav = div [h1 ["OurSite.com"]]

content :: Email -> Html
content email = div [h1 ["Custom Content for " ++ email], left, right email]

left :: Html
left = div [p ["this is the left side"]]

right :: Email -> Html
right email = div [article email]

article :: Email -> Html
article email = div [p ["this is an article"], widget email]

widget :: Email -> Html
widget email = div [p ["Hey " ++ email ++ ", we've got a great offer for you!"]]

--
-- newtype Reader e a = Reader { runReader :: e -> a }
-- instance Functor (Reader a) where
--   fmap f (Reader g) = Reader $ f . g
-- instance Applicative (Reader a) where
--   pure x = Reader $ \_ -> x
--   m <*> n = Reader $ \e -> (runReader m e) (runReader n e)
-- instance Monad (Reader a) where
--   m >>= f = Reader $ \e -> runReader (f $ runReader m $ e) e
-- ask :: Reader a a
-- ask = Reader id
-- asks :: (e -> a) -> Reader e a
-- asks = Reader
--
--
-- modify Reader content
initEmail :: Reader Email Html
initEmail = local ("XXXXXXXX" ++) view'

view' :: Reader Email Html
-- view' = page' >>= \pagep -> return $ div [pagep]
view' = do
  pp <- page'
  return $ div [pp]

page' :: Reader Email Html
page' = content' >>= \contentp -> return $ div [contentp]

content' :: Reader Email Html
content' =
  ask >>= \email ->
    right' >>= \rightp ->
      return $ div [h1 ["Custom Content for " ++ email], left, rightp]

right' :: Reader Email Html
right' = article' >>= \articlep -> return $ div [articlep]

article' :: Reader Email Html
article' =
  widget' >>= \widgetp -> return $ div [p ["this is an article"], widgetp]

widget' :: Reader Email Html
-- widget' =
--   ask >>= \email ->
--     return $ div [p ["Hey " ++ email ++ ", we've got a great offer for you!"]]
widget' = do
  email <- ask
  return $ div [p ["Hey " ++ email ++ ", we've got a great offer for you!"]]

calculateContentLen :: Reader String Int
-- calculateContentLen = do
--   content <- ask
--   return (length content)
-- calculateContentLen = do
--   length <$> ask
calculateContentLen = asks length

-- Calls calculateContentLen after adding a prefix to the Reader content.
calculateModifiedContentLen :: Reader String Int
calculateModifiedContentLen = local ("Prefix " ++) calculateContentLen

printReaderContent :: ReaderT String IO ()
printReaderContent = do
  content <- ask
  liftIO $ putStrLn ("The Reader Content: " ++ content)

main1 :: IO ()
main1 = do
  let s = "12345"
  let modifiedLen = runReader calculateModifiedContentLen s
  let len = runReader calculateContentLen s
  putStrLn $ "Modified 's' length: " ++ show modifiedLen
  putStrLn $ "Original 's' length: " ++ show len
  runReaderT printReaderContent "Some Content"
  print ex1
  print ex2
  print $ runReader (reader (const 8)) 10

-- another example from What I wish
data MyContext =
  MyContext
    { foo :: String
    , bar :: Int
    }
  deriving (Show)

computation :: Reader MyContext (Maybe String)
computation = do
  n <- asks bar
  x <- asks foo
  if n > 0
    then return (Just x)
    else return Nothing

ex1 :: Maybe String
ex1 = runReader computation $ MyContext "helloXXXX" 1

ex2 :: Maybe String
ex2 = runReader computation $ MyContext "haskellXXXX" 0
