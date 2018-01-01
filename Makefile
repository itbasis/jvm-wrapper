.PHONY: check validate clean
SHELL=/bin/bash
export XDG_CONFIG_HOME=.
tmpfile=`mktemp`

clean:
	rm -Rf ./build/ jvmw.properties

validate:
	shellcheck ./tests.sh
	pycodestyle ./jdkw

check: clean validate
	JDK_FAMILY='8' CHECK_JDK_VERSION='1.8.0' ./tests.sh
	JVMW_FILE='jvmw.8.properties' CHECK_JDK_VERSION='1.8.0' ./tests.sh || { rm jvmw.properties; exit $$?; }
	JVMW_FILE='jvmw.8u152.properties' CHECK_JDK_VERSION='1.8.0_152' ./tests.sh || { rm jvmw.properties; exit $$?; }

	JDK_FAMILY='9' CHECK_JDK_VERSION='9.0.1' ./tests.sh
	JVMW_FILE='jvmw.9.properties' CHECK_JDK_VERSION='9.0.1' ./tests.sh || { rm jvmw.properties; exit $$?; }

	mkdir -p t; cp jdkw t/jdkw; JDK_FAMILY='8' CHECK_JDK_VERSION='1.8.0' ./tests.sh t/jdkw || { rm -Rf t/; exit $$?; }; rm -Rf t/
	mkdir -p t; cp jdkw t/jdkw; JVMW_FILE='jvmw.8.properties' CHECK_JDK_VERSION='1.8.0' ./tests.sh t/jdkw || { rm -Rf t/ jvmw.properties; exit $$?; }; rm -Rf t/ jvmw.properties