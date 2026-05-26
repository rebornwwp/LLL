# AGENTS.md — LLL 学习仓库

这是一个**个人多语言学习/笔记仓库**，不是软件项目。没有统一的构建系统、CI/CD、测试套件或发布流水线。

## AI 语言准则

- **AI 的所有思考、推理、输出、工具调用描述、注释等内容均必须使用中文。** 代码、命令行、技术术语除外。此规则不可违反。

## 基本规则

- **不要重新组织或重构目录结构。** 扁平布局和松散文件是故意的。
- **不要添加构建/测试/代码检查基础设施**，除非明确要求。大多数目录只是练习，不是正式项目。
- **不要碰 `conf/` 目录**——里面是用户的个人配置文件（`.vimrc`、`.zshrc`、`.tmux.conf`、`.spacemacs`）。
- **Git 历史是非正式的。** 像 "add"、"fix"、"aaa" 这样的提交信息在这里很正常。不要主动建议改进它们。
- **根目录下没有 `python/` 目录**，尽管 README 里提到了 Python。Python 代码分布在 `pytorch/`、`algorithm/`、`hadoop-python/`、`machine-learning/` 中。

## 各语言目录约定

| 目录 | 构建系统 | 备注 |
|---|---|---|
| `algorithm/` | 无 | LeetCode/竞赛题解。命名：`{题号}.{题目}.{语言}`（如 `198.house-robber.go`、`3sum.py`）。混合 Go、Python、C。 |
| `cpp/` | CMake | `mkdir build && cd build && cmake .. && make`。C++17。有 `googletestdemo/` 测试示例。 |
| `go/` | 各子目录单独的 Makefile | `learn-go-by-concept/Makefile` 存在。根目录没有 `go.mod`。 |
| `haskell/` | Stack + Cabal | `haskell-wiki/` 是唯一的完整项目（stack、cabal、hindent、stylish-haskell）。其余都是练习。 |
| `typescript/` | 无 | 扁平 `.ts` 文件——没有 `package.json`、`tsconfig.json`、node_modules。独立示例。 |
| `pytorch/` | 无 | 教程脚本。`attention-is-all-you-need/` 有自己的 Makefile。 |
| `zig/` | Zig build | `zig-monkey/` 和 `exercises/` 子项目。 |
| `cuda-learn/` | CMake | 结构化的 C++/CUDA 教程。 |
| `java/` | 无 | `javaBase/` 和 `spring/` 子目录。 |
| `rust/` | 无 | 极简——仅 `variables/` 子目录。 |
| `hadoop-python/` | 无 | MapReduce 练习文件（Mapper/Reducer 对）。 |
| `machine-learning/` | 无 | `lecture/`、`supervised_learning/`、`unsupervised_learning/`、`utils/`。 |
| `bash/` | 无 | 独立的 `.sh` 教程脚本。 |
| `clean-code/` | 无 | 仅 `1.md` 笔记。 |
| `git/` | 无 | git 工作流 `.md` 笔记。 |
| `notes/` | 无 | `python-tips/`，包含编号提示文件（`tips-1-5.md`、`tips-16-20.md`）。 |

## 构建命令（仅在存在时有效）

```bash
# C++（cpp/ 目录）
mkdir -p build && cd build && cmake .. && make

# Haskell wiki
cd haskell/haskell-wiki && stack build

# Go learn-by-concept
cd go/learn-go-by-concept && make
```

## 明确不存在的内容

- ❌ 没有 `.github/workflows/`——无 CI/CD
- ❌ 任何层级都没有 `package.json`（TypeScript 是独立文件）
- ❌ `rust/` 中没有 `Cargo.toml`
- ❌ 没有 `pyproject.toml`、`setup.py`、`requirements.txt`——Python 环境是临时搭建的
- ❌ 没有 pre-commit 钩子
- ❌ 没有 linter/formatter 配置文件（`haskell/haskell-wiki/` 例外，它有 hindent/stylish-haskell）
