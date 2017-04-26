#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   vito
#   E-mail  :   rebornwwp.gmail.com
#   Date    :   17/04/26 00:07:10
#   Desc    :
#


def print_start():
    print("<table border=i'1'>")


def print_end():
    print("</table>")

def print_line(line, color, max_width):
    pass

def escape_html(text):
    """
    >>> excape_html("$><")
    'amp;gt;&lt;'
    """
    text = text.replace("&", "&amp;")
    text = text.replace(">", "&gt;")
    text = text.replace("<", "&lt;")
    return text


def main():
    max_width = 100
    count = 0
    while True:
        try:
            line = input()
            if count == 0:
                color = "lightgreen"
            elif count % 2 == 1:
                color = "white"
            else:
                color = "lightyellow"
            print_line(line, color, max_width)
            count += 1
        except EOFError:
            break
    print_end()

if __name__ == "__main__":
    main()
    import doctest
    doctest.testmod()

