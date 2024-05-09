#!/bin/sh

cp /action/problem-matcher.json /github/workflow/problem-matcher.json

git clone --depth 1 -b 2.3.0 https://github.com/WordPress/WordPress-Coding-Standards.git ~/wpcs

INPUT_ONLY_CHANGED_FILES=${INPUT_ONLY_CHANGED_FILES:-${INPUT_ONLY_CHANGED_LINES:-"false"}}

if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
    if [ "${GITHUB_EVENT_NAME}" = "pull_request" ]; then
        COMPARE_FROM=origin/${GITHUB_BASE_REF}
        COMPARE_TO=origin/${GITHUB_HEAD_REF}

        COMPARE_FROM_REF=$(git merge-base "${COMPARE_FROM}" "${COMPARE_TO}")
        COMPARE_TO_REF=${COMPARE_TO}
    else
        COMPARE_FROM="HEAD^"
        COMPARE_TO="HEAD"
        COMPARE_FROM_REF="HEAD^"
        COMPARE_TO_REF="HEAD"
    fi
    echo "Will only check changed files (${COMPARE_FROM_REF} -> ${COMPARE_TO_REF})"
    set +e
    CHANGED_FILES=$(git diff --name-only --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}" | xargs -rt ls -1d 2>/dev/null)
    set -e
    echo "Will check files:"
    echo "${CHANGED_FILES}"
else
    echo "Will check all files"
fi

if [ "${INPUT_STANDARD}" = "WordPress-VIP-Go" ] || [ "${INPUT_STANDARD}" = "WordPressVIPMinimum" ]; then
    echo "Setting up VIPCS"
    git clone --depth 1 -b 2.3.3 https://github.com/Automattic/VIP-Coding-Standards.git ${HOME}/vipcs
    git clone https://github.com/sirbrillig/phpcs-variable-analysis ${HOME}/variable-analysis
    if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
        if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
            step1=$(git diff -U0 --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}")
            step2=$(echo "${step1}" | diff-lines)
            step3=$(echo "${step2}" | grep -ve ':-')
            step4=$(echo "${step3}" | sed 's/:+.*//') # On some platforms, sed needs to have + escaped.  This isn't the case for Alpine sed.
            set +e
            echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/vipcs,${HOME}/variable-analysis" | filter-by-changed-lines "${step4}"
            set -e
        else
            echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/vipcs,${HOME}/variable-analysis"
        fi
    else
        ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/vipcs,${HOME}/variable-analysis"
    fi
elif [ "${INPUT_STANDARD}" = "10up-Default" ]; then
    echo "Setting up 10up-Default"
    git clone https://github.com/10up/phpcs-composer ${HOME}/10up
    git clone https://github.com/PHPCompatibility/PHPCompatibilityWP ${HOME}/phpcompatwp
    git clone https://github.com/PHPCompatibility/PHPCompatibility ${HOME}/phpcompat
    git clone https://github.com/PHPCompatibility/PHPCompatibilityParagonie ${HOME}/phpcompat-paragonie
    git clone https://github.com/PHPCSStandards/PHPCSUtils ${HOME}/phpcsutils
    git clone https://github.com/Automattic/VIP-Coding-Standards ${HOME}/vipcs
    git clone https://github.com/sirbrillig/phpcs-variable-analysis ${HOME}/variable-analysis
    if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
        if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
            step1=$(git diff -U0 --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}")
            step2=$(echo "${step1}" | diff-lines)
            step3=$(echo "${step2}" | grep -ve ':-')
            step4=$(echo "${step3}" | sed 's/:+.*//') # On some platforms, sed needs to have + escaped.  This isn't the case for Alpine sed.
            set +e
            echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/10up/10up-Default,${HOME}/phpcompatwp/PHPCompatibilityWP,${HOME}/phpcompat/PHPCompatibility,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieSodiumCompat,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieRandomCompat,${HOME}/phpcsutils/PHPCSUtils,${HOME}/vipcs,${HOME}/variable-analysis" | filter-by-changed-lines "${step4}"
            set -e
        else
            echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/10up/10up-Default,${HOME}/phpcompatwp/PHPCompatibilityWP,${HOME}/phpcompat/PHPCompatibility,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieSodiumCompat,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieRandomCompat,${HOME}/phpcsutils/PHPCSUtils,${HOME}/vipcs,${HOME}/variable-analysis"
        fi
    else
        ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/10up/10up-Default,${HOME}/phpcompatwp/PHPCompatibilityWP,${HOME}/phpcompat/PHPCompatibility,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieSodiumCompat,${HOME}/phpcompat-paragonie/PHPCompatibilityParagonieRandomCompat,${HOME}/phpcsutils/PHPCSUtils,${HOME}/vipcs,${HOME}/variable-analysis"
    fi
elif [ -z "${INPUT_STANDARD_REPO}" ] || [ "${INPUT_STANDARD_REPO}" = "false" ]; then
  if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
      if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
          step1=$(git diff -U0 --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}")
          step2=$(echo "${step1}" | diff-lines)
          step3=$(echo "${step2}" | grep -ve ':-')
          step4=$(echo "${step3}" | sed 's/:+.*//') # On some platforms, sed needs to have + escaped.  This isn't the case for Alpine sed.
          set +e
          echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths ~/wpcs | filter-by-changed-lines "${step4}"
          set -e
      else
          echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths ~/wpcs
      fi
  else
      ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths ~/wpcs
  fi
else
    echo "Standard repository: ${INPUT_STANDARD_REPO}"
    git clone -b ${INPUT_REPO_BRANCH} ${INPUT_STANDARD_REPO} ${HOME}/cs
    if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
      if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
          step1=$(git diff -U0 --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}")
          step2=$(echo "${step1}" | diff-lines)
          step3=$(echo "${step2}" | grep -ve ':-')
          step4=$(echo "${step3}" | sed 's/:+.*//') # On some platforms, sed needs to have + escaped.  This isn't the case for Alpine sed.
          set +e
          echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/cs" | filter-by-changed-lines "${step4}"
          set -e
      else
          echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/cs"
      fi
  else
      ${INPUT_PHPCS_BIN_PATH} --config-set installed_paths "${HOME}/wpcs,${HOME}/cs"
  fi
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

if [ "${HAS_CONFIG}" = true ] && [ "${INPUT_USE_LOCAL_CONFIG}" = "true" ] ; then
  if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
      if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
          step1=$(git diff -U0 --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}")
          step2=$(echo "${step1}" | diff-lines)
          step3=$(echo "${step2}" | grep -ve ':-')
          step4=$(echo "${step3}" | sed 's/:+.*//') # On some platforms, sed needs to have + escaped.  This isn't the case for Alpine sed.
          set +e
          echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle ${INPUT_EXTRA_ARGS} | filter-by-changed-lines "${step4}"
          set -e
      else
          echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle ${INPUT_EXTRA_ARGS}
      fi
  else
      ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle ${INPUT_EXTRA_ARGS}
  fi
else
  if [ "${INPUT_ONLY_CHANGED_FILES}" = "true" ]; then
      if [ "${INPUT_ONLY_CHANGED_LINES}" = "true" ]; then
          step1=$(git diff -U0 --diff-filter=d "${COMPARE_FROM_REF}" "${COMPARE_TO_REF}")
          step2=$(echo "${step1}" | diff-lines)
          step3=$(echo "${step2}" | grep -ve ':-')
          step4=$(echo "${step3}" | sed 's/:+.*//') # On some platforms, sed needs to have + escaped.  This isn't the case for Alpine sed.
          set +e
          echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle --standard=${INPUT_STANDARD} --ignore=${EXCLUDES} --extensions=php ${INPUT_PATHS} ${INPUT_EXTRA_ARGS} | filter-by-changed-lines "${step4}"
          set -e
      else
          echo "${CHANGED_FILES}" | xargs -rt ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle --standard=${INPUT_STANDARD} --ignore=${EXCLUDES} --extensions=php ${INPUT_PATHS} ${INPUT_EXTRA_ARGS}
      fi
  else
      ${INPUT_PHPCS_BIN_PATH} ${WARNING_FLAG} --report=checkstyle --standard=${INPUT_STANDARD} --ignore=${EXCLUDES} --extensions=php ${INPUT_PATHS} ${INPUT_EXTRA_ARGS}
  fi
fi

status=$?

echo "::remove-matcher owner=phpcs::"

exit $status
