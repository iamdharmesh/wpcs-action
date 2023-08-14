#!/bin/sh

cp /action/problem-matcher.json /github/workflow/problem-matcher.json

git clone --depth 1 -b 2.3.0 https://github.com/WordPress/WordPress-Coding-Standards.git ~/wpcs

if [ "${INPUT_STANDARD}" = "WordPress-VIP-Go" ] || [ "${INPUT_STANDARD}" = "WordPressVIPMinimum" ]; then
    echo "Setting up VIPCS"
    git clone --depth 1 -b 2.3.3 https://github.com/Automattic/VIP-Coding-Standards.git ${HOME}/vipcs
    git clone https://github.com/sirbrillig/phpcs-variable-analysis ${HOME}/variable-analysis
    ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/vipcs,${HOME}/variable-analysis"
elif [ "${INPUT_STANDARD}" = "10up-Default" ]; then
    echo "Setting up 10up-Default"
    git clone https://github.com/10up/phpcs-composer ${HOME}/10up
    git clone https://github.com/PHPCompatibility/PHPCompatibilityWP ${HOME}/phpcompatwp
    git clone https://github.com/PHPCompatibility/PHPCompatibility ${HOME}/phpcompat
    git clone https://github.com/PHPCompatibility/PHPCompatibilityParagonie ${HOME}/phpcompat-paragonie
    git clone https://github.com/PHPCSStandards/PHPCSUtils ${HOME}/phpcsutils
    git clone https://github.com/Automattic/VIP-Coding-Standards ${HOME}/vipcs
    git clone https://github.com/sirbrillig/phpcs-variable-analysis ${HOME}/variable-analysis
    ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/10up/10up-Default,${HOME}/phpcompatwp/PHPCompatibilityWP,${HOME}/phpcompat/PHPCompatibility,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieSodiumCompat,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieRandomCompat,${HOME}/phpcsutils/PHPCSUtils,${HOME}/vipcs,${HOME}/variable-analysis"
elif [ -z "${INPUT_STANDARD_REPO}" ] || [ "${INPUT_STANDARD_REPO}" = "false" ]; then
    ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths ~/wpcs
else
    echo "Standard repository: ${INPUT_STANDARD_REPO}"
    git clone -b ${INPUT_REPO_BRANCH} ${INPUT_STANDARD_REPO} ${HOME}/cs
    ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/cs"
fi

if [ -z "${INPUT_EXCLUDES}" ]; then
    EXCLUDES="node_modules,vendor"
else
    EXCLUDES="node_modules,vendor,${INPUT_EXCLUDES}"
fi

phpcs -i

echo "::add-matcher::${RUNNER_TEMP}/_github_workflow/problem-matcher.json"

if [ -z "${INPUT_ENABLE_WARNINGS}" ] || [ "${INPUT_ENABLE_WARNINGS}" = "false" ]; then
    WARNING_FLAG="-n"
    echo "Check for warnings disabled"
else
    WARNING_FLAG=""
    echo "Check for warnings enabled"
fi

# .phpcs.xml, phpcs.xml, .phpcs.xml.dist, phpcs.xml.dist
if [ -f ".phpcs.xml" ] || [ -f "phpcs.xml" ] || [ -f ".phpcs.xml.dist" ] || [ -f "phpcs.xml.dist" ]; then
    HAS_CONFIG=true
else
    HAS_CONFIG=false
fi

echo "!!Github base ref ${GITHUB_BASE_REF}"
echo "!!Github SHA ${GITHUB_SHA}"
git config --global --add safe.directory /github/workspace
#git status
#git branch -r
REMOTE=${git remote};
echo "Git remote: ${REMOTE}"
echo "Git remote: ${REMOTE}"
echo "Git remote: ${REMOTE}"
echo "git pull ${REMOTE} ${GITHUB_BASE_REF}"
git pull $REMOTE $GITHUB_BASE_REF
git diff --name-only --diff-filter=d $GITHUB_BASE_REF..$GITHUB_SHA

if [ "${INPUT_CHANGED_FILES}" = true ] ; then
    echo "Only check changed files"
    CHANGED_FILES=$(git diff --name-only --diff-filter=d $GITHUB_BASE_REF..3016dc63c771a593fdaf8957483f2e8a450808fb)
else
    CHANGED_FILES=""
fi

echo "${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle --standard=${INPUT_STANDARD} --ignore=${EXCLUDES} --extensions=php ${INPUT_PATHS} ${CHANGED_FILES} ${INPUT_EXTRA_ARGS}";

if [ "${HAS_CONFIG}" = true ] && [ "${INPUT_USE_LOCAL_CONFIG}" = "true" ] ; then
    ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle ${CHANGED_FILES} ${INPUT_EXTRA_ARGS}
else
    ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle --standard=${INPUT_STANDARD} --ignore=${EXCLUDES} --extensions=php ${INPUT_PATHS} ${CHANGED_FILES} ${INPUT_EXTRA_ARGS}
fi

status=$?

echo "::remove-matcher owner=phpcs::"

exit $status
