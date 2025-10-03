# main

[introduction](https://www.fpcomplete.com/haskell/tutorial/mutable-variables/)

## Software Transactional Memory (STM)

[introduction](https://github.com/snoyberg/why-you-should-use-stm)

a mutable variable 如同其他的编程语言中一样，主要面临的问题就是data race的问题,
主要由数据的read和write造成的, 在haskell中提供了STM,
STM gives us both data race protection, and more advanced behavior like retry.

There are two basic building blocks for STM:

* The STM type constructor. It provides a monadic interface, as well as an Alternative instance.
* The TVar type constructor, which is the STM equivalent of an IORef

``` haskell
readIORef :: IORef a -> IO  a
readTVar  :: TVar a  -> STM a

writeIORef :: IORef a -> a -> IO  ()
writeTVar  :: TVar a  -> a -> STM ()

atomically :: STM a -> IO a

newIORef  :: a -> IO  (IORef a)
newTVar   :: a -> STM (TVar  a)
newTVarIO :: a -> IO  (TVar  a)
```

## STM具有事务的机制

In an STM transaction, each time a variable is read or written, a notation is made in the transaction log, internally to GHC's runtime. When it comes time to commit the transaction, the runtime checks the transaction log against the current state of those variables. If any of the variables were read or written, the transaction is retried.
