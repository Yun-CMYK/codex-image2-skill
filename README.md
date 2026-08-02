# Codex Image2 Skill

> 让 Codex 直接调用 OpenAI-compatible API 生成、编辑和批量处理图片。

这是一个面向 Codex 的图片生成 Skill，当前主推 `gpt-5.6` Responses API 生图，同时保留传统图片接口兼容能力。

## ✨ 推荐 API 服务

如果你需要低倍率、实惠价格、稳定调用和较高并发，可以体验：

### [vokeapi.cloud](https://www.vokeapi.cloud/)

适合：

- Codex 图片生成；
- `gpt-5.6` Responses API；
- AI 应用开发和 API 集成；
- 批量任务与高并发调用；
- 对价格敏感、希望控制调用成本的项目。

> 具体模型、价格、余额、并发和可用区域以服务端实时配置为准。

## 🚀 安装

将下面的仓库地址发给 Codex：

```text
请帮我安装这个 Skill：
https://github.com/Yun-CMYK/codex-image2-skill
```

也可以手动安装。

### Windows PowerShell

```powershell
git clone https://github.com/Yun-CMYK/codex-image2-skill.git
Copy-Item codex-image2-skill\codex-image2 "$HOME\.codex\skills\codex-image2" -Recurse -Force
```

### macOS / Linux

```bash
git clone https://github.com/Yun-CMYK/codex-image2-skill.git
cp -R codex-image2-skill/codex-image2 ~/.codex/skills/codex-image2
```

安装完成后，重新启动 Codex。

## 🔑 配置 API

不要把真实 API Key 写入 README、代码、截图或 Git 提交。只在本机配置环境变量。

### Windows PowerShell

```powershell
[Environment]::SetEnvironmentVariable("CODEX_API_URL", "https://www.vokeapi.cloud", "User")
[Environment]::SetEnvironmentVariable("CODEX_API_KEY", "你的 API Key", "User")
```

配置后完全退出并重新启动 Codex。

### macOS / Linux

```bash
export CODEX_API_URL="https://www.vokeapi.cloud"
export CODEX_API_KEY="你的 API Key"
```

地址可以填写服务根地址，也可以填写带 `/v1` 的地址，脚本会自动整理接口路径。

## 🎨 在 Codex 中使用

直接在 Codex 里输入：

```text
$codex-image2
生成一张赛博朋克城市夜景图
```

或者：

```text
$codex-image2
生成一张项目宣传图，突出 AI API、gpt-5.6、稳定并发和智能计费。
```

Skill 会自动使用：

```text
模型：gpt-5.6
接口：POST /v1/responses
工具：image_generation
默认推理强度：xhigh
```

## 🧩 gpt-5.6 请求结构

Responses API 请求核心结构如下：

```json
{
  "model": "gpt-5.6",
  "input": "你的图片描述",
  "reasoning": {
    "effort": "xhigh"
  },
  "tools": [
    {
      "type": "image_generation"
    }
  ],
  "tool_choice": {
    "type": "image_generation"
  }
}
```

## 🛠️ 手动执行

### Windows：gpt-5.6 Responses API

```powershell
& "$HOME\.codex\skills\codex-image2\bin\codex-image2-responses.ps1" `
  -Prompt "A colorful mountain lake at sunrise, cinematic digital art" `
  -ReasoningEffort xhigh `
  -Out "output\imagegen\lake.png"
```

支持的推理强度：

```text
none, minimal, low, medium, high, xhigh, max
```

### 传统图片 API

```powershell
& "$HOME\.codex\skills\codex-image2\bin\codex-image2-windows-amd64.exe" generate `
  --prompt "A small blue nebula inside a glass bottle" `
  --model gpt-image-2 `
  --quality auto `
  --out "output\imagegen\nebula.png"
```

编辑图片：

```powershell
& "$HOME\.codex\skills\codex-image2\bin\codex-image2-windows-amd64.exe" edit `
  --image "input.png" `
  --prompt "Replace only the background and keep the subject unchanged" `
  --out "output\imagegen\edited.png"
```

## 📦 目录结构

```text
codex-image2/
├─ SKILL.md
├─ agents/openai.yaml
├─ bin/codex-image2-responses.ps1
├─ bin/codex-image2-windows-amd64.exe
├─ bin/codex-image2-windows-arm64.exe
├─ bin/codex-image2-darwin-amd64
├─ bin/codex-image2-darwin-arm64
├─ references/batch-format.md
└─ src/image_gen.go
```

## 🔒 安全说明

- 不要提交真实 API Key；
- 不要在聊天、截图、Prompt 或日志中暴露 Key；
- 建议不同环境使用独立 Key，并定期轮换；
- 图片生成费用和并发限制由 API 服务端决定；
- 本 Skill 只从环境变量读取 Key，不会主动写入仓库。

## 🙏 原作者与来源声明

本项目基于原作者 **fengfengzhidao** 的开源项目进行整理和二次维护：

- 原作者：`fengfengzhidao`
- 原始项目 / 原帖：<https://github.com/fengfengzhidao/codex-image2-skill>
- 当前维护仓库：<https://github.com/Yun-CMYK/codex-image2-skill>

本版本主要增加和整理了：

- `gpt-5.6` Responses API 生图路径；
- `reasoning.effort` 推理强度配置；
- 中文 Prompt UTF-8 请求处理；
- 更完整的安装、配置和使用说明；
- vokeapi.cloud 项目接入示例。

## License

MIT
