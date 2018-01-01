.PHONY: check validate clean
SHELL=/bin/bash
export XDG_CONFIG_HOME=.

clean:
	rm -Rf ./build/ jvmw.properties

validate:
	command -v travis || gem install travis --no-rdoc --no-ri
	travis lint ./.travis.yml
	shellcheck ./tests.sh
	pycodestyle ./jdkw

check: clean validate
	JDK_FAMILY='8' CHECK_JDK_VERSION='1.8.0' ./tests.sh
	JVMW_FILE='jvmw.8.properties' CHECK_JDK_VERSION='1.8.0' ./tests.sh || { rm jvmw.properties; exit $$?; }; rm jvmw.properties
	JVMW_FILE='jvmw.8u152.properties' CHECK_JDK_VERSION='1.8.0_152' ./tests.sh || { rm jvmw.properties; exit $$?; }; rm jvmw.properties

	JDK_FAMILY='9' CHECK_JDK_VERSION='9.0.1' ./tests.sh
	JVMW_FILE='jvmw.9.properties' CHECK_JDK_VERSION='9.0.1' ./tests.sh || { rm jvmw.properties; exit $$?; }; rm jvmw.properties
	{ JVMW_FILE='incorrect.jvmw.9u152.properties' CHECK_JDK_VERSION='9.0.1_152' ./tests.sh 2>/dev/null || { rm jvmw.properties; exit 0; }; } && { rm jvmw.properties; exit 1; }

	mkdir -p build; cp jdkw build/jdkw; JDK_FAMILY='8' CHECK_JDK_VERSION='1.8.0' ./tests.sh build/jdkw || { rm -Rf build/; exit $$?; }; rm -Rf build/
	mkdir -p build; cp jdkw build/jdkw; JVMW_FILE='jvmw.8.properties' CHECK_JDK_VERSION='1.8.0' ./tests.sh build/jdkw || { rm -Rf build/ jvmw.properties; exit $$?; }; rm -Rf build/ jvmw.properties