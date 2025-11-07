# 🧩 bat-elevate-and-run

> Simple and reliable batch wrapper to automatically elevate privileges and launch the same-named `.exe` file.

---

## 📜 Description

**`elevate-and-run.bat`** checks if the script is running with administrator privileges and, if not, restarts itself using UAC elevation (`RunAs`).
After confirmation, it launches a `.exe` file located in the same directory with the same name as the `.bat` file.

Perfect for **portable tools** that require admin rights but don’t have a built-in UAC request.

---

## ⚙️ How It Works

1. Detects the current `.bat` filename.
2. Builds the path to the same-named `.exe`.
3. Checks the current privilege level.
4. If not elevated, relaunches itself with `RunAs` (UAC prompt).
5. Once elevated, runs the `.exe`.
6. If the `.exe` is missing, prints an error message.

---

## 🧾 Example

```bat
@echo off
rem File: MyTool.bat
rem Purpose: Elevate (UAC) and start same-name .exe

setlocal enabledelayedexpansion
set "SCRIPT_NAME=%~n0"
set "EXE=%~dp0%SCRIPT_NAME%.exe"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Start-Process -FilePath '%~f0' -Verb RunAs; exit 1 } else { exit 0 }"

if ERRORLEVEL 1 exit /b

if not exist "%EXE%" (
  echo [%DATE% %TIME%] ERROR: "%EXE%" not found.
  pause
  exit /b
)

start "" "%EXE%"
```

---

## 🚀 Usage

1. Place the `.bat` file next to your `.exe`.
2. Make sure both share the same base name:

   ```
   MyTool.bat
   MyTool.exe
   ```
3. Run the `.bat`. A UAC prompt will appear if needed.
4. After confirmation, the `.exe` launches with admin rights.

---

## 🔒 Requirements

* Windows 10 / 11
* PowerShell 5.1 or newer (PowerShell 7+ supported)
* User permission to run UAC elevation

---

## 🧰 Use Cases

* Portable tools that require admin privileges
* Installers without UAC prompts
* Automated scripts that must run as admin
* System utilities distributed as `.bat + .exe`

---

## 📄 License

Distributed under the **MIT License**.
You are free to use, modify, and distribute the code with attribution.

---

## ✍️ Author

**takraztak**
[GitHub: takraztak](https://github.com/takraztak)
