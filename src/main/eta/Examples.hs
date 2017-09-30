module Examples where

import Prelude
import Java hiding ((<.>))
import qualified Java
import Access

data {-# CLASS "Foo" #-}
  Foo = Foo (Object# Foo)
  deriving Class

type instance Inherits Foo = '[Object]

foreign import java unsafe "publicMethod" publicMethod
  :: Public (Java Foo JString)

foreign import java unsafe "protectedMethod" protectedMethod
  :: Protected (Java Foo JString)
  
foreign import java unsafe "privateMethod" privateMethod
  :: Private (Java Foo JString)
  
data {-# CLASS "Bar extends Foo" #-}
  Bar = Bar (Object# Bar)
  deriving Class

type instance Inherits Bar = '[Foo]

data {-# CLASS "Baz" #-}
  Baz = Baz (Object# Baz)
  deriving Class

type instance Inherits Baz = '[Object]

-- It's public, so it should work even with `a`
publicExampleFromAny :: Foo -> Java a JString
publicExampleFromAny foo = foo <.> publicMethod

-- Doesn't compile, `a` is not <: Foo
-- protectedExampleFromAny :: Foo -> Java a JString
-- protectedExampleFromAny foo = foo <.> protectedMethod

-- Doesn't compile, Baz is not <: Foo
-- protectedExampleFromBaz :: Foo -> Java Baz JString
-- protectedExampleFromBaz foo = foo <.> protectedMethod

-- Compiles, Foo <: Foo
protectedExampleFromFoo :: Foo -> Java Foo JString
protectedExampleFromFoo foo = foo <.> protectedMethod

-- Compiles, Bar <: Foo
protectedExampleFromBar :: Foo -> Java Bar JString
protectedExampleFromBar foo = foo <.> protectedMethod

-- Doesn't compile, Bar is not ~ Foo
-- privateExampleFromBar :: Foo -> Java Bar JString
-- privateExampleFromBar foo = foo <.> privateMethod

-- Compiles, Foo ~ Foo
privateExampleFromFoo :: Foo -> Java Foo JString
privateExampleFromFoo foo = foo <.> privateMethod
