# orcode

Use [Claude Code](https://docs.anthropic.com/en/docs/claude-code) with any model through [OpenRouter](https://openrouter.ai/).

orcode is a thin wrapper around the `claude` CLI that routes requests through OpenRouter's API, giving you access to hundreds of models — Anthropic, OpenAI, Google, DeepSeek, Meta, Mistral, and more — all through the same familiar Claude Code interface.

## Pick Any Model, Instantly

```bash
orcode --or-select-model
```

<p align="center">
  <img src="assets/select-model.gif" alt="orcode interactive model selector" width="720">
</p>

Browse every model on OpenRouter with fuzzy search. See pricing at a glance. Hit Enter and you're coding.

## Quick Start

```bash
# 1. Install
curl -fsSL https://raw.githubusercontent.com/mokarimi19/orcode/main/install.sh | bash

# 2. Set your API key (get one at https://openrouter.ai/keys)
export OPENROUTER_API_KEY="sk-or-..."

# 3. Pick a model and start coding
orcode --or-select-model
```

## Installation

### One-line install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/mokarimi19/orcode/main/install.sh | bash
```

This downloads `orcode` to `~/.local/bin/` and checks that dependencies are installed. Set a custom install directory with:

```bash
ORCODE_INSTALL_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/mokarimi19/orcode/main/install.sh | bash
```

### npm

```bash
npm install -g orcode
```

### Manual

```bash
git clone https://github.com/mokarimi19/orcode.git
cd orcode
chmod +x bin/orcode
ln -s "$(pwd)/bin/orcode" /usr/local/bin/orcode
```

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) (`claude` command)
- [OpenRouter API key](https://openrouter.ai/keys) — free to create, pay per usage
- `curl` and `jq` (for model fetching)
- `fzf` (**recommended** — powers the interactive model selector)

Install fzf: `brew install fzf` (macOS) or `apt install fzf` (Linux)

## Setup

Get your API key from [openrouter.ai/keys](https://openrouter.ai/keys) and export it:

```bash
export OPENROUTER_API_KEY="sk-or-..."
```

Add it to your shell profile (`~/.zshrc`, `~/.bashrc`, etc.) to persist across sessions:

```bash
echo 'export OPENROUTER_API_KEY="sk-or-..."' >> ~/.zshrc
```

## Usage

orcode works exactly like `claude` — all arguments are forwarded directly. The only difference is that requests go through OpenRouter.

```bash
# Interactive session (default model)
orcode

# One-shot query
orcode -p "explain this function"

# Continue last session
orcode --continue

# Resume a specific session
orcode --resume SESSION_ID
```

## Model Selection

### Interactive Picker (recommended)

The fastest way to choose a model. Fuzzy-search across every model on OpenRouter, see pricing inline, and launch with one keystroke:

```bash
orcode --or-select-model
```

```
╭─────────────────── OpenRouter Models ────────────────────╮
│ model>                                                   │
│   anthropic/claude-sonnet-4-5   Claude Sonnet 4.5   in: $3/Mtok   out: $15/Mtok  │
│   openai/gpt-4o                GPT-4o              in: $2.5/Mtok  out: $10/Mtok  │
│   deepseek/deepseek-r1         DeepSeek R1          in: $0.55/Mtok out: $2.19/Mtok│
│   google/gemini-2.5-pro        Gemini 2.5 Pro       in: $1.25/Mtok out: $10/Mtok  │
│   meta-llama/llama-3.1-405b    Llama 3.1 405B       in: $3/Mtok   out: $3/Mtok   │
│   ...hundreds more                                       │
│                                                          │
│   Type to search · Enter to select · Esc to cancel       │
╰──────────────────────────────────────────────────────────╯
```

### Direct model flag

```bash
# Use a specific model for one session
orcode --or-model deepseek/deepseek-r1 -p "hello"

# Use GPT-4o
orcode --or-model openai/gpt-4o -p "write a haiku about coding"

# Use a free model
orcode --or-model meta-llama/llama-3.1-8b-instruct:free
```

### Default model via environment

```bash
export ORCODE_MODEL="anthropic/claude-sonnet-4-5-20250929"
orcode
```

### List all models

```bash
orcode --or-models
```

## All Options

| Flag | Description |
|------|-------------|
| `--or-select-model` | **Interactive model picker** — fuzzy search all models (needs `fzf`) |
| `--or-model MODEL` | Set model for this invocation |
| `--or-models` | List all available models with pricing |
| `--or-key KEY` | Set API key for this invocation |
| `--or-status` | Show current configuration |
| `--or-help` | Show orcode help |
| `--or-version` | Show version |

All other flags are passed directly to `claude`. See `claude --help` for the full list.

## How It Works

orcode sets three environment variables before launching `claude`:

```
ANTHROPIC_BASE_URL=https://openrouter.ai/api
ANTHROPIC_AUTH_TOKEN=<your OpenRouter key>
ANTHROPIC_API_KEY=<cleared>
```

This tells Claude Code to send requests to OpenRouter instead of the Anthropic API directly. OpenRouter then routes the request to whatever model you've selected.

That's it — no patching, no proxies, no config files. Just a bash script that sets env vars and calls `claude`.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `OPENROUTER_API_KEY` | Yes | Your OpenRouter API key |
| `ORCODE_MODEL` | No | Default model (overridden by `--or-model`) |

## Model Caching

Model lists are cached at `~/.cache/orcode/models.json` for 1 hour to avoid repeated API calls. The cache is refreshed automatically when it expires.

## Troubleshooting

**"OPENROUTER_API_KEY is not set"**
Export your key: `export OPENROUTER_API_KEY="sk-or-..."`

**"claude: command not found"**
Install Claude Code first: https://docs.anthropic.com/en/docs/claude-code

**"fzf is required for --or-select-model"**
Install fzf: `brew install fzf` (macOS) or `apt install fzf` (Linux)

**Model not working**
Some models may not support all Claude Code features. Try a different model or check [OpenRouter's model list](https://openrouter.ai/models) for capabilities.

## License

MIT
