SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
TOTAL_RAM_GB=$(powershell -Command "[math]::Floor((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)" 2>/dev/null)
if [ -z "$TOTAL_RAM_GB" ] || [ "$TOTAL_RAM_GB" -lt 1 ]; then
    TOTAL_RAM_GB=8
fi
if [ -f $SCRIPT_DIR/mork_ffi/target/release/libmork_ffi.so ]; then
    LD_PRELOAD=$SCRIPT_DIR/mork_ffi/target/release/libmork_ffi.so \
    swipl --stack_limit=${TOTAL_RAM_GB}g -q -s $SCRIPT_DIR/src/main.pl -- "$@" mork
else
    swipl --stack_limit=${TOTAL_RAM_GB}g -q -s $SCRIPT_DIR/src/main.pl -- "$@"
fi
