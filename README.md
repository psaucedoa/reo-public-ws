# Welcome to REO2, the REO ROS2 Workspace

## Getting Started

### Ubuntu Installation
- Recommended: Fresh install of **Ubuntu 22.0.4** (newer versions should also work).
- Ensure a wired internet connection for driver updates.

#### System Update and Tools Installation
```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install snapd -y
sudo apt install git -y
```

#### RT-Linux
> IMPORTANT: If using a real-time kernel, make sure to do the folowing. This will ensure nvidia drivers install correctly

```bash
sudo apt purge nvidia*
sudo apt install libglvnd-dev pkg-config dkms
sudo apt install gcc make pkg-config libglvnd0 -y

sudo nano /etc/modprobe.d/blacklist-nouveau.conf
# Insert into file:
#  blacklist nouveau
#  options nouveau modeset=0

sudo update-initramfs -u
sudo reboot now
sudo IGNORE_PREEMPT_RT_PRESENCE=1 apt install nvidia-driver-535  # is using server, append -server

sudo reboot now
```

#### Default Nvidia Driver Setup
- Open Additional Drivers
- Select 'Using Nvidia driver metapackage from nvidia-driver-535(proprietary-tested)

```bash
sudo apt update -y
sudo apt upgrade -y
# Reboot your machine just to make sure
sudo reboot now
```
---
### GitLab Access Token Setup

- Prerequisites: RDE account and ERDC GitLab account.
- Generate a personal access token at ERDC GitLab Tokens.
- Select all scopes for the token.
- Note: Token is irretrievable after leaving the page.

#### Git Configuration
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

---
### Development Tools Installation

#### Visual Studio Code
```bash
sudo snap install --classic code 
```
- **Note**: VS Code is recommended for uniformity and its unique features.

#### Local Code LLMs

- Install the "continue" extension
- Once installed, click on the new icon in the left task bar.
- The Continue panel should pop up.
- Next, click on the settings cog in the lower right side of the continue panel. This brings up the config json
- Replace the "models" and "tabautocompletemodels" with the following:

```
"models": [
    {
      "title": "Qwen2.5 Coder 7B",
      "provider": "llama.cpp",
      "model": "Qwen2.5-Coder-7B-Instruct-GGUF",
      "apiBase": "http://some.address.here.with:port"
    }
  ],
  "tabAutocompleteModel": {
    "title": "Qwen2.5 Coder 7B",
    "provider": "llama.cpp",
    "model": "Qwen2.5-Coder-7B-Instruct-GGUF",
    "apiBase": "http://some.address.here.with:port"
  },
  ```

> Replace `http://some.address.here.with:port` with your inference computer's ip, or some web address.

#### Foxglove Studio
```bash
sudo snap install foxglove-studio
```
- Used for visualizing robot data, an alternative to RViz.

---

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

```

#### NVIDIA Container Toolkit Installation
```bash
# Configure the repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update and install
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

# Configure Docker for NVIDIA
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Change Docker root folder
cd
mkdir docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOT
{
    "data-root": "$HOME/docker",
    "runtimes": {
        "nvidia": {
            "args": [],
            "path": "nvidia-container-runtime"
        }
    }
}
EOT
```

#### NVIDIA CUDA-Toolkit install
- You'll also need to install the CUDA-Toolkit.

- Use the following link for install install instructions: 
https://developer.nvidia.com/cuda-12-2-0-download-archive?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local

#### Docker Configuration and Workspace Cloning
```bash
sudo usermod -aG docker ${USER}
# Use gituser.sh for Git credential setup

### Restart Your Computer
- After completing the setup and configuration steps, it is necessary to restart your computer to ensure that all changes take effect.

# Clone the workspace
cd
git clone https://github.com/psaucedoa/reo-public-ws.git
# Optionally rename the workspace folder
```

---

### Setting Up the Workspace in VS Code
1. Open the workspace in VS Code (code "WORKSPACE NAME").
2. Enable autosave: File -> Autosave.
3. Set up a keyboard shortcut for tasks: `Ctrl+K` -> `Ctrl+S` -> Search for 4. 4. "Tasks: Run Task" -> Assign `Ctrl+;`.

```bash
# Create bag folder
cd
mkdir bag_files
```

#### Building the Docker Workspace Container

- Select **"Dev Containers: Reopen in container"** in the bottom left from the blue button.
- Run the "setup" task using the new shortcut (`ctrl + ;`) to pull all packages.
- Build the workspace with the "build" task.

#### Generate Documentation
- Run the "generate-workspace-documentation" task using the new shortcut (Ctrl + ;) to pull all packages.

#### Accessing Documentation
```bash
firefox reo-ws/docs/built/index.html
```
---
### Key Binding
Add key bindings to make running tasks easier. Within VSCode, if you haven't already, go to hot keys, and search for the run task command. assign ctrl+; to run task. 

> If you're on newer versions of Ubuntu, the `ctrl+;` keybind might be mapped to the *emoji shortcut*!

#### Setup
- You will need to set up the workspace. This is adding in the code that isn't already installed to the docker environment. 
- This is run with `ctrl+;` -> search `setup`
- The setup.sh script is run and imports all of the repos from the repos folder. 
- If you want to get more repos in there, add them into those folders.

#### Build 
- This builds it. ctrl+; -> search "build" 
- This may take a hot second. breathe. 

#### Add Submodules 
- Need to add submodules when you first launch the container or add a new repo to the .repos. 
- Here, you will need to do `ctrl+;` -> then type `add submodules from repos`. 
- After that, you will need to restart VSCode
- Alternitavely, if you don't see a repo pop up in your gitgraph panel, simply modify one of its files. It should then get listed in the gitgraph panel.

## File Structure

### .DEVCONTAINER/

> This folder contains a few files and folders, but the important ones are `Dockerfile` and `devcontainer.json`

#### Dockerfile 
- The docker commands which build the container. Here is where you should specify any setup that you would normally do `sudo apt install ...` for. 
- Basically, the system-level configuration. Binary installation. Dependencies. Tools.
- Additionally, you might notice the `FROM ... AS ...` syntax. These are used as ways to split up and kind of compartmentalize the docker install. 
- Instead of one large install script, you can split it into multiple `FROM ... AS ...` blocks. This is called **staging**, and is nice for many reasons, the important ones for us being:
  1. **Readability:** Staging separates different portions of the install/setup process into
   visually discrete blocks. 
  2. **Build & Copy:** You can (should) use staging to reduce the size of the final image. You can setup a 
   `stage A`, where you build and generate binaries, then set up a separate `stage B` that *copies* 
   the build binary from `stage A` without any of the tooling or dependencies.

#### devcontainer.json
- This is essentially the network & I/O configuration file for interactions between the docker image and the host machine.
- Here you can specify 
  - GPUs 
  - Networking settings 
  - Display forwarding 
  - **File system mounts** 
  - Minor stuff like VS Code extensions to
automatically add.  

### BUILD/ & INSTALL/
Self explanatory, however:

>#### my_package (won't build)
  > If you run into issues rebuilding a package, try clearing it from these directories. Sometimes stuff like the `CMakeLists.txt` doesn't get copied/symlinked or w/e, or maybe your package isn't acting as expected because it *didn't actually rebuild it*.

### REPOS/

#### src.repos 
- This file specifies the packages to be cloned into `src/` by the `setup` task.
- This is where we store and track all the packages to be cloned into our workspace. Here, you can specify the directory to-be-cloned-to in the top-level tag of each repository. 
- For example, if we want to clone `foxglove_bridge` into `src/communication`, we label this entry as:

        communication/foxglove_bridge:
            type: git
            url: https://some.address/foxglove-bridge.git
            version: main
- Note, we specify the default branch using the `version` tag. The branch specified here is `main`  

#### resources.repos 
- The same as above, except this clones into the `resources/` directory.

### SCRIPTS/

#### build.sh 
- This is the script behind the `build` task
- Just sources and builds, with some additional parameters.
- To manually build a package(s), run:
        `colcon build --packages-select your_package --merge-install`

#### setup.sh 
- This is the script behind the `setup` task
- Does a vcs import of the repos listed under `repos/src.repos` and `repos/resources.repos`
- Also does a `rosdep update` & `rosdep install`
