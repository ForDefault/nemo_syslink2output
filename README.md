# Installation Guide: Nemo_Syslink2Output

## This nemo_action:
>allows users to set one or multiple sources to have their file contents output to a selected directory via symbolic links.

 ### Enabled Features

- Multi-Source Selection:
        One file or folder: When you select a folder, only its contents appear in the destination folder (not the folder itself).
- Multiple files or folders: You can select multiple sources, and their contents will all be symlinked to the destination folder.
- Adaptive context menu: The context menu dynamically updates to reflect the number of selected sources.
## Instructions With Example

>***Given the directory structure***:

```
syslinktest
├── folder2
│   └── FILE2
├── folder3
│   └── FILE3
│   └── FILE55
└── output
```

>***Selecting a Single Folder***:

If you select folder2, right-click, and choose "1.Source to output FROM" from the context menu:
```
syslinktest
├── folder2
│   └── FILE2
├── folder3
│   └── FILE3
│   └── FILE55
└── output
    └── FILE2 -> /path/to/syslinktest/folder2/FILE2 (syslinked)
```

>***Selecting Multiple Folders***:

If you select:
-  folder2 right-click, and choose "1.Source to output FROM" from the context menu
-  Now select folder3 right-click, and choose "2.Source to output FROM" (the context menu is progressive with numbers)
-  You can then select a folder, "output",  and choose "To Output FROM Source" the result is:
```
syslinktest
├── folder2
│   └── FILE2
├── folder3
│   └── FILE3
│   └── FILE55
└── output
    ├── FILE2  -> /path/to/syslinktest/folder2/FILE2 (syslinked)
    ├── FILE3  -> /path/to/syslinktest/folder3/FILE3 (syslinked)
    └── FILE55 -> /path/to/syslinktest/folder3/FILE55 (syslinked)
```
## Quick Start
### SingleCommand Install

To install the Nemo action on Linux Mint, open a terminal and execute this SingleCommand:

```
USER=$(whoami) && \
REPO_URL="https://github.com/ForDefault/nemo_syslink2output.git" && \
REPO_NAME=$(basename $REPO_URL .git) && \
git clone $REPO_URL && \
cd $REPO_NAME && \
chmod +x install.sh && \
./install.sh && \
cd .. && rm -rf $REPO_NAME
```
## Usage

Right-click on any file or folder within Nemo, and select "Source to output FROM" from the context menu. After setting the sources, right-click on the destination folder and select "Output2Syslink here". The selected source paths will be symlinked to the destination directory.


