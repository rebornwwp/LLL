module SimpleResult where

import           SimpleJson

result :: JValue
result =
  JObject
    [ ("query", JString "awkward squad haskell")
    , ("estimatedCount", JNumber 3920)
    , ("moreResult", JBool True)
    , ( "results"
      , JArray
          [ JObject
              [ ("title", JString "Simon Peyton Jones: papers")
              , ("snippet", JString "Tackling the awkward ...")
              , ("url", JString "http://.../marktoberdorf/")
              ]
          ])
    ]
