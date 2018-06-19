import java.lang.Character.*;

class CharacterDemo {
    public static void main(String[] args) {
        char ch = 'a';
        char unichar = '\u03A9';
        char[] charArray = { 'a', 'b', 'c', 'd', 'e' };
        Character chr = new Character('a');
        System.out.println(Character.isLetter(chr));
    }
}