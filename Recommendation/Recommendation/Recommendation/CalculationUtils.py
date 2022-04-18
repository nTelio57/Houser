from numpy import dot
from numpy.linalg import norm

def EuclideanDistance(a, b):
    a = NoneToDefault(a)
    b = NoneToDefault(b)

    return 1 - (abs(a-b)/(a+b))

def BoolToBinaryParse(x):
    x = NoneToDefault(x)
    if x == False:
        return -1
    else: 
        return 1

def CosineSimilarityBool(x, y):
    a = list(map(BoolToBinaryParse, x))
    b = list(map(BoolToBinaryParse, y))
    return dot(a, b)/(norm(a)*norm(b))

def CosineSimilarity(a, b):
    a = list(map(lambda x: float(NoneToDefault(x)), a))
    b = list(map(lambda x: float(NoneToDefault(x)), b))

    if norm(a) == 0 or norm(b) == 0:
        return 0

    return dot(a, b)/(norm(a)*norm(b))

def NoneToDefault(x):
    if x == None:
        return 1
    return x