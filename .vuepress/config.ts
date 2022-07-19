import { viteBundler } from "@vuepress/bundler-vite";
import { defineUserConfig } from "@vuepress/cli";
import { defaultTheme } from "@vuepress/theme-default";

export default defineUserConfig({
  base: "/deploy-files-to-repo/",
  locales: {
    "/": {
      lang: "en-US",
      title: "Deploy-Files-to-Repo",
      description:
        "Deploy-Files-to-Repo is a GitHub action that help to deploy files into other repository & automate created pull request on target repository.",
    },
  },
  bundler: viteBundler(),
  pagePatterns: ["*.md"],
  theme: defaultTheme({
    repoLabel: "GitHub",
    repo: "https://github.com/neohsu/deploy-files-to-repo",
  }),
});
