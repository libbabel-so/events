For any further doubts/queries join [our Discord Server](https://discord.gg/Pu2mbwNP)
# Windows:
We will proceed to setup WSL(Windows Subsystem for Linux) in Windows, since most CTF oriented tools are available and very well compatible with Linux Systems. Hence, here we will install `Ubuntu` in WSL.
# MacOS:
Install [homebrew](https://brew.sh/)
# Linux (And Others):
You can skip the WSL Setup and jump directly to the setup of the packages. [[#Required Package Installation]]

# WSL Setup:
Note: Alternatively, you can follow [this guide](https://learn.microsoft.com/en-us/windows/wsl/install).
1. Go to the start menu
2. Search for `Turn Windows Features On or Off`
3. Check the box next to `Windows Subsystem for Linux` and Click `OK`
4. When it prompts you for a reboot, reboot your system by choosing `Restart Now`.
5. After the reboot open Windows Terminal as Administrator (Search for `Windows PowerShell`, right click and `Run as Administrator`)
6. Type:
```
wsl --install Ubuntu
```

  This, by default, installs Ubuntu on your system, and gives you a fully functional Linux Subsystem for your own system.  
7. If it prompt you to, Reboot your system (else skip to step 9).  
8. Launch terminal again and use
```
wsl
```
9. It will prompt you to enter a username and then a password. Remember this since you will need these to login later.
You can now access your Ubuntu Subsystem anytime using 
```
wsl
```
From `Windows PowerShell` or `Windows Terminal`(preferred).
10. Update your distro using 
```
sudo apt update && sudo apt upgrade
```
Type `y` to confirm when prompted.
## Some Basic Information:
1. The Linux filesystem stores all your files within `/home/username`.
2. WSL launches by default in your `System32` folder. You can switch to your local folder using `cd`
3. You can see this folder as a different section in your file Explorer. 
4. You can directly paste files into the required folder to access them within your Subsystem.
5. Paste all required files in your `/home/username` folder to access them quickly

# Required Package Installation:
## 1. Installing Wireshark:
### For WSL/Ubuntu:
Use:
```
sudo apt install wireshark
```
### For Other Linux Distros:
- Check your distro documentation
### For MacOS:
1. Use HomeBrew
```
brew install wireshark
```

## 2. Install Exiftool:
### For WSL/Ubuntu:
Use:
```
sudo apt install exiftool
```
if this does not work, try
```
sudo apt install libimage-exiftool-perl
```
### For Other Linux Distros:
- Check your distro documentation
### For MacOS:
1. Use HomeBrew
```
brew install exiftool
```

## 3. Install Binwalk:
### For WSL/Ubuntu:
Use
```
sudo apt install binwalk
```
### For Other Linux Distros:
- Check your distro documentation
### For MacOS:
1. Use HomeBrew
```
brew install binwalk
```
## 4. Install unzip:
### For WSL/Ubuntu:
Use
```
sudo apt install unzip
```
### For Other Linux Distros:
- Check your distro documentation
### For MacOS:
1. Use HomeBrew
```
brew install unzip
```

## 5. Install zsteg
### For WSL/Ubuntu:
Install via ruby-rubygems
```
sudo apt install ruby-rubygems
gem install zsteg --user-install

echo 'export PATH="$PATH:$(ruby -e "puts Gem.user_dir")/bin"' >> ~/.bashrc
source ~/.bashrc
```
### For Other Linux Distros:
- Check your distro documentation
### For MacOS:
1. Use HomeBrew
```
brew install ruby
gem install zsteg --user-install

echo 'export PATH="$(brew --prefix ruby)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## 6. Install SleuthKit:
### For WSL/Ubuntu:
It should be pre-insalled, if not, Use
```
sudo apt install sleuthkit
```
### For Other Linux Distros:
- Check your distro documentation
### For MacOS:
1. Use HomeBrew
```
brew install sleuthkit
```
