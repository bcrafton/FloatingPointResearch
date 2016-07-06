import csv
import glob
import os
import numpy
from numpy import genfromtxt
import matplotlib.pyplot as plt
import time

def write_csv(path, filename, result_matrix):
    if not os.path.exists(path):
        os.makedirs(path)

    full_path = os.path.join(path, filename)
    numpy.savetxt(full_path, result_matrix, delimiter=',')

def write_histogram(path, filename, result_matrix):
    if not os.path.exists(path):
        os.makedirs(path)
    full_path = os.path.join(path, filename)

    plt.hist(result_matrix, bins=50)
    plt.savefig(full_path)
    plt.close()

def array_to_csv(array, path):
    with open(path, "w") as f:
        writer = csv.writer(f)
        writer.writerows(array)
    f.close()

def get_filename(path):
    return os.path.basename(path)

def get_directory(path):
    return os.path.basename(os.path.dirname(path))

def get_key_index_map(map):
    key_index_map = {}
    index_key_map = {}
    count = 0
    for key in map:
        key_index_map[key] = column_count
        index_key_map[column_count] = key
        count = count + 1
    return key_index_map, index_key_map
