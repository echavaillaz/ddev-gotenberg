#!/usr/bin/env bats

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests/test.bats
# To exclude release tests:
#   bats ./tests/test.bats --filter-tags '!release'
# For debugging:
#   bats ./tests/test.bats --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  set -eu -o pipefail

  export GITHUB_REPO=echavaillaz/ddev-gotenberg

  TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
  bats_load_library bats-assert
  bats_load_library bats-file
  bats_load_library bats-support

  export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
  export PROJNAME="test-$(basename "${GITHUB_REPO}")"
  mkdir -p ~/tmp
  export TESTDIR=$(mktemp -d ~/tmp/"${PROJNAME}".XXXXXX)
  export DDEV_NONINTERACTIVE=true
  export DDEV_NO_INSTRUMENTATION=true
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  run ddev config --project-name="${PROJNAME}" --project-tld=ddev.site
  assert_success
  cp -rf "${DIR}"/tests/testdata/* "$TESTDIR"
  run ddev start -y
  assert_success
}

health_checks() {
  echo "Waiting for Gotenberg container to be ready..." >&3
  for _ in {1..10}; do
    run ddev exec "curl -s -o /dev/null -w '%{http_code}' http://gotenberg:3000/health"
    if [ "$output" = "200" ]; then
      echo "Gotenberg is ready" >&3
      break
    fi
    sleep 2
  done
  assert_success
  assert_output "200"

  echo "Convert URL with Chromium (default)" >&3
  run ddev exec "curl -s -o chromium-default.pdf -w '%{http_code}' -F url=https://render.com http://gotenberg:3000/forms/chromium/convert/url"
  assert_success
  assert_output "200"
  run ddev exec "test -s chromium-default.pdf"
  assert_success
  run ddev exec "head -c 4 chromium-default.pdf"
  assert_output "%PDF"

  echo "Convert URL with Chromium (A5 paper)" >&3
  run ddev exec "curl -s -o chromium-a5.pdf -w '%{http_code}' -F url=https://render.com -F paperWidth=5.83 -F paperHeight=8.27 http://gotenberg:3000/forms/chromium/convert/url"
  assert_success
  assert_output "200"
  run ddev exec "test -s chromium-a5.pdf"
  assert_success
  run ddev exec "head -c 4 chromium-a5.pdf"
  assert_output "%PDF"

  echo "Convert URL with Chromium (landscape + scale 0.8)" >&3
  run ddev exec "curl -s -o chromium-landscape-scale.pdf -w '%{http_code}' -F url=https://render.com -F landscape=true -F scale=0.8 http://gotenberg:3000/forms/chromium/convert/url"
  assert_success
  assert_output "200"
  run ddev exec "test -s chromium-landscape-scale.pdf"
  assert_success
  run ddev exec "head -c 4 chromium-landscape-scale.pdf"
  assert_output "%PDF"

  echo "Convert HTML file with Chromium" >&3
  run ddev exec "cp resources/test-chromium.html resources/index.html"
  run ddev exec "curl -s -o chromium-html.pdf -w '%{http_code}' -F files=@resources/index.html http://gotenberg:3000/forms/chromium/convert/html"
  assert_success
  assert_output "200"
  run ddev exec "test -s chromium-html.pdf"
  assert_success
  run ddev exec "head -c 4 chromium-html.pdf"
  assert_output "%PDF"

  echo "Convert .docx with LibreOffice" >&3
  run ddev exec "curl -s -o libreoffice-docx.pdf -w '%{http_code}' -F files=@resources/test-libreoffice.docx http://gotenberg:3000/forms/libreoffice/convert"
  assert_success
  assert_output "200"
  run ddev exec "test -s libreoffice-docx.pdf"
  assert_success
  run ddev exec "head -c 4 libreoffice-docx.pdf"
  assert_output "%PDF"

  echo "Convert .xlsx with LibreOffice" >&3
  run ddev exec "curl -s -o libreoffice-xlsx.pdf -w '%{http_code}' -F files=@resources/test-libreoffice.xlsx http://gotenberg:3000/forms/libreoffice/convert"
  assert_success
  assert_output "200"
  run ddev exec "test -s libreoffice-xlsx.pdf"
  assert_success
  run ddev exec "head -c 4 libreoffice-xlsx.pdf"
  assert_output "%PDF"

  echo "Merge PDFs with PDFEngines" >&3
  run ddev exec "curl -s -o pdfengines-merge.pdf -w '%{http_code}' -F files=@resources/test-pdfengines-1.pdf -F files=@resources/test-pdfengines-2.pdf http://gotenberg:3000/forms/pdfengines/merge"
  assert_success
  assert_output "200"
  run ddev exec "test -s pdfengines-merge.pdf"
  assert_success
  run ddev exec "head -c 4 pdfengines-merge.pdf"
  assert_output "%PDF"

  echo "Chromium fail with invalid URL" >&3
  run ddev exec "curl -s -o /dev/null -w '%{http_code}' -F url=not-a-url http://gotenberg:3000/forms/chromium/convert/url"
  assert_success
  assert_output "500"

  echo "Chromium fail with missing URL parameter" >&3
  run ddev exec "curl -s -o /dev/null -w '%{http_code}' http://gotenberg:3000/forms/chromium/convert/url"
  assert_success
  assert_output "405"

  echo "Chromium HTML fail with invalid HTML file" >&3
  run ddev exec "curl -s -o /dev/null -w '%{http_code}' -F files=@resources/test-chromium.html http://gotenberg:3000/forms/chromium/convert/html"
  assert_success
  assert_output "400"

  echo "LibreOffice fail with not supported extension" >&3
  run ddev exec "curl -s -o /dev/null -w '%{http_code}' -F files=@resources/test-libreoffice.yaml http://gotenberg:3000/forms/libreoffice/convert"
  assert_success
  assert_output "400"
}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1
  # Persist TESTDIR if running inside GitHub Actions. Useful for uploading test result artifacts
  # See example at https://github.com/ddev/github-action-add-on-test#preserving-artifacts
  if [ -n "${GITHUB_ENV:-}" ]; then
    [ -e "${GITHUB_ENV:-}" ] && echo "TESTDIR=${HOME}/tmp/${PROJNAME}" >> "${GITHUB_ENV}"
  else
    [ "${TESTDIR}" != "" ] && rm -rf "${TESTDIR}"
  fi
}

@test "install from directory" {
  set -eu -o pipefail
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}
