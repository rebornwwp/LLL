class Customer(object):
    customer_name = ""
    snd_way = ""
    info = ""
    phone = ""
    email = ""

    def setPhone(self, phone):
        self.phone = phone

    def setEmail(self, email):
        self.email = email

    def getPhone(self):
        return self.phone

    def getEmail(self):
        return self.email

    def setInfo(self, info):
        self.info = info

    def setName(self, name):
        self.customer_name = name

    def setBrdWay(self, snd_way):
        self.snd_way = snd_way

    def sndMsg(self):
        self.snd_way.send(self.info)


class msgSender(object):
    dst_code = ""

    def setCode(self, code):
        self.dst_code = code

    def send(self, info):
        pass


class emailSender(msgSender):
    def send(self, info):
        print("Email address: %s Email:%s" % (self.dst_code, info))


class textSender(msgSender):
    def send(self, info):
        print("Text_code:%s Email: %s" % (self.dst_code, info))


def main():
    customer = Customer()
    customer.setName("Customer_A")
    customer.setPhone("123456789")
    customer.setEmail("qwert@gmail.com")
    customer.setInfo("welcome to our new party")
    text_sender = textSender()
    text_sender.setCode(customer.getPhone())
    customer.setBrdWay(text_sender)
    customer.sndMsg()
    mail_sender = emailSender()
    mail_sender.setCode(customer.getEmail())
    customer.setBrdWay(mail_sender)
    customer.sndMsg()


if __name__ == '__main__':
    main()
