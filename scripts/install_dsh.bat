@echo off
chcp 65001 >nul
title DeepSeek Harness 一键安装
echo ============================================
echo   DeepSeek Harness (DSH) 一键安装脚本
echo   by 小白本 | 全程自动，无需手动操作
echo ============================================
echo.

set "DSH_DIR=D:\DeepSeek-Harness"

REM ========== 第1步：检测 Node.js ==========
echo [1/5] 检测 Node.js 环境...
where node >nul 2>&1
if %errorlevel%==0 (
    for /f "delims=" %%i in ('node --version') do set "NODE_VER=%%i"
    echo        ✅ 已安装 Node.js %NODE_VER%
) else (
    echo        ❌ 未检测到 Node.js，请先安装：
    echo           https://nodejs.org  （下载 LTS 版，一路下一步）
    echo.
    echo        安装完成后重新运行本脚本。
    pause
    exit /b 1
)

REM ========== 第2步：检测/安装 pnpm ==========
echo [2/5] 检测 pnpm...
where pnpm >nul 2>&1
if %errorlevel%==0 (
    for /f "delims=" %%i in ('pnpm --version') do set "PNPM_VER=%%i"
    echo        ✅ 已安装 pnpm %PNPM_VER%
) else (
    echo        未安装，正在安装 pnpm（约1分钟）...
    call npm install -g pnpm
    if %errorlevel%==0 (
        echo        ✅ pnpm 安装成功
    ) else (
        echo        ❌ pnpm 安装失败，请检查网络后重试
        pause
        exit /b 1
    )
)

REM ========== 第3步：下载 DSH 源码 ==========
echo [3/5] 检查 DeepSeek Harness 源码...
if exist "%DSH_DIR%\deepseek-harness\package.json" (
    echo        ✅ 源码已存在，跳过下载
    goto :BUILD
)

echo        未找到源码，开始下载（约20MB）...
if not exist "%DSH_DIR%" mkdir "%DSH_DIR%"
cd /d "%DSH_DIR%"

REM 尝试多个下载通道（GitHub API 直连 / 镜像）
setlocal EnableDelayedExpansion
echo        通道1：GitHub API ...
curl -sL -o dsh.zip "https://api.github.com/repos/deepseek-ai/deepseek-harness/zipball/master" --connect-timeout 30 --max-time 300
for %%A in (dsh.zip) do set "ZIP_SIZE=%%~zA"
if !ZIP_SIZE! LSS 1000000 (
    echo        通道1失败（文件过小），尝试通道2...
    del dsh.zip 2>nul
    curl -sL -o dsh.zip "https://ghproxy.net/https://github.com/deepseek-ai/deepseek-harness/archive/refs/heads/master.zip" --connect-timeout 30 --max-time 300
    for %%A in (dsh.zip) do set "ZIP_SIZE=%%~zA"
)
if !ZIP_SIZE! LSS 1000000 (
    echo        ❌ 下载失败（两个通道都失败），请检查网络后重试
    del dsh.zip 2>nul
    pause
    exit /b 1
)
endlocal

echo        解压中...
tar -xf dsh.zip
del dsh.zip 2>nul
for /d %%i in (deepseek-ai-deepseek-harness-*) do (
    if not exist "%DSH_DIR%\deepseek-harness" (
        move "%%i" "%DSH_DIR%\deepseek-harness"
    )
)
echo        ✅ 源码就绪

:BUILD
REM ========== 第4步：安装依赖 ==========
echo [4/5] 安装依赖（首次约5-15分钟，请耐心等待）...
cd /d "%DSH_DIR%\deepseek-harness"
call pnpm install
if %errorlevel%==0 (
    echo        ✅ 依赖安装完成
) else (
    echo        ❌ 依赖安装失败（网络问题可重试）
    pause
    exit /b 1
)

REM ========== 第5步：构建 ==========
echo [5/5] 构建项目（约3-10分钟）...
call pnpm run build
if %errorlevel%==0 (
    echo.
    echo ============================================
    echo   🎉 安装完成！正在启动 DeepSeek Harness...
    echo   启动后浏览器访问: http://127.0.0.1:3080
    echo ============================================
    echo.
    call pnpm dsh web
) else (
    echo        ❌ 构建失败，请截图错误信息寻求帮助
    pause
    exit /b 1
)
