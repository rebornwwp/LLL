# Ridge Regression

------

Motivation: 太多预测因素

> * 数据的输入变量的维度超过数据的观测数
> * 当多预测因素的时候，没有用上惩罚项的拟合结果将会在一个很大的预测区间中，这样最小二乘回归估计器将不唯一

Motivation: 病态的X

> * 因为最小二乘估计器计算的时候需要计算$(X'X)^{-1}$，当$(X'X)^{-1}$为奇异的，这样计算参数的时候就会有错误
> * 在常规的线性回归中，$X$中元素很小的变化，都可能导致$(X'X)^{-1}$很大的变化
> * least squared estimator 在训练数据集学习到的$\beta_{LS}$，可能将估计器放到测试数据集中，效果就不好。

------

## Ridge Regression

首先我们假设X和Y都已经中心化(centered), 所以我们就不用再回归中加入一个常数项(constant item).

> * X is a n by p matrix with centered columns
> * Y is a centered n-vector

通过最小二乘法得到的参数为
$$\hat{\beta} = (X'X)^{-1} X' Y$$, 
而ridge regression的结果是:
$$\hat{\beta}_{ridge} = (X'X+\lambda I_p)^{-1} X' Y$$
其就是下式的最小解
$$\sum_{i=1}^n (y_i - \sum_{j=1}^p x_{ij}\beta_j)^2 + \lambda \sum_{j=1}^p \beta_j^2$$

## Geometric Interpretation of Ridge Regression

![geometric interpretation](./picture/ridge_regression_geomteric.png)

上面的椭圆是residual sum of squares的等高线，越往里面，rss越小，rss被用来OLS中

对于$p=2$的时候，约束条件将变成一个圆。

岭回归的最优解就是在椭圆和圆相切的地方。

关于惩罚项(penalty item and RSS), 越大$beta$, 将使得RSS更好，但是会将惩罚项增大，这就是为什么我们更喜欢小的$$\(\beta\)$$的原因

## Properties of Ridge Estimator

$\hat{\beta}_{ls}$is an unbiased estimator of $\beta$; $\hat{\beta}_{ridge}$ is a biased estimator of $\beta$.

## 贝叶斯公式
