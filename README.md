# Welcome to REO2, the REO ROS2 Workspace

## Getting Started

### Initial Setup
#### Ubuntu Installation
- Recommended: Fresh install of **Ubuntu 22.0.4** (newer versions should also work).
- Opt for a minimal install.
- Ensure a wired internet connection for driver updates.

#### System Update and Tools Installation
```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install snapd -y
sudo apt install git -y
```

### Git Configuration
```bash
CURRENT_DIR=$(pwd)

# Install and compile libsecret
sudo apt update
sudo apt-get install libsecret-1-0 libsecret-1-dev git make gcc -y
cd /usr/share/doc/git/contrib/credential/libsecret
sudo make
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
cd $CURRENT_DIR
```

### Development Tools Installation

#### Visual Studio Code
```bash
sudo snap install --classic code 
```
- **Note**: VS Code is recommended for uniformity and its unique features.
#### Foxglove Studio
```bash
sudo snap install foxglove-studio
```
- Used for visualizing robot data, an alternative to RViz.

### Docker Installation
```bash
# Add Docker's official GPG key
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Change Docker root folder
cd
mkdir docker
cd && sudo tee /etc/docker/daemon.json > /dev/null <<EOT
{
    "data-root": "/home/rlab/docker",
    "runtimes": {
        "nvidia": {
            "args": [],
            "path": "nvidia-container-runtime"
        }
    }
}
EOT

```
### Docker Configuration and Workspace Cloning
```bash
sudo usermod -aG docker ${USER}
# Use gituser.sh for Git credential setup

### Restart Your Computer
- After completing the setup and configuration steps, it is necessary to restart your computer to ensure that all changes take effect.

# Clone the workspace
cd
git clone https://github.com/psaucedoa/reo-public-ws
# Optionally rename the workspace folder
```
### Setting Up the Workspace in VS Code
1. Open the workspace in VS Code (code "WORKSPACE NAME").
2. Enable autosave: File -> Autosave.
3. Set up a keyboard shortcut for tasks: `Ctrl+K` -> `Ctrl+S` -> Search for 4. 4. "Tasks: Run Task" -> Assign `Ctrl+;`.

```bash
# Create bag folder
cd
mkdir bag_files
```

Building the Docker Workspace Container

- Select "Open in container" in the bottom left.
- Run the "setup" task using the new shortcut (Ctrl + ;) to pull all packages.
- Build the workspace with the "build" task.

### Generate Documentation
- Run the "generate-workspace-documentation" task using the new shortcut (Ctrl + ;) to pull all packages.

### Accessing Documentation
```bash
firefox vscode-container-workspace/docs/built/index.html
```


### Intro to Docker Uses

# Key Binding
you will want to add key bindings to make running tasks easier. Within VSCode, if you haven't already, go to hot keys, and search for the run task command. assign ctrl+; to run task. 

# Setup
You will need to set up the workspace. This is adding in the code that isn't already installed to the docker environment. This is run with ctrl+; -> search "setup"

The setup.sh script is run and imports all of the repos from the repos folder. If you want to get more repos in there, add them into those folders.

# Build 
This builds it. ctrl+; -> search "build" 
This may take a hot second. breathe. 

# Add Submodules 
Need to add submodules when you first launch the container or add a new repo to the .repos. Here, you will need to do ctrl+; -> then type "add submodules from repos". After that, you will need to restart VSCode

