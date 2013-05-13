#!/usr/bin/env python2

numbers = [0,1,2,3,4,5,6,7,8,9]
letters = ["a", "b", "c", "d", "e", "f"]

for number in numbers:
    for number2 in numbers:
        print("0x%d%d," % (number, number2))
    for letter in letters:
        print("0x%d%s," % (number, letter))

for letter in letters:
    for number in numbers:
        print("0x%s%d," % (letter, number))
    for letter2 in letters:
        print("0x%s%s," % (letter, letter2))
