#!/usr/bin/env fish

set -l branch main
if test (count $argv) -ge 1
	set branch $argv[1]
end

set -l current_branch (git branch --show-current)
if test "$current_branch" != "$branch"
	echo "当前分支为 $current_branch，请先切换到 $branch"
	exit 1
end

if not git diff --quiet; or not git diff --cached --quiet
	echo "工作区存在未提交修改，停止更新"
	exit 1
end

git fetch origin $branch; or exit 1
git merge --ff-only FETCH_HEAD; or exit 1
npm ci --omit=dev; or exit 1
pm2 restart gocam --update-env; or exit 1
