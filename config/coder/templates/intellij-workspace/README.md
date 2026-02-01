# IntelliJ IDEA Workspace Template

Local macOS workspace template optimized for Java/Kotlin development with IntelliJ IDEA.

## Features

- **Native macOS workspace** - No Docker, runs directly on your Mac
- **IntelliJ IDEA integration** - One-click open in IntelliJ
- **Java/OpenJDK** - Configurable Java version (11, 17, 21)
- **Git integration** - Auto-initializes Git repository
- **VSCode fallback** - Alternative editor option
- **Terminal access** - Direct terminal access to workspace

## Parameters

- **project_name**: Name of your project (default: "my-project")
- **java_version**: Java version to use - 11, 17, or 21 (default: "21")

## Usage

### Create Workspace

```bash
coder create my-java-app --template=intellij-workspace \
  --parameter project_name=my-java-app \
  --parameter java_version=21
```

### Open in IntelliJ IDEA

From the Coder UI:
1. Navigate to your workspace
2. Click "Open in IntelliJ IDEA"

From CLI:
```bash
coder open my-java-app --app intellij
```

### Access Workspace

```bash
# SSH into workspace
coder ssh my-java-app

# Open VSCode
coder open my-java-app --app vscode

# Open Terminal
coder open my-java-app --app terminal
```

## Workspace Structure

```
~/Workspaces/{username}/{project_name}/
├── .git/                # Git repository
├── .gitignore          # Java/IntelliJ gitignore
└── src/                # Your source code
```

## Requirements

- IntelliJ IDEA installed (Community or Ultimate)
- Java/OpenJDK (will be installed via Homebrew if missing)
- Git

## iPad Access

Access the Coder UI from your iPad:
1. Connect to same network as your Mac
2. Open Safari on iPad
3. Navigate to: `http://[your-mac-ip]:7080`
4. Create/manage workspaces from the UI

Note: IntelliJ requires desktop app, but you can use the web-based code editor or connect via JetBrains Gateway.
