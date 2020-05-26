import sys

lines = sys.stdin.readlines()
lines = "\n".join(lines)

print(lines)

if "revert" in lines:
    sys.exit(-1)
