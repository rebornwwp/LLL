#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 27 17:34:54 2017

@author: rebornwwp
"""

import numpy as np
import math
import sys

def mean_squared_error(y_test, y_pred):
    y_test = np.array(y_test)
    y_pred = np.array(y_pred)
    mse = np.mean(np.power(y_test - y_pred, 2))
    return mse

    
def calculate_std_dev(X):
    std_dev = np.sqrt(calculate_variance(X))
    
    return std_dev
    
    
def calculate_variance(X):
    mean = np.ones(np.shape(X)) * X.mean(0)
    n_sample = np.shape(X)[0]
    variance = (1 / n_sample) * np.diag((X - mean).T.dot(X - mean))
    
    return variance
    

def calculate_covariance_matrix(X, Y=None):
    if Y is None:
        Y = X
        
    n_sample = np.shape(X)[0]
    convariance_matrix = (1 / n_sample) * (X - X.mean(0)).T.dot(Y - Y.mean(0))
    
    return np.array(convariance_matrix, dtype=float)
    

def calculate_correlation_matrix(X, Y=None):
    if Y is None:
        Y = X
        
    convariance = calculate_covariance_matrix(X, Y)
    #print(convariance)
    std_dev_X = np.expand_dims(calculate_std_dev(X), 1)
    std_dev_y = np.expand_dims(calculate_std_dev(Y), 1)
    #print(std_dev_X)
    #print(std_dev_Y)
    #print(std_dev_X.dot(std_dev_Y.T))
    correlation_matrix = np.divide(convariance, std_dev_X.dot(std_dev_y.T))
    
    return np.array(correlation_matrix)
 

# 分类的精度
def accuracy_score(y_true, y_pred):
    result = (y_true == y_pred)
    total_y = result.shape[0]
    result_true = result.sum()
    return result_true / total_y

    
def euclidean_distance(x1, x2):
    distance = 0
    for i, j in zip(x1, x2):
        distance += math.pow(i - j, 2)
    return math.sqrt(distance)


def test1():
    x = np.diag([1,2,3])
    print(calculate_variance(x))
    print(calculate_std_dev(x))
    print(calculate_covariance_matrix(x))
    print(calculate_correlation_matrix(x))

    
def test2():
    y_true = np.array([1,2,3,3,2,1])
    y_pred = np.array([1,2,3,1,2,3])
    result = accuracy_score(y_true, y_pred)
    print(result)

if __name__ == "__main__":
    test2()