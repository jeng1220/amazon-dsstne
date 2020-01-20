SHELL=/bin/sh
VPATH=

# Prefix of the directory to install dsstne.
PREFIX ?= $(shell pwd)/amazon-dsstne

# Build directory. Export it for sub-makefiles to use it
export BUILD_DIR ?= $(shell pwd)/build

all: | engine runtime utils tests java

engine: nvtx.o
	cd src/amazon/dsstne/engine && make

utils: nvtx.o
	cd src/amazon/dsstne/utils && make

runtime: nvtx.o
	cd src/amazon/dsstne/runtime && make

tests:
	cd tst && make

nvtx.o: src/amazon/dsstne/nvtx.cpp
	mpiCC -export-dynamic -fPIC -I/usr/local/cuda/include -c -o $(BUILD_DIR)/nvtx.o src/amazon/dsstne/nvtx.cpp

#java: | engine runtime tests
#	cd java && make

install: all
	mkdir -p $(PREFIX)
	cp -rfp $(BUILD_DIR)/lib $(PREFIX)
	cp -rfp $(BUILD_DIR)/bin $(PREFIX)
	cp -rfp $(BUILD_DIR)/include $(PREFIX)

run-tests:
	cd tst && make run-tests

clean:
	cd src/amazon/dsstne/engine && make clean
	cd src/amazon/dsstne/utils && make clean
	cd tst && make clean

#.PHONY: engine runtime tests java clean 
