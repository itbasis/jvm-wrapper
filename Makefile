.PHONY: check build validate clean
SHELL=/bin/bash

clean:
	rm -Rf ./build/

validate:
	for f in ./jdk_scripts/*; do \
		echo "shellcheck $$f file..."; \
		shellcheck $$f || exit 1; \
	done
	shellcheck -x ./jdkw

check: clean validate
	@mkdir -p ./build/test
	@[[ `JDK_VERSION=8 ./jdkw javac -version 2>&1` == *"1.8.0"* ]] || { echo "-1-"; JDK_VERSION=8 ./jdkw javac -version 2>&1; exit 1; }
	@[[ `./jdkw javac -version 2>&1` == *"9.0.1"* ]] || { echo "-2-"; ./jdkw javac -version 2>&1; exit 1; }
	@[[ `./jdkw java -version 2>&1` == *"9.0.1"* ]] || { echo "-3-"; ./jdkw java -version 2>&1; exit 1; }
	./jdkw javac -d ./build/test test/Test.java
	@[[ `./jdkw java -cp ./build/test/ Test` == "test done." ]] || { echo "-4-"; exit 1; }

build: clean validate
	mkdir -p ./build
	cp ./jdkw ./build/
	for f in ./jdk_scripts/*; do \
		echo "Processing $$f file..."; \
		sed -i.bak -e "\|source $$f| r $$f" -e "\|source $$f|d" ./build/jdkw; \
	done
	sed -i.bak -E "/^[[:blank:]]+>&2[[:blank:]]+.*/d" ./build/jdkw
	rm ./build/jdkw.bak
	shellcheck ./build/jdkw
	./build/jdkw java -version
