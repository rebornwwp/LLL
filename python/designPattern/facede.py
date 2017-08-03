class AlarmSensor(object):
    def run(self):
        print("alarim ring....")


class WaterSprinker(object):
    def run(self):
        print("Spray Water...")


class EmergencyDialer(object):
    def run(self):
        print("dial 119....")


class EmergencyFacade(object):
    def __init__(self):
        self.alarm_sensor = AlarmSensor()
        self.water_sprinker = WaterSprinker()
        self.emergency_dialer = EmergencyDialer()

    def runAll(self):
        self.alarm_sensor.run()
        self.water_sprinker.run()
        self.emergency_dialer.run()


def main():
    emergency = EmergencyFacade()
    emergency.runAll()


if __name__ == '__main__':
    main()
