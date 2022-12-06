## *
##  @file set.h
##  @brief Settings services IPC wrapper.
##  @author plutoo
##  @author yellows8
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../services/time, ../services/acc, ../services/fs,
  ../services/btdrv_types, ../services/btm_types, ../sf/service

const
  SET_MAX_NAME_SIZE* = 0x48

type
  ColorSetId* = enum
    ColorSetIdLight = 0, ColorSetIdDark = 1


## / Console Product Models

type
  SetSysProductModel* = enum
    SetSysProductModelInvalid = 0, ## /< Invalid Model
    SetSysProductModelNx = 1,   ## /< Erista Model
    SetSysProductModelCopper = 2, ## /< Erista "Simulation" Model
    SetSysProductModelIowa = 3, ## /< Mariko Model
    SetSysProductModelHoag = 4, ## /< Mariko Lite Model
    SetSysProductModelCalcio = 5, ## /< Mariko "Simulation" Model
    SetSysProductModelAula = 6  ## /< Mariko Pro Model(?)


## / IDs for Language.

type
  SetLanguage* = enum
    SetLanguageJA = 0,          ## /< Japanese
    SetLanguageENUS = 1,        ## /< US English ("AmericanEnglish")
    SetLanguageFR = 2,          ## /< French
    SetLanguageDE = 3,          ## /< German
    SetLanguageIT = 4,          ## /< Italian
    SetLanguageES = 5,          ## /< Spanish
    SetLanguageZHCN = 6,        ## /< Simplified Chinese ("Chinese")
    SetLanguageKO = 7,          ## /< Korean
    SetLanguageNL = 8,          ## /< Dutch
    SetLanguagePT = 9,          ## /< Portuguese
    SetLanguageRU = 10,         ## /< Russian
    SetLanguageZHTW = 11,       ## /< Traditional Chinese ("Taiwanese")
    SetLanguageENGB = 12,       ## /< GB English ("BritishEnglish")
    SetLanguageFRCA = 13,       ## /< CA French ("CanadianFrench")
    SetLanguageES419 = 14,      ## /< "LatinAmericanSpanish"
    SetLanguageZHHANS = 15,     ## /< [4.0.0+] ChineseSimplified
    SetLanguageZHHANT = 16,     ## /< [4.0.0+] ChineseTraditional
    SetLanguagePTBR = 17,       ## /< [10.1.0+] "BrazilianPortuguese"
    SetLanguageTotal          ## /< Total languages supported by this enum.


## / Region codes.

type
  SetRegion* = enum
    SetRegionJPN = 0,           ## /< Japan
    SetRegionUSA = 1,           ## /< The Americas
    SetRegionEUR = 2,           ## /< Europe
    SetRegionAUS = 3,           ## /< Australia/New Zealand
    SetRegionHTK = 4,           ## /< Hong Kong/Taiwan/Korea
    SetRegionCHN = 5            ## /< China


## / ConnectionFlag

type
  SetSysConnectionFlag* = enum
    SetSysConnectionFlagConnectAutomaticallyFlag = bit(0),
    SetSysConnectionFlagUnknown = bit(1)


## / AccessPointSecurityType

type
  SetSysAccessPointSecurityType* = enum
    SetSysAccessPointSecurityTypeNone = 0, SetSysAccessPointSecurityTypeShared = 1,
    SetSysAccessPointSecurityTypeWpa = 2, SetSysAccessPointSecurityTypeWpa2 = 3


## / AccessPointSecurityStandard

type
  SetSysAccessPointSecurityStandard* = enum
    SetSysAccessPointSecurityStandardNone = 0,
    SetSysAccessPointSecurityStandardWep = 1,
    SetSysAccessPointSecurityStandardWpa = 2


## / AutoSettings

type
  SetSysAutoSettings* = enum
    SetSysAutoSettingsAutoIp = bit(0), SetSysAutoSettingsAutoDns = bit(1)


## / ProxyFlags

type
  SetSysProxyFlags* = enum
    SetSysProxyFlagsUseProxyFlag = bit(0),
    SetSysProxyFlagsProxyAutoAuthenticateFlag = bit(1)


## / UserSelectorFlag

type
  SetSysUserSelectorFlag* = enum
    SetSysUserSelectorFlagSkipsIfSingleUser = bit(0)


## / EulaVersionClockType

type
  SetSysEulaVersionClockType* = enum
    SetSysEulaVersionClockTypeNetworkSystemClock = 0,
    SetSysEulaVersionClockTypeSteadyClock = 1


## / NotificationVolume

type
  SetSysNotificationVolume* = enum
    SetSysNotificationVolumeMute = 0, SetSysNotificationVolumeLow = 1,
    SetSysNotificationVolumeHigh = 2


## / FriendPresenceOverlayPermission

type
  SetSysFriendPresenceOverlayPermission* = enum
    SetSysFriendPresenceOverlayPermissionNotConfirmed = 0,
    SetSysFriendPresenceOverlayPermissionNoDisplay = 1,
    SetSysFriendPresenceOverlayPermissionFavoriteFriends = 2,
    SetSysFriendPresenceOverlayPermissionFriends = 3


## / AudioDevice

type
  SetSysAudioDevice* = enum
    SetSysAudioDeviceConsole = 0, SetSysAudioDeviceHeadphone = 1,
    SetSysAudioDeviceTv = 2


## / PrimaryAlbumStorage

type
  SetSysPrimaryAlbumStorage* = enum
    SetSysPrimaryAlbumStorageNand = 0, SetSysPrimaryAlbumStorageSdCard = 1


## / HandheldSleepPlan

type
  SetSysHandheldSleepPlan* = enum
    SetSysHandheldSleepPlan1Min = 0, SetSysHandheldSleepPlan3Min = 1,
    SetSysHandheldSleepPlan5Min = 2, SetSysHandheldSleepPlan10Min = 3,
    SetSysHandheldSleepPlan30Min = 4, SetSysHandheldSleepPlanNever = 5


## / ConsoleSleepPlan

type
  SetSysConsoleSleepPlan* = enum
    SetSysConsoleSleepPlan1Hour = 0, SetSysConsoleSleepPlan2Hour = 1,
    SetSysConsoleSleepPlan3Hour = 2, SetSysConsoleSleepPlan6Hour = 3,
    SetSysConsoleSleepPlan12Hour = 4, SetSysConsoleSleepPlanNever = 5


## / AudioOutputModeTarget

type
  SetSysAudioOutputModeTarget* = enum
    SetSysAudioOutputModeTargetUnknown0 = 0,
    SetSysAudioOutputModeTargetUnknown1 = 1,
    SetSysAudioOutputModeTargetUnknown2 = 2,
    SetSysAudioOutputModeTargetUnknown3 = 3


## / AudioOutputMode

type
  SetSysAudioOutputMode* = enum
    SetSysAudioOutputModeUnknown1 = 1 ## /< Default value.


## / ServiceDiscoveryControlSettings

type
  SetSysServiceDiscoveryControlSettings* = enum
    SetSysServiceDiscoveryControlSettingsIsChangeEnvironmentIdentifierDisabled = bit(
        0)


## / ErrorReportSharePermission

type
  SetSysErrorReportSharePermission* = enum
    SetSysErrorReportSharePermissionNotConfirmed = 0,
    SetSysErrorReportSharePermissionGranted = 1,
    SetSysErrorReportSharePermissionDenied = 2


## / KeyboardLayout

type
  SetKeyboardLayout* = enum
    SetKeyboardLayoutJapanese = 0, SetKeyboardLayoutEnglishUs = 1,
    SetKeyboardLayoutEnglishUsInternational = 2, SetKeyboardLayoutEnglishUk = 3,
    SetKeyboardLayoutFrench = 4, SetKeyboardLayoutFrenchCa = 5,
    SetKeyboardLayoutSpanish = 6, SetKeyboardLayoutSpanishLatin = 7,
    SetKeyboardLayoutGerman = 8, SetKeyboardLayoutItalian = 9,
    SetKeyboardLayoutPortuguese = 10, SetKeyboardLayoutRussian = 11,
    SetKeyboardLayoutKorean = 12, SetKeyboardLayoutChineseSimplified = 13,
    SetKeyboardLayoutChineseTraditional = 14


## / ChineseTraditionalInputMethod

type
  SetChineseTraditionalInputMethod* = enum
    SetChineseTraditionalInputMethodUnknown1 = 1,
    SetChineseTraditionalInputMethodUnknown2 = 2


## / PtmCycleCountReliability

type
  SetSysPtmCycleCountReliability* = enum
    PtmCycleCountReliabilityDefault = 0, PtmCycleCountReliabilityUnk = 1


## / PlatformRegion. Other values not listed here should be handled as "Unknown".

type
  SetSysPlatformRegion* = enum
    SetSysPlatformRegionGlobal = 1, SetSysPlatformRegionChina = 2


## / TouchScreenMode, for "Touch-Screen Sensitivity".

type
  SetSysTouchScreenMode* = enum
    SetSysTouchScreenModeStylus = 0, ## /< Stylus.
    SetSysTouchScreenModeStandard = 1 ## /< Standard, the default.


## / BlockType

type
  SetSysBlockType* = enum
    SetSysBlockTypeAudio = 1, SetSysBlockTypeVideo = 2,
    SetSysBlockTypeVendorSpecific = 3, SetSysBlockTypeSpeaker = 4


## / ControllerType

type
  SetSysControllerType* = enum
    SetSysControllerTypeJoyConR = 1, SetSysControllerTypeJoyConL = 2,
    SetSysControllerTypeProCon = 3


## / BatteryLot

type
  SetBatteryLot* {.bycopy.} = object
    lot*: array[0x18, char]     ## /< BatteryLot string.


## / NetworkSettings

type
  SetSysNetworkSettings* {.bycopy.} = object
    name*: array[0x40, char]
    uuid*: Uuid
    connectionFlags*: U32      ## /< Bitmask with \ref SetSysConnectionFlag.
    wiredFlag*: U32
    connectToHiddenNetwork*: U32 ## /< Bitmask with UseStealthNetworkFlag.
    accessPointSsid*: array[0x20, char]
    accessPointSsidLen*: U32
    accessPointSecurityType*: U32 ## /< Bitmask with \ref SetSysAccessPointSecurityType.
    accessPointSecurityStandard*: U32 ## /< Bitmask with \ref SetSysAccessPointSecurityStandard.
    accessPointPassphrase*: array[0x40, char]
    accessPointPassphraseLen*: U32
    autoSettings*: U32         ## /< Bitmask with \ref SetSysAutoSettings.
    manualIpAddress*: U32
    manualSubnetMask*: U32
    manualGateway*: U32
    primaryDns*: U32
    secondaryDns*: U32
    proxyFlags*: U32           ## /< Bitmask with \ref SetSysProxyFlags.
    proxyServer*: array[0x80, char]
    proxyPort*: U16
    padding1*: U16
    proxyAutoauthUser*: array[0x20, char]
    proxyAutoauthPass*: array[0x20, char]
    mtu*: U16
    padding2*: U16


## / LcdBacklightBrightnessMapping

type
  SetSysLcdBacklightBrightnessMapping* {.bycopy.} = object
    brightnessAppliedToBacklight*: cfloat
    ambientLightSensorValue*: cfloat
    unkX8*: cfloat


## / BacklightSettings

type
  SetSysBacklightSettings* {.bycopy.} = object
    autoBrightnessFlags*: U32
    screenBrightness*: cfloat
    brightnessMapping*: SetSysLcdBacklightBrightnessMapping
    unkX14*: cfloat
    unkX18*: cfloat
    unkX1C*: cfloat
    unkX20*: cfloat
    unkX24*: cfloat


## / BacklightSettingsEx

type
  SetSysBacklightSettingsEx* {.bycopy.} = object
    autoBrightnessFlags*: U32
    screenBrightness*: cfloat
    currentBrightnessForVrMode*: cfloat
    brightnessMapping*: SetSysLcdBacklightBrightnessMapping
    unkX18*: cfloat
    unkX1C*: cfloat
    unkX20*: cfloat
    unkX24*: cfloat
    unkX28*: cfloat


## / BluetoothDevicesSettings

type
  INNER_C_STRUCT_set_5* {.bycopy.} = object
    pad*: U8                   ## /< Padding
    name2*: array[0xF9, char]   ## /< Name

  INNER_C_UNION_set_4* {.bycopy, union.} = object
    reserved*: array[0x12B, U8] ## /< Reserved [1.0.0-12.1.0]
    anoSet6*: INNER_C_STRUCT_set_5

  SetSysBluetoothDevicesSettings* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    name*: BtmBdName           ## /< BdName. Unused on 13.0.0+
    classOfDevice*: BtmClassOfDevice ## /< ClassOfDevice
    linkKey*: array[0x10, U8]   ## /< LinkKey
    linkKeyPresent*: U8        ## /< LinkKeyPresent
    version*: U16              ## /< Version
    trustedServices*: U32      ## /< TrustedServices
    vid*: U16                  ## /< Vid
    pid*: U16                  ## /< Pid
    subClass*: U8              ## /< SubClass
    attributeMask*: U8         ## /< AttributeMask
    descriptorLength*: U16     ## /< DescriptorLength
    descriptor*: array[0x80, U8] ## /< Descriptor
    keyType*: U8               ## /< KeyType
    deviceType*: U8            ## /< DeviceType
    brrSize*: U16              ## /< BrrSize
    brr*: array[0x9, U8]        ## /< Brr
    anoSet7*: INNER_C_UNION_set_4


## / Structure returned by \ref setsysGetFirmwareVersion.

type
  SetSysFirmwareVersion* {.bycopy.} = object
    major*: U8
    minor*: U8
    micro*: U8
    padding1*: U8
    revisionMajor*: U8
    revisionMinor*: U8
    padding2*: U8
    padding3*: U8
    platform*: array[0x20, char]
    versionHash*: array[0x40, char]
    displayVersion*: array[0x18, char]
    displayTitle*: array[0x80, char]


## / Structure returned by \ref setsysGetFirmwareVersionDigest.

type
  SetSysFirmwareVersionDigest* {.bycopy.} = object
    digest*: array[0x40, char]


## / Structure returned by \ref setsysGetSerialNumber.

type
  SetSysSerialNumber* {.bycopy.} = object
    number*: array[0x18, char]


## / DeviceNickName

type
  SetSysDeviceNickName* {.bycopy.} = object
    nickname*: array[0x80, char]


## / UserSelectorSettings

type
  SetSysUserSelectorSettings* {.bycopy.} = object
    flags*: U32                ## /< Bitmask with \ref SetSysUserSelectorFlag.


## / AccountSettings

type
  SetSysAccountSettings* {.bycopy.} = object
    settings*: SetSysUserSelectorSettings

  SetSysAudioVolume* {.bycopy.} = object
    unkX0*: U32                ## /< 0 for Console and Tv, 2 for Headphones.
    volume*: U8                ## /< From 0-15.


## / EulaVersion

type
  SetSysEulaVersion* {.bycopy.} = object
    version*: U32
    regionCode*: S32
    clockType*: S32            ## /< \ref SetSysEulaVersionClockType
    pad*: U32
    networkClockTime*: U64     ## /< POSIX timestamp.
    steadyClockTime*: TimeSteadyClockTimePoint ## /< \ref TimeSteadyClockTimePoint


## / NotificationTime

type
  SetSysNotificationTime* {.bycopy.} = object
    hour*: S32
    minute*: S32


## / NotificationSettings

type
  SetSysNotificationSettings* {.bycopy.} = object
    flags*: U32                ## /< Bitmask with NotificationFlag.
    volume*: S32               ## /< \ref SetSysNotificationVolume
    startTime*: SetSysNotificationTime ## /< \ref SetSysNotificationTime
    endTime*: SetSysNotificationTime ## /< \ref SetSysNotificationTime


## / AccountNotificationSettings

type
  SetSysAccountNotificationSettings* {.bycopy.} = object
    uid*: AccountUid           ## /< \ref AccountUid
    flags*: U32                ## /< Bitmask with AccountNotificationFlag.
    friendPresenceOverlayPermission*: S8 ## /< \ref SetSysFriendPresenceOverlayPermission
    pad*: array[3, U8]          ## /< Padding.


## / TvSettings

type
  INNER_C_STRUCT_set_13* {.bycopy.} = object
    svdIndex* {.bitsize: 7.}: U8
    nativeFlag* {.bitsize: 1.}: U8

  INNER_C_STRUCT_set_12* {.bycopy.} = object
    size* {.bitsize: 5.}: U8
    blockType* {.bitsize: 3.}: SetSysBlockType
    svd*: array[0xC, INNER_C_STRUCT_set_13]

  INNER_C_STRUCT_set_14* {.bycopy.} = object
    size* {.bitsize: 5.}: U8
    blockType* {.bitsize: 3.}: SetSysBlockType
    channelCount* {.bitsize: 3.}: U8
    formatCode* {.bitsize: 4.}: U8
    padding1* {.bitsize: 1.}: U8
    samplingRatesBitmap*: U8
    bitrate*: U8

  INNER_C_STRUCT_set_15* {.bycopy.} = object
    size* {.bitsize: 5.}: U8
    blockType* {.bitsize: 3.}: SetSysBlockType
    ieeeRegistrationId*: array[3, U8]
    sourcePhysicalAddress*: U16
    modeBitmap*: U8
    maxTmdsFrequency*: U8
    latencyBitmap*: U8

  SetSysTvSettings* {.bycopy.} = object
    flags*: U32                ## /< Bitmask with TvFlag.
    tvResolution*: S32         ## /< \ref SetSysTvResolution
    hdmiContentType*: S32      ## /< \ref SetSysHdmiContentType
    rgbRange*: S32             ## /< \ref SetSysRgbRange
    cmuMode*: S32              ## /< \ref SetSysCmuMode
    underscan*: U32            ## /< Underscan.
    gamma*: cfloat             ## /< Gamma.
    contrast*: cfloat          ## /< Contrast.

  SetSysModeLine* {.bycopy.} = object
    pixelClock*: U16           ## /< In 10 kHz units.
    horizontalActivePixelsLsb*: U8
    horizontalBlankingPixelsLsb*: U8
    horizontalBlankingPixelsMsb* {.bitsize: 4.}: U8
    horizontalActivePixelsMsb* {.bitsize: 4.}: U8
    verticalActiveLinesLsb*: U8
    verticalBlankingLinesLsb*: U8
    verticalBlankingLinesMsb* {.bitsize: 4.}: U8
    verticalActiveLinesMsb* {.bitsize: 4.}: U8
    horizontalSyncOffsetPixelsLsb*: U8
    horizontalSyncPulseWidthPixelsLsb*: U8
    horizontalSyncPulseWidthLinesLsb* {.bitsize: 4.}: U8
    horizontalSyncOffsetLinesLsb* {.bitsize: 4.}: U8
    verticalSyncPulseWidthLinesMsb* {.bitsize: 2.}: U8
    verticalSyncOffsetLinesMsb* {.bitsize: 2.}: U8
    horizontalSyncPulseWidthPixelsMsb* {.bitsize: 2.}: U8
    horizontalSyncOffsetPixelsMsb* {.bitsize: 2.}: U8
    horizontalImageSizeMmLsb*: U8
    verticalImageSizeMmLsb*: U8
    verticalImageSizeMmMsb* {.bitsize: 4.}: U8
    horizontalImageSizeMmMsb* {.bitsize: 4.}: U8
    horizontalBorderPixels*: U8
    verticalBorderLines*: U8
    featuresBitmap0* {.bitsize: 1.}: U8
    featuresBitmap1* {.bitsize: 1.}: U8
    featuresBitmap2* {.bitsize: 1.}: U8
    featuresBitmap34* {.bitsize: 2.}: U8
    featuresBitmap56* {.bitsize: 2.}: U8
    interlaced* {.bitsize: 1.}: U8

  SetSysDataBlock* {.bycopy.} = object
    video*: INNER_C_STRUCT_set_12
    audio*: INNER_C_STRUCT_set_14
    vendorSpecific*: INNER_C_STRUCT_set_15
    padding*: array[2, U8]


## / Edid

type
  INNER_C_STRUCT_set_20* {.bycopy.} = object
    greenYLsb* {.bitsize: 2.}: U8
    greenXLsb* {.bitsize: 2.}: U8
    redYLsb* {.bitsize: 2.}: U8
    redXLsb* {.bitsize: 2.}: U8
    blueLsb* {.bitsize: 4.}: U8
    whiteLsb* {.bitsize: 4.}: U8
    redXMsb*: U8
    redYMsb*: U8
    greenXMsb*: U8
    greenYMsb*: U8
    blueXMsb*: U8
    blueYMsb*: U8
    whiteXMsb*: U8
    whiteYMsb*: U8

  INNER_C_STRUCT_set_21* {.bycopy.} = object
    xResolution*: U8           ## /< Real value is (val + 31) * 8 pixels.
    verticalFrequency* {.bitsize: 6.}: U8 ## /< Real value is val + 60 Hz.
    aspectRatio* {.bitsize: 2.}: U8 ## /< 0 = 16:10, 1 = 4:3, 2 = 5:4, 3 = 16:9.

  INNER_C_STRUCT_set_22* {.bycopy.} = object
    displayDescriptorZero*: U16
    padding1*: U8
    descriptorType*: U8
    padding2*: U8
    name*: array[0xD, char]

  INNER_C_STRUCT_set_23* {.bycopy.} = object
    displayDescriptorZero*: U16
    padding1*: U8
    descriptorType*: U8
    rangeLimitOffsets*: U8
    verticalFieldRateMin*: U8
    verticalFieldRateMax*: U8
    horizontalLineRateMin*: U8
    horizontalLineRateMax*: U8
    pixelClockRateMax*: U8     ## /< Rounded up to multiples of 10 MHz.
    extendedTimingInfo*: U8
    padding*: array[7, U8]

  SetSysEdid* {.bycopy.} = object
    pattern*: array[8, U8]      ## /< Fixed pattern 00 FF FF FF FF FF FF 00.
    pnpId*: U16                ## /< Big-endian set of 3 5-bit values representing letters, 1 = A .. 26 = Z.
    productCode*: U16
    serialNumber*: U32
    manufactureWeek*: U8
    manufactureYear*: U8
    edidVersion*: U8
    edidRevision*: U8
    videoInputParametersBitmap*: U8
    displayWidth*: U8
    displayHeight*: U8
    displayGamma*: U8
    supportedFeaturesBitmap*: U8
    chromaticity*: INNER_C_STRUCT_set_20
    timingBitmap*: array[3, U8]
    timingInfo*: array[8, INNER_C_STRUCT_set_21]
    timingDescriptor*: array[2, SetSysModeLine]
    displayDescriptorName*: INNER_C_STRUCT_set_22
    displayDescriptorRangeLimits*: INNER_C_STRUCT_set_23
    extensionCount*: U8        ## /< Always 1.
    checksum*: U8              ## /< Sum of all 128 bytes should equal 0 mod 256.
                ## /< Extended data.
    extensionTag*: U8          ## /< Always 2 = CEA EDID timing extension.
    revision*: U8
    dtdStart*: U8
    nativeDtdCount* {.bitsize: 4.}: U8
    nativeDtdFeatureBitmap* {.bitsize: 4.}: U8
    dataBlock*: SetSysDataBlock
    extendedTimingDescriptor*: array[5, SetSysModeLine]
    padding*: array[5, U8]
    extendedChecksum*: U8      ## /< Sum of 128 extended bytes should equal 0 mod 256.


## / DataDeletionSettings

type
  SetSysDataDeletionSettings* {.bycopy.} = object
    flags*: U32                ## /< Bitmask with DataDeletionFlag.
    useCount*: S32             ## /< Use count.


## / SleepSettings

type
  SetSysSleepSettings* {.bycopy.} = object
    flags*: U32                ## /< Bitmask with SleepFlag.
    handheldSleepPlan*: S32    ## /< \ref SetSysHandheldSleepPlan
    consoleSleepPlan*: S32     ## /< \ref SetSysConsoleSleepPlan


## / InitialLaunchSettings

type
  SetSysInitialLaunchSettings* {.bycopy.} = object
    flags*: U32                ## /< Bitmask with InitialLaunchFlag.
    pad*: U32                  ## /< Padding.
    timestamp*: TimeSteadyClockTimePoint ## /< \ref TimeSteadyClockTimePoint timestamp.


## / PtmFuelGaugeParameter

type
  SetSysPtmFuelGaugeParameter* {.bycopy.} = object
    rcomp0*: U16
    tempc0*: U16
    fullcap*: U16
    fullcapnom*: U16
    lavgempty*: U16
    qresidual00*: U16
    qresidual10*: U16
    qresidual20*: U16
    qresidual30*: U16
    cycles*: U16               ## /< Normally keeps the cycles reg. Unused and contains stack garbage.
    cyclesActual*: U32         ## /< Keeps track of cycles. The fuel gauge cycles reg is reset if > 2.00 cycles and added here.


## / Actually nn::util::Color4u8Type.

type
  SetSysColor4u8Type* {.bycopy.} = object
    field*: array[4, U8]


## / NxControllerLegacySettings

type
  SetSysNxControllerLegacySettings* {.bycopy.} = object
    address*: BtdrvAddress
    `type`*: U8                ## /< \ref SetSysControllerType.
    serial*: array[0x10, char]
    bodyColor*: SetSysColor4u8Type
    buttonColor*: SetSysColor4u8Type
    unkX1F*: array[8, U8]
    unkX27*: U8
    interfaceType*: U8         ## /< Bitmask with \ref XcdInterfaceType.


## / NxControllerSettings

type
  SetSysNxControllerSettings* {.bycopy.} = object
    address*: BtdrvAddress
    `type`*: U8                ## /< \ref SetSysControllerType.
    serial*: array[0x10, char]
    bodyColor*: SetSysColor4u8Type
    buttonColor*: SetSysColor4u8Type
    unkX1F*: array[8, U8]
    unkX27*: U8
    interfaceType*: U8         ## /< Bitmask with \ref XcdInterfaceType.
    unkX29*: array[0x403, U8]   ## /< Unknown


## / ConsoleSixAxisSensorAccelerationBias

type
  SetSysConsoleSixAxisSensorAccelerationBias* {.bycopy.} = object
    unkX0*: cfloat
    unkX4*: cfloat
    unkX8*: cfloat


## / ConsoleSixAxisSensorAngularVelocityBias

type
  SetSysConsoleSixAxisSensorAngularVelocityBias* {.bycopy.} = object
    unkX0*: cfloat
    unkX4*: cfloat
    unkX8*: cfloat


## / ConsoleSixAxisSensorAccelerationGain

type
  SetSysConsoleSixAxisSensorAccelerationGain* {.bycopy.} = object
    unkX0*: cfloat
    unkX4*: cfloat
    unkX8*: cfloat
    unkXC*: cfloat
    unkX10*: cfloat
    unkX14*: cfloat
    unkX18*: cfloat
    unkX1C*: cfloat
    unkX20*: cfloat


## / ConsoleSixAxisSensorAngularVelocityGain

type
  SetSysConsoleSixAxisSensorAngularVelocityGain* {.bycopy.} = object
    unkX0*: cfloat
    unkX4*: cfloat
    unkX8*: cfloat
    unkXC*: cfloat
    unkX10*: cfloat
    unkX14*: cfloat
    unkX18*: cfloat
    unkX1C*: cfloat
    unkX20*: cfloat


## / AllowedSslHosts

type
  SetSysAllowedSslHosts* {.bycopy.} = object
    hosts*: array[0x100, U8]


## / HostFsMountPoint

type
  SetSysHostFsMountPoint* {.bycopy.} = object
    mount*: array[0x100, char]


## / BlePairingSettings

type
  SetSysBlePairingSettings* {.bycopy.} = object
    address*: BtdrvAddress
    unkX6*: U16
    unkX8*: U16
    unkXA*: U8
    unkXB*: U8
    unkXC*: U8
    unkXD*: U8
    unkXE*: U8
    unkXF*: U8
    padding*: array[0x70, U8]


## / ConsoleSixAxisSensorAngularVelocityTimeBias

type
  SetSysConsoleSixAxisSensorAngularVelocityTimeBias* {.bycopy.} = object
    unkX0*: cfloat
    unkX4*: cfloat
    unkX8*: cfloat


## / ConsoleSixAxisSensorAngularAcceleration

type
  SetSysConsoleSixAxisSensorAngularAcceleration* {.bycopy.} = object
    unkX0*: cfloat
    unkX4*: cfloat
    unkX8*: cfloat
    unkXC*: cfloat
    unkX10*: cfloat
    unkX14*: cfloat
    unkX18*: cfloat
    unkX1C*: cfloat
    unkX20*: cfloat


## / RebootlessSystemUpdateVersion. This is the content of the RebootlessSystemUpdateVersion SystemData, in the "/version" file.

type
  SetSysRebootlessSystemUpdateVersion* {.bycopy.} = object
    version*: U32
    reserved*: array[0x1c, U8]
    displayVersion*: array[0x20, char]


## / AccountOnlineStorageSettings

type
  SetSysAccountOnlineStorageSettings* {.bycopy.} = object
    uid*: AccountUid           ## /< \ref AccountUid
    unkX10*: U32
    unkX14*: U32


## / AnalogStickUserCalibration

type
  SetSysAnalogStickUserCalibration* {.bycopy.} = object
    unkX0*: U16
    unkX2*: U16
    unkX4*: U16
    unkX6*: U16
    unkX8*: U16
    unkXA*: U16
    unkXC*: U16
    unkXE*: U16


## / ThemeId

type
  SetSysThemeId* {.bycopy.} = object
    themeId*: array[0x10, U64]


## / ThemeSettings

type
  SetSysThemeSettings* {.bycopy.} = object
    themeSettings*: U64


## / Output from \ref setsysGetHomeMenuScheme. This contains RGBA8 colors which correspond with the physical shell of the system.

type
  SetSysHomeMenuScheme* {.bycopy.} = object
    mainColor*: U32            ## /< Main Color.
    backColor*: U32            ## /< Back Color.
    subColor*: U32             ## /< Sub Color.
    bezelColor*: U32           ## /< Bezel Color.
    extraColor*: U32           ## /< Extra Color.


## / ButtonConfigSettings

type
  SetSysButtonConfigSettings* {.bycopy.} = object
    settings*: array[0x5A8, U8]


## / ButtonConfigRegisteredSettings

type
  SetSysButtonConfigRegisteredSettings* {.bycopy.} = object
    settings*: array[0x5C8, U8]

  SetCalAccelerometerOffset* {.bycopy.} = object
    offset*: array[0x6, U8]

  SetCalAccelerometerScale* {.bycopy.} = object
    scale*: array[0x6, U8]

  SetCalAmiiboEcdsaCertificate* {.bycopy.} = object
    size*: U32
    cert*: array[0x70, U8]

  SetCalAmiiboEcqvBlsCertificate* {.bycopy.} = object
    size*: U32
    cert*: array[0x20, U8]

  SetCalAmiiboEcqvBlsKey* {.bycopy.} = object
    size*: U32
    key*: array[0x40, U8]
    generation*: U32

  SetCalAmiiboEcqvBlsRootCertificate* {.bycopy.} = object
    size*: U32
    cert*: array[0x90, U8]

  SetCalAmiiboEcqvCertificate* {.bycopy.} = object
    size*: U32
    cert*: array[0x14, U8]

  SetCalAmiiboKey* {.bycopy.} = object
    size*: U32
    key*: array[0x50, U8]
    generation*: U32

  SetCalAnalogStickFactoryCalibration* {.bycopy.} = object
    calibration*: array[0x9, U8]

  SetCalAnalogStickModelParameter* {.bycopy.} = object
    parameter*: array[0x12, U8]

  SetCalBdAddress* {.bycopy.} = object
    bdAddr*: array[0x6, U8]

  SetCalConfigurationId1* {.bycopy.} = object
    cfg*: array[0x1E, U8]

  SetCalConsoleSixAxisSensorHorizontalOffset* {.bycopy.} = object
    offset*: array[0x6, U8]

  SetCalCountryCode* {.bycopy.} = object
    code*: array[0x3, char]     ## /< Country code.

  SetCalEccB233DeviceCertificate* {.bycopy.} = object
    cert*: array[0x180, U8]

  SetCalEccB233DeviceKey* {.bycopy.} = object
    size*: U32
    key*: array[0x50, U8]
    generation*: U32

  SetCalGameCardCertificate* {.bycopy.} = object
    cert*: array[0x400, U8]

  SetCalGameCardKey* {.bycopy.} = object
    size*: U32                 ## /< Size of the entire key.
    key*: array[0x130, U8]
    generation*: U32

  SetCalGyroscopeOffset* {.bycopy.} = object
    offset*: array[0x6, U8]

  SetCalGyroscopeScale* {.bycopy.} = object
    scale*: array[0x6, U8]

  SetCalMacAddress* {.bycopy.} = object
    `addr`*: array[0x6, U8]     ## /< Mac address.

  SetCalRsa2048DeviceCertificate* {.bycopy.} = object
    cert*: array[0x240, U8]

  SetCalRsa2048DeviceKey* {.bycopy.} = object
    size*: U32                 ## /< Size of the entire key.
    key*: array[0x240, U8]
    generation*: U32

  SetCalSerialNumber* = SetSysSerialNumber
  SetCalSpeakerParameter* {.bycopy.} = object
    parameter*: array[0x5A, U8]

  SetCalSslCertificate* {.bycopy.} = object
    size*: U32                 ## /< Size of the certificate data.
    cert*: array[0x800, U8]

  SetCalSslKey* {.bycopy.} = object
    size*: U32                 ## /< Size of the entire key.
    key*: array[0x130, U8]
    generation*: U32

  SetCalRegionCode* {.bycopy.} = object
    code*: U32                 ## /< Region code.

proc setInitialize*(): Result {.cdecl, importc: "setInitialize".}
## / Initialize set.

proc setExit*() {.cdecl, importc: "setExit".}
## / Exit set.

proc setGetServiceSession*(): ptr Service {.cdecl, importc: "setGetServiceSession".}
## / Gets the Service object for the actual set service session.

proc setMakeLanguage*(languageCode: U64; language: ptr SetLanguage): Result {.cdecl,
    importc: "setMakeLanguage".}
## / Converts LanguageCode to \ref SetLanguage.

proc setMakeLanguageCode*(language: SetLanguage; languageCode: ptr U64): Result {.
    cdecl, importc: "setMakeLanguageCode".}
## / Converts \ref SetLanguage to LanguageCode.

proc setGetSystemLanguage*(languageCode: ptr U64): Result {.cdecl,
    importc: "setGetSystemLanguage".}
## / Gets the current system LanguageCode.
## / Normally this should be used instead of \ref setGetLanguageCode.
## / LanguageCode is a string, see here: https://switchbrew.org/wiki/Settings_services#LanguageCode

proc setGetLanguageCode*(languageCode: ptr U64): Result {.cdecl,
    importc: "setGetLanguageCode".}
## / Gets the current LanguageCode, \ref setGetSystemLanguage should be used instead normally.

proc setGetAvailableLanguageCodes*(totalEntries: ptr S32; languageCodes: ptr U64;
                                  maxEntries: csize_t): Result {.cdecl,
    importc: "setGetAvailableLanguageCodes".}
## / Gets available LanguageCodes.
## / On system-version <4.0.0, max_entries is set to the output from \ref setGetAvailableLanguageCodeCount if max_entries is larger than that.

proc setGetAvailableLanguageCodeCount*(total: ptr S32): Result {.cdecl,
    importc: "setGetAvailableLanguageCodeCount".}
## / Gets total available LanguageCodes.
## / Output total is overridden with value 0 if the total is <0.

proc setGetRegionCode*(`out`: ptr SetRegion): Result {.cdecl,
    importc: "setGetRegionCode".}
## / Gets the RegionCode.

proc setGetQuestFlag*(`out`: ptr bool): Result {.cdecl, importc: "setGetQuestFlag".}
## *
##  @brief GetQuestFlag
##  @note Only available on [5.0.0+].
##  @param[out] out Output flag.
##

proc setGetDeviceNickname*(nickname: ptr SetSysDeviceNickName): Result {.cdecl,
    importc: "setGetDeviceNickname".}
## *
##  @brief Gets the system's nickname.
##  @note Only available on [10.1.0+].
##  @param[out] nickname \ref SetSysDeviceNickName
##

proc setsysInitialize*(): Result {.cdecl, importc: "setsysInitialize".}
## / Initialize setsys.

proc setsysExit*() {.cdecl, importc: "setsysExit".}
## / Exit setsys.

proc setsysGetServiceSession*(): ptr Service {.cdecl,
    importc: "setsysGetServiceSession".}
## / Gets the Service object for the actual setsys service session.

proc setsysSetLanguageCode*(languageCode: U64): Result {.cdecl,
    importc: "setsysSetLanguageCode".}
## *
##  @brief SetLanguageCode
##  @param[in] LanguageCode LanguageCode.
##

proc setsysSetNetworkSettings*(settings: ptr SetSysNetworkSettings; count: S32): Result {.
    cdecl, importc: "setsysSetNetworkSettings".}
## *
##  @brief SetNetworkSettings
##  @param[in] settings Input array of \ref SetSysNetworkSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetNetworkSettings*(totalOut: ptr S32;
                              settings: ptr SetSysNetworkSettings; count: S32): Result {.
    cdecl, importc: "setsysGetNetworkSettings".}
## *
##  @brief GetNetworkSettings
##  @param[out] total_out Total output entries.
##  @param[out] versions Output array of \ref SetSysNetworkSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetFirmwareVersion*(`out`: ptr SetSysFirmwareVersion): Result {.cdecl,
    importc: "setsysGetFirmwareVersion".}
## *
##  @brief Gets the system firmware version.
##  @param[out] out Firmware version to populate.
##

proc setsysGetFirmwareVersionDigest*(`out`: ptr SetSysFirmwareVersionDigest): Result {.
    cdecl, importc: "setsysGetFirmwareVersionDigest".}
## *
##  @brief GetFirmwareVersionDigest
##  @param[out] out \ref SetSysFirmwareVersionDigest
##

proc setsysGetLockScreenFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetLockScreenFlag".}
## *
##  @brief GetLockScreenFlag
##  @param[out] out Output flag.
##

proc setsysSetLockScreenFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetLockScreenFlag".}
## *
##  @brief SetLockScreenFlag
##  @param[in] flag Input flag.
##

proc setsysGetBacklightSettings*(`out`: ptr SetSysBacklightSettings): Result {.cdecl,
    importc: "setsysGetBacklightSettings".}
## *
##  @brief GetBacklightSettings
##  @param[out] out \ref SetSysBacklightSettings
##

proc setsysSetBacklightSettings*(settings: ptr SetSysBacklightSettings): Result {.
    cdecl, importc: "setsysSetBacklightSettings".}
## *
##  @brief SetBacklightSettings
##  @param[in] settings \ref SetSysBacklightSettings
##

proc setsysSetBluetoothDevicesSettings*(settings: ptr SetSysBluetoothDevicesSettings;
                                       count: S32): Result {.cdecl,
    importc: "setsysSetBluetoothDevicesSettings".}
## *
##  @brief SetBluetoothDevicesSettings
##  @param[in] settings Input array of \ref SetSysBluetoothDevicesSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetBluetoothDevicesSettings*(totalOut: ptr S32; settings: ptr SetSysBluetoothDevicesSettings;
                                       count: S32): Result {.cdecl,
    importc: "setsysGetBluetoothDevicesSettings".}
## *
##  @brief GetBluetoothDevicesSettings
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysBluetoothDevicesSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetExternalSteadyClockSourceId*(`out`: ptr Uuid): Result {.cdecl,
    importc: "setsysGetExternalSteadyClockSourceId".}
## *
##  @brief GetExternalSteadyClockSourceId
##  @param[out] out \ref Uuid
##

proc setsysSetExternalSteadyClockSourceId*(uuid: ptr Uuid): Result {.cdecl,
    importc: "setsysSetExternalSteadyClockSourceId".}
## *
##  @brief SetExternalSteadyClockSourceId
##  @param[in] uuid \ref Uuid
##

proc setsysGetUserSystemClockContext*(`out`: ptr TimeSystemClockContext): Result {.
    cdecl, importc: "setsysGetUserSystemClockContext".}
## *
##  @brief GetUserSystemClockContext
##  @param[out] out \ref TimeSystemClockContext
##

proc setsysSetUserSystemClockContext*(context: ptr TimeSystemClockContext): Result {.
    cdecl, importc: "setsysSetUserSystemClockContext".}
## *
##  @brief SetUserSystemClockContext
##  @param[in] context \ref TimeSystemClockContext
##

proc setsysGetAccountSettings*(`out`: ptr SetSysAccountSettings): Result {.cdecl,
    importc: "setsysGetAccountSettings".}
## *
##  @brief GetAccountSettings
##  @param[out] out \ref SetSysAccountSettings
##

proc setsysSetAccountSettings*(settings: SetSysAccountSettings): Result {.cdecl,
    importc: "setsysSetAccountSettings".}
## *
##  @brief SetAccountSettings
##  @param[in] settings \ref SetSysAccountSettings
##

proc setsysGetAudioVolume*(device: SetSysAudioDevice; `out`: ptr SetSysAudioVolume): Result {.
    cdecl, importc: "setsysGetAudioVolume".}
## *
##  @brief GetAudioVolume
##  @param[in] device \ref SetSysAudioDevice
##  @param[out] out \ref SetSysAudioVolume
##

proc setsysSetAudioVolume*(device: SetSysAudioDevice; volume: ptr SetSysAudioVolume): Result {.
    cdecl, importc: "setsysSetAudioVolume".}
## *
##  @brief SetAudioVolume
##  @param[in] device \ref SetSysAudioDevice
##  @param[in] volume \ref SetSysAudioVolume
##

proc setsysGetEulaVersions*(totalOut: ptr S32; versions: ptr SetSysEulaVersion;
                           count: S32): Result {.cdecl,
    importc: "setsysGetEulaVersions".}
## *
##  @brief GetEulaVersions
##  @param[out] total_out Total output entries.
##  @param[out] versions Output array of \ref SetSysEulaVersion.
##  @param[in] count Size of the versions array in entries.
##

proc setsysSetEulaVersions*(versions: ptr SetSysEulaVersion; count: S32): Result {.
    cdecl, importc: "setsysSetEulaVersions".}
## *
##  @brief SetEulaVersions
##  @param[in] versions Input array of \ref SetSysEulaVersion.
##  @param[in] count Size of the versions array in entries.
##

proc setsysGetColorSetId*(`out`: ptr ColorSetId): Result {.cdecl,
    importc: "setsysGetColorSetId".}
## / Gets the current system theme.

proc setsysSetColorSetId*(id: ColorSetId): Result {.cdecl,
    importc: "setsysSetColorSetId".}
## / Sets the current system theme.

proc setsysGetConsoleInformationUploadFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetConsoleInformationUploadFlag".}
## *
##  @brief GetConsoleInformationUploadFlag
##  @param[out] out Output flag.
##

proc setsysSetConsoleInformationUploadFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetConsoleInformationUploadFlag".}
## *
##  @brief SetConsoleInformationUploadFlag
##  @param[in] flag Input flag.
##

proc setsysGetAutomaticApplicationDownloadFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetAutomaticApplicationDownloadFlag".}
## *
##  @brief GetAutomaticApplicationDownloadFlag
##  @param[out] out Output flag.
##

proc setsysSetAutomaticApplicationDownloadFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetAutomaticApplicationDownloadFlag".}
## *
##  @brief SetAutomaticApplicationDownloadFlag
##  @param[in] flag Input flag.
##

proc setsysGetNotificationSettings*(`out`: ptr SetSysNotificationSettings): Result {.
    cdecl, importc: "setsysGetNotificationSettings".}
## *
##  @brief GetNotificationSettings
##  @param[out] out \ref SetSysNotificationSettings
##

proc setsysSetNotificationSettings*(settings: ptr SetSysNotificationSettings): Result {.
    cdecl, importc: "setsysSetNotificationSettings".}
## *
##  @brief SetNotificationSettings
##  @param[in] settings \ref SetSysNotificationSettings
##

proc setsysGetAccountNotificationSettings*(totalOut: ptr S32;
    settings: ptr SetSysAccountNotificationSettings; count: S32): Result {.cdecl,
    importc: "setsysGetAccountNotificationSettings".}
## *
##  @brief GetAccountNotificationSettings
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysAccountNotificationSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysSetAccountNotificationSettings*(
    settings: ptr SetSysAccountNotificationSettings; count: S32): Result {.cdecl,
    importc: "setsysSetAccountNotificationSettings".}
## *
##  @brief SetAccountNotificationSettings
##  @param[in] settings Input array of \ref SetSysAccountNotificationSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetVibrationMasterVolume*(`out`: ptr cfloat): Result {.cdecl,
    importc: "setsysGetVibrationMasterVolume".}
## *
##  @brief GetVibrationMasterVolume
##  @param[out] out Output volume.
##

proc setsysSetVibrationMasterVolume*(volume: cfloat): Result {.cdecl,
    importc: "setsysSetVibrationMasterVolume".}
## *
##  @brief SetVibrationMasterVolume
##  @param[in] volume Input volume.
##

proc setsysGetSettingsItemValueSize*(name: cstring; itemKey: cstring;
                                    sizeOut: ptr U64): Result {.cdecl,
    importc: "setsysGetSettingsItemValueSize".}
## *
##  @brief Gets the size of a settings item value.
##  @param name Name string.
##  @param item_key Item key string.
##  @param size_out Pointer to output the size to.
##

proc setsysGetSettingsItemValue*(name: cstring; itemKey: cstring; valueOut: pointer;
                                valueOutSize: csize_t; sizeOut: ptr U64): Result {.
    cdecl, importc: "setsysGetSettingsItemValue".}
## *
##  @brief Gets the value of a settings item.
##  @param name Name string.
##  @param item_key Item key string.
##  @param value_out Pointer to output the value to.
##  @param value_out_size Size of the value_out buffer.
##  @param size_out Total size which was copied to value_out.
##

proc setsysGetTvSettings*(`out`: ptr SetSysTvSettings): Result {.cdecl,
    importc: "setsysGetTvSettings".}
## *
##  @brief GetTvSettings
##  @param[out] out \ref SetSysTvSettings
##

proc setsysSetTvSettings*(settings: ptr SetSysTvSettings): Result {.cdecl,
    importc: "setsysSetTvSettings".}
## *
##  @brief SetTvSettings
##  @param[in] settings \ref SetSysTvSettings
##

proc setsysGetEdid*(`out`: ptr SetSysEdid): Result {.cdecl, importc: "setsysGetEdid".}
## *
##  @brief GetEdid
##  @param[out] out \ref SetSysEdid
##

proc setsysSetEdid*(edid: ptr SetSysEdid): Result {.cdecl, importc: "setsysSetEdid".}
## *
##  @brief SetEdid
##  @param[in] edid \ref SetSysEdid
##

proc setsysGetAudioOutputMode*(target: SetSysAudioOutputModeTarget;
                              `out`: ptr SetSysAudioOutputMode): Result {.cdecl,
    importc: "setsysGetAudioOutputMode".}
## *
##  @brief GetAudioOutputMode
##  @param[in] target \ref SetSysAudioOutputModeTarget
##  @param[out] out \ref SetSysAudioOutputMode
##

proc setsysSetAudioOutputMode*(target: SetSysAudioOutputModeTarget;
                              mode: SetSysAudioOutputMode): Result {.cdecl,
    importc: "setsysSetAudioOutputMode".}
## *
##  @brief SetAudioOutputMode
##  @param[in] target \ref SetSysAudioOutputModeTarget
##  @param[in] mode \ref SetSysAudioOutputMode
##

proc setsysGetSpeakerAutoMuteFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetSpeakerAutoMuteFlag".}
## *
##  @brief GetSpeakerAutoMuteFlag
##  @param[out] out Output flag.
##

proc setsysSetSpeakerAutoMuteFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetSpeakerAutoMuteFlag".}
## *
##  @brief SetSpeakerAutoMuteFlag
##  @param[in] flag Input flag.
##

proc setsysGetQuestFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetQuestFlag".}
## *
##  @brief GetQuestFlag
##  @param[out] out Output flag.
##

proc setsysSetQuestFlag*(flag: bool): Result {.cdecl, importc: "setsysSetQuestFlag".}
## *
##  @brief SetQuestFlag
##  @param[in] flag Input flag.
##

proc setsysGetDataDeletionSettings*(`out`: ptr SetSysDataDeletionSettings): Result {.
    cdecl, importc: "setsysGetDataDeletionSettings".}
## *
##  @brief GetDataDeletionSettings
##  @param[out] out \ref SetSysDataDeletionSettings
##

proc setsysSetDataDeletionSettings*(settings: ptr SetSysDataDeletionSettings): Result {.
    cdecl, importc: "setsysSetDataDeletionSettings".}
## *
##  @brief SetDataDeletionSettings
##  @param[in] settings \ref SetSysDataDeletionSettings
##

proc setsysGetInitialSystemAppletProgramId*(`out`: ptr U64): Result {.cdecl,
    importc: "setsysGetInitialSystemAppletProgramId".}
## *
##  @brief GetInitialSystemAppletProgramId
##  @param[out] out output ProgramId.
##

proc setsysGetOverlayDispProgramId*(`out`: ptr U64): Result {.cdecl,
    importc: "setsysGetOverlayDispProgramId".}
## *
##  @brief GetOverlayDispProgramId
##  @param[out] out output ProgramId.
##

proc setsysGetDeviceTimeZoneLocationName*(`out`: ptr TimeLocationName): Result {.
    cdecl, importc: "setsysGetDeviceTimeZoneLocationName".}
## *
##  @brief GetDeviceTimeZoneLocationName
##  @param[out] out \ref TimeLocationName
##

proc setsysSetDeviceTimeZoneLocationName*(name: ptr TimeLocationName): Result {.
    cdecl, importc: "setsysSetDeviceTimeZoneLocationName".}
## *
##  @brief SetDeviceTimeZoneLocationName
##  @param[in] name \ref TimeLocationName
##

proc setsysGetWirelessCertificationFileSize*(outSize: ptr U64): Result {.cdecl,
    importc: "setsysGetWirelessCertificationFileSize".}
## *
##  @brief GetWirelessCertificationFileSize
##  @param[out] out_size Output size.
##

proc setsysGetWirelessCertificationFile*(buffer: pointer; size: csize_t;
                                        outSize: ptr U64): Result {.cdecl,
    importc: "setsysGetWirelessCertificationFile".}
## *
##  @brief GetWirelessCertificationFile
##  @param[out] buffer Output buffer.
##  @param[in] size Output buffer size.
##  @param[out] out_size Output size.
##

proc setsysSetRegionCode*(region: SetRegion): Result {.cdecl,
    importc: "setsysSetRegionCode".}
## *
##  @brief SetRegionCode
##  @param[in] region \ref SetRegion
##

proc setsysGetNetworkSystemClockContext*(`out`: ptr TimeSystemClockContext): Result {.
    cdecl, importc: "setsysGetNetworkSystemClockContext".}
## *
##  @brief GetNetworkSystemClockContext
##  @param[out] out \ref TimeSystemClockContext
##

proc setsysSetNetworkSystemClockContext*(context: ptr TimeSystemClockContext): Result {.
    cdecl, importc: "setsysSetNetworkSystemClockContext".}
## *
##  @brief SetNetworkSystemClockContext
##  @param[in] context \ref TimeSystemClockContext
##

proc setsysIsUserSystemClockAutomaticCorrectionEnabled*(`out`: ptr bool): Result {.
    cdecl, importc: "setsysIsUserSystemClockAutomaticCorrectionEnabled".}
## *
##  @brief IsUserSystemClockAutomaticCorrectionEnabled
##  @param[out] out Output flag.
##

proc setsysSetUserSystemClockAutomaticCorrectionEnabled*(flag: bool): Result {.
    cdecl, importc: "setsysSetUserSystemClockAutomaticCorrectionEnabled".}
## *
##  @brief SetUserSystemClockAutomaticCorrectionEnabled
##  @param[in] flag Input flag.
##

proc setsysGetDebugModeFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetDebugModeFlag".}
## *
##  @brief GetDebugModeFlag
##  @param[out] out Output flag.
##

proc setsysGetPrimaryAlbumStorage*(`out`: ptr SetSysPrimaryAlbumStorage): Result {.
    cdecl, importc: "setsysGetPrimaryAlbumStorage".}
## *
##  @brief GetPrimaryAlbumStorage
##  @param[out] out \ref GetPrimaryAlbumStorage
##

proc setsysSetPrimaryAlbumStorage*(storage: SetSysPrimaryAlbumStorage): Result {.
    cdecl, importc: "setsysSetPrimaryAlbumStorage".}
## *
##  @brief SetPrimaryAlbumStorage
##  @param[in] storage \ref SetSysPrimaryAlbumStorage
##

proc setsysGetUsb30EnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetUsb30EnableFlag".}
## *
##  @brief GetUsb30EnableFlag
##  @param[out] out Output flag.
##

proc setsysSetUsb30EnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetUsb30EnableFlag".}
## *
##  @brief SetUsb30EnableFlag
##  @param[in] flag Input flag.
##

proc setsysGetBatteryLot*(`out`: ptr SetBatteryLot): Result {.cdecl,
    importc: "setsysGetBatteryLot".}
## *
##  @brief Gets the \ref SetBatteryLot.
##  @param[out] out \ref SetBatteryLot
##

proc setsysGetSerialNumber*(`out`: ptr SetSysSerialNumber): Result {.cdecl,
    importc: "setsysGetSerialNumber".}
## *
##  @brief Gets the system's serial number.
##  @param[out] out \ref SetSysSerialNumber
##

proc setsysGetNfcEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetNfcEnableFlag".}
## *
##  @brief GetNfcEnableFlag
##  @param[out] out Output flag.
##

proc setsysSetNfcEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetNfcEnableFlag".}
## *
##  @brief SetNfcEnableFlag
##  @param[in] flag Input flag.
##

proc setsysGetSleepSettings*(`out`: ptr SetSysSleepSettings): Result {.cdecl,
    importc: "setsysGetSleepSettings".}
## *
##  @brief GetSleepSettings
##  @param[out] out \ref SetSysSleepSettings
##

proc setsysSetSleepSettings*(settings: ptr SetSysSleepSettings): Result {.cdecl,
    importc: "setsysSetSleepSettings".}
## *
##  @brief SetSleepSettings
##  @param[in] settings \ref SetSysSleepSettings
##

proc setsysGetWirelessLanEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetWirelessLanEnableFlag".}
## *
##  @brief GetWirelessLanEnableFlag
##  @param[out] out Output flag.
##

proc setsysSetWirelessLanEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetWirelessLanEnableFlag".}
## *
##  @brief SetWirelessLanEnableFlag
##  @param[in] flag Input flag.
##

proc setsysGetInitialLaunchSettings*(`out`: ptr SetSysInitialLaunchSettings): Result {.
    cdecl, importc: "setsysGetInitialLaunchSettings".}
## *
##  @brief GetInitialLaunchSettings
##  @param[out] out \ref SetSysInitialLaunchSettings
##

proc setsysSetInitialLaunchSettings*(settings: ptr SetSysInitialLaunchSettings): Result {.
    cdecl, importc: "setsysSetInitialLaunchSettings".}
## *
##  @brief SetInitialLaunchSettings
##  @param[in] settings \ref SetSysInitialLaunchSettings
##

proc setsysGetDeviceNickname*(nickname: ptr SetSysDeviceNickName): Result {.cdecl,
    importc: "setsysGetDeviceNickname".}
## *
##  @brief Gets the system's nickname.
##  @note Same as \ref setGetDeviceNickname, which official sw uses instead on [10.1.0+].
##  @param[out] nickname \ref SetSysDeviceNickName
##

proc setsysSetDeviceNickname*(nickname: ptr SetSysDeviceNickName): Result {.cdecl,
    importc: "setsysSetDeviceNickname".}
## *
##  @brief Sets the system's nickname.
##  @param[in] nickname \ref SetSysDeviceNickName
##

proc setsysGetProductModel*(model: ptr SetSysProductModel): Result {.cdecl,
    importc: "setsysGetProductModel".}
## *
##  @brief GetProductModel
##  @param[out] model Output SetSysProductModel.
##

proc setsysGetLdnChannel*(`out`: ptr S32): Result {.cdecl,
    importc: "setsysGetLdnChannel".}
## *
##  @brief GetLdnChannel
##  @param[out] out Output LdnChannel.
##

proc setsysSetLdnChannel*(channel: S32): Result {.cdecl,
    importc: "setsysSetLdnChannel".}
## *
##  @brief SetLdnChannel
##  @param[in] channel Input LdnChannel.
##

proc setsysAcquireTelemetryDirtyFlagEventHandle*(outEvent: ptr Event): Result {.
    cdecl, importc: "setsysAcquireTelemetryDirtyFlagEventHandle".}
## *
##  @brief Gets an event that settings will signal on flag change.
##  @param out_event Event to bind. Output event will have autoclear=false.
##

proc setsysGetTelemetryDirtyFlags*(flags0: ptr U64; flags1: ptr U64): Result {.cdecl,
    importc: "setsysGetTelemetryDirtyFlags".}
## *
##  @brief Gets the settings flags that have changed.
##  @param flags_0 Pointer to populate with first 64 flags.
##  @param flags_1 Pointer to populate with second 64 flags.
##

proc setsysGetPtmBatteryLot*(`out`: ptr SetBatteryLot): Result {.cdecl,
    importc: "setsysGetPtmBatteryLot".}
## *
##  @brief GetPtmBatteryLot
##  @param[out] out \ref SetBatteryLot
##

proc setsysSetPtmBatteryLot*(lot: ptr SetBatteryLot): Result {.cdecl,
    importc: "setsysSetPtmBatteryLot".}
## *
##  @brief SetPtmBatteryLot
##  @param[in] lot \ref SetBatteryLot
##

proc setsysGetPtmFuelGaugeParameter*(`out`: ptr SetSysPtmFuelGaugeParameter): Result {.
    cdecl, importc: "setsysGetPtmFuelGaugeParameter".}
## *
##  @brief GetPtmFuelGaugeParameter
##  @param[out] out \ref SetSysPtmFuelGaugeParameter
##

proc setsysSetPtmFuelGaugeParameter*(parameter: ptr SetSysPtmFuelGaugeParameter): Result {.
    cdecl, importc: "setsysSetPtmFuelGaugeParameter".}
## *
##  @brief SetPtmFuelGaugeParameter
##  @param[in] parameter \ref SetSysPtmFuelGaugeParameter
##

proc setsysGetBluetoothEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetBluetoothEnableFlag".}
## *
##  @brief GetBluetoothEnableFlag
##  @param[out] out Output flag.
##

proc setsysSetBluetoothEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetBluetoothEnableFlag".}
## *
##  @brief SetBluetoothEnableFlag
##  @param[in] flag Input flag.
##

proc setsysGetMiiAuthorId*(`out`: ptr Uuid): Result {.cdecl,
    importc: "setsysGetMiiAuthorId".}
## *
##  @brief GetMiiAuthorId
##  @param[out] out Output MiiAuthorId.
##

proc setsysSetShutdownRtcValue*(value: U64): Result {.cdecl,
    importc: "setsysSetShutdownRtcValue".}
## *
##  @brief SetShutdownRtcValue
##  @param[in] value Input value.
##

proc setsysGetShutdownRtcValue*(`out`: ptr U64): Result {.cdecl,
    importc: "setsysGetShutdownRtcValue".}
## *
##  @brief GetShutdownRtcValue
##  @param[out] out Output value.
##

proc setsysAcquireFatalDirtyFlagEventHandle*(outEvent: ptr Event): Result {.cdecl,
    importc: "setsysAcquireFatalDirtyFlagEventHandle".}
## *
##  @brief Gets an event that settings will signal on flag change.
##  @param out_event Event to bind. Output event will have autoclear=false.
##

proc setsysGetFatalDirtyFlags*(flags0: ptr U64; flags1: ptr U64): Result {.cdecl,
    importc: "setsysGetFatalDirtyFlags".}
## *
##  @brief Gets the settings flags that have changed.
##  @param flags_0 Pointer to populate with first 64 flags.
##  @param flags_1 Pointer to populate with second 64 flags.
##

proc setsysGetAutoUpdateEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetAutoUpdateEnableFlag".}
## *
##  @brief GetAutoUpdateEnableFlag
##  @note Only available on [2.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetAutoUpdateEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetAutoUpdateEnableFlag".}
## *
##  @brief SetAutoUpdateEnableFlag
##  @note Only available on [2.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetNxControllerSettings*(totalOut: ptr S32; settings: ptr SetSysNxControllerLegacySettings;
                                   count: S32): Result {.cdecl,
    importc: "setsysGetNxControllerSettings".}
## *
##  @brief GetNxControllerSettings
##  @note On [13.0.0+] \ref setsysGetNxControllerSettingsEx should be used instead.
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysNxControllerLegacySettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysSetNxControllerSettings*(settings: ptr SetSysNxControllerLegacySettings;
                                   count: S32): Result {.cdecl,
    importc: "setsysSetNxControllerSettings".}
## *
##  @brief SetNxControllerSettings
##  @note On [13.0.0+] \ref setsysSetNxControllerSettingsEx should be used instead.
##  @param[in] settings Input array of \ref SetSysNxControllerLegacySettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetBatteryPercentageFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetBatteryPercentageFlag".}
## *
##  @brief GetBatteryPercentageFlag
##  @note Only available on [2.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetBatteryPercentageFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetBatteryPercentageFlag".}
## *
##  @brief SetBatteryPercentageFlag
##  @note Only available on [2.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetExternalRtcResetFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetExternalRtcResetFlag".}
## *
##  @brief GetExternalRtcResetFlag
##  @note Only available on [2.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetExternalRtcResetFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetExternalRtcResetFlag".}
## *
##  @brief SetExternalRtcResetFlag
##  @note Only available on [2.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetUsbFullKeyEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetUsbFullKeyEnableFlag".}
## *
##  @brief GetUsbFullKeyEnableFlag
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetUsbFullKeyEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetUsbFullKeyEnableFlag".}
## *
##  @brief SetUsbFullKeyEnableFlag
##  @note Only available on [3.0.0+].
##  @param[in] flag Input flag.
##

proc setsysSetExternalSteadyClockInternalOffset*(offset: U64): Result {.cdecl,
    importc: "setsysSetExternalSteadyClockInternalOffset".}
## *
##  @brief SetExternalSteadyClockInternalOffset
##  @note Only available on [3.0.0+].
##  @param[in] offset Input offset.
##

proc setsysGetExternalSteadyClockInternalOffset*(`out`: ptr U64): Result {.cdecl,
    importc: "setsysGetExternalSteadyClockInternalOffset".}
## *
##  @brief GetExternalSteadyClockInternalOffset
##  @note Only available on [3.0.0+].
##  @param[out] out Output offset.
##

proc setsysGetBacklightSettingsEx*(`out`: ptr SetSysBacklightSettingsEx): Result {.
    cdecl, importc: "setsysGetBacklightSettingsEx".}
## *
##  @brief GetBacklightSettingsEx
##  @note Only available on [3.0.0+].
##  @param[out] out \ref SetSysBacklightSettingsEx
##

proc setsysSetBacklightSettingsEx*(settings: ptr SetSysBacklightSettingsEx): Result {.
    cdecl, importc: "setsysSetBacklightSettingsEx".}
## *
##  @brief SetBacklightSettingsEx
##  @note Only available on [3.0.0+].
##  @param[in] settings \ref SetSysBacklightSettingsEx
##

proc setsysGetHeadphoneVolumeWarningCount*(`out`: ptr U32): Result {.cdecl,
    importc: "setsysGetHeadphoneVolumeWarningCount".}
## *
##  @brief GetHeadphoneVolumeWarningCount
##  @note Only available on [3.0.0+].
##  @param[out] out Output count.
##

proc setsysSetHeadphoneVolumeWarningCount*(count: U32): Result {.cdecl,
    importc: "setsysSetHeadphoneVolumeWarningCount".}
## *
##  @brief SetHeadphoneVolumeWarningCount
##  @note Only available on [3.0.0+].
##  @param[in] count Input count.
##

proc setsysGetBluetoothAfhEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetBluetoothAfhEnableFlag".}
## *
##  @brief GetBluetoothAfhEnableFlag
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetBluetoothAfhEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetBluetoothAfhEnableFlag".}
## *
##  @brief SetBluetoothAfhEnableFlag
##  @note Only available on [3.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetBluetoothBoostEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetBluetoothBoostEnableFlag".}
## *
##  @brief GetBluetoothBoostEnableFlag
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetBluetoothBoostEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetBluetoothBoostEnableFlag".}
## *
##  @brief SetBluetoothBoostEnableFlag
##  @note Only available on [3.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetInRepairProcessEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetInRepairProcessEnableFlag".}
## *
##  @brief GetInRepairProcessEnableFlag
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetInRepairProcessEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetInRepairProcessEnableFlag".}
## *
##  @brief SetInRepairProcessEnableFlag
##  @note Only available on [3.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetHeadphoneVolumeUpdateFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetHeadphoneVolumeUpdateFlag".}
## *
##  @brief GetHeadphoneVolumeUpdateFlag
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetHeadphoneVolumeUpdateFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetHeadphoneVolumeUpdateFlag".}
## *
##  @brief SetHeadphoneVolumeUpdateFlag
##  @note Only available on [3.0.0+].
##  @param[in] flag Input flag.
##

proc setsysNeedsToUpdateHeadphoneVolume*(a0: ptr U8; a1: ptr U8; a2: ptr U8; flag: bool): Result {.
    cdecl, importc: "setsysNeedsToUpdateHeadphoneVolume".}
## *
##  @brief NeedsToUpdateHeadphoneVolume
##  @note Only available on [3.0.0-14.1.2].
##  @param[out] a0 Output arg.
##  @param[out] a1 Output arg.
##  @param[out] a2 Output arg.
##  @param[in] flag Input flag.
##

proc setsysGetPushNotificationActivityModeOnSleep*(`out`: ptr U32): Result {.cdecl,
    importc: "setsysGetPushNotificationActivityModeOnSleep".}
## *
##  @brief GetPushNotificationActivityModeOnSleep
##  @note Only available on [3.0.0+].
##  @param[out] out Output mode.
##

proc setsysSetPushNotificationActivityModeOnSleep*(mode: U32): Result {.cdecl,
    importc: "setsysSetPushNotificationActivityModeOnSleep".}
## *
##  @brief SetPushNotificationActivityModeOnSleep
##  @note Only available on [3.0.0+].
##  @param[in] mode Input mode.
##

proc setsysGetServiceDiscoveryControlSettings*(
    `out`: ptr SetSysServiceDiscoveryControlSettings): Result {.cdecl,
    importc: "setsysGetServiceDiscoveryControlSettings".}
## *
##  @brief GetServiceDiscoveryControlSettings
##  @note Only available on [4.0.0+].
##  @param[out] out \ref ServiceDiscoveryControlSettings
##

proc setsysSetServiceDiscoveryControlSettings*(
    settings: SetSysServiceDiscoveryControlSettings): Result {.cdecl,
    importc: "setsysSetServiceDiscoveryControlSettings".}
## *
##  @brief SetServiceDiscoveryControlSettings
##  @note Only available on [4.0.0+].
##  @param[in] settings \ref ServiceDiscoveryControlSettings
##

proc setsysGetErrorReportSharePermission*(
    `out`: ptr SetSysErrorReportSharePermission): Result {.cdecl,
    importc: "setsysGetErrorReportSharePermission".}
## *
##  @brief GetErrorReportSharePermission
##  @note Only available on [4.0.0+].
##  @param[out] out \ref SetSysErrorReportSharePermission
##

proc setsysSetErrorReportSharePermission*(
    permission: SetSysErrorReportSharePermission): Result {.cdecl,
    importc: "setsysSetErrorReportSharePermission".}
## *
##  @brief SetErrorReportSharePermission
##  @note Only available on [4.0.0+].
##  @param[in] permission \ref SetSysErrorReportSharePermission
##

proc setsysGetAppletLaunchFlags*(`out`: ptr U32): Result {.cdecl,
    importc: "setsysGetAppletLaunchFlags".}
## *
##  @brief GetAppletLaunchFlags
##  @note Only available on [4.0.0+].
##  @param[out] out Output AppletLaunchFlags bitmask.
##

proc setsysSetAppletLaunchFlags*(flags: U32): Result {.cdecl,
    importc: "setsysSetAppletLaunchFlags".}
## *
##  @brief SetAppletLaunchFlags
##  @note Only available on [4.0.0+].
##  @param[in] flags Input AppletLaunchFlags bitmask.
##

proc setsysGetConsoleSixAxisSensorAccelerationBias*(
    `out`: ptr SetSysConsoleSixAxisSensorAccelerationBias): Result {.cdecl,
    importc: "setsysGetConsoleSixAxisSensorAccelerationBias".}
## *
##  @brief GetConsoleSixAxisSensorAccelerationBias
##  @note Only available on [4.0.0+].
##  @param[out] out \ref SetSysConsoleSixAxisSensorAccelerationBias
##

proc setsysSetConsoleSixAxisSensorAccelerationBias*(
    bias: ptr SetSysConsoleSixAxisSensorAccelerationBias): Result {.cdecl,
    importc: "setsysSetConsoleSixAxisSensorAccelerationBias".}
## *
##  @brief SetConsoleSixAxisSensorAccelerationBias
##  @note Only available on [4.0.0+].
##  @param[in] bias \ref SetSysConsoleSixAxisSensorAccelerationBias
##

proc setsysGetConsoleSixAxisSensorAngularVelocityBias*(
    `out`: ptr SetSysConsoleSixAxisSensorAngularVelocityBias): Result {.cdecl,
    importc: "setsysGetConsoleSixAxisSensorAngularVelocityBias".}
## *
##  @brief GetConsoleSixAxisSensorAngularVelocityBias
##  @note Only available on [4.0.0+].
##  @param[out] out \ref SetSysConsoleSixAxisSensorAngularVelocityBias
##

proc setsysSetConsoleSixAxisSensorAngularVelocityBias*(
    bias: ptr SetSysConsoleSixAxisSensorAngularVelocityBias): Result {.cdecl,
    importc: "setsysSetConsoleSixAxisSensorAngularVelocityBias".}
## *
##  @brief SetConsoleSixAxisSensorAngularVelocityBias
##  @note Only available on [4.0.0+].
##  @param[in] bias \ref SetSysConsoleSixAxisSensorAngularVelocityBias
##

proc setsysGetConsoleSixAxisSensorAccelerationGain*(
    `out`: ptr SetSysConsoleSixAxisSensorAccelerationGain): Result {.cdecl,
    importc: "setsysGetConsoleSixAxisSensorAccelerationGain".}
## *
##  @brief GetConsoleSixAxisSensorAccelerationGain
##  @note Only available on [4.0.0+].
##  @param[out] out \ref SetSysConsoleSixAxisSensorAccelerationGain
##

proc setsysSetConsoleSixAxisSensorAccelerationGain*(
    gain: ptr SetSysConsoleSixAxisSensorAccelerationGain): Result {.cdecl,
    importc: "setsysSetConsoleSixAxisSensorAccelerationGain".}
## *
##  @brief SetConsoleSixAxisSensorAccelerationGain
##  @note Only available on [4.0.0+].
##  @param[in] gain \ref SetSysConsoleSixAxisSensorAccelerationGain
##

proc setsysGetConsoleSixAxisSensorAngularVelocityGain*(
    `out`: ptr SetSysConsoleSixAxisSensorAngularVelocityGain): Result {.cdecl,
    importc: "setsysGetConsoleSixAxisSensorAngularVelocityGain".}
## *
##  @brief GetConsoleSixAxisSensorAngularVelocityGain
##  @note Only available on [4.0.0+].
##  @param[out] out \ref SetSysConsoleSixAxisSensorAngularVelocityGain
##

proc setsysSetConsoleSixAxisSensorAngularVelocityGain*(
    gain: ptr SetSysConsoleSixAxisSensorAngularVelocityGain): Result {.cdecl,
    importc: "setsysSetConsoleSixAxisSensorAngularVelocityGain".}
## *
##  @brief SetConsoleSixAxisSensorAngularVelocityGain
##  @note Only available on [4.0.0+].
##  @param[in] gain \ref SetSysConsoleSixAxisSensorAngularVelocityGain
##

proc setsysGetKeyboardLayout*(`out`: ptr SetKeyboardLayout): Result {.cdecl,
    importc: "setsysGetKeyboardLayout".}
## *
##  @brief GetKeyboardLayout
##  @note Only available on [4.0.0+].
##  @param[out] out \ref SetKeyboardLayout
##

proc setsysSetKeyboardLayout*(layout: SetKeyboardLayout): Result {.cdecl,
    importc: "setsysSetKeyboardLayout".}
## *
##  @brief SetKeyboardLayout
##  @note Only available on [4.0.0+].
##  @param[in] layout \ref SetKeyboardLayout
##

proc setsysGetWebInspectorFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetWebInspectorFlag".}
## *
##  @brief GetWebInspectorFlag
##  @note Only available on [4.0.0+].
##  @param[out] out Output flag.
##

proc setsysGetAllowedSslHosts*(totalOut: ptr S32; `out`: ptr SetSysAllowedSslHosts;
                              count: S32): Result {.cdecl,
    importc: "setsysGetAllowedSslHosts".}
## *
##  @brief GetAllowedSslHosts
##  @note Only available on [4.0.0+].
##  @param[out] total_out Total output entries.
##  @param[out] out Output array of \ref SetSysAllowedSslHosts.
##  @param[in] count Size of the hosts array in entries.
##

proc setsysGetHostFsMountPoint*(`out`: ptr SetSysHostFsMountPoint): Result {.cdecl,
    importc: "setsysGetHostFsMountPoint".}
## *
##  @brief GetHostFsMountPoint
##  @note Only available on [4.0.0+].
##  @param[out] out \ref SetSysHostFsMountPoint
##

proc setsysGetRequiresRunRepairTimeReviser*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetRequiresRunRepairTimeReviser".}
## *
##  @brief GetRequiresRunRepairTimeReviser
##  @note Only available on [5.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetRequiresRunRepairTimeReviser*(flag: bool): Result {.cdecl,
    importc: "setsysSetRequiresRunRepairTimeReviser".}
## *
##  @brief SetRequiresRunRepairTimeReviser
##  @note Only available on [5.0.0+].
##  @param[in] flag Input flag.
##

proc setsysSetBlePairingSettings*(settings: ptr SetSysBlePairingSettings; count: S32): Result {.
    cdecl, importc: "setsysSetBlePairingSettings".}
## *
##  @brief SetBlePairingSettings
##  @note Only available on [5.0.0+].
##  @param[in] settings Input array of \ref SetSysBlePairingSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetBlePairingSettings*(totalOut: ptr S32;
                                 settings: ptr SetSysBlePairingSettings; count: S32): Result {.
    cdecl, importc: "setsysGetBlePairingSettings".}
## *
##  @brief GetBlePairingSettings
##  @note Only available on [5.0.0+].
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysBlePairingSettings.
##  @param[in] count Size of the hosts array in entries.
##

proc setsysGetConsoleSixAxisSensorAngularVelocityTimeBias*(
    `out`: ptr SetSysConsoleSixAxisSensorAngularVelocityTimeBias): Result {.cdecl,
    importc: "setsysGetConsoleSixAxisSensorAngularVelocityTimeBias".}
## *
##  @brief GetConsoleSixAxisSensorAngularVelocityTimeBias
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetSysConsoleSixAxisSensorAngularVelocityTimeBias
##

proc setsysSetConsoleSixAxisSensorAngularVelocityTimeBias*(
    bias: ptr SetSysConsoleSixAxisSensorAngularVelocityTimeBias): Result {.cdecl,
    importc: "setsysSetConsoleSixAxisSensorAngularVelocityTimeBias".}
## *
##  @brief SetConsoleSixAxisSensorAngularVelocityTimeBias
##  @note Only available on [5.0.0+].
##  @param[in] bias \ref SetSysConsoleSixAxisSensorAngularVelocityTimeBias
##

proc setsysGetConsoleSixAxisSensorAngularAcceleration*(
    `out`: ptr SetSysConsoleSixAxisSensorAngularAcceleration): Result {.cdecl,
    importc: "setsysGetConsoleSixAxisSensorAngularAcceleration".}
## *
##  @brief GetConsoleSixAxisSensorAngularAcceleration
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetSysConsoleSixAxisSensorAngularAcceleration
##

proc setsysSetConsoleSixAxisSensorAngularAcceleration*(
    acceleration: ptr SetSysConsoleSixAxisSensorAngularAcceleration): Result {.
    cdecl, importc: "setsysSetConsoleSixAxisSensorAngularAcceleration".}
## *
##  @brief SetConsoleSixAxisSensorAngularAcceleration
##  @note Only available on [5.0.0+].
##  @param[in] acceleration \ref SetSysConsoleSixAxisSensorAngularAcceleration
##

proc setsysGetRebootlessSystemUpdateVersion*(
    `out`: ptr SetSysRebootlessSystemUpdateVersion): Result {.cdecl,
    importc: "setsysGetRebootlessSystemUpdateVersion".}
## *
##  @brief GetRebootlessSystemUpdateVersion
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetSysRebootlessSystemUpdateVersion
##

proc setsysGetDeviceTimeZoneLocationUpdatedTime*(
    `out`: ptr TimeSteadyClockTimePoint): Result {.cdecl,
    importc: "setsysGetDeviceTimeZoneLocationUpdatedTime".}
## *
##  @brief GetDeviceTimeZoneLocationUpdatedTime
##  @note Only available on [5.0.0+].
##  @param[out] out \ref TimeSteadyClockTimePoint
##

proc setsysSetDeviceTimeZoneLocationUpdatedTime*(
    timePoint: ptr TimeSteadyClockTimePoint): Result {.cdecl,
    importc: "setsysSetDeviceTimeZoneLocationUpdatedTime".}
## *
##  @brief SetDeviceTimeZoneLocationUpdatedTime
##  @note Only available on [5.0.0+].
##  @param[in] time_point \ref TimeSteadyClockTimePoint
##

proc setsysGetUserSystemClockAutomaticCorrectionUpdatedTime*(
    `out`: ptr TimeSteadyClockTimePoint): Result {.cdecl,
    importc: "setsysGetUserSystemClockAutomaticCorrectionUpdatedTime".}
## *
##  @brief GetUserSystemClockAutomaticCorrectionUpdatedTime
##  @note Only available on [6.0.0+].
##  @param[out] out \ref TimeSteadyClockTimePoint
##

proc setsysSetUserSystemClockAutomaticCorrectionUpdatedTime*(
    timePoint: ptr TimeSteadyClockTimePoint): Result {.cdecl,
    importc: "setsysSetUserSystemClockAutomaticCorrectionUpdatedTime".}
## *
##  @brief SetUserSystemClockAutomaticCorrectionUpdatedTime
##  @note Only available on [6.0.0+].
##  @param[in] time_point \ref TimeSteadyClockTimePoint
##

proc setsysGetAccountOnlineStorageSettings*(totalOut: ptr S32;
    settings: ptr SetSysAccountOnlineStorageSettings; count: S32): Result {.cdecl,
    importc: "setsysGetAccountOnlineStorageSettings".}
## *
##  @brief GetAccountOnlineStorageSettings
##  @note Only available on [6.0.0+].
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysAccountOnlineStorageSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysSetAccountOnlineStorageSettings*(
    settings: ptr SetSysAccountOnlineStorageSettings; count: S32): Result {.cdecl,
    importc: "setsysSetAccountOnlineStorageSettings".}
## *
##  @brief SetAccountOnlineStorageSettings
##  @note Only available on [6.0.0+].
##  @param[in] settings Input array of \ref SetSysAccountOnlineStorageSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetPctlReadyFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetPctlReadyFlag".}
## *
##  @brief GetPctlReadyFlag
##  @note Only available on [6.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetPctlReadyFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetPctlReadyFlag".}
## *
##  @brief SetPctlReadyFlag
##  @note Only available on [6.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetAnalogStickUserCalibrationL*(
    `out`: ptr SetSysAnalogStickUserCalibration): Result {.cdecl,
    importc: "setsysGetAnalogStickUserCalibrationL".}
## *
##  @brief GetAnalogStickUserCalibrationL
##  @note Only available on [8.1.1+].
##  @param[out] out \ref SetSysAnalogStickUserCalibration
##

proc setsysSetAnalogStickUserCalibrationL*(
    calibration: ptr SetSysAnalogStickUserCalibration): Result {.cdecl,
    importc: "setsysSetAnalogStickUserCalibrationL".}
## *
##  @brief SetAnalogStickUserCalibrationL
##  @note Only available on [8.1.1+].
##  @param[in] calibration \ref SetSysAnalogStickUserCalibration
##

proc setsysGetAnalogStickUserCalibrationR*(
    `out`: ptr SetSysAnalogStickUserCalibration): Result {.cdecl,
    importc: "setsysGetAnalogStickUserCalibrationR".}
## *
##  @brief GetAnalogStickUserCalibrationR
##  @note Only available on [8.1.1+].
##  @param[out] out \ref SetSysAnalogStickUserCalibration
##

proc setsysSetAnalogStickUserCalibrationR*(
    calibration: ptr SetSysAnalogStickUserCalibration): Result {.cdecl,
    importc: "setsysSetAnalogStickUserCalibrationR".}
## *
##  @brief SetAnalogStickUserCalibrationR
##  @note Only available on [8.1.1+].
##  @param[in] calibration \ref SetSysAnalogStickUserCalibration
##

proc setsysGetPtmBatteryVersion*(`out`: ptr U8): Result {.cdecl,
    importc: "setsysGetPtmBatteryVersion".}
## *
##  @brief GetPtmBatteryVersion
##  @note Only available on [6.0.0+].
##  @param[out] out Output version.
##

proc setsysSetPtmBatteryVersion*(version: U8): Result {.cdecl,
    importc: "setsysSetPtmBatteryVersion".}
## *
##  @brief SetPtmBatteryVersion
##  @note Only available on [6.0.0+].
##  @param[in] version Input version.
##

proc setsysGetUsb30HostEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetUsb30HostEnableFlag".}
## *
##  @brief GetUsb30HostEnableFlag
##  @note Only available on [6.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetUsb30HostEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetUsb30HostEnableFlag".}
## *
##  @brief SetUsb30HostEnableFlag
##  @note Only available on [6.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetUsb30DeviceEnableFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetUsb30DeviceEnableFlag".}
## *
##  @brief GetUsb30DeviceEnableFlag
##  @note Only available on [6.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetUsb30DeviceEnableFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetUsb30DeviceEnableFlag".}
## *
##  @brief SetUsb30DeviceEnableFlag
##  @note Only available on [6.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetThemeId*(`type`: S32; `out`: ptr SetSysThemeId): Result {.cdecl,
    importc: "setsysGetThemeId".}
## *
##  @brief GetThemeId
##  @note Only available on [7.0.0+].
##  @param[in] type Input theme id type.
##  @param[out] out \ref SetSysThemeId
##

proc setsysSetThemeId*(`type`: S32; themeId: ptr SetSysThemeId): Result {.cdecl,
    importc: "setsysSetThemeId".}
## *
##  @brief SetThemeId
##  @note Only available on [7.0.0+].
##  @param[in] type Input theme id type.
##  @param[in] theme_id \ref SetSysThemeId
##

proc setsysGetChineseTraditionalInputMethod*(
    `out`: ptr SetChineseTraditionalInputMethod): Result {.cdecl,
    importc: "setsysGetChineseTraditionalInputMethod".}
## *
##  @brief GetChineseTraditionalInputMethod
##  @note Only available on [7.0.0+].
##  @param[out] out \ref SetChineseTraditionalInputMethod
##

proc setsysSetChineseTraditionalInputMethod*(
    `method`: SetChineseTraditionalInputMethod): Result {.cdecl,
    importc: "setsysSetChineseTraditionalInputMethod".}
## *
##  @brief SetChineseTraditionalInputMethod
##  @note Only available on [7.0.0+].
##  @param[in] method \ref SetChineseTraditionalInputMethod
##

proc setsysGetPtmCycleCountReliability*(`out`: ptr SetSysPtmCycleCountReliability): Result {.
    cdecl, importc: "setsysGetPtmCycleCountReliability".}
## *
##  @brief GetPtmCycleCountReliability
##  @note Only available on [7.0.0+].
##  @param[out] out \ref SetSysPtmCycleCountReliability
##

proc setsysSetPtmCycleCountReliability*(reliability: SetSysPtmCycleCountReliability): Result {.
    cdecl, importc: "setsysSetPtmCycleCountReliability".}
## *
##  @brief SetPtmCycleCountReliability
##  @note Only available on [7.0.0+].
##  @param[in] reliability \ref SetSysPtmCycleCountReliability
##

proc setsysGetHomeMenuScheme*(`out`: ptr SetSysHomeMenuScheme): Result {.cdecl,
    importc: "setsysGetHomeMenuScheme".}
## *
##  @brief Gets the \ref SetSysHomeMenuScheme.
##  @note Only available on [8.1.1+].
##  @param[out] out \ref SetSysHomeMenuScheme
##

proc setsysGetThemeSettings*(`out`: ptr SetSysThemeSettings): Result {.cdecl,
    importc: "setsysGetThemeSettings".}
## *
##  @brief GetThemeSettings
##  @note Only available on [7.0.0+].
##  @param[out] out \ref SetSysThemeSettings
##

proc setsysSetThemeSettings*(settings: ptr SetSysThemeSettings): Result {.cdecl,
    importc: "setsysSetThemeSettings".}
## *
##  @brief SetThemeSettings
##  @note Only available on [7.0.0+].
##  @param[in] settings \ref SetSysThemeSettings
##

proc setsysGetThemeKey*(`out`: ptr FsArchiveMacKey): Result {.cdecl,
    importc: "setsysGetThemeKey".}
## *
##  @brief GetThemeKey
##  @note Only available on [7.0.0+].
##  @param[out] out \ref FsArchiveMacKey
##

proc setsysSetThemeKey*(key: ptr FsArchiveMacKey): Result {.cdecl,
    importc: "setsysSetThemeKey".}
## *
##  @brief SetThemeKey
##  @note Only available on [7.0.0+].
##  @param[in] key \ref FsArchiveMacKey
##

proc setsysGetZoomFlag*(`out`: ptr bool): Result {.cdecl, importc: "setsysGetZoomFlag".}
## *
##  @brief GetZoomFlag
##  @note Only available on [8.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetZoomFlag*(flag: bool): Result {.cdecl, importc: "setsysSetZoomFlag".}
## *
##  @brief SetZoomFlag
##  @note Only available on [8.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetT*(`out`: ptr bool): Result {.cdecl, importc: "setsysGetT".}
## *
##  @brief Returns Terra platform type flag.
##  @note On [9.0.0+], this is a wrapper for \ref setsysGetPlatFormRegion() == 2.
##  @note Only available on [8.0.0+].
##  @param[out] out Output flag.
##

proc setsysSetT*(flag: bool): Result {.cdecl, importc: "setsysSetT".}
## *
##  @brief Sets Terra platform type flag.
##  @note On [9.0.0+], this is a wrapper for \ref setsysSetPlatFormRegion(1 + (IsT & 1)).
##  @note Only available on [8.0.0+].
##  @param[in] flag Input flag.
##

proc setsysGetPlatformRegion*(`out`: ptr SetSysPlatformRegion): Result {.cdecl,
    importc: "setsysGetPlatformRegion".}
## *
##  @brief Gets the \ref SetSysPlatformRegion.
##  @note This is used internally by \ref appletGetSettingsPlatformRegion.
##  @note Only available on [9.0.0+].
##  @param[out] out \ref SetSysPlatformRegion
##

proc setsysSetPlatformRegion*(region: SetSysPlatformRegion): Result {.cdecl,
    importc: "setsysSetPlatformRegion".}
## *
##  @brief Sets the \ref SetSysPlatformRegion.
##  @note Only available on [9.0.0+].
##  @param[in] region \ref SetSysPlatformRegion
##

proc setsysGetHomeMenuSchemeModel*(`out`: ptr U32): Result {.cdecl,
    importc: "setsysGetHomeMenuSchemeModel".}
## *
##  @brief GetHomeMenuSchemeModel
##  @note This will throw an error when loading the "settings_debug!{...}" system-setting which is used with this fails.
##  @note Only available on [9.0.0+].
##  @param[out] out HomeMenuSchemeModel.
##

proc setsysGetMemoryUsageRateFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetMemoryUsageRateFlag".}
## *
##  @brief GetMemoryUsageRateFlag
##  @note Only available on [9.0.0+].
##  @param[out] out Output flag.
##

proc setsysGetTouchScreenMode*(`out`: ptr SetSysTouchScreenMode): Result {.cdecl,
    importc: "setsysGetTouchScreenMode".}
## *
##  @brief Gets the \ref SetSysTouchScreenMode.
##  @note Only available on [9.0.0+].
##  @param[out] out \ref SetSysTouchScreenMode
##

proc setsysSetTouchScreenMode*(mode: SetSysTouchScreenMode): Result {.cdecl,
    importc: "setsysSetTouchScreenMode".}
## *
##  @brief Sets the \ref SetSysTouchScreenMode.
##  @note Only available on [9.0.0+].
##  @param[in] mode \ref SetSysTouchScreenMode
##

proc setsysGetButtonConfigSettingsFull*(totalOut: ptr S32; settings: ptr SetSysButtonConfigSettings;
                                       count: S32): Result {.cdecl,
    importc: "setsysGetButtonConfigSettingsFull".}
## *
##  @brief GetButtonConfigSettingsFull
##  @note Only available on [10.0.0+].
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysButtonConfigSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysSetButtonConfigSettingsFull*(settings: ptr SetSysButtonConfigSettings;
                                       count: S32): Result {.cdecl,
    importc: "setsysSetButtonConfigSettingsFull".}
## *
##  @brief SetButtonConfigSettingsFull
##  @note Only available on [10.0.0+].
##  @param[in] settings Input array of \ref SetSysButtonConfigSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetButtonConfigSettingsEmbedded*(totalOut: ptr S32;
    settings: ptr SetSysButtonConfigSettings; count: S32): Result {.cdecl,
    importc: "setsysGetButtonConfigSettingsEmbedded".}
## *
##  @brief GetButtonConfigSettingsEmbedded
##  @note Only available on [10.0.0+].
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysButtonConfigSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysSetButtonConfigSettingsEmbedded*(
    settings: ptr SetSysButtonConfigSettings; count: S32): Result {.cdecl,
    importc: "setsysSetButtonConfigSettingsEmbedded".}
## *
##  @brief SetButtonConfigSettingsEmbedded
##  @note Only available on [10.0.0+].
##  @param[in] settings Input array of \ref SetSysButtonConfigSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetButtonConfigSettingsLeft*(totalOut: ptr S32; settings: ptr SetSysButtonConfigSettings;
                                       count: S32): Result {.cdecl,
    importc: "setsysGetButtonConfigSettingsLeft".}
## *
##  @brief GetButtonConfigSettingsLeft
##  @note Only available on [10.0.0+].
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysButtonConfigSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysSetButtonConfigSettingsLeft*(settings: ptr SetSysButtonConfigSettings;
                                       count: S32): Result {.cdecl,
    importc: "setsysSetButtonConfigSettingsLeft".}
## *
##  @brief SetButtonConfigSettingsLeft
##  @note Only available on [10.0.0+].
##  @param[in] settings Input array of \ref SetSysButtonConfigSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetButtonConfigSettingsRight*(totalOut: ptr S32; settings: ptr SetSysButtonConfigSettings;
                                        count: S32): Result {.cdecl,
    importc: "setsysGetButtonConfigSettingsRight".}
## *
##  @brief GetButtonConfigSettingsRight
##  @note Only available on [10.0.0+].
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysButtonConfigSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysSetButtonConfigSettingsRight*(settings: ptr SetSysButtonConfigSettings;
                                        count: S32): Result {.cdecl,
    importc: "setsysSetButtonConfigSettingsRight".}
## *
##  @brief SetButtonConfigSettingsRight
##  @note Only available on [10.0.0+].
##  @param[in] settings Input array of \ref SetSysButtonConfigSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysGetButtonConfigRegisteredSettingsEmbedded*(
    settings: ptr SetSysButtonConfigRegisteredSettings): Result {.cdecl,
    importc: "setsysGetButtonConfigRegisteredSettingsEmbedded".}
## *
##  @brief GetButtonConfigRegisteredSettingsEmbedded
##  @note Only available on [10.0.0+].
##  @param[out] settings \ref SetSysButtonConfigRegisteredSettings
##

proc setsysSetButtonConfigRegisteredSettingsEmbedded*(
    settings: ptr SetSysButtonConfigRegisteredSettings): Result {.cdecl,
    importc: "setsysSetButtonConfigRegisteredSettingsEmbedded".}
## *
##  @brief SetButtonConfigRegisteredSettingsEmbedded
##  @note Only available on [10.0.0+].
##  @param[in] settings \ref SetSysButtonConfigRegisteredSettings
##

proc setsysGetButtonConfigRegisteredSettings*(totalOut: ptr S32;
    settings: ptr SetSysButtonConfigRegisteredSettings; count: S32): Result {.cdecl,
    importc: "setsysGetButtonConfigRegisteredSettings".}
## *
##  @brief GetButtonConfigRegisteredSettings
##  @note Only available on [10.0.0+].
##  @param[out] settings \ref SetSysButtonConfigRegisteredSettings
##

proc setsysSetButtonConfigRegisteredSettings*(
    settings: ptr SetSysButtonConfigRegisteredSettings; count: S32): Result {.cdecl,
    importc: "setsysSetButtonConfigRegisteredSettings".}
## *
##  @brief SetButtonConfigRegisteredSettings
##  @note Only available on [10.0.0+].
##  @param[in] settings \ref SetSysButtonConfigRegisteredSettings
##

proc setsysGetFieldTestingFlag*(`out`: ptr bool): Result {.cdecl,
    importc: "setsysGetFieldTestingFlag".}
## *
##  @brief GetFieldTestingFlag
##  @note Only available on [10.1.0+].
##  @param[out] out Output flag.
##

proc setsysSetFieldTestingFlag*(flag: bool): Result {.cdecl,
    importc: "setsysSetFieldTestingFlag".}
## *
##  @brief SetFieldTestingFlag
##  @note Only available on [10.1.0+].
##  @param[in] flag Input flag.
##

proc setsysGetNxControllerSettingsEx*(totalOut: ptr S32;
                                     settings: ptr SetSysNxControllerSettings;
                                     count: S32): Result {.cdecl,
    importc: "setsysGetNxControllerSettingsEx".}
## *
##  @brief GetNxControllerSettingsEx
##  @param[out] total_out Total output entries.
##  @param[out] settings Output array of \ref SetSysNxControllerSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setsysSetNxControllerSettingsEx*(settings: ptr SetSysNxControllerSettings;
                                     count: S32): Result {.cdecl,
    importc: "setsysSetNxControllerSettingsEx".}
## *
##  @brief SetNxControllerSettingsEx
##  @param[in] settings Input array of \ref SetSysNxControllerSettings.
##  @param[in] count Size of the settings array in entries.
##

proc setcalInitialize*(): Result {.cdecl, importc: "setcalInitialize".}
## / Initialize setcal.

proc setcalExit*() {.cdecl, importc: "setcalExit".}
## / Exit setcal.

proc setcalGetServiceSession*(): ptr Service {.cdecl,
    importc: "setcalGetServiceSession".}
## / Gets the Service object for the actual setcal service session.

proc setcalGetBdAddress*(`out`: ptr SetCalBdAddress): Result {.cdecl,
    importc: "setcalGetBdAddress".}
## *
##  @brief Gets the \ref SetCalBdAddress.
##  @param[out] out \ref SetCalBdAddress
##

proc setcalGetConfigurationId1*(`out`: ptr SetCalConfigurationId1): Result {.cdecl,
    importc: "setcalGetConfigurationId1".}
## *
##  @brief Gets the \ref SetCalConfigurationId1.
##  @param[out] out \ref SetCalConfigurationId1
##

proc setcalGetAccelerometerOffset*(`out`: ptr SetCalAccelerometerOffset): Result {.
    cdecl, importc: "setcalGetAccelerometerOffset".}
## *
##  @brief Gets the \ref SetCalAccelerometerOffset.
##  @param[out] out \ref SetCalAccelerometerOffset
##

proc setcalGetAccelerometerScale*(`out`: ptr SetCalAccelerometerScale): Result {.
    cdecl, importc: "setcalGetAccelerometerScale".}
## *
##  @brief Gets the \ref SetCalAccelerometerScale.
##  @param[out] out \ref SetCalAccelerometerScale
##

proc setcalGetGyroscopeOffset*(`out`: ptr SetCalGyroscopeOffset): Result {.cdecl,
    importc: "setcalGetGyroscopeOffset".}
## *
##  @brief Gets the \ref SetCalGyroscopeOffset.
##  @param[out] out \ref SetCalGyroscopeOffset
##

proc setcalGetGyroscopeScale*(`out`: ptr SetCalGyroscopeScale): Result {.cdecl,
    importc: "setcalGetGyroscopeScale".}
## *
##  @brief Gets the \ref SetCalGyroscopeScale.
##  @param[out] out \ref SetCalGyroscopeScale
##

proc setcalGetWirelessLanMacAddress*(`out`: ptr SetCalMacAddress): Result {.cdecl,
    importc: "setcalGetWirelessLanMacAddress".}
## *
##  @brief Gets the \ref SetCalMacAddress.
##  @param[out] out \ref SetCalMacAddress
##

proc setcalGetWirelessLanCountryCodeCount*(outCount: ptr S32): Result {.cdecl,
    importc: "setcalGetWirelessLanCountryCodeCount".}
## *
##  @brief GetWirelessLanCountryCodeCount
##  @param[out] out_count Output count
##

proc setcalGetWirelessLanCountryCodes*(totalOut: ptr S32;
                                      codes: ptr SetCalCountryCode; count: S32): Result {.
    cdecl, importc: "setcalGetWirelessLanCountryCodes".}
## *
##  @brief GetWirelessLanCountryCodes
##  @param[out] total_out Total output entries.
##  @param[out] codes Output array of \ref SetCalCountryCode.
##  @param[in] count Size of the versions array in entries.
##

proc setcalGetSerialNumber*(`out`: ptr SetCalSerialNumber): Result {.cdecl,
    importc: "setcalGetSerialNumber".}
## *
##  @brief Gets the \ref SetCalSerialNumber.
##  @param[out] out \ref SetCalSerialNumber
##

proc setcalSetInitialSystemAppletProgramId*(programId: U64): Result {.cdecl,
    importc: "setcalSetInitialSystemAppletProgramId".}
## *
##  @brief SetInitialSystemAppletProgramId
##  @param[in] program_id input ProgramId.
##

proc setcalSetOverlayDispProgramId*(programId: U64): Result {.cdecl,
    importc: "setcalSetOverlayDispProgramId".}
## *
##  @brief SetOverlayDispProgramId
##  @param[in] program_id input ProgramId.
##

proc setcalGetBatteryLot*(`out`: ptr SetBatteryLot): Result {.cdecl,
    importc: "setcalGetBatteryLot".}
## *
##  @brief Gets the \ref SetBatteryLot.
##  @param[out] out \ref SetBatteryLot
##

proc setcalGetEciDeviceCertificate*(`out`: ptr SetCalEccB233DeviceCertificate): Result {.
    cdecl, importc: "setcalGetEciDeviceCertificate".}
## *
##  @brief Gets the \ref SetCalEccB233DeviceCertificate.
##  @param[out] out \ref SetCalEccB233DeviceCertificate
##

proc setcalGetEticketDeviceCertificate*(`out`: ptr SetCalRsa2048DeviceCertificate): Result {.
    cdecl, importc: "setcalGetEticketDeviceCertificate".}
## *
##  @brief Gets the \ref SetCalRsa2048DeviceCertificate.
##  @param[out] out \ref SetCalRsa2048DeviceCertificate
##

proc setcalGetSslKey*(`out`: ptr SetCalSslKey): Result {.cdecl,
    importc: "setcalGetSslKey".}
## *
##  @brief Gets the \ref SetCalSslKey.
##  @param[out] out \ref SetCalSslKey
##

proc setcalGetSslCertificate*(`out`: ptr SetCalSslCertificate): Result {.cdecl,
    importc: "setcalGetSslCertificate".}
## *
##  @brief Gets the \ref SetCalSslCertificate.
##  @param[out] out \ref SetCalSslCertificate
##

proc setcalGetGameCardKey*(`out`: ptr SetCalGameCardKey): Result {.cdecl,
    importc: "setcalGetGameCardKey".}
## *
##  @brief Gets the \ref SetCalGameCardKey.
##  @param[out] out \ref SetCalGameCardKey
##

proc setcalGetGameCardCertificate*(`out`: ptr SetCalGameCardCertificate): Result {.
    cdecl, importc: "setcalGetGameCardCertificate".}
## *
##  @brief Gets the \ref SetCalGameCardCertificate.
##  @param[out] out \ref SetCalGameCardCertificate
##

proc setcalGetEciDeviceKey*(`out`: ptr SetCalEccB233DeviceKey): Result {.cdecl,
    importc: "setcalGetEciDeviceKey".}
## *
##  @brief Gets the \ref SetCalEccB233DeviceKey.
##  @param[out] out \ref SetCalEccB233DeviceKey
##

proc setcalGetEticketDeviceKey*(`out`: ptr SetCalRsa2048DeviceKey): Result {.cdecl,
    importc: "setcalGetEticketDeviceKey".}
## *
##  @brief Gets the \ref SetCalRsa2048DeviceKey.
##  @param[out] out \ref SetCalRsa2048DeviceKey
##

proc setcalGetSpeakerParameter*(`out`: ptr SetCalSpeakerParameter): Result {.cdecl,
    importc: "setcalGetSpeakerParameter".}
## *
##  @brief Gets the \ref SetCalSpeakerParameter.
##  @param[out] out \ref SetCalSpeakerParameter
##

proc setcalGetLcdVendorId*(outVendorId: ptr U32): Result {.cdecl,
    importc: "setcalGetLcdVendorId".}
## *
##  @brief GetLcdVendorId
##  @note Only available on [4.0.0+].
##  @param[out] out_vendor_id Output LcdVendorId.
##

proc setcalGetEciDeviceCertificate2*(`out`: ptr SetCalRsa2048DeviceCertificate): Result {.
    cdecl, importc: "setcalGetEciDeviceCertificate2".}
## *
##  @brief Gets the \ref SetCalRsa2048DeviceCertificate.
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetCalRsa2048DeviceCertificate
##

proc setcalGetEciDeviceKey2*(`out`: ptr SetCalRsa2048DeviceKey): Result {.cdecl,
    importc: "setcalGetEciDeviceKey2".}
## *
##  @brief Gets the \ref SetCalRsa2048DeviceKey.
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetCalRsa2048DeviceKey
##

proc setcalGetAmiiboKey*(`out`: ptr SetCalAmiiboKey): Result {.cdecl,
    importc: "setcalGetAmiiboKey".}
## *
##  @brief Gets the \ref SetCalAmiiboKey.
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetCalAmiiboKey
##

proc setcalGetAmiiboEcqvCertificate*(`out`: ptr SetCalAmiiboEcqvCertificate): Result {.
    cdecl, importc: "setcalGetAmiiboEcqvCertificate".}
## *
##  @brief Gets the \ref SetCalAmiiboEcqvCertificate.
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetCalAmiiboEcqvCertificate
##

proc setcalGetAmiiboEcdsaCertificate*(`out`: ptr SetCalAmiiboEcdsaCertificate): Result {.
    cdecl, importc: "setcalGetAmiiboEcdsaCertificate".}
## *
##  @brief Gets the \ref SetCalAmiiboEcdsaCertificate.
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetCalAmiiboEcdsaCertificate
##

proc setcalGetAmiiboEcqvBlsKey*(`out`: ptr SetCalAmiiboEcqvBlsKey): Result {.cdecl,
    importc: "setcalGetAmiiboEcqvBlsKey".}
## *
##  @brief Gets the \ref SetCalAmiiboEcqvBlsKey.
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetCalAmiiboEcqvBlsKey
##

proc setcalGetAmiiboEcqvBlsCertificate*(`out`: ptr SetCalAmiiboEcqvBlsCertificate): Result {.
    cdecl, importc: "setcalGetAmiiboEcqvBlsCertificate".}
## *
##  @brief Gets the \ref SetCalAmiiboEcqvBlsCertificate.
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetCalAmiiboEcqvBlsCertificate
##

proc setcalGetAmiiboEcqvBlsRootCertificate*(
    `out`: ptr SetCalAmiiboEcqvBlsRootCertificate): Result {.cdecl,
    importc: "setcalGetAmiiboEcqvBlsRootCertificate".}
## *
##  @brief Gets the \ref SetCalAmiiboEcqvBlsRootCertificate.
##  @note Only available on [5.0.0+].
##  @param[out] out \ref SetCalAmiiboEcqvBlsRootCertificate
##

proc setcalGetUsbTypeCPowerSourceCircuitVersion*(outVersion: ptr U8): Result {.cdecl,
    importc: "setcalGetUsbTypeCPowerSourceCircuitVersion".}
## *
##  @brief GetUsbTypeCPowerSourceCircuitVersion
##  @note Only available on [5.0.0+].
##  @param[out] out_version Output UsbTypeCPowerSourceCircuitVersion.
##

proc setcalGetAnalogStickModuleTypeL*(outType: ptr U8): Result {.cdecl,
    importc: "setcalGetAnalogStickModuleTypeL".}
## *
##  @brief GetAnalogStickModuleTypeL
##  @note Only available on [8.1.1+].
##  @param[out] out_version Output AnalogStickModuleType.
##

proc setcalGetAnalogStickModelParameterL*(
    `out`: ptr SetCalAnalogStickModelParameter): Result {.cdecl,
    importc: "setcalGetAnalogStickModelParameterL".}
## *
##  @brief Gets the \ref SetCalAnalogStickModelParameter.
##  @note Only available on [8.1.1+].
##  @param[out] out \ref SetCalAnalogStickModelParameter
##

proc setcalGetAnalogStickFactoryCalibrationL*(
    `out`: ptr SetCalAnalogStickFactoryCalibration): Result {.cdecl,
    importc: "setcalGetAnalogStickFactoryCalibrationL".}
## *
##  @brief Gets the \ref SetCalAnalogStickFactoryCalibration.
##  @note Only available on [8.1.1+].
##  @param[out] out \ref SetCalAnalogStickFactoryCalibration
##

proc setcalGetAnalogStickModuleTypeR*(outType: ptr U8): Result {.cdecl,
    importc: "setcalGetAnalogStickModuleTypeR".}
## *
##  @brief GetAnalogStickModuleTypeR
##  @note Only available on [8.1.1+].
##  @param[out] out_version Output AnalogStickModuleType.
##

proc setcalGetAnalogStickModelParameterR*(
    `out`: ptr SetCalAnalogStickModelParameter): Result {.cdecl,
    importc: "setcalGetAnalogStickModelParameterR".}
## *
##  @brief Gets the \ref SetCalAnalogStickModelParameter.
##  @note Only available on [8.1.1+].
##  @param[out] out \ref SetCalAnalogStickModelParameter
##

proc setcalGetAnalogStickFactoryCalibrationR*(
    `out`: ptr SetCalAnalogStickFactoryCalibration): Result {.cdecl,
    importc: "setcalGetAnalogStickFactoryCalibrationR".}
## *
##  @brief Gets the \ref SetCalAnalogStickFactoryCalibration.
##  @note Only available on [8.1.1+].
##  @param[out] out \ref SetCalAnalogStickFactoryCalibration
##

proc setcalGetConsoleSixAxisSensorModuleType*(outType: ptr U8): Result {.cdecl,
    importc: "setcalGetConsoleSixAxisSensorModuleType".}
## *
##  @brief GetConsoleSixAxisSensorModuleType
##  @note Only available on [8.1.1+].
##  @param[out] out_version Output ConsoleSixAxisSensorModuleType.
##

proc setcalGetConsoleSixAxisSensorHorizontalOffset*(
    `out`: ptr SetCalConsoleSixAxisSensorHorizontalOffset): Result {.cdecl,
    importc: "setcalGetConsoleSixAxisSensorHorizontalOffset".}
## *
##  @brief Gets the \ref SetCalConsoleSixAxisSensorHorizontalOffset.
##  @note Only available on [8.1.1+].
##  @param[out] out \ref SetCalConsoleSixAxisSensorHorizontalOffset
##

proc setcalGetBatteryVersion*(outVersion: ptr U8): Result {.cdecl,
    importc: "setcalGetBatteryVersion".}
## *
##  @brief GetBatteryVersion
##  @note Only available on [6.0.0+].
##  @param[out] out_version Output BatteryVersion.
##

proc setcalGetDeviceId*(outDeviceId: ptr U64): Result {.cdecl,
    importc: "setcalGetDeviceId".}
## *
##  @brief GetDeviceId
##  @note Only available on [10.0.0+].
##  @param[out] out_type Output DeviceId.
##

proc setcalGetConsoleSixAxisSensorMountType*(outType: ptr U8): Result {.cdecl,
    importc: "setcalGetConsoleSixAxisSensorMountType".}
## *
##  @brief GetConsoleSixAxisSensorMountType
##  @note Only available on [10.0.0+].
##  @param[out] out_type Output ConsoleSixAxisSensorMountType.
##

