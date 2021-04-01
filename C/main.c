#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>

int ITERATIONS = 600;
int ARRAY_SIZE = 800;

// algorithm quicksort(A, lo, hi) is
//     if lo < hi then
//         p := partition(A, lo, hi)
//         quicksort(A, lo, p - 1)
//         quicksort(A, p + 1, hi)
//
// algorithm partition(A, lo, hi) is
//     pivot := A[hi]
//     i := lo
//     for j := lo to hi do
//         if A[j] < pivot then
//             swap A[i] with A[j]
//             i := i + 1
//     swap A[i] with A[hi]
//     return i

void quicksort(int array[], int first, int last);

int partition(int array[], int first, int last);

void swap(int *a, int *b);

int intComparator(const void *a, const void *b);


int main(int argc, char *argv[])
{
  if (argc != 4) {
    printf("Usage: <inFile> <outFile> <quicksort>\n");
    printf("  inFile: relative path to input file\n");
    printf("  outFile: relative path to output file\n");
    printf("  quicksort [true, false]: true if quicksort should be used or false for built in sort\n");
    return -1;
  }

  char *inFile = argv[1];
  char *outFile = argv[2];
  char *quick = argv[3];
  int array[ARRAY_SIZE];
  char line[1024];

  FILE* stream = fopen(inFile, "r");

  int i = 0;
  while (fgets(line, 1024, stream)) {
    array[i] = atoi(line);
    i++;
  }

  clock_t start, end;
  int arrayCopy[ARRAY_SIZE];
  FILE *fp = fopen(outFile, "w");

  fprintf(fp, "run,time\n");

  for (int i = 1; i < ITERATIONS + 1; i++) {
    for (int j = 0; j < ARRAY_SIZE; j++) {
      arrayCopy[j] = array[j];
    }

    int size = sizeof arrayCopy / sizeof *arrayCopy;

    if (strcmp(quick, "true") == 0) {
      start = clock();
      quicksort(arrayCopy, 0, size);
      end = clock();
    } else {
      start = clock();
      qsort(arrayCopy, size, sizeof(int), intComparator);
      end = clock();
    }

    double time = ((double) (end - start) / CLOCKS_PER_SEC);

    fprintf(fp, "%d,%f\n", i, time);
  }
  fclose(fp);

  return 0;
}


int intComparator(const void *a, const void *b)
{
  int int_a = *((int*) a);
  int int_b = *((int*) b);

  if (int_a == int_b) return 0;
  else if (int_a < int_b) return -1;
  else return 1;
}


void quicksort(int array[], int first, int last)
{
  if (first < last) {
    int pivIndex = partition(array, first, last);
    quicksort(array, first, pivIndex - 1);
    quicksort(array, pivIndex + 1, last);
  }
}


int partition(int array[], int first, int last)
{
  int piv = array[last];
  int i = first;

  for (int j = first; j < last; j++) {
    if (array[j] < piv) {
      swap(&array[i], &array[j]);
      i++;
    }
  }

  swap(&array[i], &array[last]);
  return i;
}


void swap(int *a, int *b)
{
  int tmp = *a;
  *a = *b;
  *b = tmp;
}
