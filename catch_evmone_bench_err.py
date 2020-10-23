import sys

lines = sys.stdin.readlines()
lines = "\n".join(lines)

print(lines)

if "error_message" in lines:
    sys.exit(-1)
