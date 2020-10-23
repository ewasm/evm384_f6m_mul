import sys

lines = sys.stdin.readlines()
lines = "\n".join(lines)

print(lines)

if not "success" in lines:
    sys.exit(-1)
