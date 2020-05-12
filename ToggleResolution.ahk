EncodeInteger( p_value, p_size, p_address, p_offset )
{
	loop, %p_size%
		DllCall( "RtlFillMemory"
			, "uint", p_address+p_offset+A_Index-1
			, "uint", 1
			, "uchar", ( p_value >> ( 8*( A_Index-1 ) ) ) & 0xFF )

}

; Magic numbers are part of shell32 enum. 
; Source for this solution: https://autohotkey.com/board/topic/7646-change-display-mode/
; Source for magic numbers : https://stackoverflow.com/questions/195267/use-windows-api-from-c-sharp-to-set-primary-monitor

ChangeResolution(screenX, screenY, refresh)
{
    struct_devicemode_size = 156
    VarSetCapacity( device_mode, struct_devicemode_size, 0 )

    VarSetCapacity( device_mode, 156, 0 )
    EncodeInteger( struct_devicemode_size, 2, &device_mode, 36 )
    success := DllCall( "EnumDisplaySettingsA", "uint", 0, "uint", -1, "uint", &device_mode )
    EncodeInteger( 0x00040000|0x00080000|0x00100000|0x00400000, 4, &device_mode, 40 )
    EncodeInteger( 32, 4, &device_mode, 104 )										; quality (i.e., color depth)
    EncodeInteger( screenX, 4, &device_mode, 108 )										; width
    EncodeInteger( screenY, 4, &device_mode, 112 )										; height
    EncodeInteger( refresh, 4, &device_mode, 120 )										; frequency (i.e., refresh rate)

    result := DllCall( "ChangeDisplaySettingsA", "uint", &device_mode, "uint", 0 )
}



^!0::
    ChangeResolution(3840,2160,60)
return

^!9::
    ChangeResolution(2560,1440,120)
return