// Deoxyribonucleic acid (DNA) is a chemical found in the nucleus of cells and carries the "instructions" for the development and functioning of living organisms.

// If you want to know more http://en.wikipedia.org/wiki/DNA

// In DNA strings, symbols "A" and "T" are complements of each other, as "C" and "G". You have function with one side of the DNA (string, except for Haskell); you need to get the other complementary side. DNA strand is never empty or there is no DNA at all (again, except for Haskell).

// dnaStrand("ATTGC") # return "TAACG"

// dnaStrand("GTAT") # return "CATA"

class Kata {
    static dnaStrand(dna: string) {
        let result: string = "";
        let map: object = { C: 'G', G: 'C', A: 'T', T: 'A' }
        for (let value of dna) {
            result += map[value];
        }
        return result;
    }
}

console.log(Kata.dnaStrand("AAAA"));