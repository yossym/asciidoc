#!/usr/bin/python3

f=open("myfile.txt")
lines = f.readlines()
print(lines[0])
f.close()
