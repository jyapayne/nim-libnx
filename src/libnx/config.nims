switch("passC", "-I" & thisDir() & "/wrapper/nx/include")
switch("passL", "-specs=" & thisDir() & "/wrapper/nx/switch.specs -L" & thisDir() & "/wrapper/nx/lib -lnx")
#switch("passC", "-I$DEVKITPRO/libnx/include")
#switch("passL", "-specs=$DEVKITPRO/libnx/switch.specs -L$DEVKITPRO/libnx/lib -lnx")
