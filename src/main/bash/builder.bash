#!/usr/bin/env bash

SCRIPT_FILE=build/jvmw

mkdir -p build
echo '#!/usr/bin/env bash' > ${SCRIPT_FILE}

for f in 'core' 'properties' 'download_oracle' 'unpack_oracle' 'main'; do
	awk '/^# BEGIN SCRIPT/{flag=1;next}/^# END SCRIPT/{flag=0}flag' <"src/main/bash/jvmw/${f}.bash" >> ${SCRIPT_FILE}
done

awk 'NF' < ${SCRIPT_FILE} > t && mv t ${SCRIPT_FILE}