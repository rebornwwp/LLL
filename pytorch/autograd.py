import torch
from torch.autograd import Variable

dtype = torch.FloatTensor

N, D_in, H, D_out = 64, 1000, 100, 10

x = Variable(torch.randn(N, D_in).type(dtype), requires_grad=True)
y = Variable(torch.randn(N, D_out).type(dtype), requires_grad=True)


w1 = Variable(torch.randn(D_in, H).type(dtype), requires_grad=True)
w2 = Variable(torch.randn(H, D_out).type(dtype), requires_grad=True)

learning_rate = 1e-6
for t in range(500):
    y_pred = x.mm(w1).clamp(min=0).mm(w2)
    loss = (y_pred - y).pow(2).sum()
    print(t, loss.data)
    loss.backward()
    w1.data -= learning_rate * w1.grad.data
    w2.data -= learning_rate * w2.grad.data
    w1.grad.data.zero_()
    w2.grad.data.zero_()

y_pred = x.mm(w1).clamp(min=0).mm(w2)
loss = (y_pred - y).pow(2).sum()
print("the last loss is:{}".format(loss.data))
