import numpy as np


def linear_kernel(**kwargs):
    """
    inner product
    """
    def f(x1, x2):
        return np.inner(x1, x2)
    return f


def polynomial_kernel(power, coef, **kwargs):
    """
    k(x,y) = (inner(x,y) + c)**d
    """
    def f(x1, x2):
        return (np.inner(x1, x2) + coef)**power
    return f


def rgf_kernel(gamma, **kwargs):
    """
    k(x,y) = exp(-1/(2*rou**2)*distance(x,y))
    """
    def f(x1, x2):
        distance = np.linalg.norm(x1 - x2) ** 2
        return np.exp(-gamma * distance)
    return f


if __name__ == "__main__":
    print("test linear kernel")
    x1 = np.arange(10)
    x2 = np.arange(10)
    fun1 = linear_kernel()
    print(fun1(x1=x1, x2=x2))
    fun2 = polynomial_kernel(power=0.5, coef=1)
    print(fun2(x1, x2))
    fun3 = rgf_kernel(-0.1)
    print(fun3(x1, x2))

