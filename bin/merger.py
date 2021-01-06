#!/bin/python
#merges notebooks
#input: unresolved merge file of a notebook
#output: merged file with all the entries reordered my datestamp

import sys, dateutil.parser
assert len(sys.argv) == 2
path = sys.argv[1]
with open(path, 'r') as f:
    lines = [""] + f.read().split("\n")

#group lines
start = []
dates = []
for i, line in enumerate(lines[:-1]):
    if line.strip() == "":
        test = lines[i+1].strip()
        try:
            assert test and test[0] not in (" ", "\t") #must not start with whitespace
            date = dateutil.parser.parse(test)
        except (ValueError, AssertionError):
            continue

        start.append(i+1)
        dates.append(date)

ends = start[1:] + [len(lines)]
blocks = []
for i in range(len(start)):
    blk = lines[start[i]:ends[i]]
    while not blk[-1].strip():
        blk.pop() 
    blocks.append(blk)

blocks = [x for _,x in sorted(zip(dates,blocks))]
blocks = filter(lambda x: len(x) > 1, blocks)
blocks = ["\n".join(x) for x in blocks]

txt = "\n\n".join(blocks)
print(txt)
