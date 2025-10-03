import os
import torch
import pandas as pd
from skimage import io, transform
import matplotlib.pyplot as plt
import numpy as np
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms

import warnings

warnings.filterwarnings("ignore")


# data load
class FaceLandmarksDataset(Dataset):
    def __init__(self, csv_file, root_dir, transform=None):
        self.landmarks_frame = pd.read_csv(csv_file)
        self.root_dir = root_dir
        self.transform = transform

    def __len__(self):
        return len(self.landmarks_frame)

    def __getitem__(self, idx):
        img_name = os.path.join(self.root_dir, self.landmarks_frame.ix[idx, 0])
        image = io.imread(img_name)
        landmarks = self.landmarks_frame.ix[idx, 1:].as_matrix().astype("float")
        landmarks = landmarks.reshape(-1, 2)
        sample = {"image": image, "landmarks": landmarks}

        if self.transform:
            sample = self.transform(sample)

        return sample


face_dataset = FaceLandmarksDataset(
    csv_file="faces/face_landmarks.csv", root_dir="faces/"
)

# print(face_dataset[0]["image"].shape)
# print(face_dataset[0]["landmarks"].shape)


def imshow(image, landmarks):
    plt.imshow(image)
    plt.scatter(landmarks[:, 0], landmarks[:, 1], s=10, marker=".", c="r")
    plt.pause(0.001)


# plt.figure()
# imshow(**face_dataset[0])
# plt.show()


# data transform
class Rescale(object):
    def __init__(self, output_size):
        assert isinstance(output_size, (int, tuple))
        self.output_size = output_size

    def __call__(self, sample):
        image, landmarks = sample["image"], sample["landmarks"]
        h, w = image.shape[:2]
        if isinstance(self.output_size, int):
            if h > w:
                new_h, new_w = self.output_size * h / w, self.output_size
            else:
                new_h, new_w = self.output_size, self.output_size * w / h
        else:
            new_h, new_w = self.output_size
        new_h, new_w = int(new_h), int(new_w)
        transformed_image = transform.resize(image, (new_h, new_w))
        landmarks = landmarks * [new_w / w, new_h / h]
        return {"image": transformed_image, "landmarks": landmarks}


class RandomCrop(object):
    def __init__(self, output_size):
        assert isinstance(output_size, (int, tuple))
        if isinstance(output_size, int):
            self.output_size = (output_size, output_size)
        else:
            assert len(output_size) == 2
            self.output_size = output_size

    def __call__(self, sample):
        image, landmarks = sample["image"], sample["landmarks"]
        h, w = image.shape[:2]
        new_h, new_w = self.output_size

        top = np.random.randint(0, h - new_h)
        left = np.random.randint(0, w - new_w)

        image = image[top : top + new_h, left : left + new_w]
        landmarks = landmarks - [left, top]
        return {"image": image, "landmarks": landmarks}


class ToTensor(object):
    def __call__(self, sample):
        image, landmarks = sample["image"], sample["landmarks"]
        # swap color axis because
        # numpy image: H x W x C
        # torch image: C X H X W
        # base on index
        image = image.transpose((2, 0, 1))

        return {
            "image": torch.from_numpy(image),
            "landmarks": torch.from_numpy(landmarks),
        }


scale = Rescale(256)
crop = RandomCrop(128)
composed = transforms.Compose([Rescale(256), RandomCrop(224)])
fig = plt.figure()
sample = face_dataset[5]
for i, tsfrm in enumerate([scale, crop, composed]):
    transformed_sample = tsfrm(sample)
    ax = plt.subplot(1, 3, i + 1)
    plt.tight_layout()
    ax.set_title(type(tsfrm).__name__)
    imshow(**transformed_sample)

plt.show()
transformed_dataset = FaceLandmarksDataset(
    csv_file="faces/face_landmarks.csv",
    root_dir="faces/",
    transform=transforms.Compose([Rescale(256), RandomCrop(224), ToTensor()]),
)

for i in range(len(transformed_dataset)):
    sample = transformed_dataset[i]

    print(i, sample["image"].size(), sample["landmarks"].size())

    if i == 3:
        break


#  Batching the data
#  Shuffling the data
#  Load the data in parallel using ``multiprocessing`` workers.

loader = DataLoader(
    transformed_dataset,
    batch_size=4,
    shuffle=True,
    num_workers=4,
)
