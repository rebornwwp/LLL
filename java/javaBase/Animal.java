class Animal {
    private String name;
    private int id;

    public Animal(String name, int id) {
        this.name = name;
        this.id = id;
    }

    public void eat() {
        System.out.println(name + "is eating");
    }

    public void sleep() {
        System.out.println(name + "is sleeping");
    }

    public void introduction() {
        System.out.println("My name is " + name + " id is " + id);
    }
}

class Penguin extends Animal {
    public Penguin(String name, int id) {
        super(name, id);
    }
}

class Mouse extends Animal {
    public Mouse(String name, int id) {
        super(name, id);
    }
}