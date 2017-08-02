# coding=utf-8


class ACompanyStaff(object):
    name = ''
    id = ''
    phone = ''

    def __init__(self, id):
        self.id = id

    def getName(self):
        return self.name

    def setName(self, name):
        self.name = name

    def getPhone(self):
        return self.phone

    def setPhone(self, phone):
        self.phone = phone


class BCompanyStaff(object):
    name = ''
    id = ''
    telephone = ''

    def __init__(self, id):
        self.id = id

    def get_name(self):
        return self.name

    def set_name(self, name):
        self.name = name

    def get_telephone(self):
        return self.telephone
    # 借口和A公司不一样

    def set_telephone(self, telephone):
        self.telephone = telephone


class CompanyStaffAdapter(object):
    b_Company = ''

    def __init__(self, id):
        self.b_Company = BCompanyStaff(id)

    def getName(self):
        return self.b_Company.get_name()

    def setName(self, name):
        self.b_Company.set_name(name)

    def getPhone(self):
        return self.b_Company.get_telephone()

    def setPhone(self, phone):
        self.b_Company.set_telephone(phone)


if __name__ == "__main__":
    acpn_staff = ACompanyStaff("123")
    acpn_staff.setName("X-A")
    acpn_staff.setPhone("10012345678")
    print(acpn_staff.getName())
    print(acpn_staff.getPhone())
    bcpn_staff = CompanyStaffAdapter("456")
    bcpn_staff.setName("Y-B")
    bcpn_staff.setPhone("99987654321")
    print(bcpn_staff.getName())
    print(bcpn_staff.getPhone())
