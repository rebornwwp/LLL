import os
import sys

def renamefile(filepath, prefix):
    splited_path = filepath.strip('./').split('/')
    os.rename(filepath, prefix + '-' + '-'.join(splited_path))


def walk_dir(dir, prefix):
    if dir is None:
        dir = '.'
    for root, dirs, files in os.walk(dir):
        for name in files:
            if not name.endswith('.py'):
                renamefile(os.path.join(root, name), prefix)

if __name__ == '__main__':
    arg = sys.argv[1]
    walk_dir('.', arg)
