#  This file is part of DirectFB.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

interface {
        name    IWindow
        version 1.0
        object  CoreWindow

        method {
                name    SetConfig

                arg {
                        name        config
                        direction   input
                        type        struct
                        typename    CoreWindowConfig
                }

                arg {
                        name        keys
                        direction   input
                        type        enum
                        typename    DFBInputDeviceKeySymbol
                        count       num_keys
                        optional    yes
                }

                arg {
                        name        num_keys
                        direction   input
                        type        int
                        typename    u32
                }

                arg {
                        name        flags
                        direction   input
                        type        enum
                        typename    DFBWindowConfigFlags
                }
        }

        method {
                name    GetInsets

                arg {
                        name        insets
                        direction   output
                        type        struct
                        typename    DFBInsets
                }
        }

        method {
                name    Destroy
        }

        method {
                name    ChangeEvents

                arg {
                        name        disable
                        direction   input
                        type        enum
                        typename    DFBWindowEventType
                }

                arg {
                        name        enable
                        direction   input
                        type        enum
                        typename    DFBWindowEventType
                }
        }

        method {
                name    ChangeOptions

                arg {
                        name        disable
                        direction   input
                        type        enum
                        typename    DFBWindowOptions
                }

                arg {
                        name        enable
                        direction   input
                        type        enum
                        typename    DFBWindowOptions
                }
        }

        method {
                name    SetColor

                arg {
                        name        color
                        direction   input
                        type        struct
                        typename    DFBColor
                }
        }

        method {
                name    SetColorKey

                arg {
                        name        key
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    SetOpacity

                arg {
                        name        opacity
                        direction   input
                        type        int
                        typename    u8
                }
        }

        method {
                name    SetOpaque

                arg {
                        name        opaque
                        direction   input
                        type        struct
                        typename    DFBRegion
                }
        }

        method {
                name    SetCursorShape

                arg {
                        name        shape
                        direction   input
                        type        object
                        typename    CoreSurface
                        optional    yes
                }

                arg {
                        name        hotspot
                        direction   input
                        type        struct
                        typename    DFBPoint
                }
        }

        method {
                name    Move

                arg {
                        name        dx
                        direction   input
                        type        int
                        typename    s32
                }

                arg {
                        name        dy
                        direction   input
                        type        int
                        typename    s32
                }
        }

        method {
                name    MoveTo

                arg {
                        name        x
                        direction   input
                        type        int
                        typename    s32
                }

                arg {
                        name        y
                        direction   input
                        type        int
                        typename    s32
                }
        }

        method {
                name    Resize

                arg {
                        name        width
                        direction   input
                        type        int
                        typename    s32
                }

                arg {
                        name        height
                        direction   input
                        type        int
                        typename    s32
                }
        }

        method {
                name    SetBounds

                arg {
                        name        bounds
                        direction   input
                        type        struct
                        typename    DFBRectangle
                }
        }

        method {
                name    SetStacking

                arg {
                        name        stacking
                        direction   input
                        type        enum
                        typename    DFBWindowStackingClass
                }
        }

        method {
                name    Restack

                arg {
                        name        relative
                        direction   input
                        type        object
                        typename    CoreWindow
                        optional    yes
                }

                arg {
                        name        relation
                        direction   input
                        type        int
                        typename    s32
                }
        }

        method {
                name    Bind

                arg {
                        name        source
                        direction   input
                        type        object
                        typename    CoreWindow
                }

                arg {
                        name        x
                        direction   input
                        type        int
                        typename    s32
                }

                arg {
                        name        y
                        direction   input
                        type        int
                        typename    s32
                }
        }

        method {
                name    Unbind

                arg {
                        name        source
                        direction   input
                        type        object
                        typename    CoreWindow
                }
        }

        method {
                name    RequestFocus
        }

        method {
                name    ChangeGrab

                arg {
                        name        target
                        direction   input
                        type        enum
                        typename    CoreWMGrabTarget
                }

                arg {
                        name        grab
                        direction   input
                        type        enum
                        typename    DFBBoolean
                }
        }

        method {
                name    GrabKey

                arg {
                        name        symbol
                        direction   input
                        type        enum
                        typename    DFBInputDeviceKeySymbol
                }

                arg {
                        name        modifiers
                        direction   input
                        type        enum
                        typename    DFBInputDeviceModifierMask
                }
        }

        method {
                name    UngrabKey

                arg {
                        name        symbol
                        direction   input
                        type        enum
                        typename    DFBInputDeviceKeySymbol
                }

                arg {
                        name        modifiers
                        direction   input
                        type        enum
                        typename    DFBInputDeviceModifierMask
                }
        }

        method {
                name    SetKeySelection

                arg {
                        name        selection
                        direction   input
                        type        enum
                        typename    DFBWindowKeySelection
                }

                arg {
                        name        keys
                        direction   input
                        type        enum
                        typename    DFBInputDeviceKeySymbol
                        count       num_keys
                        optional    yes
                }

                arg {
                        name        num_keys
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    SetRotation

                arg {
                        name        rotation
                        direction   input
                        type        int
                        typename    s32
                }
        }

        method {
                name    BeginUpdates

                arg {
                        name        update
                        direction   input
                        type        struct
                        typename    DFBRegion
                        optional    yes
                }
        }

        method {
                name    PostEvent

                arg {
                        name        event
                        direction   input
                        type        struct
                        typename    DFBWindowEvent
                }
        }

       method {
                name    SetCursorPosition

                arg {
                        name        x
                        direction   input
                        type        int
                        typename    s32
                }

                arg {
                        name        y
                        direction   input
                        type        int
                        typename    s32
                }
        }

        method {
                name    SetTypeHint

                arg {
                        name        type_hint
                        direction   input
                        type        enum
                        typename    DFBWindowTypeHint
                }
        }

        method {
                name    ChangeHintFlags

                arg {
                        name        clear
                        direction   input
                        type        enum
                        typename    DFBWindowHintFlags
                }

                arg {
                        name        set
                        direction   input
                        type        enum
                        typename    DFBWindowHintFlags
                }
        }
 
        method {
                name    AllowFocus
        }

        method {
                name    GetSurface

                arg {
                        name        surface
                        direction   output
                        type        object
                        typename    CoreSurface
                }
        }
}
