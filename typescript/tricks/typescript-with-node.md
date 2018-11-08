# 如何将typescript和node结合

1. 创建一个项目然后将项目里面加入package.json。 快速：`npm init -y`
2. 添加`TypeScript`(npm install typescript --save-dev)
3. 添加`node.d.ts`（npm install @types/node --save-dev)
4. 初始化`tsconfig.json`, 其中加入对于typescript的一些选项检测的选择 `(npx tsc --init --rootDir src --outDir lib --esModuleInterop --resolveJsonModule --lib es6,dom --module commonjs)`

最后我们就能开始写代码，在目录结构中，src是存放写的ts代码，lib存放的是生成的js代码

# bonus: Live compile + run

1. 添加ts-node，用来做live-compile 和再node下运行，(npm instll ts-node --save-dev)
2. 添加nodemon，用来如果文件修改了，将会调用ts-node重新进行，(npm install nodemon --save-dev)
3. 之后加入代码到package.json中， index.ts是入口代码
``` json
  "scripts": {
    "start": "npm run build:live",
    "build": "tsc -p .",
    "build:live": "nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/index.ts"
  },
```
通过`npm start`就能将代码运行，但这是本地的运行，
如果将代码部署为javascript的程序的时候，运行，`npm run build`
