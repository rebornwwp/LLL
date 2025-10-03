#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 27 17:34:54 2017

@author: rebornwwp
"""

import matplotlib.pyplot as plt
import numpy as np
from sklearn import datasets
import sys
import os
import math

dir_path = os.path.dirname(os.path.realpath(__file__))
dir_path = os.path.dirname(dir_path)
sys.path.insert(0, os.path.join(dir_path, 'utils'))
from data_operation import mean_squared_error
from data_manipulation import train_test_split

class LinearRegression(object):
    def __init__(self, n_iterations=100, learning_rate=0.001,
            gradient_descent=True):
        self.w = None
        self.n_iterators=n_iterations
        self.learning_rate=learning_rate
        self.gradient_descent=gradient_descent

    def fit(self, X, y):
        X = np.insert(X, 0, 1, axis=1)
        if self.gradient_descent:
            n_features = np.shape(X)[1]
            self.w = np.random.random((n_features, 1))
            for _ in range(self.n_iterators):
                w_gradient = X.T.dot(X.dot(self.w) - y)
                self.w -= self.learning_rate * w_gradient
        else:
            U, S, V = np.linalg.svd(X.T.dot(X))
            S = np.diag(S)
            X_sq_inv = V.dot(np.linalg.pinv(S).dot(U.T))
            self.w = X_sq_inv.dot(X.T).dot(y)

    def predict(self, X):
        X = np.insert(X, 0 ,1, axis=1)
        y_pred = X.dot(self.w)
        return y_pred

def main():
    X, y = datasets.make_regression(n_features=1, n_samples=200, bias=100,
        noise = 5)
    X_train, X_test, y_train ,y_test = train_test_split(X, y, test_size=0.4)
    print(X_train.shape, y_train.shape)
    clf = LinearRegression(gradient_descent=False)
    clf.fit(X_train, y_train)
    y_pred = clf.predict(X_test)
    print(y_pred.shape)
    print(X_test.shape)
    mse = mean_squared_error(y_test, y_pred)

    print("Mean squared error", mse)

    plt.scatter(X_test, y_test, color='black')
    plt.plot(X_test, y_pred, color='red', lw=4)
    plt.title("Linear Regression")
    plt.show()

if __name__ == "__main__":
    main()

