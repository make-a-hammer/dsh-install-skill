# 🛠️ DeepSeek Harness (DSH) 安装技能包

> **让 AI 帮你装 DeepSeek Harness** —— 一个给 AI 读的安装指南（SKILL.md）+ 一键脚本（install_dsh.bat）
> 持续跟踪 DeepSeek 官方更新，**欢迎社区贡献** 💙

## 📖 这是什么

DeepSeek Harness（`dsh`）是 DeepSeek 官方开源的 AI Agent 框架，核心理念 **Everything is a Plugin**（万物皆插件）。

本仓库把 DSH 的安装流程打包成 **AI 可读的技能包**：

| 文件 | 作用 |
|:---|:---|
| `SKILL.md` | 给 AI（豆包 / Kimi / DeepSeek / Claude…）读的安装指南：快速路径 + 分步路径 + 踩坑表 |
| `scripts/install_dsh.bat` | 一键脚本：自动检测 Node → 装 pnpm → 下载 DSH → 装依赖 → 构建 → 启动 |

**核心玩法**：把 `SKILL.md` 喂给豆包等 AI，它读一遍就会了，指挥你完成安装。安装中报错直接查踩坑表。

## 🚀 快速开始

### 方式一：一键脚本（推荐）

```bash
# 1. 下载脚本
curl -L -o install_dsh.bat https://raw.githubusercontent.com/1413488953-netizen/dsh-install-skill/main/scripts/install_dsh.bat

# 2. 双击运行（Windows 10/11）
install_dsh.bat
```

脚本自动完成：检测 Node → 装 pnpm → 下载源码 → 装依赖 → 构建 → 启动 Web UI。

### 方式二：给 AI 喂 SKILL.md（豆包玩法）

1. 打开豆包（或其他 AI 助手）
2. 把 `SKILL.md` 内容粘贴给它
3. 说：*"我 Windows 11，想装 DeepSeek Harness，按这个技能包来"*
4. AI 会指引你：先跑脚本，报错查踩坑表

### 方式三：手动安装

```bash
# 1. 装 Node.js（https://nodejs.org LTS）
node --version

# 2. 装 pnpm
npm install -g pnpm

# 3. 下载 DSH 源码
mkdir D:\DeepSeek-Harness && cd D:\DeepSeek-Harness
curl -sL -o dsh.zip "https://api.github.com/repos/deepseek-ai/deepseek-harness/zipball/master"
tar -xf dsh.zip
# 重命名解压目录为 deepseek-harness

# 4. 装依赖 + 构建 + 启动
cd deepseek-harness
pnpm install
pnpm run build
pnpm dsh web    # 浏览器打开 http://127.0.0.1:3080
```

## ✅ 验证安装成功

```bash
cd D:\DeepSeek-Harness\deepseek-harness
pnpm dsh --version                        # 显示 0.1.0-rc.x
pnpm dsh --profile web --dump-config      # 打印插件配置树
```

## ⚠️ 踩坑表（持续更新）

| 坑 | 症状 | 解法 |
|:---|:---|:---|
| 分支名是 `master` 不是 `main` | 下载 404（14 字节 HTML） | 用 `zipball/master` |
| ghproxy 镜像对 DSH 失效 | 14 字节 "404: Not Found" | 用 GitHub API zipball 直连 |
| `PYTHONPATH` 污染 | conda 报 `pydantic_core` 错误 | `set PYTHONPATH=` 清空再跑 |
| 代理断连 | curl 走 127.0.0.1:10808 失败 | 国内直连，别走代理 |
| chunk 大小警告 | 构建时 `>500kB` 提示 | 无害，忽略 |
| examples bin 警告 | `Failed to create bin` | 无害，忽略 |

## 🔄 持续更新承诺

- DeepSeek Harness 处于 **Developer preview** 阶段，官方会持续迭代
- 本仓库会**持续跟踪官方更新**：版本变更、安装方式变化、新踩坑记录
- 发现新坑或新版本，欢迎提交 issue / PR

## 🤝 社区贡献

欢迎所有人为这个社区做贡献！你可以：

- **报 bug**：安装遇到新问题 → [提交 Issue](https://github.com/1413488953-netizen/dsh-install-skill/issues)，附上错误截图和系统信息
- **加坑**：踩了新坑并解决 → 提 PR 把踩坑记录加进 `SKILL.md`
- **测新版本**：DSH 发新版后，帮忙验证安装流程 → 提 PR 更新脚本
- **加玩法**：豆包/Kimi 等其他 AI 喂 skill 的新姿势 → 提 PR

### 贡献步骤

1. Fork 本仓库
2. 改 `SKILL.md` 或 `scripts/` 
3. 提 Pull Request（描述清楚：改了什么、为什么、验证过什么）

> 保持简单：一行坑记录、一个脚本修复，都欢迎。社区靠每个人的小贡献长大。

## 📜 License

MIT — 随便用，随便改，注明来源即可。

## 💬 联系

- 用 GitHub Issues 交流（公开，所有人都能看）
- 想聊玩法 / 提建议，开个 Issue 就行

---

**让 AI 自己装 AI —— 这是验证过的事。**
