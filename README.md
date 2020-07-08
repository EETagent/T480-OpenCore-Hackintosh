# T480-OpenCore-Hackintosh

**Status: Work In Progress**

[![release](https://img.shields.io/badge/Download-latest-brightgreen.svg)](https://github.com/EETagent/T480-OpenCore-Hackintosh/releases/latest)
[![OpenCore](https://img.shields.io/badge/OpenCore-0.6.0-blue.svg)](https://github.com/acidanthera/OpenCorePkg)
[![ThinkPad](https://img.shields.io/badge/ThinkPad-T480-blue.svg)]()
[![macOS-Previous](https://img.shields.io/badge/macOS-10.14.6-brightgreen.svg)](https://github.com/EETagent/T480-OpenCore-Hackintosh/issues/11)
[![macOS-Stable](https://img.shields.io/badge/macOS-10.15.6-brightgreen.svg)](https://www.apple.com/macos/catalina/)
[![macOS-Unstable](https://img.shields.io/badge/macOS-11-yellow.svg)](https://www.apple.com/macos/big-sur-preview/)
### General knowledge & credits

- To install macOS follow the guides provided by [Dortania](https://dortania.github.io/getting-started/)

- Useful tools by [CorpNewt](https://github.com/corpnewt)

- [CREDITS](CREDITS.md) file

## Hardware:

| Category  | Component                            | Note                                                                                                                                     |
| --------- | ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| CPU       | Intel Core i5-8250U                  | 20L50000MC                                                                                                                               |
| GPU       | Intel UHD 620                        |                                                                                                                                          |
| SSD       | Samsung PM981 NVMe solid-state drive | Fixed in NVMeFix 1.0.2 for Acidanthera testing machines. [Problems still persist](https://github.com/acidanthera/bugtracker/issues/780). |
| Memory    | 8GB DDR4 2400                        |                                                                                                                                          |
| Battery   | Dual battery                         |                                                                                                                                          |
| Camera    | 720p Camera                          |                                                                                                                                          |
| Wifi & BT | Intel Wireless-AC 8265               | Both works. Place Wi-Fi SSIDs and passwords either in the kext plist file or use amazing HeliPort application.                                   |
| KBD       | Keyboard                             | [ThinkPad Assistant](https://github.com/MSzturc/ThinkpadAssistant) for media keys like microphone switch, etc. PrtSc is mapped as F13.   |

## Main software:

| Component      | Version           |
| -------------- | ----------------- |
| MacOS Catalina | 10.15.6 (19G60d)  |
| OpenCore       | v0.6.0 Beta       |

## Kernel extensions

| Kext                   | Version        |
|:---------------------- | -------------- |
| AppleALC               | 1.5.1          |
| CPUFriend              | 1.2.1          |
| CPUFriendDataProvider  | i5-8250U       |
| HibernationFixup       | 1.3.4          |
| HoRNDIS                | Disabled, 9.2  |
| IntelBluetoothFirmware | 1.1.1          |
| IntelBluetoothInjector | 1.1.1          |
| IntelMausiEthernet     | 2.5.1.d1       |
| Itlwm                  | 1.0.1          |
| Lilu                   | 1.4.6          |
| NoTouchID              | 1.0.3          |
| RTCMemoryFixup         | 1.0.6          |
| NVMeFix                | 1.0.3          |
| VirtualSMC             | 1.1.5          |
| VoltageShift           | Disabled, 1.22 |
| VoodooPS2Controller    | 2.1.5          |
| VoodooRMI              | 0.4.0          |
| VoodooSMBus            | 2.1.0          |
| WhateverGreen          | 1.4.1          |

## UEFI Drivers

| Driver          | Version           |
|:---------------:| ----------------- |
| AudioDxe.efi    | OpenCorePkg 0.6.0 |
| HfsPlus.efi     | OcBinaryData      |
| OpenCanopy.efi  | OpenCorePkg 0.6.0 |
| OpenRuntime.efi | OpenCorePkg 0.6.0 |

## What's working

- [x] Battery percentage

- [x] Bluetooth - Intel Wireless-AC 8265 (0x0A2B) 

- [x] Boot chime

- [x] Boot menu

- [x] CPU power management / performance `Now on par with Windows without XTU undervolt.`

- [x] FireVault 2 

- [x] GPU UHD 620 hardware acceleration / performance 

- [x] HDMI `Closed and opened lid. With audio.`

- [x] iMessage, FaceTime, App Store, iTunes Store. **Generate your own SMBIOS**

- [x] Intel I219V Ethernet port

- [x] Keyboard `Volume and brightness hotkeys. Another media keys with ThinkPad Assistant.`

- [x] Microphone `With keyboard switch using ThinkPad Assistant.`

- [x] Realtek® ALC3287 ("ALC257") Audio

- [x] SD card reader `Fortunately, USB connected.`

- [x] Sidecar wired `Works with 15,2 SMBIOS. I was unable to get it working wit 14,1 SMBIOS, which some T480 configs uses.`

- [x] Sidecar wireless `If you want to use this feature, buy a compatible Broadcom card!`

- [x] TouchPad `1-5 fingers swipe works. Emulate force touch using longer and more voluminous touch.`

- [x] TrackPoint  `Works perfectly. Just like on Windows or Linux.`

- [x] USB Ports `USB Map is different for devices with Windows Hello camera.`

- [x] Web camera

- [x] Wifi - Intel Wireless-AC 8265 `Wifi requires to manually place passwords and SSIDs in the Kext plist file. (Basic control with HeliPort app in Other folder)`

- [x] Sleep/Wake `Does not work when booting over USB.`

## What's not working ⚠️

- [ ] Fingerprint reader `Drivers aren't even on Linux. The chances of creating a driver for macOS are minimal.`

- [ ] PM 981 `Still unstable. Could work for some, not for others.`

## Not tested

- [ ] Thunderbolt  `No device to test.`

- [ ] Upper (charging) USB Type C port

- [ ] USB Type C Video output `No device to test.`


## Bios settings

**Security**

- `Security Chip` **Disabled**
- `Memory Protection -> Execution Prevention` **Enabled**
- `Virtualization -> Intel Virtualization Technology` **Enabled**
- `Virtualization -> Intel VT-d Feature` **Disabled**
- `Anti-Theft -> Computrace -> Current Setting` **Disabled**
- `Secure Boot -> Secure Boot` **Disabled**
- `Intel SGX -> Intel SGX Control` **Disabled**
- `Device Guard` **Disabled**

**Startup**

- `UEFI/Legacy Boot` **UEFI Only**
- `CSM Support` **No**

### Generate your own SMBIOS

[GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)

MacBookPro15,2

### USB ports map

For different models, use

[GitHub - corpnewt/USBMap: Py script for mapping out USB ports and creating a custom SSDT or injector kext (WIP)](https://github.com/corpnewt/USBMap)

### CPUFriend power management

Generate CPUFriendDataProvider for your machine [here](https://github.com/corpnewt/CPUFriendFriend) or use at your own risk files provided in the Other folder.

### VoltageShift undervolt

It is possible to use VoltageShift from EFI folder instead of disabling SIP. You need to use specific version provided in the Other folder.

**If you want to use this feature, enable it in config.plist**

### Android USB Tethering | HoRNDIS | "Wifi adapter"

> **Important:** Mac computers can't tether with Android. 

I don't think so Google.

1. Using a USB cable, connect your phone to the other device. A "Connected as a…" notification shows at the top of the screen.
2. Open your phone's Settings app.
3. Tap Network & internet ![And then](https://lh3.googleusercontent.com/WD3LKKej34vq3cZXwilgeahIPOiokN2uarmkDxtMqKMFg4SSys8BkOBJbn4_4R930gE=h18 "And then") Hotspot & tethering.
4. Turn on USB tethering.

You should see new Ethernet connection in the network settings. Works with USB Type C and USB A.

**If you want to use this feature, enable it in config.plist**

Some devices changes MAC adress on every connection, so macOS creates new ethernet`en` connection every time. To delete them, you must remove 

`/Library/Preferences/SystemConfiguration` or included networking plists.

### Own prev-lang-kbd settings

Data field accepts HEX data [(ProperTree)](https://github.com/corpnewt/ProperTree)

Format is lang-COUNTRY:keyboard

- [0] en_US - U.S --> en-US:0 --> 656e2d55 533a30

- [30776] cs - Czech --> cs-CZ:30776 --> 63732d43 5a3a3330 373736

- cs-CZ:0 --> 63732d43 5a3a30

etc.

[AppleKeyboardLayouts.txt](https://github.com/acidanthera/OpenCorePkg/blob/master/Utilities/AppleKeyboardLayouts/AppleKeyboardLayouts.txt)

## CFG Lock | Advanced menu

It's possible to unlock Advanced menu thus disable CFG Lock natively in BIOS + Other Advanced menu benefits. Flasher is needed

https://www.reddit.com/r/thinkpad/comments/ffqqx5/currently_testing_skyra1n/

[T480 consuming 60w (~85w total) - unlimited TDP : thinkpad](https://www.reddit.com/r/thinkpad/comments/g8fk51/t480_consuming_60w_85w_total_unlimited_tdp/)

[ThinkPad discord](discord.gg/Ybdz7AS)
