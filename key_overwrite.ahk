#Requires AutoHotkey v2.0

; Hotkey to reload the script
^r:: Reload  ; Press Ctrl+R to reload the script

; Highspeed scroll
SendMode("Input")
+WheelUp:: {
    Send("{WheelUp 5}")
}
+WheelDown:: {
    Send("{WheelDown 5}")
}

; Disable IME Change
#Space:: return

;;;;;;;;;;;;;;;;;;
;;;; 左Altキー ;;;;
;;;;;;;;;;;;;;;;;;
; Initialize the global flag
global isLeftAltPressed := false
; Define the hotkey for the left Alt key press
LAlt:: {
    global isLeftAltPressed
    isLeftAltPressed := true
    SetTimer LAltDown, -200
}
; Define the hotkey for the left Alt key release
LAlt up:: {
    global isLeftAltPressed
    if isLeftAltPressed {
        isLeftAltPressed := false
        IME_OFF()
    }
    Send("{Blind}{LAlt Up}")
}
LAltDown() {
    if isLeftAltPressed {
        Send("{Blind}{LAlt DownR}")
    }
}

;;;;;;;;;;;;;;;;;;
;;;; 右Altキー ;;;;
;;;;;;;;;;;;;;;;;;
; Initialize the global flag
global isRightAltPressed := false
; Define the hotkey for the right Alt key press
RAlt:: {
    global isRightAltPressed
    isRightAltPressed := true
    SetTimer RAltDown, -200
}
; Define the hotkey for the right Alt key release
RAlt up:: {
    global isRightAltPressed
    if isRightAltPressed {
        isRightAltPressed := false
        IME_ON()
    }
    Send("{Blind}{RAlt Up}")
}
RAltDown() {
    if isRightAltPressed {
        Send("{Blind}{RAlt DownR}")
    }
}

IME_OFF() {
    IME_SET(0)
}

IME_ON() {
    IME_SET(1)
}

IME_SET(SetSts, WinTitle := "A") {
    hwnd := WinGetID(WinTitle)
    if WinActive(WinTitle) {
        ptrSize := A_PtrSize
        stGTI := Buffer(4 + 4 + (ptrSize * 6) + 16, 0)
        NumPut("UInt", 4 + 4 + (ptrSize * 6) + 16, stGTI, 0) ; DWORD cbSize;
        hwnd := DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", stGTI.Ptr)
            ? NumGet(stGTI, 8 + ptrSize, "UInt") : hwnd
    }

    return DllCall("SendMessage"
        , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
        , "UInt", 0x0283  ; Message : WM_IME_CONTROL
        , "Int", 0x006    ; wParam  : IMC_SETOPENSTATUS
        , "Int", SetSts)  ; lParam  : 0 or 1
}
