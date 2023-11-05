#!/bin/bash

# Replace <username> with your GitHub username
GITHUB_USER="${1:mi-skam}"

# List all repositories for the user
repos=$(gh repo list $GITHUB_USER --limit 1000 --json nameWithOwner -q ".[].nameWithOwner")

# Iterate over each repository and list open pull requests
for repo in $repos; do
    echo "Open PRs for $repo:"
    gh pr list -R $repo --json title,number,createdAt -q ".[] | \"#\(.number) \(.title) (\(.createdAt))\""
    echo ""
done

