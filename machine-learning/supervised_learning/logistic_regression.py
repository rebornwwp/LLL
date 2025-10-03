#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 15:25:34 2017

@author: MacBook
"""

import sys
import os
import math
from sklearn import datasets
import numpy as np

dir_path = os.path.dirname(os.path.realpath(__file__))
dir_path = os.path.dirname(dir_path)
sys.path.insert(0, os.path.join(dir_path, 'utils'))

from data_manipulation import normalize, train_test_split
from data_operation import accuracy_score

sys.path.insert(0, os.path.join(dir_path, 'unsupervised_learning'))
from pca import PCA

def sigmoid(x):
    return 1. / (1 + np.exp(-x))

def sigmoid_gradient(x):
    return sigmoid(x) * (1 - sigmoid(x))


class LogisticRegression():
    def __init__(self, learning_rate=0.1, gradient_descent=True):
        self.param = None
        self.learning_rate = learning_rate
        self.gradient_descent = gradient_descent

    def fit(self, X, y, n_iterations=4000):
        X = np.insert(X, 0, 1, axis=1)

        n_samples, n_features = np.shape(X)
        a = -1. / math.sqrt(n_features)
        b = -a
        self.param = (b - a) * np.random.random((n_features,)) + a
        for _ in range(n_iterations):
            y_pred = sigmoid(X.dot(self.param))
            if self.gradient_descent:
                self.param -= self.learning_rate * X.T.dot(y_pred - y)
            else:
                diag_gradient = np.diag(sigmoid_gradient(X.dot(self.param)))
                self.param = np.linalg.pinv(X.T.dot(diag_gradient).dot(X)).dot(X.T).dot(diag_gradient.dot(X).dot(self.param) + y - y_pred)

    def predict(self, X):
        X = np.insert(X, 0, 1, axis=1)
        dot = X.dot(self.param)
        y_pred = np.round(sigmoid(dot)).astype(int)
        return y_pred

def main():
    # Load dataset
    data = datasets.load_iris()
    X = normalize(data.data[data.target != 0])
    y = data.target[data.target != 0]
    y[y == 1] = 0
    y[y == 2] = 1

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, seed=1)

    clf = LogisticRegression(gradient_descent=True)
    clf.fit(X_train, y_train)
    y_pred = clf.predict(X_test)

    accuracy = accuracy_score(y_test, y_pred)

    print ("Accuracy:", accuracy)

    # Reduce dimension to two using PCA and plot the results
    pca = PCA()
    pca.plot_in_2d(X_test, y_pred, title="Logistic Regression", accuracy=accuracy)

if __name__ == "__main__":
    main()

