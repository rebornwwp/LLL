#!/usr/bin/env python
# encoding: utf-8

import os
import sys

import numpy as np
from sklearn import datasets

import matplotlib.pyplot as plt
import matplotlib.cm  as cmx
import matplotlib.colors as colors
from mpl_toolkits.mplot3d import Axes3D

dir_path = os.path.dirname(os.path.realpath(__file__))
dir_path = os.path.dirname(dir_path)
sys.path.insert(0, os.path.join(dir_path, 'utils'))

from data_operation import calculate_covariance_matrix
from data_operation import calculate_correlation_matrix
from data_manipulation import standardize

class PCA():
    def __init__(self):
        pass

    def transform(slef, X, n_components):
        covariance = calculate_covariance_matrix(X)

        eigenvalues, eigenvectors = np.linalg.eig(covariance)
        print(np.diag(eigenvalues))
        print(eigenvectors * covariance * eigenvectors.T)
        idx = eigenvalues.argsort()[::-1]
        # sort the eigenvalue, pick the the n_components latgest eigenvalues.
        eigenvalues = eigenvalues[idx][:n_components]
        eigenvectors = np.atleast_1d(eigenvectors[:, idx])[:, :n_components]
        X_transformed = X.dot(eigenvectors)

        return X_transformed

    def plot_in_2d(self, X, y=None, title=None, accuracy=None, legend_labels=None):
        X_transformed = self.transform(X, n_components=2)
        x1 = X_transformed[:, 0]
        x2 = X_transformed[:, 1]

        y = np.array(y).astype(int)

        # color map
        cmap = plt.get_cmap('viridis')
        colors = [cmap(i) for i in np.linspace(0, 1, len(np.unique(y)))]

        for i, l in enumerate(np.unique(y)):
            _x1 = x1[y == l]
            _x2 = x2[y == l]
            _y = y[y == l]
            plt.scatter(_x1, _x2, color=colors[i])

        if legend_labels is not None:
            plt.legend(class_distr, legend_labels, loc=1)

        if title is not None:
            if accuracy is not None:
                percent = 100 * accuracy
                plt.suptitle(title)
                plt.title("Accuracy: %.1f%%" % percent, fontsize=10)
            else:
                plt.title(title)

        plt.xlabel('Principal Component 1')
        plt.ylabel('Principal Component 2')

        plt.show()


    def plot_in_3d(self, X, y=None):
        X_transformed = self.transform(X, 3)
        x1 = X_transformed[:, 0]
        x2 = X_transformed[:, 1]
        x3 = X_transformed[:, 2]
        fig = plt.figure()
        ax = fig.add_subplot(111, projection="3d")
        ax.scatter(x1, x2, x3, c=y)
        plt.show()





def test():
    data = datasets.load_digits()
    X = data.data
    y = data.target

    pca = PCA()
    pca.plot_in_2d(X, y, title="PCA", accuracy=0.2)


if __name__ == "__main__":
    test()

