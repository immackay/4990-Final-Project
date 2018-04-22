from kpp import Kpp
from kmeans import Kmeans


kpp_means = Kpp("pts2.txt", 4)
centroids = kpp_means.execute(graph=True)

kmeans = Kmeans("pts2.txt", 4, seed=23) # Finds appropriate clusters
#kmeans = Kmeans("pts2.txt", 4, seed=3) # Local optimum
#kmeans = Kmeans("pts2.txt", 4, seed=6) # Local optimum
#centroids = kmeans.execute(graph=True)

'''
all_kmeans_centroids = []
all_kpp_means_centroids = []

for _ in range(1, 100):
    kmeans_centroids = kmeans.execute(graph=False)
    all_kmeans_centroids.append(kmeans_centroids)

for _ in range(1, 100):
    kpp_centroids = kpp_means.execute(graph=False)
    all_kpp_means_centroids.append(kpp_centroids)

print(all_kpp_means_centroids)
'''
