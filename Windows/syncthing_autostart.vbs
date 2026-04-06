' winget_upgrade_hidden.vbs
Option Explicit
Dim shell, cmd, execCmd
Set shell = CreateObject("WScript.Shell")

' Full path to winget (use environment PATH), run via cmd /c to allow argument parsing
cmd = "cmd.exe /c ""syncthing --no-console --no-browser"" "

' Run hidden: 0 = hide window, True = don't wait for completion
shell.Run cmd, 0, False
