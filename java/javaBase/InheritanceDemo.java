class InheritanceDemo {
    public class Penguin extends Animal {
        public Penguin(String name, int id) {
            super(name, id);
        }
    }

    public class Mouse extends Animal {
        public Mouse(String name, int id) {
            super(name, id);
        }
    }

    public static void main(String[] args) {
        Animal a = new Animal("helo", 1);
        a.introduction();
        InheritanceDemo i = new InheritanceDemo();
        Penguin p = i.new Penguin("wang", 2);
        Mouse m = i.new Mouse("wan", 3);
        p.introduction();
        m.introduction();
    }
}