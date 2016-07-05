import csv
import glob
import os
import numpy
from numpy import genfromtxt
import matplotlib.pyplot as plt
import time

def write_csv(data, key, i, j, result_matrix):
    path = os.path.join(analysis_directory, "csv", data[key][i] + data[key][j])
    if not os.path.exists(path):
        os.makedirs(path)

    full_path = os.path.join(path, key)
    numpy.savetxt(full_path, result_matrix, delimiter=',')

def write_histogram(data, key, i, j, result_matrix):
    path = os.path.join(analysis_directory, "histogram", data[key][i] + data[key][j])
    if not os.path.exists(path):
        os.makedirs(path)
    full_path = os.path.join(path, os.path.splitext(key)[0] + ".jpg")

    plt.hist(result_matrix, bins=50)
    plt.savefig(full_path)
    plt.close()

data_directory = os.getcwd() + '\\data\\'
analysis_directory = os.getcwd() + '\\analysis\\'

paths = glob.glob(data_directory + '*/*.csv')

data = {}

for path in paths:
    try:
        data[os.path.basename(path)].append(os.path.basename(os.path.dirname(path)))
    except:
        data[os.path.basename(path)] = []
        data[os.path.basename(path)].append(os.path.basename(os.path.dirname(path)))


columns = {}
columns_inv = {}
column_count = 0
for key in data:
    columns[key] = column_count
    columns_inv[column_count] = key
    column_count = column_count + 1

rows = {}
rows_inv = {}
row_count = 0
for key in data:
    for i in range(len(data[key])):
        for j in range(i+1, len(data[key])):
            row = data[key][i] + data[key][j]
            if row not in rows.keys():
                rows[row] = row_count
                rows_inv[row_count] = row
                row_count = row_count + 1

difference = a = [['X'] * (len(columns)+1) for i in range(len(rows)+1)]

for i in range(len(rows)):
    difference[i+1][0] = rows_inv[i]
for i in range(len(columns)):
    difference[0][i+1] = columns_inv[i]

for key in data:
    matrix = []
    for i in range(len(data[key])):
        path = os.path.join(data_directory, data[key][i], key)
        matrix.append(genfromtxt(path, delimiter=','))
    for i in range(len(data[key])):
        for j in range(i+1, len(data[key])):
            # get the result
            result_matrix = numpy.subtract(matrix[i], matrix[j])
            # difference matrix coordinates
            row = data[key][i] + data[key][j]
            col = key
            largest_values = a = [[0] * (5) for i in range(len(data[key]))]
            if numpy.count_nonzero(result_matrix) != 0:
                # print the details
                print(row + os.path.splitext(key)[0])

                # set difference equal to 2
                difference[rows[row] + 1][columns[key] + 1] = 1

                # get the indexes of largest values
                abs = numpy.absolute(result_matrix.flatten())
                indexes = abs.argsort()[-5:]
                indexes = numpy.unravel_index(indexes, result_matrix.shape)
                indexes = numpy.matrix(indexes)
                indexes = indexes.T
                indexes = indexes.tolist()
                for k in range(len(indexes)):
                    print(result_matrix[tuple(indexes[k])])

                # get current time
                t = time.time()

                # write the csv
                write_csv(data, key, i, j, result_matrix)

                # write the histogram
                #write_histogram(data, key, i, j, result_matrix)

                print("done, time taken: " + str(time.time() - t))

            else:
                difference[rows[row] + 1][columns[key] + 1] = 0

    print(largest_values)

with open(analysis_directory + "output.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerows(difference)
f.close()



