# CACTUS

```
  ██████╗ █████╗  ██████╗████████╗██╗   ██╗███████╗
 ██╔════╝██╔══██╗██╔════╝╚══██╔══╝██║   ██║██╔════╝
 ██║     ███████║██║        ██║   ██║   ██║███████╗
 ██║     ██╔══██║██║        ██║   ██║   ██║╚════██║
 ╚██████╗██║  ██║╚██████╗   ██║   ╚██████╔╝███████║
  ╚═════╝╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚══════╝
```

**Paint art on your GitHub contribution graph.**

Creates backdated git commits to draw patterns on your GitHub profile's contribution graph (the green squares).

## Requirements

- Git
- Bash 4.0+

## Quick Start

```bash
./cactusbnmk
```

## Commands

| Command | Description |
|---------|-------------|
| `themes` | List all available themes |
| `preview <theme>` | Preview how it will look on GitHub |
| `paint <theme> <mode> [year]` | Create the commits |
| `exit` | Exit |

## Modes

| Mode | Description |
|------|-------------|
| `current` | Paint on the last 365 days (visible on your profile now) |
| `previous` | Paint on a past year (e.g., 2022, 2023) |

## Usage Examples

### Interactive Mode

```bash
$ ./cactusbnmk

cactus> themes
cactus> preview sunset
cactus> paint sunset current
```

### Paint the Current Year (Last 365 Days)

```bash
cactus> paint sunset current
```

This paints the pattern over the last 365 days, which is what's visible on your GitHub profile right now.

### Paint a Previous Year

```bash
cactus> paint galaxy previous 2022
```

This paints the pattern in the year 2022. Useful for filling in older years on your profile.

## After Painting

```bash
cd output/github-banner
git remote add origin https://github.com/YOUR_USERNAME/github-banner.git
git branch -M main
git push -u origin main
```

The pattern appears on your contribution graph within minutes.

## Themes (12)

| Theme | Pattern |
|-------|---------|
| `sunset` | Rising sun at bottom |
| `saturn` | Planet with ring |
| `heart` | Heart shape |
| `pacman` | Pacman eating dots |
| `wave` | Smooth sine wave |
| `lightning` | Zigzag bolt |
| `galaxy` | Spiral with stars |
| `matrix` | Falling code |
| `cactus` | Cactus shape |
| `diamond` | Diamond gem |
| `chess` | Checkerboard |
| `invaders` | Space invader |

## Keeping the Banner Updated (Cronjob)

When using `current` mode, the contribution graph shifts daily. As each day passes, the oldest day disappears and a new day appears. To keep your banner always visible, set up a daily cronjob.

### Step 1: Initial Setup

First, create and push the initial banner:

```bash
./cactusbnmk
cactus> paint sunset current
cactus> exit

cd output/github-banner
git remote add origin https://github.com/YOUR_USERNAME/github-banner.git
git branch -M main
git push -u origin main
```

### Step 2: Set Up Daily Cronjob

#### Linux/macOS

Edit your crontab:

```bash
crontab -e
```

Add this line (runs daily at 12:00 PM):

```bash
0 12 * * * /path/to/cactusbnmk --daily /path/to/output/github-banner sunset >> /var/log/cactus.log 2>&1
```

Replace:
- `/path/to/cactusbnmk` with the full path to the script
- `/path/to/output/github-banner` with the full path to your repo
- `sunset` with your chosen theme

#### Windows (Task Scheduler)

1. Open Task Scheduler
2. Create Basic Task → Name: "CACTUS Daily"
3. Trigger: Daily at 12:00 PM
4. Action: Start a program
5. Program: `C:\path\to\git-bash.exe`
6. Arguments: `-c "/path/to/cactusbnmk --daily /path/to/output/github-banner sunset"`

#### GitHub Actions (Recommended)

Create `.github/workflows/cactus.yml` in your github-banner repo:

```yaml
name: Daily Banner Update

on:
  schedule:
    - cron: '0 12 * * *'  # Runs daily at 12:00 UTC
  workflow_dispatch:  # Allows manual trigger

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Clone CACTUS
        run: git clone https://github.com/YOUR_USERNAME/CactusBNMK.git cactus

      - name: Run daily update
        run: |
          cd cactus
          ./cactusbnmk --daily ${{ github.workspace }} sunset

      - name: Push changes
        run: |
          git config user.name "CACTUS Bot"
          git config user.email "bot@example.com"
          git push
```

### How the Daily Mode Works

The `--daily` flag:
1. Checks what day of the week it is
2. Looks up the pattern for today's position in the 52x7 grid
3. Creates commits only if the pattern requires activity for today
4. Automatically pushes to GitHub (if remote is configured)

This ensures your banner "moves" with time, always staying in the visible 52-week window.

## How It Works

1. **Choose Mode** - `current` for last 365 days, `previous` for a past year
2. **Preview** - See how the pattern will look (52x7 grid = 52 weeks × 7 days)
3. **Paint** - Creates a git repository with backdated commits
4. **Push** - Push to GitHub and the pattern appears on your profile
5. **Maintain** - (Optional) Set up cronjob to keep `current` mode banners visible

## Note

The contribution graph shows the last 52 weeks. Patterns painted with `current` mode will slowly disappear over the year unless you set up the daily cronjob. Patterns painted with `previous` mode are permanent (they're in the past).

## License

MIT
