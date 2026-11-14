# Yuketang Auto Player

A Selenium-based auto player for **Yuketang (雨课堂 / Rain Classroom)** course videos:
it drives a real browser (Edge or Chrome), finds the episodes you haven't finished,
plays them, and moves on — no manual clicking.

> ⚠️ **For learning Selenium / personal convenience only.** It cannot do your homework,
> and using it may violate your school's rules and Yuketang's Terms of Service.
> See [Disclaimer](#disclaimer) before use.

[中文说明（README.md）](README.md) · [Full manual (Chinese)](使用说明.md)

---

## Quick start (4 steps)

**1. Install Python 3.9+** — during setup tick **`Add python.exe to PATH`**.

**2. Install the dependency**

```bash
pip install -r requirements.txt
```

**3. Fill in the config**

Copy `config.ini.example` to `config.ini` and set **one** line:

```ini
course_url = https://www.yuketang.cn/ai-workspace/lms-graph/xxxx/video/xxxxx?node_id=xxxx
```

Open the course in your browser, click **学习内容 / 学习空间**, then copy the whole URL
from the address bar. `cookie` can stay empty.

**4. Run**

Double-click `启动.bat`, or:

```bash
python main.py
```

In the browser window that opens, **scan the QR code once**. The `sessionid` is saved back
into `config.ini` automatically, then playback starts. You can minimize the window, but
**don't move your mouse into it** — the script is driving that browser.

> Just want to check your setup? `python main.py --list` prints the pending episodes and
> plays nothing.

---

## Prebuilt EXE

Grab `YuketangAutoPlayer.exe` from the [Releases](../../releases) page — no Python needed.
Put it in a folder, run it once (it creates `config.ini`), fill `course_url`, run it again.

> Windows SmartScreen / antivirus may warn about the EXE because it is built with
> PyInstaller (a very common false positive). Source code is in this repo; build it yourself
> with `pyinstaller --onefile --collect-all selenium main.py` if you prefer.

---

## Configuration (`config.ini`)

| Key | Default | Meaning |
|---|---|---|
| `headless` | `false` | `true` = run without a browser window. **QR login requires `false`** |
| `browser` | `auto` | `auto` / `chrome` / `edge`. `auto` prefers Edge (ships with Windows) |
| `course_url` | — | Course page URL, required, must start with `https://` |
| `cookie` | empty | `sessionid` value. Empty = scan the QR code on every run |
| `playback_rate` | `2` | Playback speed. `2` is the safest value the platform accepts; `4/8/16` also work but may not be credited |
| `restart_from_start` | `true` | `true` = replay unfinished episodes from 0:00; `false` = resume |
| `implicitly_wait` | `20` | Max seconds to wait for page elements |
| `max_minutes_per_video` | `180` | Give up on a single video after N minutes |

Restart the program after editing the config.

**Default behaviour**: half-watched episodes (pie icon) are played first, from the
beginning; finished ones (check icon / "已完成") are skipped; homework and text-only
materials are ignored.

---

## Commands

| Command | Purpose |
|---|---|
| `python main.py` | Start playing |
| `python main.py --list` | List pending episodes only |
| `python main.py --login` | Force a re-login and save the new sessionid |
| `python main.py --dump` | Save the course page structure to `debug/` (for bug reports) |
| `python main.py --self-test` | Only check that the browser can start |
| `python main.py --headless` | Headless mode (no QR login) |
| `python main.py --rate 1.5` | Override playback speed |

---

## How it works

- Detects three different Yuketang UIs: the 2025 "learning space" tree (`leaf-item`),
  the newer list (`study-unit`) and the legacy list (`leaf-detail`).
- Auto-selects the browser and lets Selenium Manager download the matching driver.
- Sets the speed by clicking the player's own speed menu; if that doesn't stick it pins
  `<video>.playbackRate` so the player cannot revert it.
- Self-healing: stalled stream → reload; broken source or frozen progress → restart the
  browser and retry; missing list → reopen the course page.
- After each episode it checks whether the platform's "completed" counter went up and
  warns you if it didn't.

---

## Credits / Inspiration

This project is **not** built from scratch:

- **[LetMeFly666/YuketangAutoPlayer](https://github.com/LetMeFly666/YuketangAutoPlayer)** —
  the original Selenium approach (drive a real browser, locate list items, force-play on
  pause, detect completion). This project is a substantial rewrite on top of that idea.
- **CSDN article "汕头大学雨课堂自动播放器 (YuketangAutoPlayer For STU)"** by 不想做小丑 —
  the tutorial that popularised the scenario.
- [Selenium](https://www.selenium.dev/).

Main differences from upstream: support for the 2025 "learning space" UI, automatic
browser/driver selection, speed pinning, replay-from-zero, self-healing, and the
completion-counter check.

---

## AI assistance

This project was developed **with the help of an AI coding assistant**: code, debugging and
documentation were produced with ZCode (model `deepseek-flash`). Design decisions,
real-environment testing and the final review were done by the author.

Disclosed for transparency.

---

## Disclaimer

1. This project is for **learning browser automation (Selenium)** and for managing courses
   you are personally enrolled in.
2. It **cannot and should not** be used to complete homework, quizzes or exams.
3. Auto-playing courses may **violate your school's course requirements and Yuketang's
   Terms of Service**. You are solely responsible for any consequences (grades,
   attendance, account penalties).
4. No commercial use, no "course farming" services, no bulk account operation.
5. The author is not liable for any damage caused by using this project.
6. `sessionid` is your credential — never share it. This tool uploads none of your data.

**If you disagree with any of the above, please do not use this project.**

---

## License

LGPL-2.1, same as the upstream project. See [LICENSE](LICENSE).
