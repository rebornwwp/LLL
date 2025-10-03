import java.util.StringJoiner;

class StringDemo {
    public static void main(String[] args) {
        String palindrome = "Dont saw I was Tod";
        int len = palindrome.length();
        char[] temCharArray = new char[len];
        char[] charArray = new char[len];

        for (int i = 0; i < len; i++) {
            temCharArray[i] = palindrome.charAt(i);
        }

        for (int j = 0; j < len; j++) {
            charArray[j] = temCharArray[len - 1 - j];
        }

        String reversePalindrome = new String(charArray);
        System.out.println(reversePalindrome);

        System.out.println("My name is ".concat("Bob."));
        System.out.println("My name is " + "Bob.");

        // parse arguments
        if (args.length == 2) {
            float a = (Float.valueOf(args[0])).floatValue();
            float b = (Float.valueOf(args[1])).floatValue();
            System.out.println(a);
            System.out.println(b);
        } else {
            System.out.println("this program requires two command-line arguments.");
        }

        // convert numbers to strings
        int i = 1000;
        double d = 3.1415926;
        String s1 = Integer.toString(i);
        String s2 = Double.toString(d);
        System.out.println(s1 + "   " + s2);
        System.out.println(s2.indexOf('.'));
        System.out.println(s2.length());

        // manipulate chatactes in a string
        String anotherPalindrome = "Niagara. O roar again!";
        System.out.println(anotherPalindrome.charAt(9));
        System.out.println(anotherPalindrome.substring(11, 15));

        // compare to String
        String searchMe = "Green Eggs and Ham";
        String findMe = "Eggs";
        int searchMeLength = searchMe.length();
        int findMeLength = findMe.length();
        boolean foundIt = false;
        for (int i = 0; i <= (searchMeLength - findMeLength); i++) {
            if (searchMe.regionMatches(i, findMe, 0, findMeLength)) {
                foundIt = true;
                System.out.println(searchMe.substring(i, i + findMeLength));
                break;
            }
        }
        if (!foundIt)
            System.out.println("No match found.");

        // StringBuilder
        StringBuilder sb = new StringBuilder(palindrome);
        System.out.println(sb);
        sb.reverse();
        System.out.println(sb);
    }
}