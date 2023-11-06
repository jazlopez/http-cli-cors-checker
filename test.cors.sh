#!/usr/bin/env bash
set -euo pipefail

clear
FILE_LAST_USED_COOKIE="${PWD}/.cookie_last_used"
FILE_LAST_USED_TARGET_URL="${PWD}/.target_url_last_used"
FILE_LAST_USED_ORIGIN_HOST="${PWD}/.origin_host_last_used"

LABEL_TARGET_URL=""
LABEL_ORIGIN_HOST=""
LABEL_COOKIES=""


if [ -f "${FILE_LAST_USED_COOKIE}" ]; then
  COOKIES=$(cat "${FILE_LAST_USED_COOKIE}")
  LABEL_COOKIES="(${COOKIES})"
else
  COOKIES=""
fi

if [ -f "${FILE_LAST_USED_TARGET_URL}" ]; then
  TARGET_URL=$(cat "${FILE_LAST_USED_TARGET_URL}")
  LABEL_TARGET_URL="(${TARGET_URL})"
else
  TARGET_URL=""
fi

if [ -f "${FILE_LAST_USED_ORIGIN_HOST}" ]; then
  ORIGIN_HOST=$(cat "${FILE_LAST_USED_ORIGIN_HOST}")
  LABEL_ORIGIN_HOST="(${ORIGIN_HOST})"
else
  ORIGIN_HOST=""
fi
#
read -p "TARGET_URL ${LABEL_TARGET_URL}: " INPUT_TARGET_URL
read -p "ORIGIN_HOST ${LABEL_ORIGIN_HOST}: " INPUT_ORIGIN_HOST
read -p "COOKIES ${LABEL_COOKIES}: " INPUT_COOKIES

if [ -n "${INPUT_TARGET_URL}" ]; then
  TARGET_URL=${INPUT_TARGET_URL}
fi

if [ -n "${INPUT_ORIGIN_HOST}" ]; then
  ORIGIN_HOST=${INPUT_ORIGIN_HOST}
fi

if [ -n "${INPUT_COOKIES}" ]; then
  COOKIES=${INPUT_COOKIES}
fi

echo "Calling:    ${TARGET_URL}"
echo "From:       ${ORIGIN_HOST}"
echo "Cookies:    ${COOKIES}"
echo "----"

curl -I -L ${TARGET_URL} -X GET \
  -H "Access-Control-Request-Method: OPTIONS" \
  -H "Origin: ${ORIGIN_HOST}" \
  -H 'Cache-Control: no-cache, no-store' \
  -H 'Pragma: no-cache' \
  -H "Access-Control-Request-Headers: X-Requested-With" \
  -H "Cookie: ${COOKIES}"

# CHECK for the "access-control-allow-" headers in the response

rm -f "${FILE_LAST_USED_TARGET_URL}"
rm -f "${FILE_LAST_USED_ORIGIN_HOST}"
rm -f "${FILE_LAST_USED_COOKIE}"

echo ${TARGET_URL} > "${FILE_LAST_USED_TARGET_URL}"
echo ${ORIGIN_HOST} > "${FILE_LAST_USED_ORIGIN_HOST}"
echo ${COOKIES} > "${FILE_LAST_USED_COOKIE}"

# Jaziel Lopez jazlopez at github.com
# 2023