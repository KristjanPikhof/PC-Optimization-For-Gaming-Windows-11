# PC Optimization Script for Gaming

This PowerShell script provides a user-friendly GUI to automate various tasks aimed at optimizing your PC for gaming. It's designed to help you clean up your system quickly and efficiently, allowing you to maintain peak performance without the hassle of manual intervention.

The primary goal of this script is to help users clean their PCs faster and more efficiently by providing a set of commonly used optimization tasks in a simple graphical interface. It allows you to select the specific tasks you want to perform, making it customizable to your needs

## Features

- **Configure and Run Disk Cleanup**
- **Clear Temporary Files**
- **Clear Prefetch Files**
- **Clear Windows Update Cache**
- **Clear NVIDIA Caches**
- **Clear DNS Cache**
- **Empty Recycle Bin**
- **Set Cloudflare DNS (Fastest)**

## How to Run

1. **Requirements**: Ensure that you have PowerShell installed on your Windows PC.

2. **Download the Script**: Save the provided script in a `.ps1` file (e.g., `PC_Optimization_Script.ps1`).

3. **Execute the Script**: 
   - Find the saved `.ps1` file. It's easiest to just save on `C:/`
   - Open PowerShell as **Administratorl** in the same directory (e.g., `C:/`)
   - You can then run it in the console by entering:
   ```
     C:\PC-Optimization-For-Gaming.ps1
   ```

4. **If Needed: Set Execution Policy**: If you face issues running the script, you might need to set the execution policy to allow the running of scripts. 
   - Open PowerShell as an administrator and execute:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
5. **When you run a .ps1 PowerShell script you might get the message saying “.ps1 is not digitally signed. The script will not execute on the system.”**
   - To fix it you have to run the command below to run Set-ExecutionPolicy and change the Execution Policy setting.
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```

## Images
![image](https://github.com/user-attachments/assets/05431978-df4e-4332-bc5b-915f98c3a507)



## About
This is an open-source code created by Esmaabi. If you wish to support the development, please check out the project repository: GitHub Repository.
