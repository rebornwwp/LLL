#encoding=utf-8
import threading
import time


class Singleton(object):
    """
    类有个_instance属性，这个属性永远是此类的一个实例，类中属性永远保存这一个这个类的实例。
    """
    def __new__(cls, *args, **kwargs):
        if not hasattr(cls, '_instance'):
            orig = super(Singleton, cls)
            cls._instance = orig.__new__(cls, *args, **kwargs)
        return cls._instance


class Bus(Singleton):
    lock = threading.RLock()
    def sendData(self, data):
        self.lock.acquire()
        time.sleep(3)
        print "Sending Signal Data ...", data
        self.lock.release()


class VisitEntity(threading.Thread):
    my_bus = ""
    name = ""
    def getName(self):
        return self.name
    def setName(self, name):
        self.name = name
    def run(self):
        self.my_bus = Bus()
        self.my_bus.sendData(self.name)


if __name__ == '__main__':
    for i in range(3):
        print "Entity %d begin to run ..." % i
        my_entity = VisitEntity()
        my_entity.setName("Entity_" + str(i))
        my_entity.start()
