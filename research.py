import csv
import glob
import os
import numpy
from numpy import genfromtxt
import matplotlib.pyplot as plt
import time

def write_csv(path, filename, matrix):
    if not os.path.exists(path):
        os.makedirs(path)

    full_path = os.path.join(path, filename)
    numpy.savetxt(full_path, matrix, delimiter=',')

def write_histogram(path, filename, matrix):
    if not os.path.exists(path):
        os.makedirs(path)
    full_path = os.path.join(path, filename)

    plt.hist(matrix, bins=50)
    plt.savefig(full_path)
    plt.close()

def array_to_csv(path, array):
    with open(path, "w") as f:
        writer = csv.writer(f)
        writer.writerows(array)
    f.close()

def get_boolean_result_matrix(benchmark_hardware_results_map, hardware_pairs, benchmarks):
    num_rows = len(hardware_pairs) + 1
    num_cols = len(benchmarks) + 1
    boolean_result_matrix = [['X'] * num_cols for i in range(num_rows)]
    for i in range(len(hardware_pairs)):
        boolean_result_matrix[i + 1][0] = hardware_pairs[i]
    for i in range(len(benchmarks)):
        boolean_result_matrix[0][i + 1] = benchmarks[i]
    for benchmark in benchmarks:
        for hardware_pair in hardware_pairs:
            row_index = hardware_pairs.index(hardware_pair) + 1
            col_index = benchmarks.index(benchmark) + 1
            if numpy.count_nonzero(benchmark_hardware_results_map[hardware_pair, benchmark]) != 0:
                boolean_result_matrix[row_index][col_index] = 1
            else:
                boolean_result_matrix[row_index][col_index] = 0
    path = os.path.join(analysis_directory, "boolean_matrix.csv")
    array_to_csv(path, boolean_result_matrix)


def largest_relative_indexes(benchmark_hardware_output_map, hardwares, benchmark):

    control_hardware = 'intel'
    result_map = {}
	
    largest_indexes = []
    for hardware in hardwares:
        if hardware != control_hardware:
            m0 = benchmark_hardware_output_map[hardware, benchmark]
            m1 = benchmark_hardware_output_map[control_hardware, benchmark]
            result_map[hardware] = numpy.divide(numpy.absolute(numpy.subtract(m0, m1)), numpy.absolute(m1))
            if numpy.count_nonzero(result_map[hardware]) != 0:
                abs = numpy.absolute(result_map[hardware].flatten())
                indexes = abs.argsort()[-5:]
                indexes = numpy.unravel_index(indexes, result_map[hardware].shape)
                indexes = numpy.matrix(indexes)
                indexes = indexes.T
                indexes = indexes.tolist()
                largest_indexes = largest_indexes + indexes

    num_rows = len(hardwares) + 1
    num_cols = len(largest_indexes) + 1
    largest_index_values = [['X'] * num_cols for i in range(num_rows)]

    for i in range(len(hardwares)):
        largest_index_values[i + 1][0] = hardwares[i]
    for i in range(len(largest_indexes)):
        largest_index_values[0][i + 1] = largest_indexes[i]

    for hardware in hardwares:
        if hardware != control_hardware:
            if numpy.count_nonzero(result_map[hardware]) != 0:
                # the danger with
                # for index in largest_indexes:
                # is that the count of iterations through is needed, not index
                for i in range(len(largest_indexes)):
                    index = largest_indexes[i]
                    row_index = hardwares.index(hardware) + 1
                    col_index = i + 1
                    # if you do a reverse lookup on largest_indexes for i
                    # col_index = largest_indexes.index(index) then any duplicates will fuck you.
                    largest_index_values[row_index][col_index] = result_map[hardware][tuple(index)]

    path = os.path.join(relative_values_directory, "relative_values_" + benchmark + ".csv")
    array_to_csv(path, largest_index_values)


def largest_absolute_indexes(benchmark_hardware_results_map, hardware_pairs, benchmark):
    largest_indexes = []
    for hardware_pair in hardware_pairs:
        if numpy.count_nonzero(benchmark_hardware_results_map[hardware_pair, benchmark]) != 0:
            abs = numpy.absolute(benchmark_hardware_results_map[hardware_pair, benchmark].flatten())
            indexes = abs.argsort()[-5:]
            indexes = numpy.unravel_index(indexes, benchmark_hardware_results_map[hardware_pair, benchmark].shape)
            indexes = numpy.matrix(indexes)
            indexes = indexes.T
            indexes = indexes.tolist()
            largest_indexes = largest_indexes + indexes

    num_rows = len(hardware_pairs) + 1
    num_cols = len(largest_indexes) + 1
    largest_index_values = [['X'] * num_cols for i in range(num_rows)]

    for i in range(len(hardware_pairs)):
        largest_index_values[i + 1][0] = hardware_pairs[i]
    for i in range(len(largest_indexes)):
        largest_index_values[0][i + 1] = largest_indexes[i]

    for hardware_pair in hardware_pairs:
        if numpy.count_nonzero(benchmark_hardware_results_map[hardware_pair, benchmark]) != 0:
            # the danger with
            # for index in largest_indexes:
            # is that the count of iterations through is needed, not index
            for i in range(len(largest_indexes)):
                index = largest_indexes[i]
                row_index = hardware_pairs.index(hardware_pair) + 1
                col_index = i + 1
                # if you do a reverse lookup on largest_indexes for i
                # col_index = largest_indexes.index(index) then any duplicates will fuck you.
                largest_index_values[row_index][col_index] = benchmark_hardware_results_map[hardware_pair, benchmark][tuple(index)]

    path = os.path.join(largest_values_directory, "largest_values_" + benchmark + ".csv")
    array_to_csv(path, largest_index_values)

data_directory = os.path.join(os.getcwd(), "data")
data_output_directory = os.path.join(data_directory, "output")
data_input_directory = os.path.join(data_directory, "input")

analysis_directory = os.path.join(os.getcwd(), "analysis")
csv_directory = os.path.join(analysis_directory, "csv")
histogram_directory = os.path.join(analysis_directory, "histogram")
largest_values_directory = os.path.join(analysis_directory, "largest_values")
relative_values_directory = os.path.join(analysis_directory, "relative_values")

hardwares = ["amdcpu", "amdgpu", "intel", "nvidia"]
benchmarks = ["md", "sor", "spmv", "stencil2d"]
hardware_pairs = []
# every possible comparison between the hardwares
for i in range(len(hardwares)):
    for j in range(i + 1, len(hardwares)):
        hardware_pairs.append((hardwares[i], hardwares[j]))

benchmarks_with_input = ["sor"]

# the map between a hardware, benchmark pair
#   and the result data
#   and the input data
benchmark_hardware_output_map = {}
benchmark_hardware_input_map = {}

# the result matrix from each hardware pair's run of a benchmark
benchmark_hardware_results_map = {}

# load the benchmark results and input data for each hardware
for hardware in hardwares:
    for benchmark in benchmarks:
        output_path = os.path.join(data_output_directory, hardware + "_" + benchmark + ".csv")
        if os.path.isfile(output_path):
            benchmark_hardware_output_map[(hardware, benchmark)] = genfromtxt(output_path, delimiter=',')

        input_path = os.path.join(data_input_directory, hardware + "_" + benchmark + ".csv")
        if os.path.isfile(input_path):
            benchmark_hardware_input_map[(hardware, benchmark)] = genfromtxt(input_path, delimiter=',')

# verify inputs are the same
for benchmark in benchmarks_with_input:
    valid = 1
    for hardware_pair in hardware_pairs:
        m0 = benchmark_hardware_input_map[hardware_pair[0], benchmark]
        m1 = benchmark_hardware_input_map[hardware_pair[1], benchmark]
        result = numpy.subtract(m0, m1)
        if numpy.count_nonzero(result) != 0:
            print(hardware_pair[0], "and", hardware_pair[1], "have different input matrixes!")
            valid = 0
    if valid == 1:
        print("All inputs are the same for", benchmark)

# for each bench mark
for benchmark in benchmarks:
    largest_indexes = []
    # for each hardware pair
    for hardware_pair in hardware_pairs:
            # get current time
            t = time.time()
            # get the result
            m0 = benchmark_hardware_output_map[hardware_pair[0], benchmark]
            m1 = benchmark_hardware_output_map[hardware_pair[1], benchmark]
            benchmark_hardware_results_map[hardware_pair, benchmark] = numpy.subtract(m0, m1)
            # if there is a difference in the matrices
            if numpy.count_nonzero(benchmark_hardware_results_map[hardware_pair, benchmark]) != 0:
                # write the csv
                matrix = benchmark_hardware_results_map[hardware_pair, benchmark]
                filename = hardware_pair[0] + "_" + hardware_pair[1] + "_" + benchmark + ".csv"
                write_csv(path=csv_directory, filename=filename, matrix=matrix)

                # write the histogram
                matrix = benchmark_hardware_results_map[hardware_pair, benchmark]
                filename = hardware_pair[0] + "_" + hardware_pair[1] + "_" + benchmark + ".jpg"
                #write_histogram(path=histogram_directory, filename=filename, matrix=matrix)

                print(hardware_pair, benchmark)

    largest_absolute_indexes(benchmark_hardware_results_map=benchmark_hardware_results_map,
                        hardware_pairs=hardware_pairs,
                        benchmark=benchmark)
    largest_relative_indexes(benchmark_hardware_output_map=benchmark_hardware_output_map,
                             hardwares=hardwares,
                        benchmark=benchmark)

get_boolean_result_matrix(benchmark_hardware_results_map=benchmark_hardware_results_map, hardware_pairs=hardware_pairs,
                          benchmarks=benchmarks)


