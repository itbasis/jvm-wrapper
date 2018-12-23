#!/usr/bin/env bash

SCRIPT_FILE=build/jvmw

SCRIPT_PARTS="core properties download unpack core_oracle download_oracle core_openjdk download_openjdk main"

for f in ${SCRIPT_PARTS}; do
	shellcheck "./src/main/bash/jvmw/${f}.bash"
done

mkdir -p build
echo '#!/usr/bin/env bash' > ${SCRIPT_FILE}

# push build date
echo "# Build date: ${JVM_WRAPPER_VERSION}" >> ${SCRIPT_FILE}
echo "#" >> ${SCRIPT_FILE}

for f in ${SCRIPT_PARTS}; do
	awk '/^# BEGIN SCRIPT/{flag=1;next}/^# END SCRIPT/{flag=0}flag' <"src/main/bash/jvmw/${f}.bash" >> ${SCRIPT_FILE}
done

awk 'NF' < ${SCRIPT_FILE} > t && mv t ${SCRIPT_FILE}

shellcheck ${SCRIPT_FILE}

chmod +x ${SCRIPT_FILE}
