/**
 * Adds the OSX-native ACPI-interface for broadcom-wifi-cards.
 *
 * Shuts down the whole PCIe-interface on disable and sleep of the machine and wakes it up on resume/reenable.
 * Should respect settings regarding wakeonwifi and similar.
 *
 * Only works with the OSX-native broadcom-drivers for now. The card can be spoofed by `AirportBrcmFixup`.
 * No support in Itlwm (intel-based WIFI-cards) for the moment.
 *
 * I hope it helps with the usual power drain on sleep of ~1% battery per hour. To be verified.
 * 
 * Working, but not widely tested yet.
 *
 * IMPORTANT: If you want to adapt this for your config, please ensure that the PCIe-prt (RPXX) matches or adapt accordingly!
 **/

DefinitionBlock ("", "SSDT", 2, "T480", "ARPT", 0x00001000)
{
    External (_SB.PCI0.RP01, DeviceObj)
    External (_SB.PCI0.RP01.PXSX, DeviceObj)
    External (_SB.PCI0.RP01.LDIS, FieldUnitObj)
    External (_SB.PCI0.RP01.LEDM, FieldUnitObj)
    External (_SB.PCI0.RP01.L23E, FieldUnitObj)
    External (_SB.PCI0.RP01.L23R, FieldUnitObj)
    External (_SB.PCI0.RP01.D3HT, FieldUnitObj)

    Scope (_SB.PCI0.RP01.PXSX)
    {
        Method (_STA, 0, NotSerialized)
        {
            Return (Zero) // hidden
        }
    }

    // WIFI
    Scope (_SB.PCI0.RP01)
    {
        Name (WOWE, Zero)
        Name (TAPD, Zero)
        Name (APWC, Zero)

        OperationRegion (A1E0, PCI_Config, Zero, 0x0380)
        Field (A1E0, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            BMIE,   3, 
            Offset (0x19), 
            SECB,   8, 
            SBBN,   8, 
            Offset (0x1E), 
                ,   13, 
            MABT,   1, 
            Offset (0x4A), 
                ,   5, 
            TPEN,   1, 
            Offset (0x50), 
                ,   4, 
            // LDIS,   1, 
                ,   1, 
                ,   24, 
            LACT,   1, 
            Offset (0xA4), 
            // D3HT,   2, 
                ,   2,
            Offset (0xE2), 
                ,   2, 
            // L23E,   1, 
                ,   1, 
            // L23D,   1, 
                ,   1, 
            Offset (0x324), 
                ,   3, 
            // LEDM,   1
        }

        OperationRegion (A1E1, PCI_Config, 0x18, 0x04)
        Field (A1E1, DWordAcc, NoLock, Preserve)
        {
            BNIR,   32
        }

        Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
        {
            If ((BMIE == Zero) && (SECB == 0xFF))
            {
                Return (SNBS) /* \_SB_.PCI0.RP01.SNBS */
            }
            Else
            {
                Return (SECB) /* \_SB_.PCI0.RP01.SECB */
            }
        }

        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            Return (0x0F)
        }

        Name (BMIS, Zero)
        Name (SNBS, Zero)
        Name (BNIS, Zero)

        // Airport power down
        Method (APPD, 0, Serialized)
        {
            Debug = "ARPT:APPD"
            Debug = "ARPT:AVND: "
            Debug = ^ARPT.AVND

            If (!_OSI ("Darwin") || WOWE == One || TAPD != One)
            {
                Debug = "ARPT:APPD - break"

                Return (Zero)
            }

            Debug = "ARPT:APPD: Put airport module to D3"
            ^ARPT.D3HT = 0x03

            If (((BMIE != Zero) && (BMIE != BMIS)) && (
                ((SECB != Zero) && (SECB != SNBS)) && ((BNIR != 
                Zero) && (BNIR != BNIS))))
            {
                BMIS = BMIE /* \_SB_.PCI0.RP01.BMIE */
                SNBS = SECB /* \_SB_.PCI0.RP01.SECB */
                BNIS = BNIR /* \_SB_.PCI0.RP01.BNIR */
            }

            BMIE = Zero
            BNIR = 0x00FEFF00
            Local0 = TPEN /* \_SB_.PCI0.RP01.TPEN */

            Debug = "ARPT:APPD: Put airport root port to D3"
            D3HT = 0x03

            Local0 = TPEN /* \_SB_.PCI0.RP01.TPEN */

            Local0 = (Timer + 0x00989680)
            While (Timer <= Local0)
            {
                If (LACT == Zero)
                {
                    Break
                }

                Sleep (0x0A)
            }

            If (TAPD == One)
            {
                APWC = Zero
                // Sleep (0x3C)
            }

            Debug = "ARPT:AVND: "
            Debug = ^ARPT.AVND

            Return (Zero)
        }

        // Airport Power up
        Method (APPU, 0, Serialized)
        {
            Debug = "ARPT:APPU"
            Debug = "ARPT:AVND: "
            Debug = ^ARPT.AVND

            If (_OSI ("Darwin") && WOWE == One && TAPD == One)
            {
                WAPS ()
            }

            If (!_OSI ("Darwin") || WOWE == One || TAPD != One)
            {
                WOWE = Zero

                Debug = "ARPT:APPU: on boot"

                Return (Zero)
            }

            Debug = "ARPT:APPU: Restore airport root port back to D0"
            D3HT = Zero

            If (SECB != 0xFF)
            {
                Debug = "ARPT:APPU: Valid config, no restore needed"
                WAPS ()

                Return (Zero)
            }

            BNIR = BNIS /* \_SB_.PCI0.RP01.BNIS */
            LDIS = Zero
            WOWE = Zero

            // If (LEqual (\_SB.PCI0.LPCB.EC.APWC, 0x01))
            If (APWC == 0x01)
            {
                WAPS ()

                Return (Zero)
            }

            Local0 = Zero

            While (One)
            {
                Debug = "ARPT:APPU: Restore Power"
                // Store (0x01, \_SB.PCI0.LPCB.EC.APWC)
                APWC = One
                Sleep (0xFA)

                Local1 = Zero

                Local2 = (Timer + 0x00989680)
                While (Timer <= Local2)
                {
                    If ((LACT == One) && (^ARPT.AVND != 0xFFFF))
                    {
                        Local1 = One
                        Break
                    }

                    Sleep (0x0A)
                }

                If (Local1 == One)
                {
                    WAPS ()
                    MABT = One
                    Break
                }

                If (Local0 == 0x04)
                {
                    Break
                }

                Local0++

                // Store (0x00, \_SB.PCI0.LPCB.EC.APWC)
                APWC = Zero
                Sleep (0x3C)
            }

            Debug = "ARPT:AVND: "
            Debug = ^ARPT.AVND

            Return (Zero)
        }

        Method (ALPR, 1, NotSerialized)
        {
            If (Arg0 == One)
            {
                Debug = "ARPT:ALPR -> down"

                APPD ()
            }
            Else
            {
                Debug = "ARPT:ALPR -> up"

                APPU ()
            }
        }

        Method (_PS0, 0, Serialized)  // _PS0: Power State 0
        {
            Debug = "ARPT:_PS0"

            If (_OSI ("Darwin"))
            {
                ALPR (Zero)
            }
        }

        Method (_PS3, 0, Serialized)  // _PS3: Power State 3
        {
            Debug = "ARPT:_PS3"

            If (_OSI ("Darwin"))
            {
                ALPR (One)
            }
        }

        Method (WAPS, 0, Serialized)
        {
            Debug = "ARPT:WAPS"

            D3HT = 0x00

            If (BNIS != BNIR)
            {
                BNIR = BNIS
            }

            ^ARPT.D3HT = 0x00
            Debug = "ARPT:WAPS - ^ARPT.BDEN = 0x40"
            ^ARPT.BDEN = 0x40
            Debug = "ARPT:WAPS - ^ARPT.BDMR = 0x18003000"
            ^ARPT.BDMR = 0x18003000
            Debug = "ARPT:WAPS - ^ARPT.BDIR = 0x0120"
            ^ARPT.BDIR = 0x0120
            Debug = "ARPT:WAPS - ^ARPT.BDDR = 0x0438"
            ^ARPT.BDDR = 0x0438
            Debug = "ARPT:WAPS - ^ARPT.BDIR = 0x0124"
            ^ARPT.BDIR = 0x0124
            Debug = "ARPT:WAPS - ^ARPT.BDDR = 0x0170106B"
            ^ARPT.BDDR = 0x0170106B // 0x0134106B // 
            Debug = "ARPT:WAPS - ^ARPT.BDEN = Zero"
            ^ARPT.BDEN = Zero
        }

        Device (ARPT)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (_GPE, 0x31)  // _GPE: General Purpose Events
            OperationRegion (ARE2, PCI_Config, Zero, 0x80)
            Field (ARE2, ByteAcc, NoLock, Preserve)
            {
                AVND,   16, 
                ADID,   16, 
                Offset (0x4C), 
                D3HT,   2
            }

            OperationRegion (ARE3, PCI_Config, 0x80, 0x80)
            Field (ARE3, DWordAcc, NoLock, Preserve)
            {
                BDMR,   32, 
                Offset (0x08), 
                BDEN,   32, 
                Offset (0x20), 
                BDIR,   32, 
                BDDR,   32
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
            {
                If (_OSI ("Darwin"))
                {
                    Return (Package (0x02)
                    {
                        0x69, 
                        0x04
                    })
                }
                Else
                {
                    Return (Package (0x02)
                    {
                        0x69, 
                        0x04
                    })
                }
            }

            Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
            {
                Return (Zero)
            }

            Method (WWEN, 1, NotSerialized)
            {
                Debug = "ARPT:WWEN"

                Debug = "ARPT:WWEN - AVND"
                Debug = AVND
                Debug = "ARPT:WWEN - ADID"
                Debug = ADID

                ^^WOWE = Arg0
            }

            Method (PDEN, 1, NotSerialized)
            {
                If (Arg0 == One)
                {
                    Debug = "ARPT:PDEN - Arg0 = One"
                }
                Else
                {
                    Debug = "ARPT:PDEN - Arg0:"
                    Debug = Arg0
                }

                ^^TAPD = Arg0
            }
        }
    }
}

