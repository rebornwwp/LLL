#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 27 22:52:00 2017

@author: rebornwwp
"""

import os
import sys
import math
from sklearn import datasets
import numpy as np
import pandas as pd

dir_path = os.path.dirname(os.path.realpath(__file__))
dir_path = os.path.dirname(dir_path)

sys.path.insert(0, os.path.join(dir_path, "utils"))
from data_manipulation import train_test_split, normalize
from data_operation import accuracy_score

sys.path.insert(0, os.path.join(dir_path, "unsupervised_learning"))
from pca import PCA


class NaiveBayes():
    def __init__(self):
        self.classes = None
        self.X = None
        self.y = None
        self.parameters = []

    # 假定P(X|Y)服从高斯分布，下面存储每个Xi的高斯分布中的参数
    def fit(self, X, y):
        self.X = X
        self.y = y
        self.classes = np.unique(y)
        
        for i in range(self.classes.shape[0]):
            cla = self.classes[i]
            cla_X = (X[np.where(y == cla)])
            self.parameters.append([])
            for j in range(cla_X.shape[1]):
                col = cla_X[:, j]
                mean_var = {}
                mean_var["mean"] = col.mean()
                mean_var["var"] = col.var()
                self.parameters[i].append(mean_var)
    
    # 高斯分布, 其作用是计算条件概率分布
    def _calculate_probability(self, mean, var, x):
        coef = 1. / np.sqrt(2 * np.pi * var)
        exponent = np.exp(-np.power((x - mean), 2) / (2 * var))
        return coef * exponent
       
    # 计算先验概率
    def _calculate_prior(self, c):
        total_c_class = (self.y == c).sum()
        total = np.shape(self.X)[0]
        return total_c_class / total
        
    def _classify(self, sample):
        posteriors = []
        
        for i in range(len(np.unique(self.y))):
            cla = self.classes[i]
            # 计算先验概率分布P(y)
            prior = self._calculate_prior(cla)
            
            gaussian_params = self.parameters[i]
            for j, gaussian_param in enumerate(gaussian_params):
                mean = gaussian_param["mean"]
                var = gaussian_param["var"]
                x = sample[j]
                # 计算条件概率P(X=Xj | y = c)
                prob = self._calculate_probability(mean, var, x)
                
                # 计算 P(X|y) = P(X=X1|y)*P(X=X2|y)*...(X=Xn|y)
                prior = prior * prob
            posteriors.append(prior)
        
        index_of_max = np.argmax(posteriors)
        #max_value = posteriors[index_of_max]
        class_of_sample = self.classes[index_of_max]
        return class_of_sample
    
    def predict(self, X):
        y_pred = []
        for sample in X:
            y = self._classify(sample)
            y_pred.append(y)
        return np.array(y_pred)
     
def main():
    data = datasets.load_iris()
    X = normalize(data.data)
    y = data.target
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, 0.3)
    
    clf = NaiveBayes()
    clf.fit(X_train, y_train)
    y_pred = clf.predict(X_test)
    
    print(accuracy_score(y_pred, y_test))

if __name__ == "__main__":
    main()
