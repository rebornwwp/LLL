#encoding=utf-8
# factory pattern
MINI14 = '1.4GHz Mac mini'


class AppleFactory:

    class MacMini14:
        def __init__(self):
            self.memory = 4  # in gigabytes
            self.hdd = 500  # in gigabytes
            self.gpu = 'Intel HD Graphics 5000'

        def __str__(self):
            info = ('Model: {}'.format(MINI14),
                    'Memory: {}GB'.format(self.memory),
                    'Hard Disk: {}GB'.format(self.hdd),
                    'Graphics Card: {}'.format(self.gpu))
            return '\n'.join(info)

    def build_computer(self, model):
        if model == MINI14:
            return self.MacMini14()
        else:
            print("I don't know how to build {}".format(model))


# 使用工厂
afac = AppleFactory()
mac_mini = afac.build_computer(MINI14)
print(mac_mini)


# builder模式


class Computer:
    def __init__(self, serial_number):
        self.serial = serial_number
        self.memory = None      # in gigabytes
        self.hdd = None         # in gigabytes
        self.gpu = None

    def __str__(self):
        info = ('Memory: {}GB'.format(self.memory),
                'Hard Disk: {}GB'.format(self.hdd),
                'Graphics Card: {}'.format(self.gpu))
        return '\n'.join(info)


class ComputerBuilder:
    def __init__(self):
        self.computer = Computer('AG23385193')

    def configure_memory(self, amount):
        self.computer.memory = amount

    def configure_hdd(self, amount):
        self.computer.hdd = amount

    def configure_gpu(self, gpu_model):
        self.computer.gpu = gpu_model


class HardwareEngineer:
    def __init__(self):
        self.builder = None

    def construct_computer(self, memory, hdd, gpu):
        self.builder = ComputerBuilder()
        [step for step in (self.builder.configure_memory(memory),
                        self.builder.configure_hdd(hdd),
                        self.builder.configure_gpu(gpu))]

    @property
    def computer(self):
        return self.builder.computer

# 使用buidler，可以创建多个builder类实现不同的组装方式
engineer = HardwareEngineer()
engineer.construct_computer(hdd=500, memory=8, gpu='GeForce GTX 650 Ti')
computer = engineer.computer
print(computer)
