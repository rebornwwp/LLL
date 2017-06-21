#!/usr/bin/env python
# -*- coding:utf-8 -*-

from PIL import Image, ImageDraw, ImageFont


def add_num(picPath, num):
    img = Image.open(picPath)
    xSize, ySize = img.size
    fontsize = int(ySize / 4)
    position = xSize - fontsize
    myFont = ImageFont.truetype('Symbol.ttf', size=fontsize)
    ImageDraw.Draw(img).text((position, 0), str(num), font=myFont, fill='red')
    img.save('icon_with_num.jpg')


if __name__ == '__main__':
    picPath = "test.jpg"
    num = 3
    add_num(picPath, num)
