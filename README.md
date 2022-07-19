# Deploy-Files-to-Repo

![lint](https://github.com/neohsu/deploy-files-to-repo/actions/workflows/lint.yml/badge.svg) ![license](https://img.shields.io/badge/license-MIT-brightgreen)

## Introduction

`Deploy-Files-to-Repo` is a GitHub action that helps to deploy files to target repository & automatically creates pull request on it.

## How It Works

`Deploy-Files-to-Repo` will clone target repository to `__${TARGET_REPO}__clone__` folder on `$GITHUB_WORKSPACE`.

It will copy files/folders from source repository to target repository and make corresponding commits.

After pushing git commits, this action will automatically create pull request to target repository.

### Deploy-Files-to-Repo workflow

![Deploy-Files-to-Repo workflow](./deploy-files-to-repo-workflow.svg?raw=true)

## Getting Started

### Dependencies

Before use `Deploy-Files-to-Repo` action, please use `actions/checkout` action firstly because `Deploy-Files-to-Repo` action need source code workspace.

### Configuration

| Input                        | required | description                                                                                                                   |
| ---------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| source_dir                   | `false`   | Deploy file or folder from this repository.<br/> eg. `README.md`                                       |
| target_dir                   | `false`   | Deploy target file or folder path into target GitHub repository.<br/>eg. `doc/README.md` of `.elastic_runner`                 |
| target_github_domain         | `false`  | Target GitHub domain.<br/>`default`: `github.com`                                                              |
| target_github_api            | `false`  | Target GitHub API URL.<br/>`default`: `https://api.github.com`                                              |
| target_personal_access_token | `true`   | Target GitHub personal access token                                                                                           |
| target_owner                 | `true`   | Target GitHub owner                                                                                                           |
| target_repo                  | `true`   | Target GitHub repository                                                                                                      |
| target_branch                | `false`  | Target GitHub repository's branch. <br/>`default`: `main`                                                                     |
| target_pre_copy_command      | `false`  | Run command on target repository before copy files flow.<br/>This command path is on `$GITHUB_WORKSPACE`                      |
| target_pre_commit_command    | `false`  | Run command on target repository before git commit.<br/>This command path is on `$GITHUB_WORKSPACE/__${TARGET_REPO}__clone__` |
| commit_msg                   | `false`  | Custom git commit message.<br/>`default`: `Deployed $SOURCE_DIR into $TARGET_DIR from $GITHUB_REPOSITORY@${GIT_SHA_SHORT}`    |
| target_pr_branch             | `false`  | Custom PR branch.<br/>`default`: `deploy-files-to-repo--branches`                                                             |

### Usage

```yaml
name: deploy-files
on:
  workflow_dispatch:
    inputs:
      source_dir:
        description: "Deploy file or folder from this repo"
        required: true
      target_dir:
        description: "Deploy target file or folder path into target GitHub repository"
        required: true
      target_personal_access_token:
        description: "Target GitHub personal access token"
        required: true
      target_owner:
        description: "Target GitHub owner"
        required: true
      target_repo:
        description: "Target GitHub repository"
        required: true
      target_branch:
        description: "Target GitHub repository branch"
        default: "main"
        required: false
jobs:
  deploy:
    strategy:
      matrix:
        runner:
          - deploy-runner
    runs-on: ${{ matrix.runner }}
    steps:
      - uses: actions/checkout@v2
      - uses: actions/deploy-files-to-repo@main
        with:
          source_dir: ${{ github.event.inputs.source_dir }
          target_dir: ${{ github.event.inputs.target_dir }}}
          target_owner: ${{ github.event.inputs.target_owner }}
          target_repo: ${{ github.event.inputs.target_repo }}
          target_branch: ${{ github.event.inputs.target_branch }}
          target_personal_access_token: ${{ github.event.inputs.target_personal_access_token }}
```

## Contribute

See [CONTRIBUTING.md in the repo](CONTRIBUTING.md) or the [Contributing section on the docs site](DOCUMENTATION.md).
