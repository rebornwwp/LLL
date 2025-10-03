#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 28 16:44:20 2017

@author: rebornwwp
"""

import os
import sys
import numpy as np

dir_path = os.path.dirname(os.path.realpath(__file__))
dir_path = os.path.dirname(dir_path)
sys.path.insert(0, os.path.join(dir_path, "utils"))
from data_operation import mean_squared_error
from data_manipulation import train_test_split


class RidgeRegression():
    def __init__(self, penalty_coef, n_iterations=100, learning_rate=0.01, \
                 gradient_descent=True):
        self.w = None
        self.penalty_coef = penalty_coef
        self.n_iterations = n_iterations
        self.learning_rate = learning_rate
        self.gradient_descent = gradient_descent

    def fit(self, X, y):
        # 添加intercept的w参数
        X = np.insert(X, 0, 1, axis=1)

        n_feature = X.shape[1]

        if self.gradient_descent is True:
            pass
        else:
            # 求解 (X^T * X + alpha * I) * w = X^T * y
            # 式子中 X^T * X + alpha * I = X
            # X_inv = X^(-1)
            U, S, V = np.linalg.svd(X.T.dot*(X) + \
                                    self.penalty_coef * np.identity(n_feature))
            S = np.diag(S)
            X_inv = V.dot(np.linalg.pinv(S)).dot(U.T)
            self.w = X.inv.dot(X.T).dot(y)

    def predict(self, X):
        X = np.insert(X, 0, 1, axis=1)
        y_pred = X.dot(self.w)
        return y_pred


def main():
    X, y = datasets.make_regression(n_features=1, n_samples=100, bias=3, noise=10)
    X_train, X_test, y_train, y_test = train_test_split(X, y, 0.3)
    clf = RidgeRegression()

