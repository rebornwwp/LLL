class Beverage():
    name = ""
    price = 0.0
    type = "BEVERAGE"
    def getPrice(self):
        return self.price
    def setPrice(self, price):
        self.price = price
    def getName(self):
        return self.name


class coke(Beverage):
    def __init__(self):
        self.name = "coke"
        self.price = 4.0


class milk(Beverage):
    def __init__(self):
        self.name = "milk"
        self.price = 5.0


class drinkDecorator(object):
    
    def getName(self):
        pass

    def getPrice(self):
        pass


class iceDecorator(drinkDecorator):
    def __init__(self, beverage):
        self.beverage = beverage

    def getName(self):
        return self.beverage.getName() + "+ice"

    def getPrice(self):
        return self.beverage.getPrice() + 0.3


class sugerDecorator(drinkDecorator):
    def __init__(self, beverage):
        self.beverage = beverage

    def getName(self):
        return self.beverage.getName() + '+suger'

    def getPrice(self):
        return self.beverage.getPrice() + 0.5

def main():
    coke_cola = coke()
    print(coke_cola.getName())
    print(coke_cola.getPrice())
    ice_coke = iceDecorator(coke_cola)
    print(ice_coke.getName())
    print(ice_coke.getPrice())

if __name__ == '__main__':
    main()