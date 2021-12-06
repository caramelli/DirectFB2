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
        name    IGraphicsState
        version 1.0
        object  CoreGraphicsState

        method {
                name    SetDrawingFlags
                async   yes
                queue   yes

                arg {
                        name        flags
                        direction   input
                        type        enum
                        typename    DFBSurfaceDrawingFlags
                }
        }

        method {
                name    SetBlittingFlags
                async   yes
                queue   yes

                arg {
                        name        flags
                        direction   input
                        type        enum
                        typename    DFBSurfaceBlittingFlags
                }
        }

        method {
                name    SetClip
                async   yes
                queue   yes

                arg {
                        name        region
                        direction   input
                        type        struct
                        typename    DFBRegion
                }
        }

        method {
                name    SetColor
                async   yes
                queue   yes

                arg {
                        name        color
                        direction   input
                        type        struct
                        typename    DFBColor
                }
        }

        method {
                name    SetColorAndIndex
                async   yes
                queue   yes

                arg {
                        name        color
                        direction   input
                        type        struct
                        typename    DFBColor
                }

                arg {
                        name        index
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    SetSrcBlend
                async   yes
                queue   yes

                arg {
                        name        function
                        direction   input
                        type        enum
                        typename    DFBSurfaceBlendFunction
                }
        }

        method {
                name    SetDstBlend
                async   yes
                queue   yes

                arg {
                        name        function
                        direction   input
                        type        enum
                        typename    DFBSurfaceBlendFunction
                }
        }

        method {
                name    SetSrcColorKey
                async   yes
                queue   yes

                arg {
                        name        key
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    SetDstColorKey
                async   yes
                queue   yes

                arg {
                        name        key
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    SetDestination
                async   yes
                queue   yes

                arg {
                        name        surface
                        direction   input
                        type        object
                        typename    CoreSurface
                }
        }

        method {
                name    SetSource
                async   yes
                queue   yes

                arg {
                        name        surface
                        direction   input
                        type        object
                        typename    CoreSurface
                }
        }

        method {
                name    SetSourceMask
                async   yes
                queue   yes

                arg {
                        name        surface
                        direction   input
                        type        object
                        typename    CoreSurface
                }
        }

        method {
                name    SetSourceMaskVals
                async   yes
                queue   yes

                arg {
                        name        offset
                        direction   input
                        type        struct
                        typename    DFBPoint
                }

                arg {
                        name        flags
                        direction   input
                        type        enum
                        typename    DFBSurfaceMaskFlags
                }
        }

        method {
                name    SetIndexTranslation
                async   yes
                queue   yes

                arg {
                        name        indices
                        direction   input
                        type        struct
                        typename    s32
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    SetColorKey
                async   yes
                queue   yes

                arg {
                        name        key
                        direction   input
                        type        struct
                        typename    DFBColorKey
                }
        }

        method {
                name    SetRenderOptions
                async   yes
                queue   yes

                arg {
                        name        options
                        direction   input
                        type        enum
                        typename    DFBSurfaceRenderOptions
                }
        }

        method {
                name    SetMatrix
                async   yes
                queue   yes

                arg {
                        name        values
                        direction   input
                        type        struct
                        typename    s32
                        count       9
                }
        }

        method {
                name    SetSource2
                async   yes
                queue   yes

                arg {
                        name        surface
                        direction   input
                        type        object
                        typename    CoreSurface
                }
        }

        method {
                name    SetFrom
                async   yes
                queue   yes

                arg {
                        name        role
                        direction   input
                        type        enum
                        typename    DFBSurfaceBufferRole
                }

                arg {
                        name        eye
                        direction   input
                        type        enum
                        typename    DFBSurfaceStereoEye
                }
        }

        method {
                name    SetTo
                async   yes
                queue   yes

                arg {
                        name        role
                        direction   input
                        type        enum
                        typename    DFBSurfaceBufferRole
                }

                arg {
                        name        eye
                        direction   input
                        type        enum
                        typename    DFBSurfaceStereoEye
                }
        }

        method {
                name    FillRectangles
                async   yes
                queue   yes

                arg {
                        name        rects
                        direction   input
                        type        struct
                        typename    DFBRectangle
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    DrawRectangles
                async   yes
                queue   yes

                arg {
                        name        rects
                        direction   input
                        type        struct
                        typename    DFBRectangle
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    DrawLines
                async   yes
                queue   yes

                arg {
                        name        lines
                        direction   input
                        type        struct
                        typename    DFBRegion
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    FillTriangles
                async   yes
                queue   yes

                arg {
                        name        triangles
                        direction   input
                        type        struct
                        typename    DFBTriangle
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    FillTrapezoids
                async   yes
                queue   yes

                arg {
                        name        trapezoids
                        direction   input
                        type        struct
                        typename    DFBTrapezoid
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    FillQuadrangles
                async   yes
                queue   yes

                arg {
                        name        quadrangles
                        direction   input
                        type        struct
                        typename    DFBPoint
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    FillSpans
                async   yes
                queue   yes

                arg {
                        name        y
                        direction   input
                        type        int
                        typename    s32
                }

                arg {
                        name        spans
                        direction   input
                        type        struct
                        typename    DFBSpan
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    Blit
                async   yes
                queue   yes

                arg {
                        name        rects
                        direction   input
                        type        struct
                        typename    DFBRectangle
                        count       num
                }

                arg {
                        name        points
                        direction   input
                        type        struct
                        typename    DFBPoint
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    Blit2
                async   yes
                queue   yes

                arg {
                        name        rects
                        direction   input
                        type        struct
                        typename    DFBRectangle
                        count       num
                }

                arg {
                        name        points1
                        direction   input
                        type        struct
                        typename    DFBPoint
                        count       num
                }

                arg {
                        name        points2
                        direction   input
                        type        struct
                        typename    DFBPoint
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    StretchBlit
                async   yes
                queue   yes

                arg {
                        name        srects
                        direction   input
                        type        struct
                        typename    DFBRectangle
                        count       num
                }

                arg {
                        name        drects
                        direction   input
                        type        struct
                        typename    DFBRectangle
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    TileBlit
                async   yes
                queue   yes

                arg {
                        name        rects
                        direction   input
                        type        struct
                        typename    DFBRectangle
                        count       num
                }

                arg {
                        name        points1
                        direction   input
                        type        struct
                        typename    DFBPoint
                        count       num
                }

                arg {
                        name        points2
                        direction   input
                        type        struct
                        typename    DFBPoint
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }
        }

        method {
                name    TextureTriangles
                async   yes
                queue   yes

                arg {
                        name        vertices
                        direction   input
                        type        struct
                        typename    DFBVertex
                        count       num
                }

                arg {
                        name        num
                        direction   input
                        type        int
                        typename    u32
                }

                arg {
                        name        formation
                        direction   input
                        type        enum
                        typename    DFBTriangleFormation
                }
        }

        method {
                name    Flush
                async   yes
        }

        method {
                name    ReleaseSource
                async   yes
                queue   yes
        }

        method {
                name    SetSrcConvolution
                async   yes
                queue   yes

                arg {
                        name        filter
                        direction   input
                        type        struct
                        typename    DFBConvolutionFilter
                }
        }

        method {
                name    GetAccelerationMask

                arg {
                        name        accel
                        direction   output
                        type        enum
                        typename    DFBAccelerationMask
                }
        }
}
