# -*- coding:utf-8 -*-

COMMANDS = {
    # Lables
    'info': (33, '[!] '),
    'que': (34, '[?] '),
    'bad': (31, '[-] '),
    'good': (32, '[+] '),
    'run': (97, '[~] '),

    # Colors
    'green': 32,
    'lightgreen': 92,
    'grey': 37,
    'black': 30,
    'red': 31,
    'lightred': 91,
    'cyan': 36,
    'lightcyan': 96,
    'blue': 34,
    'lightblue': 94,
    'purple': 35,
    'yellow': 93,
    'white': 97,
    'lightpurple': 95,
    'orange': 33,

    # Styles
    'bg': ';7',
    'bold': ';1',
    'italic': '3',
    'under': '4',
    'strike': '09',
}


def _gen(string, prefix, key):
    """ 将字符串转变成需要的样式字符串

    Arguments:
        string {str} -- 输出字符串
        prefix {str} -- 输出字符串的前缀
        key {int} -- 字符串输出的颜色号

    Returns:
        str -- 带有输出字符串的样式字符串
    """

    colored = prefix if prefix else string
    no_color = string if prefix else ''
    return '\033[{}m{}\033[0m{}'.format(key, colored, no_color)


""" 封装函数并且放到locals()中 """
for key, value in COMMANDS.items():
    color_num, prefix = value if isinstance(value, tuple) else (value, '')
    locals()[key] = lambda s, prefix=prefix, color_num=color_num: _gen(
        s, prefix, color_num)
