#!/data/data/com.termux/files/usr/bin/bash
# Build the Godot editor natively in Termux (Fathom / Quest 3, aarch64).
# Settings follow termux-packages' x11-packages/godot recipe, but use Godot's
# bundled thirdparty libs (so master doesn't depend on Termux lib versions)
# and skip Wayland (we run under Termux:X11). SDL is the exception: the
# bundled copy compiles Android-only code under Termux, so use system sdl3.
#
#   ./build-termux.sh            editor build, -j4
#   JOBS=6 ./build-termux.sh     more parallel jobs (watch RAM: ~7 GB total)
#   ./build-termux.sh target=template_release   extra scons args pass through
#
# Output: bin/godot.linuxbsd.editor.arm64.llvm  (run with ~/bin/godot-gpu-style env
# for the VirGL GPU, or plain for llvmpipe).
set -e
cd "$(dirname "$0")"
JOBS=${JOBS:-4}
export BUILD_NAME=jazzy
exec scons -j"$JOBS" \
	platform=linuxbsd \
	target=editor \
	arch=arm64 \
	use_llvm=yes \
	linker=lld \
	use_static_cpp=no \
	alsa=no \
	pulseaudio=yes \
	udev=no \
	wayland=no \
	execinfo=yes \
	module_camera_enabled=no \
	builtin_sdl=no \
	system_certs_path="$PREFIX/etc/tls/cert.pem" \
	linkflags="-landroid-execinfo" \
	CPPPATH="$PREFIX/include" \
	LIBPATH="$PREFIX/lib" \
	"$@"
