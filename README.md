# Arch Dotfiles: The "Library Mode" Setup

This is my personal collection of dotfiles for **Arch Linux**, featuring **AwesomeWM**, **Neovim**, and a bunch of scripts I wrote to keep my machine running efficiently. 

<kbd>
   <img src="assets/awesomewm1.png">
   <kbd>awesomewm</kbd>
</kbd>
<hr>
<kbd>
   <img src="assets/awesomewm.png">
   <kbd>awesomewm</kbd>
</kbd>

<hr>

### The Backstory
I use an **HP Pavilion Gaming Laptop**, which is ironic because I hate two things:
1.  **Fan Noise:** If my laptop sounds like a jet engine, I can't think.
2.  **Bloat:** I’m running on single-channel RAM, so I can't afford to waste memory on Electron apps or background services I don't need.

> My goal is simple: **Minimum RAM consumption, Zero Decibels.**

### 🛠️ What's Inside?
* **AwesomeWM:** Tiling window manager because dragging windows around is a waste of time.
* **Neovim:** configured to load instantly.
* **Scripts:** Custom power-management scripts to keep the battery drain remarkably low.

---

### 💻 The Hardware Situation
Here is what I’m working with (and how I’m forcing it to behave):

| Component | The Reality | My Solution |
| :--- | :--- | :--- |
| **CPU** | **Ryzen 5 5600H** | Great chip, but runs hot. I’ve throttled and undervolted it so it stays cool enough that the fans literally never turn on. |
| **GPU** | **NVIDIA RTX** | A power hog. I completely disabled it. It sits at **0W** power draw. It’s basically an expensive paperweight now. |
| **RAM** | **8GB (Single Channel)** | Since I don't have dual-channel, I treat RAM like a limited resource. No `zswap`, no heavy desktops. Just pure efficiency. |

---

### 🚫 The "No-Fly" List
*Things that are banned on this machine to save RAM:*
- [x] Electron Apps (The devil's RAM eaters)
- [x] Desktop Environments (Too much bloat)
- [x] "Helpful" HP Services (Deleted with extreme prejudice)
- [x] Happiness (Optional)

---

### 🧘‍♂️ Philosophy
I don't care about high benchmarks. I care about a laptop that stays cool to the touch, lasts all day on battery, and doesn't make a sound even at 2 AM in a dead silent room.

## License
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
