# Docs & Site

Documentation & site contribution guide.

## Initial Setup

- Fork `Deploy-Files-to-Repo` on GitHub and/or Git clone the default branch:

```shell:no-line-numbers
# clone your forker
git clone https://github.com/<OWNER>/deploy-files-to-repo.git
# or clone asdf
git clone https://github.com/neohsu/deploy-files-to-repo.git
```

- [Node.js](https://nodejs.org): JavaScript runtime built on Chrome's V8 JavaScript engine.

Install Node.js dependencies from `package.json`:

```shell:no-line-numbers
yarn install
```

## Development

[Vuepress (v2)](https://v2.vuepress.vuejs.org/) is the Static Site Generator (SSG) we use to build the `Deploy-Files-to-Repo` documentation site.

`package.json` contains the scripts required for development:

@[code json{7-9}](./package.json)

To start the local development server:

```shell:no-line-numbers
yarn docs:dev
```

Format the code before committing:

```shell:no-line-numbers
yarn docs:format
```

## Pull Requests, Releases & Conventional Commits

Creating a PR for documentation changes please make the PR title with the Conventional Commit type `docs` in the format `docs: <description>`.

## Vuepress

Configuration of the site is contained within a few JavaScript files with JS Objects used to represent the config. They are:

- `.vuepress/config.ts`: the root config file for the site. Read the [Vuepress documentation](https://v2.vuepress.vuejs.org/guide/configuration.html#config-file) for it's spec.
