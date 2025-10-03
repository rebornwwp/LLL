# Mix

## 创建项目

``` bash
mix new projectname
```

## 交互

``` bash
cd projectname
iex -S mix
```

## 编译

``` bash
mix compile
```

## 管理依赖

在mix.exs文件中deps部分加入依赖的包
``` elixir
def deps do
  [
    {:phoenix, "~> 1.1 or ~> 1.2"},
    {:phoenix_html, "~> 2.3"},
    {:cowboy, "~> 1.0", only: [:dev, :test]},
    {:slime, "~> 0.14"}
  ]
end
```

加入依赖
``` bash
mix deps.get
```

##  环境管理

* :dev 默认环境
* :test mix test使用环境
* :prod 把应用上线会用到的环境

``` bash
# 获取当前环境
MIX_ENV=prod mix compile
```
