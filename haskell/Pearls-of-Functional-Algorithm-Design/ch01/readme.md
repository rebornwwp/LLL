# introduction

Consider the problem of computing the smallest natural number not in a given finite set X of natural numbers. The problem is a simplification of a common programming task in which the numbers name objects and X is the set of objects currently in use. The task is to find some object not in use, say the one with the smallest name.
The solution to the problem depends, of course, on how X is represented. If X is given as a list without duplicates and in increasing order, then the solution is straightforward: simply look for the first gap. But suppose X is given as a list of distinct numbers in no particular order. For example,
[08, 23, 09, 00, 12, 11, 01, 10, 13, 07, 41, 04, 14, 21, 05, 17, 03, 19, 02, 06]
How would you find the smallest number not in this list?
It is not immediately clear that there is a linear-time solution to the problem; after all, sorting an arbitrary list of numbers cannot be done in linear time. Nevertheless, linear-time solutions do exist and the aim of this pearl is to describe two of them: one is based on Haskell arrays and the other
on divide and conquer.
