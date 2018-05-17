#!/usr/bin/env python
# -*- coding:utf-8 -*-

# from link http://masnun.rocks/2017/04/15/interfaces-in-python-protocols-and-abcs/


# informal interfaces: Protocols / Duck typing
class Team(object):
    def __init__(self, members):
        self._members = members

    def __len__(self):
        return len(self._members)

    def __contains__(self, member):
        return member in self._members

    def __str__(self):
        return " ".join(self._members)

    __repr__ = __str__


# formal interfaces: ABCs
import abc


class Bird(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def fly(self):
        pass


class Parrot(Bird):
    def fly(self):
        print("flying")


class Aeroplane(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def fly(self):
        pass


class Boeing(Aeroplane):
    def fly(self):
        print("flying")


# virtual subclass
@Bird.register
class Robin:
    pass


def main():
    # Protocols
    team = Team(["batman", "wonder woman", "flash"])
    print(team)
    print(len(team))
    print("batman" in team)
    print("="*50)
    # Duck typing
    ducks = [team, ["abc", "cde"]]
    for duck in ducks:
        print("the duck is", duck)
        print(len(duck))
        print("batman" in duck)
    print("="*50)
    # ABCs
    p = Parrot()
    print(isinstance(p, Bird))
    print(isinstance(p, Parrot))
    b = Boeing()
    print(isinstance(b, Parrot))
    print("="*50)
    # virtual subclass
    r = Robin()
    print(isinstance(r, Robin))
    print(isinstance(r, Bird))
    print("="*50)


if __name__ == '__main__':
    main()
