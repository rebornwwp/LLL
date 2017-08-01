from copy import copy, deepcopy


class simpleLayer(object):
    # background代表背景的rgba, content代表内容
    background = [0, 0, 0, 0]
    content = 'blank'

    def getContent(self):
        return self.content

    def getBackground(self):
        return self.background
    
    def paint(self, painting):
        self.content = painting

    def setParent(self, p):
        self.background[3] = p

    def fillBackground(self, back):
        '''
        p: list of number
        '''
        self.background = back

    def clone(self):
        '''
        直接拷贝内存，这个是一个不用类实例化的过程
        '''
        return copy(self)

    def deep_clone(self):
        '''
        和上面一样
        '''
        return deepcopy(self)
