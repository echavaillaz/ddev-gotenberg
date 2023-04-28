setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-gotenberg
  mkdir -p $TESTDIR
  export PROJNAME=test-gotenberg
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  echo "# Setting up project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  cp -R ${DIR}/tests/testdata/* .
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  ddev exec curl --request POST http://gotenberg:3000/forms/chromium/convert/url --form url=https://render.com --output chromium.pdf
  ddev exec test -s chromium.pdf || ( printf "PDF is empty or cannot be checked" && exit 1 )
  ddev exec curl --request POST http://gotenberg:3000/forms/libreoffice/convert --form files=@resources/test-libreoffice.docx --output libreoffice.pdf
  ddev exec test -s libreoffice.pdf || ( printf "PDF is empty or cannot be checked" && exit 1 )
  ddev exec curl --request POST http://gotenberg:3000/forms/pdfengines/merge --form files=@resources/test-pdfengines-1.pdf --form files=@resources/test-pdfengines-2.pdf --output pdfengines.pdf
  ddev exec test -s pdfengines.pdf || ( printf "PDF is empty or cannot be checked" && exit 1 )
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get echavaillaz/ddev-gotenberg with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get echavaillaz/ddev-gotenberg
  ddev restart >/dev/null
  ddev exec curl --request POST http://gotenberg:3000/forms/chromium/convert/url --form url=https://render.com --output chromium.pdf
  ddev exec test -s chromium.pdf || ( printf "PDF is empty or cannot be checked" && exit 1 )
  ddev exec curl --request POST http://gotenberg:3000/forms/libreoffice/convert --form files=@resources/test-libreoffice.docx --output libreoffice.pdf
  ddev exec test -s libreoffice.pdf || ( printf "PDF is empty or cannot be checked" && exit 1 )
  ddev exec curl --request POST http://gotenberg:3000/forms/pdfengines/merge --form files=@resources/test-pdfengines-1.pdf --form files=@resources/test-pdfengines-2.pdf --output pdfengines.pdf
  ddev exec test -s pdfengines.pdf || ( printf "PDF is empty or cannot be checked" && exit 1 )
}
