param(
    [Parameter(Mandatory = $true)]
    [string]$Prompt,
    [string]$Out = "output/imagegen/image.png",
    [string]$Model = "gpt-5.5",
    [ValidateSet("none", "minimal", "low", "medium", "high", "xhigh", "max")]
    [string]$ReasoningEffort = "xhigh",
    [switch]$Force,
    [int]$TimeoutSec = 240
)

$ErrorActionPreference = "Stop"

$base = [Environment]::GetEnvironmentVariable("CODEX_API_URL", "Process")
if ([string]::IsNullOrWhiteSpace($base)) {
    $base = [Environment]::GetEnvironmentVariable("CODEX_API_URL", "User")
}
$key = [Environment]::GetEnvironmentVariable("CODEX_API_KEY", "Process")
if ([string]::IsNullOrWhiteSpace($key)) {
    $key = [Environment]::GetEnvironmentVariable("CODEX_API_KEY", "User")
}

if ([string]::IsNullOrWhiteSpace($base)) {
    throw "CODEX_API_URL is not set"
}
if ([string]::IsNullOrWhiteSpace($key)) {
    throw "CODEX_API_KEY is not set"
}

$base = $base.TrimEnd("/")
$endpoint = if ($base.EndsWith("/v1")) { "$base/responses" } else { "$base/v1/responses" }

if ((Test-Path -LiteralPath $Out) -and -not $Force) {
    throw "Refusing to overwrite existing file: $Out"
}

$payload = @{
    model = $Model
    input = $Prompt
    reasoning = @{ effort = $ReasoningEffort }
    tools = @(@{ type = "image_generation" })
    tool_choice = @{ type = "image_generation" }
} | ConvertTo-Json -Depth 10
$bodyBytes = [Text.Encoding]::UTF8.GetBytes($payload)

$headers = @{
    Authorization = "Bearer $key"
    "Content-Type" = "application/json"
}

$response = Invoke-WebRequest `
    -UseBasicParsing `
    -Method Post `
    -Uri $endpoint `
    -Headers $headers `
    -Body $bodyBytes `
    -TimeoutSec $TimeoutSec

$json = $response.Content | ConvertFrom-Json
$call = @($json.output) | Where-Object { $_.type -eq "image_generation_call" } | Select-Object -First 1
if ($null -eq $call -or [string]::IsNullOrWhiteSpace($call.result)) {
    throw "Responses API returned no image_generation_call result"
}

$encoded = [string]$call.result
if ($encoded -match "^data:image/[^;]+;base64,") {
    $encoded = $encoded -replace "^data:image/[^;]+;base64,", ""
}

$bytes = [Convert]::FromBase64String($encoded)
$parent = Split-Path -Parent $Out
if (-not [string]::IsNullOrWhiteSpace($parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
}
[IO.File]::WriteAllBytes($Out, $bytes)

[pscustomobject]@{
    model = $Model
    reasoning_effort = $ReasoningEffort
    endpoint = $endpoint
    output = [IO.Path]::GetFullPath($Out)
} | ConvertTo-Json
