import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation


class Kmeans(object):
    def __init__(self, data_as_txt, k, seed=None):
        self.k = k
        self.data_as_txt = data_as_txt
        self.seed = seed

    def load_dataset(self, name):
        return np.loadtxt(name)

    def euclidian(slef, a, b):
        return np.linalg.norm(a-b)  # magnitude between two points

    def plot(self, dataset, history_centroids, belongs_to):
        colors = ['r', 'g', 'y', 'c']

        fig, ax = plt.subplots()


        for index in range(dataset.shape[0]):
            instances_close = [i for i in range(len(belongs_to)) if belongs_to[i] == index]
            for instance_index in instances_close:
                ax.plot(dataset[instance_index][0], dataset[instance_index][1], (colors[index] + 'o'))

        history_points = []
        for index, centroids in enumerate(history_centroids):
            for inner, item in enumerate(centroids):
                if index == 0:
                    history_points.append(ax.plot(item[0], item[1], 'bo')[0])
                else:
                    history_points[inner].set_data(item[0], item[1])
                    plt.pause(0.8)


    ''' num_instances: number of rows in data (i.e how many points)
        dataset: the data
        return: list of k randomly selected data points in a list: [[x1 y1] [x2 y2] ... [xk yk]]
    '''
    def initialization(self, dataset):

        if self.seed is not None:
            np.random.seed(self.seed)

        num_instances, num_features = dataset.shape  # 45, 2
        return dataset[np.random.choice(num_instances - 1, self.k, replace=False)]
        #return dataset[np.random.randint(0, num_instances - 1, size = self.k)]

    def kmeans(self, k, epsilon=0, distance='euclidian'):
        history_centroids = []
        if distance == 'euclidian':
            dist_method = self.euclidian
        dataset = self.load_dataset(self.data_as_txt)
        # dataset = dataset[:, 0:dataset.shape[1] - 1]
        num_instances, num_features = dataset.shape  # 45, 2


        #prototypes = dataset[np.random.randint(0, num_instances - 1, size=k)]
        prototypes = self.initialization(dataset)
        history_centroids.append(prototypes)
        prototypes_old = np.zeros(prototypes.shape)
        belongs_to = np.zeros((num_instances, 1))
        norm = dist_method(prototypes, prototypes_old)
        iteration = 0

        while norm > epsilon:
            iteration += 1
            norm = dist_method(prototypes, prototypes_old)
            prototypes_old = prototypes
            for index_instance, instance in enumerate(dataset):
                dist_vec = np.zeros((k, 1))
                for index_prototype, prototype in enumerate(prototypes):
                    dist_vec[index_prototype] = dist_method(prototype,
                                                            instance)

                belongs_to[index_instance, 0] = np.argmin(dist_vec)

            tmp_prototypes = np.zeros((k, num_features))

            for index in range(len(prototypes)):
                instances_close = [i for i in range(len(belongs_to)) if belongs_to[i] == index]
                prototype = np.mean(dataset[instances_close], axis=0)
                # prototype = dataset[np.random.randint(0, num_instances, size=1)[0]]

                tmp_prototypes[index, :] = prototype

            prototypes = tmp_prototypes

            history_centroids.append(tmp_prototypes)

        #self.plot(dataset, history_centroids, belongs_to)

        return prototypes, history_centroids, belongs_to

    def execute(self, graph=True):
        dataset = self.load_dataset(self.data_as_txt)
        centroids, history_centroids, belongs_to = self.kmeans(self.k)
        if(graph):
            self.plot(dataset, history_centroids, belongs_to)

        return centroids
