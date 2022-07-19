#!/bin/sh -l
set -eu

git config --global --add safe.directory /github/workspace
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"

TARGET_PERSONAL_ACCESS_TOKEN="$INPUT_TARGET_PERSONAL_ACCESS_TOKEN"
SOURCE_DIR="$INPUT_SOURCE_DIR"
TARGET_OWNER="$INPUT_TARGET_OWNER"
TARGET_REPO="$INPUT_TARGET_REPO"
TARGET_BRANCH=$(echo "$INPUT_TARGET_BRANCH" | sed -e 's/^"//' -e 's/"$//')
TARGET_DIR="$INPUT_TARGET_DIR"
TARGET_PRE_COPY_COMMAND="$INPUT_TARGET_PRE_COPY_COMMAND"
TARGET_PRE_COMMIT_COMMAND="$INPUT_TARGET_PRE_COMMIT_COMMAND"
TARGET_GITHUB_DOMAIN="$INPUT_TARGET_GITHUB_DOMAIN"
TARGET_GITHUB_API="$INPUT_TARGET_GITHUB_API"
TARGET_PR_BRANCH="$INPUT_TARGET_PR_BRANCH"

TARGET_REPOSITORY=$TARGET_GITHUB_DOMAIN/$TARGET_OWNER/$TARGET_REPO
TARGET_REPOSITORY_URL="https://$TARGET_PERSONAL_ACCESS_TOKEN@$TARGET_REPOSITORY.git"
TARGET_CLONE_DIR="__${TARGET_REPO}__clone__"
GIT_SHA_SHORT=$(git rev-parse --short HEAD)

DEFAULT_COMMIT_MSG="Deployed $SOURCE_DIR into $TARGET_DIR from $GITHUB_REPOSITORY@${GIT_SHA_SHORT}"
COMMIT_MSG="${INPUT_COMMIT_MSG:-$DEFAULT_COMMIT_MSG}"

echo "Clone $TARGET_REPOSITORY into $TARGET_CLONE_DIR"
cd "$GITHUB_WORKSPACE"

rm -rf "$TARGET_CLONE_DIR"
git clone -b "$TARGET_BRANCH" "$TARGET_REPOSITORY_URL" "$TARGET_CLONE_DIR"

cd "$GITHUB_WORKSPACE/$TARGET_CLONE_DIR"
git checkout -b "$TARGET_PR_BRANCH--$TARGET_BRANCH"

if [ -n "$TARGET_PRE_COPY_COMMAND" ]; then
    echo "Run pre-copy command"
    eval "$TARGET_PRE_COPY_COMMAND"
fi

if [ -n "$SOURCE_DIR" ]; then
    echo "Copy files from $SOURCE_DIR into $TARGET_DIR"
    if [ -d "$GITHUB_WORKSPACE/$SOURCE_DIR" ]; then
        mkdir -p "$GITHUB_WORKSPACE/$TARGET_CLONE_DIR/$TARGET_DIR"
        cp -r "$GITHUB_WORKSPACE/$SOURCE_DIR"/* "$GITHUB_WORKSPACE/$TARGET_CLONE_DIR/$TARGET_DIR"
    else
        cp -r "$GITHUB_WORKSPACE/$SOURCE_DIR" "$GITHUB_WORKSPACE/$TARGET_CLONE_DIR/$TARGET_DIR"
    fi
fi

cd "$GITHUB_WORKSPACE/$TARGET_CLONE_DIR"

if [ -n "$TARGET_PRE_COMMIT_COMMAND" ]; then
    echo "Run pre-commit command"
    eval "$TARGET_PRE_COMMIT_COMMAND"
fi

cd "$GITHUB_WORKSPACE/$TARGET_CLONE_DIR"
if [ -n "$(git status --porcelain)" ]; then
    echo "Committing changes"
    git add .
    git commit -m "$COMMIT_MSG"
    echo "Push '$TARGET_PR_BRANCH--$TARGET_BRANCH' branch"
    git push -f origin "$TARGET_PR_BRANCH--$TARGET_BRANCH"
    echo "Create pull request from '$TARGET_PR_BRANCH--$TARGET_BRANCH' into '$TARGET_BRANCH'"
    curl -X POST -u "GitHub Action":"$TARGET_PERSONAL_ACCESS_TOKEN" -d "{\"title\":\"Deployed files from $GITHUB_REPOSITORY\",\"body\": \"$DEFAULT_COMMIT_MSG\",\"head\": \"$TARGET_PR_BRANCH--$TARGET_BRANCH\",\"base\": \"$TARGET_BRANCH\"}" "$TARGET_GITHUB_API/repos/$TARGET_OWNER/$TARGET_REPO/pulls"
else
    echo "No changes to push"
fi

echo "Cleanup target repository files"
cd "$GITHUB_WORKSPACE"
rm -rf "${GITHUB_WORKSPACE:?}/$TARGET_CLONE_DIR"

echo "Done"
