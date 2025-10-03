
class RideHideMethod {
    public class Animal {
        public static void testClassMethod() {
            System.out.println("The static method in Animal");
        }

        public void testInstanceMethod() {
            System.out.println("The instance method in Animal");
        }
    }

    public class Cat extends Animal {
        public static void testClassMethod() {
            System.out.println("The static method in Cat");
        }

        public void testInstanceMethod() {
            System.out.println("The instance method in Cat");
        }
    }

    public static void main(String[] args) {
        RideHideMethod r = new RideHideMethod();
        Cat myCat = r.new Cat();
        Animal myAnimal = myCat;
        Animal.testClassMethod();
        myAnimal.testInstanceMethod();
    }
}
