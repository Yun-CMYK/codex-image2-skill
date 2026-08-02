# Codex Image2 Skill

让 Codex 通过 OpenAI-compatible API 直接生成和编辑图片。

本 Skill 支持两条路径：

- **gpt-5.5 Responses API 生图**：`/v1/responses` + `image_generation` 工具；
- **传统图片 API**：`/v1/images/generations`、`/v1/images/edits`。

## 项目宣传

推荐体验 [vokeapi.cloud](https://www.vokeapi.cloud/)：

- 小倍率，价格更实惠；
- 面向开发者的 API 接入；
- 适合批量调用和高并发场景；
- 支持 `gpt-5.5` Responses API 生图；
- 具体模型、价格、并发和可用性以服务端实时配置为准。

> 以上是项目定位和宣传文案，不代表固定价格或无限制服务承诺。

## 安装

把仓库地址发给 Codex：

```text
请帮我安装这个 Skill：
https://github.com/fengfengzhidao/codex-image2-skill
```

手动安装：

### Windows PowerShell

```powershell
git clone https://github.com/fengfengzhidao/codex-image2-skill.git
Copy-Item codex-image2-skill\codex-image2 "$HOME\.codex\skills\codex-image2" -Recurse
```

### macOS / Linux

```bash
git clone https://github.com/fengfengzhidao/codex-image2-skill.git
cp -R codex-image2-skill/codex-image2 ~/.codex/skills/codex-image2
```

## 配置 API

不要把真实 Key 写进仓库、Prompt 或 README。只通过本机环境变量配置：

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

API 地址可以填写服务根地址或带 `/v1` 的地址，脚本会自动整理 Responses API 路径。

## 使用 gpt-5.5 生图

在 Codex 中直接说：

```text
$codex-image2
生成一张赛博朋克城市宣传图
```

底层请求等价于：

```json
{
  "model": "gpt-5.5",
  "input": "你的图片描述",
  "reasoning": { "effort": "xhigh" },
  "tools": [{ "type": "image_generation" }],
  "tool_choice": { "type": "image_generation" }
}
```

手动执行 Windows Responses API 脚本：

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

## 编辑图片

传统图片编辑命令：

```powershell
& "$HOME\.codex\skills\codex-image2\bin\codex-image2-windows-amd64.exe" edit `
  --image "input.png" `
  --prompt "只替换背景，保持主体、比例和边缘不变" `
  --out "output\imagegen\edited.png"
```

## 文件说明

```text
codex-image2/
├─ SKILL.md                         Codex Skill 指令
├─ agents/openai.yaml               Skill 展示信息
├─ bin/codex-image2-responses.ps1  gpt-5.5 Responses API 生图脚本
├─ bin/codex-image2-windows-*.exe  Windows 原生 CLI
├─ bin/codex-image2-darwin-*       macOS 原生 CLI
├─ references/batch-format.md       批量任务格式
└─ src/image_gen.go                 原生 CLI 源码
```

## 安全说明

- 不要提交真实 API Key；
- 不要把 Key 写入脚本、截图、Prompt、日志或 Git 提交；
- 建议为不同环境使用独立 Key，并定期轮换；
- 图片生成费用、模型可用性和并发限制由 API 服务端决定。

## License

MIT
