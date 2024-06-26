module Basic.For where

import           Control.Monad      (forM_)
import           Control.Monad.Cont (ContT (runContT), MonadCont (callCC),
                                     MonadIO (liftIO))

testmain :: IO ()
testmain = do
  print "for demo" >> print "let's begin"
  forM_ [1 .. 3] $ \i -> print i
  withBreak $ \break ->
    forM_ [1 ..] $ \_ -> do
      p "loop"
      break ()
  where
    withBreak = (`runContT` return) . callCC
    p = liftIO . putStrLn
