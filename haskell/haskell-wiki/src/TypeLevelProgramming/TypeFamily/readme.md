# Introduce

Sometimes we need to map types onto types. Type families allow expressing such computations:
they map one or several types to a result, which is also a type.

Haskell provides several flavors of type families. We’ll discuss

1. type synonym families (they don’t create new types)
2. data families (they allow defining new data types)
3. associated families (they are defined inside type classes).
4. Another word that is often used to characterize type families is indexed. We use types as indices to type families to get resulting types.
