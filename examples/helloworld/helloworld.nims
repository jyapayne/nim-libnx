let buildDir = "build"
let dkpPath = getEnv("DEVKITPRO")
let toolsPath = dkpPath & "/tools/bin"
let dkpCompilerPath = dkpPath & "/devkitA64/bin"

switch("path", toolsPath)
switch("path", dkpCompilerPath)

task build, "Build hello world":

  let author = "Unspecified Author"
  let version = "1.0.0"

  if existsDir buildDir:
    rmDir buildDir

  echo "Building..."

  mkDir buildDir


  exec "nim c --os:nintendoswitch helloworld.nim"

  echo "Making nso..."
  exec "elf2nso helloworld.elf " & buildDir & "/helloworld.nso"
  
  echo "Making pfs0..."
  mkdir buildDir & "/exefs"
  exec "cp " & buildDir & "/helloworld.nso " & buildDir & "/exefs/main"
  exec "build_pfs0 " & buildDir & "/exefs " & buildDir & "/helloworld.pfs0"
  
  echo "Making lst..."
  exec "aarch64-none-elf-gcc-nm helloworld.elf > " & buildDir & "/helloworld.lst"

  echo "Making nacp..."
  # Some meta data for the homebrew launcher
  exec "nacptool --create helloworld '" & author & "' '" & version & "' " & buildDir & "/helloworld.nacp"

  echo "Making nro..."
  # This is the important one. The above are just extras.
  exec "elf2nro helloworld.elf helloworld.nro --icon=" & dkpPath & "/libnx/default_icon.jpg --nacp=" & buildDir & "/helloworld.nacp"

  echo "Done! helloworld.nro is now in the current directory."
  echo "Other build files are in the build folder."

task clean, "Cleanup files":
  if existsDir buildDir:
    rmDir buildDir

  if existsDir "nimcache":
    rmDir "nimcache"

  if existsFile "helloworld.elf":
    rmFile "helloworld.elf"

  if existsFile "helloworld.nro":
    rmFile "helloworld.nro"
