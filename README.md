# Introduction

This is a collection of scripts that help you setup your workstation for developing complex applications.
It contains scripts that install the IDEs and package managers involved in building
applications with frontends, backends, docker containers, node modules, dotnet packages and so on.
It works on Windows, WSL, Ubuntu and MacOS.
The scripts are written in Powershell for Windows based applications and Shell Script for WSL, Ubuntu and MacOS.

# Apps

Apps define an application you are working on. They usually have at least one Git repo.
An app will be shown in the main menu if its `showMenu` property is `true`.
Each app has a ws1.config.json that defines its attibutes. Here is an example:

```
{
  "id": "webapp",
  "title": "Sample Web App",
  "sortOrder": 10,
  "os": ["macos", "ubuntu"],
  "contact": {
    "email": "nick_etuk@hotmail.com"
  },
  "showMenu": true
}
```

# Activities

Activities define the menu items that are shown for each app. They contain a set of steps that are executed if the activity's menu option is chosen.
They are json files that contain the word `activity` in their filenames.
They can be located anywhere within the app's directory.
Here is an example:
`web_development_activity.json`

```
{
  "id": "web",
  "sortOrder": 10,
  "title": "Web development",
  "repo": "https://github.com/nick-etuk/workstation1-sample-web-app.git",
  "repoPath": "$HOME/repos/workstation1-sample-web-app",
  "subMenu": "login-env",
  "steps": [
    "install_node",
    "activate_node",
    "install_backend",
    "install_vscode",
    "install_text_editor",
    "configure_backend",
    "build_backend backendworker",
    "build_backend web",
    "start_docker",
    "docker_login",
    "start_service backendworker",
    "start_http_server",
    "open_vscode"
  ]
}

# Steps
Steps are the Shell script or Powershell code files that actually perform the actions specified in the activities.
Each step has a json configuration file that matches the name of the script file. This specifies the
dependencies and checks that go with the step. It can also contain child steps.
If the step is simple, the code for what it does can be entered as a command directly in the step defintion.

## Checks

Each step has an expression called a "check". This is used to work out if the step has been done or not.
The checks look like this:

{
  "dependencies": [],
  "checks": {
    "macos": ["command -v keybase | grep -q keybase"],
    "ubuntu": ["true"]
  }
}

The checks can be OS specific - macos, ubuntu, win. Unix means macos or ubuntu.


```
