import csv
import sys
import time
from datetime import datetime

"""
algorithm quicksort(A, lo, hi) is
    if lo < hi then
        p := partition(A, lo, hi)
        quicksort(A, lo, p - 1)
        quicksort(A, p + 1, hi)

algorithm partition(A, lo, hi) is
    pivot := A[hi]
    i := lo
    for j := lo to hi do
        if A[j] < pivot then
            swap A[i] with A[j]
            i := i + 1
    swap A[i] with A[hi]
    return i
"""

ITERATIONS = 600

def quicksort(list, first, last):
    if first < last:
        pivIndex = partition(list, first, last)
        quicksort(list, first, pivIndex - 1)
        quicksort(list, pivIndex + 1, last)


def partition(list, first, last):
    piv = list[last]
    i = first

    for j in range(first, last):
        if list[j] < piv:
            swap(list, i, j)
            i += 1

    swap(list, i, last)
    return i


def swap(list, a, b):
    tmp = list[a]
    list[a] = list[b]
    list[b] = tmp


def main():
    if len(sys.argv) != 4:
        print("Usage: <inFile> <outFile> <quicksort>")
        print("  inFile: relative path to input file")
        print("  outFile: relative path to output file")
        print("  quicksort [true, false]: true if quicksort should be used or false for built in sort")
        return

    inFile = sys.argv[1]
    outFile = sys.argv[2]
    quick = sys.argv[3]

    with open(outFile, "w") as f:
        csv_writer = csv.writer(f)
        csv_writer.writerow(["run", "time"])

        for i in range(1, ITERATIONS + 1):
            with open(inFile) as f:
                list = [int(line) for line in f.readlines()]

            if (quick == "true"):
                dtstart = datetime.now()
                quicksort(list, 0, len(list) - 1)
                dtend = datetime.now()
            else:
                dtstart = datetime.now()
                list.sort()
                dtend = datetime.now()

            csv_writer.writerow([i, "{:.20f}".format((dtend - dtstart).total_seconds())])


if __name__ == "__main__":
    main()
