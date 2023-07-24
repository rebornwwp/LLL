module PhantomType where

{- | https://www.stevenleiva.com/posts/phantom_types
-}
data Mile

data Kilometer

newtype Distance a =
  Distance
    { unDistance :: Double
    }
  deriving (Num, Show)

addMilesToKilometers ::
     Distance Mile -> Distance Kilometer -> Distance Kilometer
addMilesToKilometers distanceInMiles distanceInKilometers =
  Distance
    (unDistance distanceInKilometers + unDistance distanceInMiles * 1.60934)

addKilometersToMiles :: Distance Kilometer -> Distance Mile -> Distance Mile
addKilometersToMiles distanceInKilometers distanceInMiles =
  Distance
    (unDistance distanceInMiles + unDistance distanceInKilometers * 0.621371)

class Add a b where
  addDistance :: Distance a -> Distance b -> Distance b

instance Add Mile Kilometer
 where
  addDistance = addMilesToKilometers

instance Add Kilometer Mile
 where
  addDistance = addKilometersToMiles

instance Add Mile Mile

 where
  addDistance = (+)

instance Add Kilometer Kilometer where
  addDistance = (+)

tenMiles = Distance 10 :: Distance Mile

tenKilometers = Distance 10 :: Distance Kilometer

a = addDistance tenMiles tenMiles


-- => Distance {unDistance = 20.0} :: Distance Mile
b = addDistance tenKilometers tenKilometers


-- => Distance {unDistance = 20.0} :: Distance Kilometer
c = addDistance tenMiles tenKilometers


-- => Distance {unDistance = 26.0934} :: Distance Kilometer
d = addDistance tenKilometers tenMiles
-- => Distance {unDistance = 16.21371} :: Distance Mile
