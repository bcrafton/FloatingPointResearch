import csv
import glob
import os
import numpy
from numpy import genfromtxt
import matplotlib.pyplot as plt
import time

research_directory = os.getcwd() + '\\research\\'
results_directory = os.getcwd() + '\\results\\'

paths = glob.glob(research_directory + '*/*.csv')

results = {}

for path in paths:
    # f = open(path, 'rb')
    # reader = csv.reader(f)

    '''
    for row in reader:
        print row
    '''

    # print os.path.basename(os.path.dirname(path))

    try:
        results[os.path.basename(path)].append(os.path.basename(os.path.dirname(path)))
    except:
        results[os.path.basename(path)] = []
        results[os.path.basename(path)].append(os.path.basename(os.path.dirname(path)))

    '''
    if results[os.path.basename(path)] is None:
        results[os.path.basename(path)] = []
        results[os.path.basename(path)].append(os.path.basename(os.path.dirname(path)))
    '''

    # f.close()

# we cud make better practices but using order dictionaries in all cases
# so thay way no chance of amdintel and intelamd

columns = {}
column_count = 0
for key in results:
    columns[key] = column_count
    column_count = column_count + 1
# print(columns)

rows = {}
row_count = 0
for key in results:
    for i in range(len(results[key])):
        row = results[key][i] + results[key][(i + 1) % len(results[key])]
        if row not in rows.keys():
            print(results[key][i])
            rows[row] = row_count
            row_count = row_count + 1
# print(rows)

difference = numpy.zeros((len(rows)+1, len(columns)+1))


def get_index(array, val):
    array = array.flatten()
    for i in range(len(array)):
        if val == array[i]:
            return i


for key in results:
    data = []
    for i in range(len(results[key])):
        path = os.path.join(research_directory, results[key][i], key)
        data.append(genfromtxt(path, delimiter=','))
    for i in range(len(results[key])):
        result_matrix = numpy.subtract(data[i], data[(i + 1) % len(results[key])])
        # difference matrix coordinates
        row = results[key][i] + results[key][(i + 1) % len(results[key])]
        col = key
        if numpy.count_nonzero(result_matrix) != 0:

            largest = numpy.sort(numpy.absolute(result_matrix), axis=None)[-5:]
            largest_indexes = []
            for j in largest:
                largest_indexes.append(get_index(numpy.absolute(result_matrix), j))
            print(largest_indexes)

            # set difference equal to 2
            difference[rows[row] + 1][columns[key] + 1] = 2
            '''
            # print the details
            print(results[key][i] + results[key][(i + 1) % len(results[key])] + os.path.splitext(key)[0])

            # get current time
            t = time.time()

            # write the csv
            path = os.path.join(results_directory, results[key][i] + results[key][(i + 1) % len(results[key])] + key)
            numpy.savetxt(path, result_matrix, delimiter=',')

            # write the histogram
            plt.hist(result_matrix, bins=50)
            path = research_directory + results[key][i] + results[key][(i + 1) % len(results[key])] + \
                   os.path.splitext(key)[0] + ".jpg"
            plt.savefig(path)
            plt.close()
            print("done, time taken: " + str(time.time() - t))
            '''
        else:
            difference[rows[row] + 1][columns[key] + 1] = 1

print(difference)
