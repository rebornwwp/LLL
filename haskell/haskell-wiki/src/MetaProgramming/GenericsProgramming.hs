{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module MetaProgramming.GenericsProgramming where

import           Data.Text    (Text)
import           GHC.Generics (Generic)


-- data-type-generic programming
data Status
  = OK
  | Err
  deriving (Generic, Show) --


-- >>>> :info Generic
-- type Generic :: * -> Constraint
-- class Generic a where
--   type Rep :: * -> * -> *
--   type family Rep a
--   from :: a -> Rep a x
--   to :: Rep a x -> a
--   {-# MINIMAL from, to #-}
--   	-- Defined in ‘GHC.Generics’
-- >>>> :t from OK
-- from OK
--   :: D1
--        ('MetaData
--           "Status" "MetaProgramming.GenericsProgramming" "main" 'False)
--        (C1 ('MetaCons "OK" 'PrefixI 'False) U1
--         :+: C1 ('MetaCons "Err" 'PrefixI 'False) U1)
--        x
data Request =
  Request String Int
  deriving (Generic)


-- the Generic type class allows us to go from a value to its generic representation and back.

-- example. generate Insert sql queries
data Student =
  Student
    { studentId :: Int
    , name      :: Text
    , year      :: Int
    }

data Course =
  Course
    { courseId   :: Int
    , title      :: Text
    , instructor :: Int
    }

class ToSQL a where
  insertInto :: Text -> a -> Text
