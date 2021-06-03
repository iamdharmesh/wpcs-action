#!/bin/sh

cp /action/problem-matcher.json /github/workflow/problem-matcher.json

echo "::add-matcher::${RUNNER_TEMP}/_github_workflow/problem-matcher.json"

git clone -b master https://github.com/WordPress/WordPress-Coding-Standards.git ~/wpcs

if [ "${INPUT_IS_VIPCS}" = "true" ]; then
    echo "Setting up VIPCS"
    git clone https://github.com/Automattic/VIP-Coding-Standards ${HOME}/vipcs
    git clone https://github.com/sirbrillig/phpcs-variable-analysis ${HOME}/variable-analysis
    phpcs --config-set installed_paths "${HOME}/wpcs,${HOME}/vipcs,${HOME}/variable-analysis"
elif [ -z "${INPUT_STANDARD_REPO}" ] || [ "${INPUT_STANDARD_REPO}" = "false" ]; then
    phpcs --config-set installed_paths ~/wpcs
else
    echo "Standard repository: ${INPUT_STANDARD_REPO}"
    git clone -b ${INPUT_REPO_BRANCH} ${INPUT_STANDARD_REPO} ${HOME}/cs
    phpcs --config-set installed_paths "${HOME}/wpcs,${HOME}/cs"
fi

phpcs -i

if [ -z "${INPUT_ENABLE_WARNINGS}" ] || [ "${INPUT_ENABLE_WARNINGS}" = "false" ]; then
    echo "Check for warnings disabled"

    phpcs -s -n --report=checkstyle --standard=${INPUT_STANDARD} --extensions=php --ignore=node_modules,vendor ${INPUT_PATHS}
else
    echo "Check for warnings enabled"

    phpcs -s --report=checkstyle --standard=${INPUT_STANDARD} --ignore=node_modules,vendor --extensions=php ${INPUT_PATHS}
fi

status=$?

echo "::remove-matcher owner=phpcs::"

exit $status
