import torch
from torch.autograd import Variable

class MyReLU(torch.autograd.Function):
    def forward(self, input):
        self.save_for_backward(input)
        return input.clamp(min=0)

    def backward(self, grad_input):
        input, = self.saved_tensors
        grad_input = grad_input.clone()
        grad_input[input < 0] = 0
        return grad_input


dtype = torch.FloatTensor

N, D_in, H, D_out = 64, 1000, 100, 10

x = Variable(torch.randn(N, D_in).type(dtype), requires_grad=True)
y = Variable(torch.randn(N, D_out).type(dtype), requires_grad=True)


w1 = Variable(torch.randn(D_in, H).type(dtype), requires_grad=True)
w2 = Variable(torch.randn(H, D_out).type(dtype), requires_grad=True)

learning_rate = 1e-6
for t in range(5000):
    ReLU = MyReLU()
    y_pred = ReLU(x.mm(w1)).mm(w2)
    loss = (y_pred - y).pow(2).sum()
    print(t, loss.data[0])
    loss.backward()
    w1.data -= learning_rate*w1.grad.data
    w2.data -= learning_rate*w2.grad.data
    w1.grad.data.zero_()
    w2.grad.data.zero_()

y_pred = x.mm(w1).clamp(min=0).mm(w2)
loss = (y_pred - y).pow(2).sum()
print("the last loss is:{}".format(loss.data[0]))
