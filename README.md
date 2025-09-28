# Introduction

This is a set of scripts that setup your workstation for developing applications.
It contains scripts that install the IDEs and package managers involved in building
applications with frontends, backends, docker containers, node modules, dotnet packages and so on.
It works on Windows, WSL, Ubuntu and MacOS.
The scripts are written in Powershell for Windows based applications and Shell Script for WSL, Ubuntu and MacOS.
It shows a menu that lets you choose which development activity you want to startup:

The menus contain activities for each of your major development projects.
![image info](./doc/troubleshooting/image-menu.png)

# Getting started

Clone this repo to wherever you keep your local repos.
Switch to `<repo_dir>/workstation1/src/core/cli and run `./ws.sh` or `./ws.ps1` on Windows.
This will add the `ws` command to your path and show you the main menu.

# Adding a project to the menu

To add a project to the menu, switch to the root directoy of the project (or any other directory), and then run `ws add`.
This will prompt you for a description and then create a `workstation1` directory, where you can
define your activities and steps.
`ws add` creates a `ws1_project.json` file in the `workstation1` directory.
This file defines the project and its attributes.
It also adds the path of the `workstation1` directory to ~/.workstation1/project_registry.csv, so that it is included in the main menu.

You can add new activities anywhere within the `workstation1` directory.
Activities are defined in json files that contain the word `activity` in their filenames.
For example, `web_development_activity.json`.
Create new steps for the project inside a `workstation1/steps` directory.
Only create new steps if one does not already exist that does what you want. To get a full list of existing steps, run `ws list`.

# Projects

A project is an application or system you are working on.
It usually has at least one Git repo.
Each project has a `ws1_project.json` file that defines its attibutes. Here is an example:

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

The project will be shown in the main menu if the `showMenu` property is `true`.

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
  "repo": "https://github.com/nick-etuk/workstation1-template-web.git",
  "repoPath": "$HOME/repos/workstation1-template-web",
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
```

Activity IDs must be unique across all projects.

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

## Scope

The scope of a step can be public or private. By default, steps are public. Private steps are steps that do nothing useful by themseleves,
but a libraries or sub-modules for other steps. Private steps are not shown when you run `ws list`.

## Step names

The name of the step config file must match the name of the script file.
For example, if the step script is `install_node.sh`, the step config file must be `install_node.json`.
Step names must be unique across all projects.

# CLI commands

- `ws`: Shows the main menu. This contains a list of all projects and activities.
- `ws <activity>`: Runs the specified activity.
- `ws <step>`: Runs the specified step.
- `ws list`: Lists all steps in all projects.
- `ws add`: Adds a new project to the menu.
- `ws update`: Updates the step registry with the latest steps from all projects.
  Run this command after adding new steps or activities.
- `ws help`: Shows the help menu.
