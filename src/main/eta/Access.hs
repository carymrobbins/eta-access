module Access where

import Prelude
import Java hiding ((<.>))

{-# INLINE dotImpl #-}
dotImpl :: Class c => (level (Java c a) -> Java c a) -> c -> level (Java c a) -> Java b a
dotImpl access cls method = Java $ \o -> case m (unobj cls) of (# _, a #) -> (# o, a #)
  where
  Java m = access method

class Accessible level c b where
  (<.>) :: Class c => c -> level (Java c a) -> Java b a

newtype Public a = Public { unPublic :: a }

instance Accessible Public c b where
  {-# INLINE (<.>) #-}
  (<.>) = dotImpl unPublic

newtype Protected a = Protected { unProtected :: a }

instance (b <: c) => Accessible Protected c b where
  {-# INLINE (<.>) #-}
  (<.>) = dotImpl unProtected

newtype Private a = Private { unPrivate :: a }

instance Accessible Private c c where
  {-# INLINE (<.>) #-}
  (<.>) = dotImpl unPrivate
