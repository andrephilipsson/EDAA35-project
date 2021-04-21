import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;
import java.util.Arrays;


public class main {
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

    private static File inFile;
    private static File outFile;
    private static FileWriter writer;
    private static String quick;
    private static int[] array = new int[800];
    private static final int ITERATIONS = 600;

    public static void Main(String[] args) {
        if (args.length != 3) {
            System.out.println("Usage: <inFile> <outFile> <quicksort>");
            System.out.println("  inFile: relative path to input file");
            System.out.println("  outFile: relative path to output file");
            System.out.println("  quicksort [true, false]: true if quicksort should be used of false for built in sort");
            return;
        }

        inFile = new File(args[0]);
        outFile = new File(args[1]);
        quick = args[2];

        try {
            Scanner scanner = new Scanner(inFile);
            int i = 0;
            while (scanner.hasNextLine()) {
                array[i] = Integer.parseInt(scanner.nextLine());
                i++;
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        try {
            outFile.createNewFile();
            writer = new FileWriter(outFile);
            writer.write("run,time\n");

            for (int i = 1; i <= ITERATIONS; i++) {
                int[] arrayCopy = Arrays.copyOf(array, array.length);
                long start = 0;
                long end = 0;

                if (quick.compareTo("true") == 0) {
                    start = System.nanoTime();
                    quicksort(arrayCopy, 0, arrayCopy.length - 1);
                    end = System.nanoTime();
                } else {
                    start = System.nanoTime();
                    Arrays.sort(arrayCopy);
                    end = System.nanoTime();
                }

                double time = (end - start) / 1000000000.0;
                writer.write(i + "," + String.format("%.12f", time) + '\n');
            }

            writer.close();
        } catch(IOException e) {
            e.printStackTrace();
        }
    }

    private static void quicksort(int[] array, int first, int last) {
        if (first < last) {
            int pivIndex = partition(array, first, last);
            quicksort(array, first, pivIndex - 1);
            quicksort(array, pivIndex + 1, last);
        }
    }

    private static int partition(int[] array, int first, int last) {
        int piv = array[last];
        int i = first;

        for (int j = first; j < last; j++) {
            if (array[j] < piv) {
                swap(array, i, j);
                i++;
            }
        }

        swap(array, i, last);
        return i;
    }

    private static void swap(int[] array, int a, int b) {
        int tmp = array[a];
        array[a] = array[b];
        array[b] = tmp;
    }
}
