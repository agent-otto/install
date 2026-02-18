# Otto

Otto is an AI-powered task management and automation agent. Give Otto tasks, and it gets them done — researching, writing, analyzing, and more.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/agent-otto/install/main/install.sh | bash
```

Then:

```bash
cd ~/otto
./otto start
```

The setup wizard runs on first launch and walks you through configuration.

## Requirements

- **Docker** (with Docker Compose v2)
- **An LLM API key** — one of:
  - Google Gemini (recommended) — get a key at [aistudio.google.com](https://aistudio.google.com/)
  - OpenAI
  - Ollama (local, no key needed)

## Commands

```
otto start            Start Otto
otto stop             Stop all services
otto restart          Restart all services
otto update           Pull latest version and restart
otto status           Show service status and health
otto logs [service]   Tail logs
otto configure        Change API keys or add integrations
otto backup           Create a backup
otto restore <dir>    Restore from a backup
otto help             Show all commands
```

## Updating

```bash
otto update
```

This pulls the latest Docker images and restarts services. Your data and configuration are preserved.

## Configuration

All settings live in the `.env` file inside your Otto directory. You can edit it directly or use `otto configure` for an interactive setup.

## Support

For questions or issues, contact info@backrank.eu.
