## *
##  @file mii.h
##  @brief Mii services (mii:*) IPC wrapper.
##  @author XorTroll
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  MiiServiceType* = enum
    MiiServiceTypeSystem = 0,   ## /< Initializes mii:e.
    MiiServiceTypeUser = 1      ## /< Initializes mii:u.


## / Mii age.

type
  MiiAge* = enum
    MiiAgeYoung = 0,            ## /< Young
    MiiAgeNormal = 1,           ## /< Normal
    MiiAgeOld = 2,              ## /< Old
    MiiAgeAll = 3               ## /< All of them


## / Mii gender.

type
  MiiGender* = enum
    MiiGenderMale = 0,          ## /< Male
    MiiGenderFemale = 1,        ## /< Female
    MiiGenderAll = 2            ## /< Both of them


## / Mii face color.

type
  MiiFaceColor* = enum
    MiiFaceColorBlack = 0,      ## /< Black
    MiiFaceColorWhite = 1,      ## /< White
    MiiFaceColorAsian = 2,      ## /< Asian
    MiiFaceColorAll = 3         ## /< All of them


##  Mii source flag.

type
  MiiSourceFlag* = enum
    MiiSourceFlagDatabase = bit(0), ## /< Miis created by the user
    MiiSourceFlagDefault = bit(1), ## /< Default console miis
    MiiSourceFlagAll = MiiSourceFlagDatabase.cint or MiiSourceFlagDefault.cint ## /< All of them


##  Mii special key code

type
  MiiSpecialKeyCode* = enum
    MiiSpecialKeyCodeNormal = 0, ## /< Normal miis
    MiiSpecialKeyCodeSpecial = 0xA523B78F ## /< Special miis
  MiiDatabase* {.bycopy.} = object
    s*: Service



##  Mii create ID.

type
  MiiCreateId* {.bycopy.} = object
    uuid*: Uuid


##  Mii data structure.

type
  MiiCharInfo* {.bycopy.} = object
    createId*: MiiCreateId
    miiName*: array[10 + 1, U16]  ## /< utf-16be, null-terminated
    unkX26*: U8
    miiColor*: U8
    miiSex*: U8
    miiHeight*: U8
    miiWidth*: U8
    unkX2b*: array[2, U8]
    miiFaceShape*: U8
    miiFaceColor*: U8
    miiWrinklesStyle*: U8
    miiMakeupStyle*: U8
    miiHairStyle*: U8
    miiHairColor*: U8
    miiHasHairFlipped*: U8
    miiEyeStyle*: U8
    miiEyeColor*: U8
    miiEyeSize*: U8
    miiEyeThickness*: U8
    miiEyeAngle*: U8
    miiEyePosX*: U8
    miiEyePosY*: U8
    miiEyebrowStyle*: U8
    miiEyebrowColor*: U8
    miiEyebrowSize*: U8
    miiEyebrowThickness*: U8
    miiEyebrowAngle*: U8
    miiEyebrowPosX*: U8
    miiEyebrowPosY*: U8
    miiNoseStyle*: U8
    miiNoseSize*: U8
    miiNosePos*: U8
    miiMouthStyle*: U8
    miiMouthColor*: U8
    miiMouthSize*: U8
    miiMouthThickness*: U8
    miiMouthPos*: U8
    miiFacialHairColor*: U8
    miiBeardStyle*: U8
    miiMustacheStyle*: U8
    miiMustacheSize*: U8
    miiMustachePos*: U8
    miiGlassesStyle*: U8
    miiGlassesColor*: U8
    miiGlassesSize*: U8
    miiGlassesPos*: U8
    miiHasMole*: U8
    miiMoleSize*: U8
    miiMolePosX*: U8
    miiMolePosY*: U8
    unkX57*: U8

proc miiInitialize*(serviceType: MiiServiceType): Result {.cdecl,
    importc: "miiInitialize".}
## / Initialize mii.

proc miiExit*() {.cdecl, importc: "miiExit".}
## / Exit mii.

proc miiGetServiceSession*(): ptr Service {.cdecl, importc: "miiGetServiceSession".}
## / Gets the Service object for the actual mii service session.

proc miiOpenDatabase*(`out`: ptr MiiDatabase; keyCode: MiiSpecialKeyCode): Result {.
    cdecl, importc: "miiOpenDatabase".}
## *
##  @brief Opens a mii database.
##  @param[in] key_code Mii key code filter.
##  @param[out] out Database.
##

proc miiDatabaseIsUpdated*(db: ptr MiiDatabase; outUpdated: ptr bool;
                          flag: MiiSourceFlag): Result {.cdecl,
    importc: "miiDatabaseIsUpdated".}
## *
##  @brief Returns whether the mii database is updated.
##  @param[in] db Database.
##  @param[in] flag Source flag.
##  @param[out] out_updated Whether the mii database is updated.
##

proc miiDatabaseIsFull*(db: ptr MiiDatabase; outFull: ptr bool): Result {.cdecl,
    importc: "miiDatabaseIsFull".}
## *
##  @brief Returns whether the mii database is full.
##  @param[in] db Database.
##  @param[out] out_full Whether the mii database is full.
##

proc miiDatabaseGetCount*(db: ptr MiiDatabase; outCount: ptr S32; flag: MiiSourceFlag): Result {.
    cdecl, importc: "miiDatabaseGetCount".}
## *
##  @brief Returns number of miis in the database with the specified source flag.
##  @param[in] db Database.
##  @param[in] flag Source flag.
##  @param[out] out_count Out mii count.
##

proc miiDatabaseGet1*(db: ptr MiiDatabase; flag: MiiSourceFlag;
                     outInfos: ptr MiiCharInfo; count: S32; totalOut: ptr S32): Result {.
    cdecl, importc: "miiDatabaseGet1".}
## *
##  @brief Reads mii charinfo data from the specified source flag.
##  @param[in] db Database.
##  @param[in] flag Source flag.
##  @param[out] out_infos Output mii charinfo array.
##  @param[in] count Number of mii chainfos to read.
##  @param[out] total_out Number of mii charinfos which were actually read.
##

proc miiDatabaseBuildRandom*(db: ptr MiiDatabase; age: MiiAge; gender: MiiGender;
                            faceColor: MiiFaceColor; outInfo: ptr MiiCharInfo): Result {.
    cdecl, importc: "miiDatabaseBuildRandom".}
## *
##  @brief Generates a random mii charinfo (doesn't register it in the console database).
##  @param[in] db Database.
##  @param[in] age Mii's age.
##  @param[in] gender Mii's gender.
##  @param[in] face_color Mii's face color.
##  @param[out] out_info Out mii charinfo data.
##

proc miiDatabaseClose*(db: ptr MiiDatabase) {.cdecl, importc: "miiDatabaseClose".}
## / Closes a mii database.

