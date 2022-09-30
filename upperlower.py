import argparse

a = argparse.ArgumentParser()
a.add_argument('--file', default='README.md', help="Default: %(default)s")
args = a.parse_args()

with open(args.file) as f:
    c = f.read()

t = [c[i].upper() if i%2 else c[i].lower() for i in range(len(c))]
print(''.join(t))
