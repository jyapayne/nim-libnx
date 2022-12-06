## *
##  @file usb.h
##  @brief Common USB (usb:*) service IPC header.
##  @author SciresM, yellows8
##  @copyright libnx Authors
##

## / Names starting with "libusb" were changed to "usb" to avoid collision with actual libusb if it's ever used.
## / Imported from libusb with changed names.
##  Descriptor sizes per descriptor type

const
  USB_DT_INTERFACE_SIZE* = 9
  USB_DT_ENDPOINT_SIZE* = 7
  USB_DT_DEVICE_SIZE* = 0x12
  USB_DT_SS_ENDPOINT_COMPANION_SIZE* = 6
  USB_ENDPOINT_ADDRESS_MASK* = 0x0f
  USB_ENDPOINT_DIR_MASK* = 0x80
  USB_TRANSFER_TYPE_MASK* = 0x03

## / Imported from libusb, with some adjustments.

type
  UsbEndpointDescriptor* {.bycopy.} = object
    bLength*: uint8
    bDescriptorType*: uint8    ## /< Must match USB_DT_ENDPOINT.
    bEndpointAddress*: uint8   ## /< Should be one of the usb_endpoint_direction values, the endpoint-number is automatically allocated.
    bmAttributes*: uint8
    wMaxPacketSize*: uint16
    bInterval*: uint8


## / Imported from libusb, with some adjustments.

type
  UsbInterfaceDescriptor* {.bycopy.} = object
    bLength*: uint8
    bDescriptorType*: uint8    ## /< Must match USB_DT_INTERFACE.
    bInterfaceNumber*: uint8   ## /< See also USBDS_DEFAULT_InterfaceNumber.
    bAlternateSetting*: uint8  ## /< Must match 0.
    bNumEndpoints*: uint8
    bInterfaceClass*: uint8
    bInterfaceSubClass*: uint8
    bInterfaceProtocol*: uint8
    iInterface*: uint8         ## /< Ignored.


## / Imported from libusb, with some adjustments.

type
  UsbDeviceDescriptor* {.bycopy.} = object
    bLength*: uint8
    bDescriptorType*: uint8    ## /< Must match USB_DT_Device.
    bcdUSB*: uint16
    bDeviceClass*: uint8
    bDeviceSubClass*: uint8
    bDeviceProtocol*: uint8
    bMaxPacketSize0*: uint8
    idVendor*: uint16
    idProduct*: uint16
    bcdDevice*: uint16
    iManufacturer*: uint8
    iProduct*: uint8
    iSerialNumber*: uint8
    bNumConfigurations*: uint8


## / Imported from libusb, with some adjustments.

type
  UsbConfigDescriptor* {.bycopy.} = object
    bLength*: uint8
    bDescriptorType*: uint8
    wTotalLength*: uint16
    bNumInterfaces*: uint8
    bConfigurationValue*: uint8
    iConfiguration*: uint8
    bmAttributes*: uint8
    maxPower*: uint8


## / Imported from libusb, with some adjustments.

type
  UsbSsEndpointCompanionDescriptor* {.bycopy.} = object
    bLength*: uint8
    bDescriptorType*: uint8    ## /< Must match USB_DT_SS_ENDPOINT_COMPANION.
    bMaxBurst*: uint8
    bmAttributes*: uint8
    wBytesPerInterval*: uint16


## / Imported from libusb, with some adjustments.

type
  UsbStringDescriptor* {.bycopy.} = object
    bLength*: uint8
    bDescriptorType*: uint8    ## /< Must match USB_DT_STRING.
    wData*: array[0x40, uint16]


## / Imported from libusb, with changed names.

type
  UsbClassCode* = enum
    USB_CLASS_PER_INTERFACE = 0, USB_CLASS_AUDIO = 1, USB_CLASS_COMM = 2,
    USB_CLASS_HID = 3, USB_CLASS_PHYSICAL = 5, USB_CLASS_PTP = 6, ##  legacy name from libusb-0.1 usb.h
    USB_CLASS_PRINTER = 7, USB_CLASS_MASS_STORAGE = 8, USB_CLASS_HUB = 9,
    USB_CLASS_DATA = 10, USB_CLASS_SMART_CARD = 0x0b,
    USB_CLASS_CONTENT_SECURITY = 0x0d, USB_CLASS_VIDEO = 0x0e,
    USB_CLASS_PERSONAL_HEALTHCARE = 0x0f, USB_CLASS_DIAGNOSTIC_DEVICE = 0xdc,
    USB_CLASS_WIRELESS = 0xe0, USB_CLASS_APPLICATION = 0xfe,
    USB_CLASS_VENDOR_SPEC = 0xff

const
  USB_CLASS_IMAGE* = USB_CLASS_PTP

## / Imported from libusb, with changed names.

type
  UsbDescriptorType* = enum
    USB_DT_DEVICE = 0x01, USB_DT_CONFIG = 0x02, USB_DT_STRING = 0x03,
    USB_DT_INTERFACE = 0x04, USB_DT_ENDPOINT = 0x05, USB_DT_BOS = 0x0f,
    USB_DT_DEVICE_CAPABILITY = 0x10, USB_DT_HID = 0x21, USB_DT_REPORT = 0x22,
    USB_DT_PHYSICAL = 0x23, USB_DT_HUB = 0x29, USB_DT_SUPERSPEED_HUB = 0x2a,
    USB_DT_SS_ENDPOINT_COMPANION = 0x30


## / Imported from libusb, with changed names.

type
  UsbEndpointDirection* = enum
    USB_ENDPOINT_OUT = 0x00, USB_ENDPOINT_IN = 0x80


## / Imported from libusb, with changed names.

type
  UsbTransferType* = enum
    USB_TRANSFER_TYPE_CONTROL = 0, USB_TRANSFER_TYPE_ISOCHRONOUS = 1,
    USB_TRANSFER_TYPE_BULK = 2, USB_TRANSFER_TYPE_INTERRUPT = 3,
    USB_TRANSFER_TYPE_BULK_STREAM = 4


## / Imported from libusb, with changed names.

type
  UsbStandardRequest* = enum    ## * Request status of the specific recipient
    USB_REQUEST_GET_STATUS = 0x00, ## * Clear or disable a specific feature
    USB_REQUEST_CLEAR_FEATURE = 0x01, ##  0x02 is reserved
                                   ## * Set or enable a specific feature
    USB_REQUEST_SET_FEATURE = 0x03, ##  0x04 is reserved
                                 ## * Set device address for all future accesses
    USB_REQUEST_SET_ADDRESS = 0x05, ## * Get the specified descriptor
    USB_REQUEST_GET_DESCRIPTOR = 0x06, ## * Used to update existing descriptors or add new descriptors
    USB_REQUEST_SET_DESCRIPTOR = 0x07, ## * Get the current device configuration value
    USB_REQUEST_GET_CONFIGURATION = 0x08, ## * Set device configuration
    USB_REQUEST_SET_CONFIGURATION = 0x09, ## * Return the selected alternate setting for the specified interface
    USB_REQUEST_GET_INTERFACE = 0x0A, ## * Select an alternate interface for the specified interface
    USB_REQUEST_SET_INTERFACE = 0x0B, ## * Set then report an endpoint's synchronization frame
    USB_REQUEST_SYNCH_FRAME = 0x0C, ## * Sets both the U1 and U2 Exit Latency
    USB_REQUEST_SET_SEL = 0x30, ## * Delay from the time a host transmits a packet to the time it is
                             ##  received by the device.
    USB_SET_ISOCH_DELAY = 0x31


## / Imported from libusb, with changed names.

type
  UsbIsoSyncType* = enum
    USB_ISO_SYNC_TYPE_NONE = 0, USB_ISO_SYNC_TYPE_ASYNC = 1,
    USB_ISO_SYNC_TYPE_ADAPTIVE = 2, USB_ISO_SYNC_TYPE_SYNC = 3


## / Imported from libusb, with changed names.

type
  UsbIsoUsageType* = enum
    USB_ISO_USAGE_TYPE_DATA = 0, USB_ISO_USAGE_TYPE_FEEDBACK = 1,
    USB_ISO_USAGE_TYPE_IMPLICIT = 2


## / USB Device States, per USB 2.0 spec

type
  UsbState* = enum
    UsbStateDetached = 0,       ## /< Device is not attached to USB.
    UsbStateAttached = 1,       ## /< Device is attached, but is not powered.
    UsbStatePowered = 2,        ## /< Device is attached and powered, but has not been reset.
    UsbStateDefault = 3,        ## /< Device is attached, powered, and has been reset, but does not have an address.
    UsbStateAddress = 4,        ## /< Device is attached, powered, has been reset, has an address, but is not configured.
    UsbStateConfigured = 5,     ## /< Device is attached, powered, has been reset, has an address, configured, and may be used.
    UsbStateSuspended = 6       ## /< Device is attached and powered, but has not seen bus activity for 3ms. Device is suspended and cannot be used.

