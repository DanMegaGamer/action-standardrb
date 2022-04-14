#!/bin/sh
version() {
  if [ -n "$1" ]; then
    echo "-v $1"
  fi
}

git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
git config --global --add safe.directory "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1
cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

gem install -N standard $(version $INPUT_RUBOCOP_VERSION)

standardrb ${INPUT_RUBOCOP_FLAGS} \
  | reviewdog \
	-f=rubocop \
	-name="${INPUT_TOOL_NAME}" \
	-reporter="${INPUT_REPORTER}" \
	-fail-on-error="${INPUT_FAIL_ON_ERROR}" \
	-level="${INPUT_LEVEL}"
