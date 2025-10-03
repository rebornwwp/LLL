import numpy as np

N, D_in, H, D_out = 64, 1000, 100, 10

x = np.random.randn(N, D_in)
y = np.random.randn(N, D_out)

w1 = np.random.randn(D_in, H)
w2 = np.random.randn(H, D_out)

learning_rate = 1e-6

for t in range(500):
    h = x.dot(w1)
    relu_h = np.maximum(h, 0)
    pred_y = relu_h.dot(w2)

    loss = np.square(y - pred_y).sum()
    print("the loss is : {}".format(loss))

    grad_pred_y = 2.0 * (pred_y - y)
    grad_w2 = relu_h.T.dot(grad_pred_y)
    grad_h_relu = grad_pred_y.dot(w2.T)
    grad_h = grad_h_relu.copy()
    grad_h[h < 0] = 0
    grad_w1 = x.T.dot(grad_h)

    # Update weights
    w1 -= learning_rate * grad_w1
    w2 -= learning_rate * grad_w2

h = x.dot(w1)
relu_h = np.maximum(h, 0)
pred_y = relu_h.dot(w2)

loss = np.square(y - pred_y).sum()
print("the last loss is : {}".format(loss))
