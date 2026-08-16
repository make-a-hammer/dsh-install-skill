---
name: dsh-install
description: Use when 用户需要安装 DeepSeek Harness (DSH) 或遇到安装问题。一键脚本 + 分步指导，Windows 10/11 适用。
---

# DeepSeek Harness (DSH) 一键安装技能

让 AI 代理（豆包/Kimi/DeepSeek 等）指导用户完成 DSH 安装。**核心：脚本兜底 + 分步讲解**。

## 快速路径（推荐）

1. 确认用户系统是 **Windows 10/11 64位**
2. 让用户下载/复制 `install_dsh.bat` 到任意目录（建议 `D:\DeepSeek-Harness\`）
3. **双击运行** `install_dsh.bat`——脚本自动完成：检测 Node → 装 pnpm → 下载 DSH → 装依赖 → 构建 → 启动
4. 等待窗口显示"🎉 安装完成！"，浏览器打开 `http://127.0.0.1:3080`

## 分步路径（脚本不可用时手把手）

### 第1步：检查 Node.js
```bash
node --version
```
- 有输出（如 v22.x）→ 继续
- 无 → 让用户去 https://nodejs.org 装 LTS 版，装完重开终端

### 第2步：安装 pnpm
```bash
npm install -g pnpm
pnpm --version   # 应显示 9.x+ / 11.x
```

### 第3步：下载 DSH 源码
```bash
mkdir D:\DeepSeek-Harness && cd D:\DeepSeek-Harness
curl -sL -o dsh.zip "https://api.github.com/repos/deepseek-ai/deepseek-harness/zipball/master"
tar -xf dsh.zip
# 解压出的目录形如 deepseek-ai-deepseek-harness-<hash>，重命名：
rename 解压出的目录名 deepseek-harness
```

### 第4步：装依赖 + 构建 + 启动
```bash
cd D:\DeepSeek-Harness\deepseek-harness
pnpm install        # 首次 5-15 分钟
pnpm run build      # 3-10 分钟
pnpm dsh web        # 启动，浏览器开 http://127.0.0.1:3080
```

## Pitfalls（踩坑记录，务必检查）

| 坑 | 症状 | 解法 |
|:--|:--|:--|
| **分支名是 master 不是 main** | 下载 404（14字节 HTML） | 用 `zipball/master`，不要用 main |
| **ghproxy 镜像对 DSH 失效** | 14字节 "404: Not Found" | 用 GitHub API zipball 直连 |
| **PYTHONPATH 污染** | conda 报 `pydantic_core` 错误 | `set PYTHONPATH=` 清空再跑 conda |
| **代理断连** | curl 走 127.0.0.1:10808 失败 | 国内直连，别走代理 |
| **chunk 大小警告** | 构建时 `>500kB` 提示 | 无害，忽略 |
| **examples bin 警告** | `Failed to create bin ...dsh-acp-demo` | 无害，忽略 |

## 验证（安装成功的标志）

```bash
cd D:\DeepSeek-Harness\deepseek-harness
pnpm dsh --version                # 显示 0.1.0-rc.x
pnpm dsh --profile web --dump-config   # 打印插件配置树（llm/session/typert 等）
```

## 支持文件
- `scripts/install_dsh.bat` — 一键安装脚本（自动检测+双通道下载+全流程）
