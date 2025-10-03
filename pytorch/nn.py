from torch.autograd import Variable
import torch

N, D_in, H, D_out = 64, 1000, 100, 10

x = Variable(torch.randn(N, D_in))
y = Variable(torch.randn(N, D_out))

model = torch.nn.Sequential(
    torch.nn.Linear(D_in, H),
    torch.nn.ReLU(),
    torch.nn.Linear(H, D_out),
)

loss_f = torch.nn.MSELoss()

learning_rate = 1e-4
for t in range(500):
    pred_y = model(x)
    loss = loss_f(pred_y, y)
    print("the loss {} is {}".format(t, loss.data.item()))

    model.zero_grad()
    loss.backward()
    for param in model.parameters():
        if param.grad:
            param.data -= learning_rate * param.grad.data
