# Python opens the Store instead of your installed version: check PATH first

AI Tools That Work, build session 32. Windows Command Prompt only.

The lesson is a replay of one prepared historical environment, not a live terminal or a diagnosis of every Windows Python installation. The original 13 command outputs were recorded twice with identical results. Both recordings are included.

## Limits and safety

The recorder removed hosted-tool-cache Python entries from its own session PATH to expose an App Installer alias. Do not strip your own PATH to reproduce the failure. If Python already works, inspect the replay instead.

The runner folder is an example, not a path to paste unchanged. For real practice, use a new Command Prompt window and only verified, trusted folders from your own selected interpreter. PATH changes affect command selection in that window and child programs. Close it afterwards. No permanent edit, installation or package download is part of the lesson.

Current Python install-manager setups can use working WindowsApps aliases. A missing py command does not prove Python is absent. A missing standalone pip command does not prove the pip module is absent; python -m pip can use the module for the selected interpreter when installed. Identify the installation method before changing it.

## Windows checks

`verify32.ps1` checks this prepared GitHub-hosted Windows case, not all Python installations. It verifies 12 conditions including alias selection, append/prepend order, selected interpreter, pip command location, child-process scope and restoration of the original process PATH in a finally block. The test performs no installs and no permanent environment edits. Two successful verification transcripts are included.

Ubuntu is not applicable to this Windows alias and cmd.exe example.

References:
- https://learn.microsoft.com/en-us/windows/python/faqs
- https://docs.python.org/3/using/windows.html

MIT license for teaching code. No warranty. No personal data, credentials or analytics included.
