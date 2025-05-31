set -xe

if ! [ -e ppsspp ]
then
	git clone --recurse-submodules https://github.com/hrydgard/ppsspp.git
fi

cd ppsspp

if [ "$WORKSPACE" == true ]
then
	bash -l
	exit 0
fi

if [ "$RUN" == "true" ]
then
	BIN_PATH=$(realpath build/PPSSPPSDL)
	if ! [ -e "$BIN_PATH" ]
	then
		echo please first build ppsspp
		exit 1
	fi

	export LD_LIBRARY_PATH="/work_dir/sdl_test:$LD_LIBRARY_PATH"
	if [ "$DEBUG" == true ]
	then
		gdb $BIN_PATH
	else
		$BIN_PATH
	fi

	exit 0
fi

if [ "$CLEAN_BUILD" == "true" ]
then
	rm -r build
fi
mkdir -p build
cd build

if [ "$DEBUG" == true ]
then
	BUILD_TYPE=Debug
else
	BUILD_TYPE=Release
fi

cmake .. \
	-DCMAKE_BUILD_TYPE=$BUILD_TYPE

make -j$(nproc)
