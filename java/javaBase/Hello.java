class Hello {
    public int x = 10;

    class FirstLevel {
        public int x = 200;

        void firstPrint(int x) {
            System.out.println(x);
            System.out.println(this.x);
            System.out.println(Hello.this.x);
        }

    }
    public static void main(String[] args) {
        Hello h = Hello();
        h.FirstLevel fl = h.new h.FirstLevel;
        fl.firstPrint(123);
    }
}