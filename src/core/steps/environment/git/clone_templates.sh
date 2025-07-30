#!/usr/bin/env bash

clone_templates() {
    # [ $(get_config status templates_cloned) = 'done' ] && return

    switch_to "$REPO_DIR"
    git clone https://github.com/nick-etuk/workstation1-template-web.git
    add_project_to_registry "$REPO_DIR/workstation1-template-web"
    # set_config status templates_cloned 'done'
    switch_back

}

clone_templates
