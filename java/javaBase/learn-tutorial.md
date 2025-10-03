# hello java

``` java
// HelloWorldApp.java
class HelloWorldApp {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```

# 注释

``` java
/* ignored text */

/** documentation one line */

/** 
 * documentation
 * multiple lines
 */

// ignored text
```

# 变量

``` java
// 传统意义上的变量

// literals
boolean result = true;
char capitalC = 'C';
byte b = 100;
short s = 1000;
int i = 100000;

// integer literals
int decVal = 26;
int hexVal = 0x1a;
int binVal = 0b11010;

// floating point literals
double d1 = 123.4;
double d2 = 1.234e2;
float f1 = 123.4f;

// string
String s = "hello world";

// using underscore characters in numeric literals
long creditCardNumber = 1234_5678_9012_3456L;
float pi = 3.14_15F;
byte nybbles = 0b0010_0101;
long bytes = 0b11010010_01101001_10010100_10010010;
```

``` java
// 数组(Array)
// ArrayDemo.java
class ArrayDemo {
    public static void main(String[] args) {
        // declares an array of integers
        int[] anArray;

        // allocates memory for 10 integers
        anArray = new int[10];

        // initialize first element
        anArray[0] = 100;

        // initialize second element
        anArray[1] = 200;
        // and so forth
        anArray[2] = 300;
        anArray[3] = 400;
        anArray[4] = 500;
        anArray[5] = 600;
        anArray[6] = 700;
        anArray[7] = 800;
        anArray[8] = 900;
        anArray[9] = 1000;
        System.out.println("Element an index 0 is " + anArray[0]);
    }
}
// see more array information at https://docs.oracle.com/javase/tutorial/java/nutsandbolts/arrays.html
```

sumary of variables
primitive data `byte` , `short` , `int` , `long` , `float` , `double` , `boolean` , `char` , and `java.long.String`

# operators

``` java
// assignment, arithmetic, and unary operators

// assignment(=)
int cadence = 0;

// arithmetic(+, - , *, /, %)
int result1 = 1 + 2;
int result2 = 2 - 1;
int result3 = 2 * 1;
int result4 = 5 / 2;
int result5 = 5 % 2;

// the unary operators (+, -, ++, --, !)
int result = +1;
// result is 1
result--;
// result is 0
result++;
// result is 1
result = -result;
// result is -1
boolean success = false;
System.out.println(!success);
// true

int i = 3;
i++;
++i;
i--;
--i;

// Equality, relational, and conditional operators
// the equality and relational
// ==, !=, >, >=, <, <=
int value1 = 1;
int value2 = 2;
if(value1 == value2)
    System.out.println("value1 == value2");
if(value1 != value2)
    System.out.println("value1 != value2");
if(value1 > value2)
    System.out.println("value1 > value2");
if(value1 < value2)
    System.out.println("value1 < value2");
if(value1 <= value2)
    System.out.println("value1 <= value2");

// the conditional operators
// &&, ||, ?:
boolean and = true && false;
boolean or = true || false;
int i = true ? 1 : 2;

// the type comparison operator instanceof
// instanceof
// obj instanceof Class

// bitwise and bite shift operators
// <<, >>, >>>
// bytewise operators ~, &, ^, | 

// for more information at https://docs.oracle.com/javase/tutorial/java/nutsandbolts/opsummary.html
```

# Expressions, statements, and blocks

An expression is a construct made up of variables, operators, and method invocations, which are constructed according to the syntax of the language, that evaluates to a single value.

Statements are roughly equivalent to sentences in natural languages. A statement forms a complete unit of execution. 

A block is a group of zero or more statements between balanced braces and can be used anywhere a single statement is allowed. 

# control flow statements

``` java
// if else

boolean condition = true;
if (condition){
    // do somthing
}

if (condition) {
    // do somthing
} else {
    // do something
}

if (condition) {
    // do something
} else if (condition1) {
    // do something
} else if (condition2) {
    // do something
} else (condition3) {
    // do something
}
```

``` java
// switch
int month = 8;

switch (month) {
    case 1:  futureMonths.add("January");
    case 2:  futureMonths.add("February");
    case 3:  futureMonths.add("March");
    case 4:  futureMonths.add("April");
    case 5:  futureMonths.add("May");
    case 6:  futureMonths.add("June");
    case 7:  futureMonths.add("July");
    case 8:  futureMonths.add("August");
    case 9:  futureMonths.add("September");
    case 10: futureMonths.add("October");
    case 11: futureMonths.add("November");
    case 12: futureMonths.add("December");
                break;
    default: break;
```

``` java
// while and do while
while (true) {
    // do something
}

do {
    statement(s);
} while( expression );
```

``` java
// for
for (int i = 1; i < 10; i++) {
    Syetem.out.println(i);
}

int[] numbers = {1,2,3,4,5,6,7,8,9,10};
for (int num : numbers) {
    System.out.println("count is: " + num);
}
```

``` java
// other branch statements
break;
continue;
return 0;
```

# classes

``` java
// bicycle demo
public class Bicycle {
    public int cadence;
    public int gear;
    public int speed;
    // constructor
    public Bicycle(int startCadence, int startSpeed, int startFear) {
        gear = startGear;
        cadence = startCadence;
        speed = startSpeed;
    }

    // four methods
    public void setCadence(int newValue) {
        cadence = newValue;
    }

    public void setGear(int newValue) {
        gear = newValue;
    }

    public void applyBrake(int decrement) {
        speed -= decrement;
    }

    public void speedUp(int increment) {
        speed += increment;
    }
}

public class MountainBike extends Bicycle {

    // the MountainBike subclass has
    // one field
    public int seatHeight;

    // the MountainBike subclass has
    // one constructor
    public MountainBike(int startHeight, int startCadence,
                        int startSpeed, int startGear) {
        super(startCadence, startSpeed, startGear);
        seatHeight = startHeight;
    }

    // the MountainBike subclass has
    // one method
    public void setHeight(int newValue) {
        seatHeight = newValue;
    }
}
```

``` java
// declaring classes
class MyClass extends MySuperClass implements YourInterface {
    // field, constructor, and
    // method declarations
}
//  MyClass is a subclass of MySuperClass and that it implements the YourInterface interface.

// overloading methods
public class DataArtist {
    ...
    public void draw(String s) {
        ...
    }
    public void draw(int i) {
        ...
    }
    public void draw(double f) {
        ...
    }
    public void draw(int i, double f) {
        ...
    }
}

// create objects
Point orginOne = new Point(23, 94);
// Declaring a Variable to Refer to an Object
Point point;

// using objects
objectReference.fieldName;
objectReference.methodName();

// use this
// Using this with a Field
public class Point {
    public int x = 0;
    public int y = 0;

    // constructor
    public Point(int a, int b) {
        this.x = a;
        this.y = b;
    }
}

// Using this with a Constructor
public class Rectangle {
    private int x, y;
    private int width, height;

    public Rectangle() {
        this(0, 0, 1, 1);
    }
    public Rectangle(int width, int height) {
        this(0, 0, width, height);
    }
    public Rectangle(int x, int y, int width, int height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    ...
}

```

关键字
`public` , `private`

Access Levels

|Modifier|Class|Package|Subclass|World|
|-|-|-|-|-|
|public|Y|Y|Y|Y|
|protected|Y|Y|Y|N|
|no modifier|Y|Y|N|N|
|private|Y|N|N|N|

``` java
// static

// class static 申明的变量是针对类的，而不是针对类的对象。
// 比如pi这个变量针对所有的圆类都是3.141592，而不是针对一个圆类的对象是3.14159， 这个变量可以针对一些操作而变化，如同python中的类的一个参数。

// class method
public static int getNumberOfBicycles() {
    return 0;
}
// 这个方法可以可以直接这样的 ClassName.methodName(args), 如同python中类中函数有个classmethod的修饰。

// constants
static final double PI = 3.141592653;
```

``` java
// initializing fields
public class BedAndBreakfast {
    // initialize to 10
    public static int capacity = 10;

    // initialize to false
    private boolean full = false;
}

// static initialization blocks
static {
    // whatever code is needed for initialization goes here
}

/** 
 * protected修饰的方法或变量将会被任何位置的子类继承，
 * 但是永远只能被最早定义他的父类所在的包的类所见
 * （除了该类以及其子类能看到本身的该protected方法或变量之外。）
 */
// final A final method cannot be overridden in a subclass.

class Whatever {
    private varType myVar = initializeInstanceVariable();

    protected final varType initializeInstanceVariable() {
        // initialization code goes here
    }
}
```

``` java
// nested classes

class OuterClass {
    ...
    static class StaticNestedClass {
        ...
    }

    class InnerClass {
        ...
    }
}

OuterClass.StaticNestedClass nestedObject = new OuterClass.StaticNestedClass();
```

``` java
// lambda expression
p -> p.getGender() == Person.Sex.MALE
    && p.getAge() >= 18
    && p.getAge() <= 25
```

``` java
// enum
public enum Day {
    SUNDAY, MONDAY, TUESDAY, WEDNESDAY,
    THURSDAY, FRIDAY, SATURDAY 
}
```

# annotation

注解(Annotations)是一种元数据，提供了程序之外的一些程序信息。注解并不会直接影响被注解的代码。注解有很多用法： 

1. 为编译器提供信息(Information for the compiler) ——编译器能直接使用注解检查错误(detect errors)和禁止警告(suppress warnings)。 
2. 编译期和部署时处理(Compile-time and deployment-time processing) —— 软件工具可以使用注解生成代码，XML文件等待。 
3. 运行期处理(Runtime processing) —— 一些注解可以在运行期被检测。

``` java
@Entity

@Override
void mySuperMethod() {
    ...
}

@Author(
   name = "Benjamin Franklin",
   date = "3/27/2003"
)
class MyClass() { ... }

// where to use annotations?
// class instance creation expression
new @Interned MyObject();
// type cast
myString = (@NonNull String) str;
// implements clause
class UnmodfifiableList<T> implements
    @Readonly List<@Readonly T> {
        ...
    }
// Thrown exception declaration
void monitorTemperature() throws
    @Critical TemperatureException {
        ...
    }
```

# Interfaces and Inheritance

``` java
public interface GroupedInterface extends Interface1, InterFace2, Interface3 {
    double E = 2.718282;

    void doSomething(int i, double x);
    int doSomethingElse(String s);
}
/**
 * 接口有三种
 * abstract methods 只有一个接口用分号结束，没有大括号包含具体的实现
 * default methods 用default关键字来改变接口属性
 * static methods 用static关键字来改变接口的属性
 * 在接口中不加申明的话，接口都是public的
 * 在接口中的定义的变量默认属性是public，static，final来
 * 定义的函数默认是public abstract的
 */

// 定义接口
public interface Relatable {
    public int isLargerThan(Relatable other);
}
// 类中实现接口

public class RectanglePlus implements Relatable {
    public int width = 0;
    public int height = 0;
    public Point origin;
    
    // four constructors
    public RectanglePlus() {
        origin = new Point(0, 0);
    }
    public RectanglePlus(Point p) {
        origin = p;
    }
    public RectanglePlus(int w, int h) {
        origin = new Point(0, 0);
        this.width = w;
        this.height = h;
    }
    public RectanglePlus(Point p, int w, int h) {
        origin = p;
        this.width = w;
        this.height = h;
    }

    // move the rectangle
    public void move(int x, int y) {
        origin.x = x;
        origin.y = y;
    }

    // get area
    public int getArea() {
        return this.width * this.height;
    }

    // implement the interface
    // 下面的具体实现中将接口名当做一个数据类型来用，这样是可行的，
    // 并且如果 Relatable a = new RectaflePlus() 这样初始化变量也是可以的 感觉很新颖啊，这个东西
    public int isLargerThan(Relatable other) {
        RectanglePlus otherRect = (RectanglePlus)other;
        if(this.getArea() < otherRect.GetArea())
            return -1;
        else if (this.getArea() > otherRect.GetArea())
            return 1;
        else
            return 0;
    }
}

// evolving interface
// 使用的对象当一个接口，想加入更多的方法的时候，为了避免修改原接口的代码，我们可以创建一个新的接口，并且这个接口是通过原接口扩展而来的。

public interface DoIt {
    void doSomething(int i, double x);
    int doSomethingElse(String s);
    // default 的方法，必须在interface中实现
    default int get_one() {
        // method body
        return 1;
    }
}
// extends interface
public interface DoItPlus extends DoIt {
    boolean didItWork(int i, double x, String s);
}
```

``` java
// inheritance
// code in Animal.java InheritanceDemo.java

// overriding and hiding methods
// 子类中的static方法将会hide父类中的同样的方法，而不是直接override
// demo

public class Animal {
    public static void testClassmethod() {
        System.out.println("the static method in animal");
    }

    public void testInstanceMethod() {
        System.out.println("the instance method in animal");
    }
}

public class Cat extends Animal {
    public static void testInstanceMethod() {
        System.out.println("The static method in Cat");
    }

    public void testInstanceMethod() {
        System.out.println("the instance method in cat");
    }

    public static void main(String[] args) {
        Cat myCat = new Cat();
        Animal myAnimal = myCat;
        Animal.testClassMethod();
        myAnimal.testInstanceMethod();
    }
}
```

Defining a Method with the Same Signature as a Superclass's Method
|1| Superclass Instance Method|Superclass Static Method|
|-|-|-|
|Subclass Instance Method|Overrides|Generates a compile-time error|
|Subclass Static Method|Generates a compile-time error|Hides|

``` java
// hiding Fields
// 只要在子类中实例化了相同变通变量名的变量，就能隐藏fields。而且实例前后的数据类型可以是不一样的
```

``` java
// accessing superclass members 子类中使用父类的方法
public class Superclass {
    public void printMethod() {
        System.out.println("Printed in Superclass");
    }
}

public class Subclass extends Superclass {
    // override printMethod in Superclass
    public void printMethod() {
        super.printMethod();
        System.out.println("Printed in Subclass");
    }

    public static void main(String[] args) {
        Subclass a = new Subclass();
        s.printMethod();
    }
}

// subclass Constructors
// using super() or super(parameter list)
public MountainBike(int startHeight,
                    int startCadence,
                    int startSpeed,
                    int startGear) {
    super(startCadence, startSpeed, startGear);
    seatHeight = startHeight;
}
```

``` java
// Object as a Superclass
public class Book extends Object {
    ...
    // using Object class
    public boolean equals(Object obj) {
        if (obj instanceof Book)
            return ISBN.equals((Book)obj.getISBN()); 
        else
            return false;
    }
}

// Swing Tutorial, 2nd edition
Book firstBook  = new Book("0201914670");
Book secondBook = new Book("0201914670");
if (firstBook.equals(secondBook)) {
    System.out.println("objects are equal");
} else {
    System.out.println("objects are not equal");
}

// final 这个修饰的方法，说明这个方法不能在子类中被override
class ChessAlgorithm {
    enum ChessPlayer { WHITE, BLACK }
    ...
    final ChessPlayer getFirstPlayer() {
        return ChessPlayer.WHITE;
    }
    ...
}

// abstract
// abstract class 不能被实例化。
// abstract method 只是申明，但是方法具体是没有被立即实现的。

abstract class GraphicObject {
    int x, y;
    ...
    void moveTo(int newX, int newY) {
        ...
    }
    abstract void draw();
    abstract void resize();
}

class Circle extends GraphicObject {
    void draw() {
        ...
    }
    void resize() {
        ...
    }
}
class Rectangle extends GraphicObject {
    void draw() {
        ...
    }
    void resize() {
        ...
    }
}

abstract class X implements Y {
  // implements all but one method of Y
}

class XX extends X {
  // implements the remaining method in Y
}
```

# Generic

``` java
// In a nutshell, generics enable types (classes and interfaces) to be parameters when defining classes, interfaces and methods. 

// Demo
public class Box<T> {
    private T t;

    public void set(T t) {
        this.t = t;
    }

    public T get() {
        return this.t;
    }
}

/**
 * type parameter Naming onventions
 * E - element
 * K - key
 * T - type
 * V - value
 * S,U,V etc. - 2nd, 3rd, 4th types
 */

// Multiple Type Parameters

public interface Pair<K, V> {
    public K getKey();
    public V getValue();
}

public class OrderPair<K, V> implements Pair<K, V> {
    private K key;
    private V value;

    public OrderPair(K key, V value){
        this.key = key;
        this.value = value;
    }

    public K getKey() {
        return this.key;
    }

    public V getValue() {
        return this.value;
    }

    public K setKey(K key) {
        this.key = key;
    }

    public V setValue(V value) {
        this.value = value;
    }
}

// Bounded Type Parameters
// There may be times when you want to restrict the types that can be used as type arguments in a parameterized type. 
// 严格定义类型参数只能是限定的几种类型
public class Box<T> {

    private T t;

    public void set(T t) {
        this.t = t;
    }

    public T get() {
        return t;
    }

    // 传入参数的类型必须是Number，或者是其子类
    public <U extends Number> void inspect(U u){
        System.out.println("T: " + t.getClass().getName());
        System.out.println("U: " + u.getClass().getName());
    }

    public static void main(String[] args) {
        Box<Integer> integerBox = new Box<Integer>();
        integerBox.set(new Integer(10));
        integerBox.inspect("some text"); // error: this is still String!
    }
}

// Multiple Bounds

Class A { /* ... */ }
interface B { /* ... */ }
interface C { /* ... */ }

class D <T extends A & B & C> { /* ... */ }

class D <T extends B & A & C> { /* ... */ }  // compile-time error A必须是第一个

// As you already know, it is possible to assign an object of one type to an object of another type provided that the types are compatible. For example, you can assign an Integer to an Object, since Object is one of Integer's supertypes:

Object someObject = new Object();
Integer someInteger = new Integer(10);
someObject = someInteger;
```

# exception

``` java
// put try catch and finally together.
public void writeList() {
    PrintWriter out = null;

    try {
        System.out.println("Entering" + " try statement");

        out = new PrintWriter(new FileWriter("OutFile.txt"));
        for (int i = 0; i < SIZE; i++) {
            out.println("Value at: " + i + " = " + list.get(i));
        }
    } catch (IndexOutOfBoundsException e) {
        System.err.println("Caught IndexOutOfBoundsException: " + e.getMessage()); 
    } catch (IOException e) {
        System.err.println("Caught IOException: " +  e.getMessage());
    } finally {
        if (out != null) {
            System.out.println("Closing PrintWriter");
            out.close();
        } 
        else {
            System.out.println("PrintWriter not open");
        }
    }
}

// Specifying the Exceptions Thrown by a Method
// 函数的申明中包含了函数可能抛出申明异常的信息
public void writeList() throws IOException {
    ...
}

//  throw exception
try {
    ...
} catch (IOException e) {
    throw new SampleException("Other IOException", e);
}

```
