switch("passC", "-I" & thisDir() & "/../../src/libnx/wrapper/nx/include")
switch("passL", "-specs=" & thisDir() & "/../../src/libnx/wrapper/nx/switch.specs -L" & thisDir() & "/../../src/libnx/wrapper/nx/lib -lnx")
#switch("passC", "-I$DEVKITPRO/libnx/include")
#switch("passL", "-specs=$DEVKITPRO/libnx/switch.specs -L$DEVKITPRO/libnx/lib -lnx")
