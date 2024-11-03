# Introduce

Sometimes we need to map types onto types. Type families allow expressing such computations:
they map one or several types to a result, which is also a type.

Haskell provides several flavors of type families. We’ll discuss

1. type synonym families (they don’t create new types)
2. data families (they allow defining new data types)
3. associated families (they are defined inside type classes).
4. Another word that is often used to characterize type families is indexed. We use types as indices to type families to get resulting types.

[goood](https://serokell.io/blog/type-families-haskell#type-constructor-flavours)

`type family`（类型族）和 `FlexibleInstances` 是 Haskell 中实现类型多态和灵活性的方法，但它们的目的和作用范围有所不同。以下是它们的主要区别：

### 1. **目的和使用场景**

- **`type family`**：用于定义与类型类关联的类型别名或关联类型。它允许类型类中的某些类型随实例而变化，并且可以根据不同的类型类实例定义类型。这对于实现具有不同返回类型的多态行为特别有用。
  
- **`FlexibleInstances`**：是一种语言扩展，用于放宽 Haskell 中实例声明的默认约束，允许在实例声明中使用类型变量和更复杂的类型构造器。它不是一个具体的类型功能，而是让我们可以定义更灵活的类型类实例。

### 2. **类型族（Type Family）示例**

`type family` 通常用于在类型类中关联一个类型，而不直接使用类型参数。它在需要不同类型的返回值时非常有用。例如，我们可以定义一个转换类型类 `Convert`，不同实例将有不同的 `Target` 类型：

```haskell
{-# LANGUAGE TypeFamilies #-}

-- 定义一个 Convert 类型类，具有关联类型 Target
class Convert a where
    type Target a
    convert :: a -> Target a

-- 为不同类型定义实例，不同的 Target 类型
instance Convert Int where
    type Target Int = String
    convert x = show x

instance Convert Bool where
    type Target Bool = Int
    convert True = 1
    convert False = 0
```

在这个例子中，`type family` 允许每个实例定义自己的 `Target` 类型。`Convert Int` 的 `Target` 是 `String`，而 `Convert Bool` 的 `Target` 是 `Int`。这种方式使得我们可以有灵活的关联类型，而不需要在每个实例中明确指定类型参数。

### 3. **FlexibleInstances 示例**

在没有 `FlexibleInstances` 的情况下，Haskell 默认只允许我们为具体类型（concrete types）定义实例。例如，假设我们有一个简单的类型类 `ShowList` 来表示所有元素可以被转换为字符串的列表：

```haskell
class ShowList a where
    showListElements :: [a] -> [String]
```

没有 `FlexibleInstances` 的时候，我们只能为具体类型如 `Int`、`String` 等定义实例。

```haskell
-- 定义 ShowList 类型类
class ShowList a where
    showListElements :: [a] -> [String]

-- 为 Int 定义 ShowList 实例
instance ShowList Int where
    showListElements xs = map show xs

-- 为 String 定义 ShowList 实例
instance ShowList String where
    showListElements xs = map show xs
```

使用 `FlexibleInstances` 扩展后，我们可以定义更通用的实例：

```haskell
{-# LANGUAGE FlexibleInstances #-}

-- 为任何实现了 Show 的类型定义 ShowList 实例
instance Show a => ShowList a where
    showListElements xs = map show xs
```

这里，`FlexibleInstances` 允许我们定义 `ShowList` 的实例，而不需要指定具体的类型。我们可以直接使用 `Show a => ShowList a` 这样的实例声明，这在 Haskell 默认的实例规则下是被禁止的。

### 4. **主要区别**

| 特性                      | `type family`                           | `FlexibleInstances`                       |
|---------------------------|-----------------------------------------|-------------------------------------------|
| **目的**                  | 定义随实例变化的关联类型               | 放宽实例的定义规则，允许使用类型变量等   |
| **主要用途**              | 提供不同实例的关联类型                 | 让类型类实例更通用、更灵活               |
| **实现灵活性**            | 实现一种类型类内部的多态性             | 实现实例声明的通用性和多态性             |
| **使用的语言特性**        | 类型族（Type Families）                 | 语言扩展（FlexibleInstances）            |
| **示例场景**              | 需要不同实例有不同的类型关联           | 定义通用实例（如 `Show a => ShowList a`） |
| **典型限制和注意事项**    | 可能需要显式的类型注解以辅助推理       | 可能导致歧义或实例冲突                   |

### 5. **组合使用的场景**

在某些情况下，`type family` 和 `FlexibleInstances` 可以结合使用来定义更灵活的类型类。比如我们可以使用 `FlexibleInstances` 放宽实例约束，使用 `type family` 定义关联类型，实现更加灵活和通用的类型类：

```haskell
{-# LANGUAGE FlexibleInstances, TypeFamilies #-}

-- 定义 Container 类型类，具有关联类型 Item
class Container c where
    type Item c
    insert :: Item c -> c -> c
    getItems :: c -> [Item c]

-- 定义 ListContainer，可以存储任意类型的元素
data ListContainer a = ListContainer [a]

-- 使用 FlexibleInstances 允许为 ListContainer 的任何类型定义实例
instance Container (ListContainer a) where
    type Item (ListContainer a) = a
    insert x (ListContainer xs) = ListContainer (x : xs)
    getItems (ListContainer xs) = xs
```

在这个例子中，`FlexibleInstances` 允许 `ListContainer a` 的实例，而 `type family` 定义了 `Item` 关联类型，可以让 `Item (ListContainer a)` 解析为 `a`。

### 总结

- **`type family`**：用来定义与类型类相关联的类型，在需要不同实例关联不同类型时使用。
- **`FlexibleInstances`**：一种语言扩展，放宽了实例声明的规则，允许定义更通用的实例。
