from kmeans import Kmeans
import scipy
import numpy as np


class Kpp(Kmeans):

    def initialization(self, dataset):
        X = dataset
        print(X)

        C = [X[0]]
        print(C)
        for k in range(1, self.k):
            #  find shortest distantce squared to center
            D2 = scipy.array([min([scipy.inner(c-x, c-x) for c in C]) for x in X])
            probs = D2/D2.sum()
            cumprobs = probs.cumsum()
            print(cumprobs)
            r = scipy.rand()
            for j, p in enumerate(cumprobs):
                if r < p:
                    i = j
                    break
            C.append(X[i])
        return np.array(C)
