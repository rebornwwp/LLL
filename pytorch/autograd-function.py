import torch
from torch.autograd import Variable


class MyReLU(torch.autograd.Function):
    @staticmethod
    def forward(ctx, input):
        ctx.save_for_backward(input)
        return input.clamp(min=0)

    @staticmethod
    def backward(ctx, grad_input):
        (input,) = ctx.saved_tensors
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
    y_pred = MyReLU.apply(x.mm(w1)).mm(w2)
    loss = (y_pred - y).pow(2).sum()
    loss.backward()
    w1.data -= learning_rate * w1.grad.data
    w2.data -= learning_rate * w2.grad.data
    w1.grad.data.zero_()
    w2.grad.data.zero_()

y_pred = x.mm(w1).clamp(min=0).mm(w2)
loss = (y_pred - y).pow(2).sum()
print("the last loss is:{}".format(loss.data))
