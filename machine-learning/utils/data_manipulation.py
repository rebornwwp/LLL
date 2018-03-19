#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 27 17:34:54 2017

@author: rebornwwp
"""

import numpy as np


def shuffle_data(X, y, seed=None):
    X_y = np.concatenate((X, y.reshape((1, len(y))).T), axis=1)
    if seed:
        np.random.seed(seed)

    np.random.shuffle(X_y)
    X = X_y[:, :-1]
    y = X_y[:, -1].astype(int)

    return X, y


def train_test_split(X, y, test_size=0.5, shuffle=True, seed=None):
    if shuffle:
        X, y = shuffle_data(X, y, seed)
    split_i = len(y) - int(len(y) // (1 / test_size))
    x_train, x_test = X[:split_i], X[split_i:]
    y_train, y_test = y[:split_i], y[split_i:]

    return x_train, x_test, y_train, y_test


def standardize(X):
    mean = X.mean(axis=0)
    std = X.std(axis=0)
    # broadcast
    X_std = (X - mean) / std
    return X_std


def normalize(X, axis=-1, order=2):
    l2 = np.atleast_1d(np.linalg.norm(X, order, axis))
    # 防止后面除的时候0不能除
    l2[l2 == 0] = 1
    return X / np.expand_dims(l2, axis)


def k_fold_cross_validation_sets(X, y, k, shuffle=True):
    if shuffle:
        X, y = shuffle_data(X, y)

    n_samples =len(y)
    left_overs = {}
    n_left_overs = (n_samples % k)
    if n_left_overs != 0:
        left_overs["X"] = X[-n_left_overs:]
        left_overs["y"] = y[-n_left_overs:]
        X = X[:-n_left_overs]
        y = y[:-n_left_overs]

    X_split = np.split(X, k)
    y_split = np.split(y, k)
    sets = []
    for i in range(k):
        X_test, y_test = X_split[i], y_split[i]
        X_train = np.concatenate(X_split[:i] + X_split[i + 1:], axis=0)
        y_train = np.concatenate(y_split[:i] + y_split[i + 1:], axis=0)
        sets.append([X_train, X_test, y_train, y_test])

    if n_left_overs != 0:
        np.append(sets[-1][0], left_overs["X"], axis=0)
        np.append(sets[-1][0], left_overs["y"], axis=0)
    return np.array(sets)


def test1():
    X = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    y = [1, 2, 3]
    X = np.array(X)
    y = np.array(y)
    print(train_test_split(X, y, seed=1))
    X = np.random.randn(10, 3)
    print(standardize(X).mean(axis=0))
    print(standardize(X).std(axis=0))


if __name__ == "__main__":
    test2()
