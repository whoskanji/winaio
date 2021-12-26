Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ErrorActionPreference = 'SilentlyContinue'
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

# GUI Specs

Try{
	# Check if winget is already installed
	$er = (invoke-expression "winget -v") 2>&1
	if ($lastexitcode) {throw $er}
	Write-Host "Kanji's AIO Windows 10 Tool"
}
Catch{
	# winget is not installed. Install it from the Github release
	Write-Host "winget is not found, installing it right now."

	$asset = Invoke-RestMethod -Method Get -Uri 'https://api.github.com/repos/microsoft/winget-cli/releases/latest' | ForEach-Object assets | Where-Object name -like "*.msixbundle"
	$output = $PSScriptRoot + "\winget-latest.appxbundle"
	Write-Host "Downloading latest winget release"
	Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $output

	Write-Host "Installing the winget package"
	Add-AppxPackage -Path $output

    Write-Host "Cleanup winget install package"
    if (Test-Path -Path $output) {
        Remove-Item $output -Force -ErrorAction SilentlyContinue
    }
}
Finally {
	# Start installing the packages with winget
	#Get-Content .\winget.txt | ForEach-Object {
	#	iex ("winget install -e " + $_)
	#}
}

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(1050,700)
$Form.text                       = "All-In-One Windows Tool by Kanji"
$Form.StartPosition              = "CenterScreen"
$Form.TopMost                    = $false
$Form.BackColor                  = [System.Drawing.ColorTranslator]::FromHtml("#212121")
$Form.AutoScaleDimensions     = '192, 192'
$Form.AutoScaleMode           = "Dpi"
$Form.AutoSize                = $True
$Form.ClientSize              = '1050, 700'
$Form.FormBorderStyle         = 'FixedSingle'

# GUI Icon
$iconBase64                      = 'AAABAAEAICAAAAEAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAABAAAMMOAADDDgAAAAAAAAAAAAC7xNH/v8jV/8PM2P/J09z/0t3l/9bg6P/U3ef/1d7o/9Td5//Z4Oz/1t3q/9Xe6//S2uf/vMXT/52mtP+Ol6X/j5im/5Scqv+coq7/oqWw/6Kmr/+orbf/uL3J/7S6xf++w87/wcXQ/8DEz//FydT/xsrV/8bM1//GzNf/xszX/8TN2v/Bytf/zNXh/9Xf6f/V4Oj/093m/9fg6f/X4Or/0tvk/9ff6//Z3+z/09rl/7vE0f+hqbb/kJim/4+Ypv+Sm6j/l5+s/6Kns/+qrbj/rK+4/6GmsP+mrLf/t73I/7u/yv/GytX/wMLN/8TG0f/IzNf/x8zX/8XL1v/GzNf/yNHe/8XO3P/Gz9v/z9rj/9Te5//V3uf/1t/o/9Lb5f/P1+L/zdbi/8HI1f+us77/lJuo/42Vov+Smqf/lJyp/5eeq/+Zn6v/oKWw/6yxuv+ytsD/r7XA/6OptP+tsr3/tLjD/77Ay//GyNP/x8nU/8jM1//Kztn/yc7Z/8rQ2/+9xtP/zNXi/8rU3//O2OH/1t/p/9Xe6P/U3eb/1d7p/8nQ3v+vt8T/lZ2p/5SapP+Znqn/mJ6q/5mgrv+co7D/nqSx/56lsP+lqrX/r7S9/7W6w/+9ws3/u8HM/7i7xv+3ucT/sLK9/8zO2f/O0Nv/zM3Y/87R3P/Q1eD/ztTf/8zV4v/U3er/0tvn/8nS2//R2uT/1t/p/9Xd6P/P1+T/pq67/4mQn/+RmKX/naKt/6GksP+orbn/rbO+/6iuuf+nrbj/p625/6ituf+utL//ucDJ/8TJ0//Q1N//zNDb/8rM1/+6vMf/ycvW/9PV4P/Q0t3/0dXg/9PX4v/T1+L/09vo/9Pc5//Y4ev/zdbg/8XO2P/R2uP/0Nnk/7W9yv+BiZf/gIeX/46Uo/+boKv/qKy2/7K3wv+6v8r/s7jD/660v/+qsLr/p664/6ixu/+3wMn/yc/a/9HW4f/T1+L/19rl/8/R3P/Gx9L/0tTf/9nb5v/T1uH/1Nnk/9Xb5v/U3On/1d3o/9Lc5f/Q2eP/xc7Y/9DZ4//P2OT/lZ2r/3uDkf+FjZ3/hIua/5KXov+mqbX/s7fC/7e8xv+7v8r/sbbB/6Wrt/+eprH/naax/6Stuv+8xM7/y9Db/83S3f/P0t3/1tjj/9PV4P/P0t3/19rl/9fb5v/W3Of/2uHs/8TL2f/Hz9r/zNXf/9Xe6P/U3ef/0Njk/8HK1/+Ejpz/g4qb/4mRo/+Ij57/k5il/6Sntf+ytsL/sbbB/6qwu/+jqrT/m6Ov/5Kap/+Tnav/m6W0/6u0wP+4vsn/vMLN/8bL1v/T1+L/2d7p/9LX4v/T2OP/2uDr/9fe6P/b4ez/x8/c/7zF0P+/yNH/ydLc/9Xe5//U3en/pa68/32GlP+Gjp//iZGj/4OKm/+RlqX/o6m2/660wf+0usf/pqy5/5GZpv+NlaP/hpCf/4iVpv+Qnq3/oqy5/7K7xf/AyNL/y9Hc/9Xb5v/b4ez/2+Hs/9rf6v/b4u3/2eLs/9Td5//Y3uz/2ODr/87X4f/By9T/wsvV/7O9yP+MlaL/eYOR/4SMnf+GjaD/f4aY/4ySov+ip7X/rbPB/7m/y/+0usf/oKi1/5Kbqf+MmKb/jpyt/5Wjtf+jsLz/t8HL/8jR2//M1d7/1dvm/93k7//g5/L/4Ofx/93m7//b5O7/1t/p/9je7v/V3Ov/2ODu/8DH1f+HjZz/dXuL/4SMm/+BiZj/g4qb/4GJnP+EjJz/i5Kg/5mfrv+sssL/usHT/73E1/+nr8H/iJGj/4qWpv+Ypbb/oK6//6y7xf+6xs3/xc/Y/87Y4f/V3ef/3ePu/+Ln8v/i6fP/4Onz/93l8P/c5vD/0Nfq/9Xc7/+wtsj/en6R/29zhv+Hi53/nKK0/4qRo/97gpP/gIma/36Hlf+JkJz/k5qq/6Wrwf+ip8L/io+u/4qQsP93gJ3/bXeP/5WgtP+irr7/scHJ/8PS1//O2uH/1t/o/9ni6v/g5e//4ebx/+Ln8v/i6PP/3ufx/9zm8P+8wtX/qrDD/3F3if9qb4H/iY2g/4+Tpf+ssML/qK6+/3+Glf+BiZf/gIiW/4aLnP+TmKr/mp+2/2Voif8gIU3/NTVp/4GDt/9vdaP/fIWp/6axzP+6xNT/zdjh/9Xg6f/Z4ez/2OHr/9rj7f/d5fD/3+jy/9/p8//e6PL/2+bw/6ivwP+Ah5j/dHqM/5GVpv+fpLT/lZqq/6Knt/+8wdD/mJ6t/4uToP+SmKn/jo+k/5CUqf+AhZz/NTha/wcHOP8qKGX/bmqv/3FvsP9sb6P/l57F/73E2//V3Or/2eLv/9ji7f/X4Oz/1+Lu/9jk7v/b5/H/3Orz/9vp8v/Z5/D/sbnJ/56ltf+fpbT/n6Wz/5+ksv+lqrj/pKi3/6KntP+jqLX/qa66/5+is/+amrH/jpKm/3F2jf8wNFL/DxE+/xwaV/9DQIX/W1mc/3d4s/+boM//sbfS/9TZ6v/e5PT/3OTz/9fi7v/V4uz/1eTt/9bl7f/Z5/D/3Ojx/9rm8P/Ax9X/w8rZ/8rQ3//GzNj/usDN/7W7yP+yt8T/kJOh/5+jr/+9wMv/pai3/52gsv+Tl6r/am6H/zs/X/8gIkz/Bwg8/xQUTv8/QHn/QkR6/3p+rv+8wd3/09rp/9/m9f/d5vP/2eXu/9fl7P/W4ur/1uHq/93o8P/i7PX/4er0/7vE0f+xucf/x8/c/83V4v/L0+D/xMrW/7/Ez/+Tl6L/gYWQ/8jK1v+1uMT/oaWz/4+Sqv9hY4b/QUBv/zc2a/8jI1f/ExVG/w4RPv8BBS//S094/7nB2P/V3un/3efy/9zn7//c6O3/2uXr/9Xg5//Y4en/z9ji/7e+y/+orrz/yNPf/7rF0f+6xdL/1t/s/9Xe7P/V3un/ztXg/6yxvP+ChpH/oqSv/8vQ2P+3vcb/l5u2/1xZi/9COnz/QTl//zo2cf8pKln/ISZI/zk/XP9zeZP/tb/Q/9Th6v/e6fL/2ubr/9vn6v/b5er/1d7n/9jh7f+lrr3/cHiM/15off/K1+P/wM3Z/7bDz//O2+f/0d3q/9Lc6P/P2OL/wsjT/6muuf+doKv/uL3G/8vS3f+vsc//YFuP/zwzd/9DOX7/Qjx2/05Nd/9scIv/p6zA/8XM3P/M2OP/0+Dp/9Xg6P/b5Or/3+jt/9ri6//W4ez/wMzc/3+Opf9TZYH/QlV0/8bV4f/Bz9v/wM7a/8PR3f/J2OT/zNjl/8vU4P/CytT/rrK9/6yuuf+Ii5j/hoyd/5WZtP98e6L/YF6L/2Ffjf9iYof/g4ai/6isv//Jzdv/3eHt/9vl7v/Y5Oz/1d7n/9bd5v/a4er/2eLt/87b6/+GmK//R2GA/zdWe/8wVHv/wtHf/8HR3v/G1uP/xdTg/8TR3f+6x9L/vMbS/7K7x/+4vcj/t7rE/5mdrf93epP/XmJ5/4eMoP+1vMv/p6+7/5+lsf+qsLz/w8jS/9fZ5f/b3ej/3OTu/9rj7f/b4uz/3OHr/9jd6P/N1OP/p7XK/3mRrf9lh6r/WIKs/0l5pf+xw9r/ucjb/7jE0/++x9H/uL7F/7S5wP+ss7v/qK64/6asuP+vtcL/trrH/7Cywv+fpbj/pKq7/8/Q2//S0dj/y83b/8XM3f/Iz9//0Nbi/87U3//S3ef/2+Ts/+Xm7f/i5+z/ztDZ/6intP+bn6//nKzB/52wzf+Gn8H/dJW5/zRKav87Tmn/aHKG/66yvv+wsrn/rK+0/6uvt/+lqrT/oKax/5yksv+kqbL/wMXN/9Le8f/N1en/wMDL/7mzvf/Gx9j/xc3j/8nS4v/P1tz/z9ba/8jY4//Y5PT/0NDc/7S3vf+xrLL/jH+F/5mTmf+tt8L/q7TJ/56rxv9/l7P/Hjdd/xguTv9QX3f/rrbH/7C0v/+vsbr/rbC6/6qvuP+nq7X/naGt/5GWoP+Djpv/pLfQ/6i4z/++xtX/rK+5/6Got/+0wNL/x9He/8vQ0//O09X/r8TX/4qhv/92f5v/lpek/5B/fv98ZF//loyL/6q0u/+jr8H/mavF/2OBoP8mQmz/Izpg/1lqhv+uucz/rrXD/7S2wf+xs73/r7G7/6yvuf+mqLH/lpyp/2Jwi/9LY4r/TWeN/2l6l/9se5P/boCd/3OHp/+Im7b/tsLW/7XA1P9igJ3/M1aA/0peiP+TjqL/n4B5/4RhT/+Vhn7/nqmt/4mYpv92jKT/SmqL/yU9ZP8dMlX/XmyI/7bA0/+zt8f/tbjD/7W3wf+ztcD/r7G7/6mqsv+Tnq3/VXCR/zpikf8oVIP/O2GK/zdcfv80XIT/OWOO/0Bnj/9mh6z/aYqu/0dukf9CbJj/P1yO/5SQp/+shnz/f1ZA/3trY/9/iYz/doaT/26Cmf9LZIX/X3CO/1pphP+Hkab/vsPS/7i7x/+6vMb/trjD/7W3w/+usbz/ra64/5ultP9mgJ3/QWeU/zNejf9Gb5X/R2yN/0Jqj/9Fb5j/TXSb/01uk/9RcZj/RWuK/zFegv9AYpP/kI+o/6iGff9jPSv/X1NQ/3V9if91g5L/eYie/19yj/+6w9b/vcXU/8LG0f/Dw83/wsHK/7y9x/+5vMf/t7rI/7W4xv+usbz/pqy6/5Wiu/9deJ7/RWWM/196mP9tg5j/Z3+W/2yCm/9yg5r/doOY/3mGnv9mgZT/Mlx6/zthjv98gp3/k317/1dBN/9UT1j/dX6T/3eGmP91gpf/XWmG/8TH0//Dxs//xsbN/8nHy//Hxsv/wcLK/7q9yf+hprT/rrTB/7K2w/+qssH/mrDG/1Z5nP8sUnf/VXSO/3mQn/93jZv/d4uY/32Mlf+FjpT/gIuV/2yCkf9FaoX/L1d+/1tqh/+Ni5T/ZGBl/zQ7Tf87RmL/NENd/yMzS/8YKET/yMrT/8jK0v/KytD/zMzP/8PEyf+6vcT/sLXA/6Cms/+pr7z/t7vI/6y0wv+csMf/W3yj/xI2Xv8pRWP/TWBz/0ZVZv9EVGT/Qk5b/ztEUf8xPk7/Gy9I/yJFZ/8hSXD/O1R2/1dmfP8rOU3/AxEt/wAGJ/8ADy3/ABEv/wMcPP/IzNj/x8vV/8nM0v/LzdP/wcHJ/7K2v/+zucX/rbPB/6qvvP+7wMr/uL/I/6y5y/9NaIz/EjBX/w4mR/8WJTz/GCg//x0uSv8eMEv/GC1J/xcvU/8VLlr/JEV0/yJLdv8gP2f/Kklq/zFPbv87UHH/P01x/zJOcv8tVHj/L1Z7/8XM2v/GzNn/xcvU/8rN1f/Ex9D/vcHK/7zCzv+borD/qa+6/8LH0P/Bxsr/s77G/32Vr/9ui63/e5Ox/4OTrP+CmLP/dY+v/3eVuP92l8D/Vn2u/1Z2r/9YebD/VX+t/2OFr/9okLb/faLF/5601/+eq9D/bIyx/12NtP9bjLT/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
$iconBytes                       = [Convert]::FromBase64String($iconBase64)
$stream                          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length)
$Form.Icon                    = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$Form.Width                   = $objImage.Width
$Form.Height                  = $objImage.Height

$Panel1                          = New-Object system.Windows.Forms.Panel
$Panel1.height                   = 639
$Panel1.width                    = 219
$Panel1.location                 = New-Object System.Drawing.Point(6,54)

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "System Tools"
$Label3.AutoSize                 = $true
$Label3.width                    = 230
$Label3.height                   = 25
$Label3.ForeColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Label3.location                 = New-Object System.Drawing.Point(15,12)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',24)

$winacti                       = New-Object system.Windows.Forms.Button
$winacti.text                  = "Activate Windows"
$winacti.width                 = 204
$winacti.height                = 75
$winacti.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$winacti.location              = New-Object System.Drawing.Point(4,25)
$winacti.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$Debloat                         = New-Object system.Windows.Forms.Button
$Debloat.text                    = "Debloat Windows"
$Debloat.width                   = 204
$Debloat.height                  = 75
$Debloat.ForeColor               = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Debloat.location                = New-Object System.Drawing.Point(4,105)
$Debloat.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$twitter                         = New-Object system.Windows.Forms.Button
$twitter.text                    = "My Twitter"
$twitter.width                   = 204
$twitter.height                  = 75
$twitter.ForeColor               = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$twitter.location                = New-Object System.Drawing.Point(4,535)
$twitter.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$Form.controls.AddRange(@($Panel1,$Panel2,$Label3,$Label15,$Panel4,$Label4,$Panel3))
$Panel1.controls.AddRange(@($winacti,$Debloat,$twitter,$Label5))

$winacti.Add_Click({
    Write-Host "Removing Existing key (if any).."
    slmgr.vbs /upk
    Start-Sleep -s 2
    Write-Host "Getting OS..."
    $P = (Get-ComputerInfo).OsName
    Write-Host Got $P
    Start-Sleep -s 2
    Write-Host Activating..
    if ($P = "Microsoft Windows 10 Pro") {
        slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
    } elseif ($P = "Microsoft Windows 10 Pro N") {
        slmgr /ipk MH37W-N47XK-V7XM9-C7227-GCQG9
    } elseif ($P = "Microsoft Windows 10 Home") {
        slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
    } elseif ($P = "Microsoft Windows 10 Home N") {
        slmgr /ipk 3KHY7-WNT83-DGQKR-F7HPR-844BM
    } elseif ($P = "Microsoft Windows 10 Enterprise") {
        slmgr /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
    } elseif ($P = "Microsoft Windows 10 Enterprise Pro") {
        slmgr /ipk DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
    }
    Start-Sleep -s 3
    slmgr /skms kms8.msguides.com
    slmgr /ato
    Write-Host Activated $P
})

$Debloat.Add_Click({
    Write-Host "Creating system restore point.."
    Enable-ComputerRestore -Drive "C:\"
    Checkpoint-Computer -Description "Restore1" -RestorePointType "MODIFY_SETTINGS"

    Write-Host "Running O&O Shutup with Recommended Settings"
    Import-Module BitsTransfer
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ooshutup10.cfg" -Destination ooshutup10.cfg
    Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
    ./OOSU10.exe ooshutup10.cfg /quiet

    Write-Host "Disabling Telemetry..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
    Write-Host "Disabling Wi-Fi Sense..."
    If (!(Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
        New-Item -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0
    Write-Host "Disabling Application suggestions..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
    Write-Host "Disabling Activity History..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0
    # Keep Location Tracking commented out if you want the ability to locate your device
    Write-Host "Disabling Location Tracking..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
    Write-Host "Disabling automatic Maps updates..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
    Write-Host "Disabling Feedback..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Disabling Tailored Experiences..."
    If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
    Write-Host "Disabling Advertising ID..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
    Write-Host "Disabling Error reporting..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
    Write-Host "Restricting Windows Update P2P only to local network..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
    Write-Host "Stopping and disabling Diagnostics Tracking Service..."
    Stop-Service "DiagTrack" -WarningAction SilentlyContinue
    Set-Service "DiagTrack" -StartupType Disabled
    Write-Host "Stopping and disabling WAP Push Service..."
    Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
    Set-Service "dmwappushservice" -StartupType Disabled
    Write-Host "Enabling F8 boot menu options..."
    bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
    Write-Host "Stopping and disabling Home Groups services..."
    Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
    Set-Service "HomeGroupListener" -StartupType Disabled
    Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
    Set-Service "HomeGroupProvider" -StartupType Disabled
    Write-Host "Disabling Remote Assistance..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
    Write-Host "Disabling Storage Sense..."
    Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Recurse -ErrorAction SilentlyContinue
    Write-Host "Stopping and disabling Superfetch service..."
    Stop-Service "SysMain" -WarningAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled
    Write-Host "Disabling Hibernation..."
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0
    Write-Host "Showing task manager details..."
    $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
    Do {
        Start-Sleep -Milliseconds 100
        $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
    } Until ($preferences)
    Stop-Process $taskmgr
    $preferences.Preferences[28] = 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
    Write-Host "Showing file operations details..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1
    Write-Host "Hiding Task View button..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    Write-Host "Hiding People icon..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0
    Write-Host "Enabling NumLock after startup..."
    If (!(Test-Path "HKU:")) {
        New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
    }
    Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
    Add-Type -AssemblyName System.Windows.Forms
    If (!([System.Windows.Forms.Control]::IsKeyLocked('NumLock'))) {
        $wsh = New-Object -ComObject WScript.Shell
        $wsh.SendKeys('{NUMLOCK}')
    }

    Write-Host "Changing default Explorer view to This PC..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

    Write-Host "Hiding 3D Objects icon from This PC..."
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

	# Network Tweaks
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20

	# SVCHost Tweak
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value 4194304

    #Write-Host "Installing Windows Media Player..."
	#Enable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

    Write-Host "Disable News and Interests"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
    # Remove "News and Interest" from taskbar
    Set-ItemProperty -Path  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

    # remove "Meet Now" button from taskbar

    If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
    }

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWord -Value 1

    Write-Host "Removing AutoLogger file and restricting directory..."
    $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
    If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
        Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
    }
    icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

    Write-Host "Stopping and disabling Diagnostics Tracking Service..."
    Stop-Service "DiagTrack"
    Set-Service "DiagTrack" -StartupType Disabled

    Write-Host "Showing known file extensions..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
    Write-Host "Windows has been debloated. Please restart your PC to see results."

})

$twitter.Add_Click({
    Write-Host "Going to Kanji's Twitter."
    Start-Process "https://twitter.com/kanjishere"
})

[void]$Form.ShowDialog()
