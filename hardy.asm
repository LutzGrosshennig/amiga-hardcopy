;**************************************************
;*                                                *
;* ASSEMBLER HARDCOPY PROGRAMM                    *
;* Verwendet Preferences Treiber                  *
;* (c) 1988 by Lutz Großhennig                    *
;*                                                *
;**************************************************

; Library Offsets EXEC
 
OpenLibrary    = -408
CloseLibrary   = -414
AllocMem       = -198
FreeMem        = -210
AllocSignal    = -330
FreeSignal     = -336
FindTask       = -294
DoIO           = -456
OpenDevice     = -444
CloseDevice    = -450
AddPort        = -354
RemPort        = -360

; Konstanten

ExecBase       = 4

Init:

       Move.l  ExecBase,a6    ; Intuition Library öffnen
       Lea     Intname,a1
       Jsr     OpenLibrary(a6)
       Move.l  d0,Intbase

Drucken:

       Move.l  Execbase,a6
       Move.l  Intbase,a1
       Move.l  $34(a1),sWindow
       Move.l  $34(a1),a1
       Move.l  46(a1),sScreen
       Move.l  46(a1),d0
       Add.l   #44,d0
       Move.l  d0,sViewPort
       Add.l   #40,d0
       Move.l  d0,sRastPort
       Move.l  sViewPort,a1
       Move.l  4(a1),sColorMap
       Move.w  32(a1),ViewModes

       Move.b  #-1,d0
       Jsr     AllocSignal(a6)
       Move.b  d0,SigBit

       Move.b  #40,d0
       Move.l  #65537,d1
       Jsr     AllocMem(a6)
       Move.l  d0,MsgPort
       Beq     NoMem

       Move.b  #0,d0
       Jsr     FindTask(a6)
       Move.l  d0,SigTask

       Move.l  MsgPort,a1
       Move.b  #4,8(a1)
       Move.b  #0,9(a1)
       Lea     PortName,a0
       Move.l  a0,10(a1)
       Move.b  #0,14(a1)
       Move.b  SigBit,15(a1)
       Move.l  SigTask,16(a1)

       Move.l  MsgPort,a1
       Jsr     AddPort(a6)

       Move.l  #IoRequest,a1
       Move.b  #5,8(a1)
       Move.b  #0,9(a1)           ; Priority
       Move.l  MsgPort,14(a1)

       Lea     DevName,a0
       Move.l  #0,d0
       Move.l  #IoRequest,a1
       Move.l  #0,d1
       Jsr     OpenDevice(a6)
       Bne     NoPrinter

       Move.l  #IoRequest,a1
       Move.w  Command,28(a1)
       Move.l  sRastPort,32(a1)
       Move.l  sColorMap,36(a1)
       Move.l  Viewmodes,40(a1)
       Move.w  ScrX,44(a1)
       Move.w  ScrY,46(a1)
       Move.w  ScrWidth,48(a1)
       Move.w  ScrHeight,50(a1)
       Move.l  DestColors,52(a1)
       Move.l  DestRows,56(a1)
       Move.w  Special,60(a1)

       Move.l  ExecBase,a6
       Move.l  #IoRequest,a1
       Jsr     DoIO(a6)
       bne     AusgabeFehler

Cleanup1:

       Move.l  #IoRequest,a1
       Jsr     Closedevice(a6)

Cleanup2:

       Move.l  #IoRequest,a1
       Move.b  #$ff,8(a1)
       Move.l  #-1,20(a1)
       Move.l  #-1,24(a1)
       Move.l  #64,d0
       Jsr     FreeMem(a6)

Cleanup3:

       Move.l  MsgPort,a1
       Jsr     RemPort(a6)
       Move.l  MsgPort,a1
       Move.b  #$ff,8(a1)
       Move.l  #-1,20(a1)
       Move.b  SigBit,d0
       Jsr     FreeSignal(a6)
       Move.l  MsgPort,a1
       Move.l  #40,d0
       Jsr     FreeMem(a6)

Cleanup4:

       Move.l  Intbase,a1
       Jsr     CloseLibrary(a6)
       Rts

NoMem:

       Bra     Cleanup4

NoPrinter:

       Bra     Cleanup2

NoRequest:

       Bra     Cleanup3

AusgabeFehler:

       Bra     Cleanup1

; Variablen

IntBase:       dc.l    0
sWindow:       dc.l    0
sScreen:       dc.l    0
sViewPort:     dc.l    0
sRastPort:     dc.l    0
sColorMap:     dc.l    0
ViewModes:     dc.w    0
ScrX:          dc.w    0
ScrY:          dc.w    0
ScrWidth:      dc.w    640
ScrHeight:     dc.w    256
DestRows:      dc.l    0
DestColors:    dc.l    0
Special:       dc.w    $84
Command:       dc.w    11
MsgPort:       dc.l    0
SigTask:       dc.l    0
IoRequest:     ds.b    64,0
 Align
SigBit:        dc.b    0
 Align
Intname:       dc.b    "intuition.library",0
 Align
DevName:       dc.b    "printer.device",0
 Align
PortName:      dc.b    "MyPrinterPort",0
 Align


 END








