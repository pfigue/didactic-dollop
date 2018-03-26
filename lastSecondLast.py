#!/usr/bin/python3

import sys


def last_and_second_last(inp):
    if len(inp) == 0:
        out = ""
    else:
        out = inp[-1]
        out += " " + inp[-2] if len(inp) > 1 else ""
    return out


inp = input("Type a word: ")
if len(inp) < 1 or len(inp) > 100:
    print("Word length should be between 1 and 100", file=sys.stderr)
    sys.exit(1)
out = last_and_second_last(inp)
print(out)

