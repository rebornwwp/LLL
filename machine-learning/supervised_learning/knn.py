#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 28 14:02:55 2017

@author: rebornwwp
"""

import os
import sys
import numpy as np
import matplotlib.pyplot as plt
from sklearn import datasets

dir_path = os.path.dirname(os.path.realpath(__file__))
dir_path = os.path.dirname(dir_path)
sys.path.insert(0, os.path.join(dir_path, "utils"))
from data_manipulation import train_test_split, normalize
from data_operation import euclidean_distance, accuracy_score
sys.path.insert(0, os.path.join(dir_path, "unsupervised_learning"))
from pca import PCA


class KNN():
    def __init__(self, k=5):
        self.k = k

    # 多数表决
    def _majority_vote(self, neighbors, classes):
        max_count = 0
        max_vote = None

        for cla in np.unique(classes):
            count = len(neighbors[neighbors[:, 1] == cla])
            if count > max_count:
                max_count = count
                max_vote = cla
        return max_vote

    # 选择前k个最小欧拉距离的点
    def predict(self, X_test, X_train, y_train):
        classes = np.unique(y_train)
        pred_classes = []

        for test_sample in X_test:
            # 获得[欧拉距离，标签]的矩阵
            distances = []
            for i, train_sample in enumerate(X_train):
                distance = euclidean_distance(test_sample, train_sample)
                label = y_train[i]
                distances.append([distance, label])
            distances = np.array(distances)
            # 获得前k个最小的欧拉距离的点。
            index_argsort = np.argsort(distances[:, 0])
            neighbors = distances[index_argsort][:self.k]
            # 利用多数表决进行投票
            pred_cla = self._majority_vote(neighbors, classes)
            pred_classes.append(pred_cla)

        return np.array(pred_classes)

def main():
    data = datasets.load_iris()
    X = normalize(data.data)
    y = data.target

    X_train, X_test, y_train, y_test = train_test_split(X, y, 0.3)
    knn = KNN(3)
    y_pred = knn.predict(X_test, X_train, y_train)
    accuracy = accuracy_score(y_pred, y_test)
    print("accuracy is ", accuracy)

    pca = PCA()
    pca.plot_in_2d(X_test, y_pred, title="knn", accuracy=accuracy)


if __name__ == "__main__":
    main()

