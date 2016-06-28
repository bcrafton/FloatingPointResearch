import csv
import glob
import os
import numpy
from numpy import genfromtxt
import matplotlib.pyplot as plt

research_directory = 'C:/Users/craft/Desktop/Research/'
#savedir = 'C:\\Users\\craft\\Desktop\\Research'

paths = glob.glob(research_directory + '*/*.csv')

results = {}

def print_csv(path):
    f = open(path, 'rb')
    reader = csv.reader(f)
    for row in reader:
        print (row)
    f.close()

for path in paths:
    #f = open(path, 'rb')
    #reader = csv.reader(f)

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

    #f.close()

# reason why stencil2d is failing is because csv has no commas!
#a = genfromtxt(research_directory+'/AMD/Stencil2D00.csv', delimiter=',')
#print(a)

for key in results:
    data = []
    for i in range(len(results[key])):
        path = os.path.join(research_directory, results[key][i], key)
        data.append(genfromtxt(path, delimiter=','))
    for i in range(len(results[key])):
        result_matrix = numpy.subtract(data[i], data[(i+1) % len(results[key])])
        if numpy.count_nonzero(result_matrix) != 0:
            #print(numpy.std(result_matrix))
            path = os.path.join(research_directory, 'results', results[key][i] + results[key][(i+1) % len(results[key])] + key)
            #print(path)
            #numpy.savetxt(path, result_matrix, delimiter=',')
			print(result_matrix.size)
            #plt.hist(result_matrix, bins=50)
            #plt.savefig(research_directory + results[key][i] + results[key][(i+1) % len(results[key])] + "figure" + ".jpg")
			
