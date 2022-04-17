from numpy import dot
from numpy.linalg import norm

def EuclideanDistance(a, b):
    return 1 - (abs(a-b)/(a+b))

def BoolToBinaryParse(x):
    if x == None:
        return 0
    if x == False:
        return -1
    else: 
        return 1

def CosineSimilarityBool(x, y):
    a = list(map(BoolToBinaryParse, x))
    b = list(map(BoolToBinaryParse, y))
    return dot(a, b)/(norm(a)*norm(b))

def CosineSimilarity(a, b):
    a = list(map(lambda x: float(x), a))
    b = list(map(lambda x: float(x), b))

    if norm(a) == 0 or norm(b) == 0:
        return 0

    return dot(a, b)/(norm(a)*norm(b))
