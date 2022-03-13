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
	Write-Host "Kanji's AIO Windows Tool"
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
$Form.text                       = "All-In-One Windows Tool by Kanji#2222"
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

$Panel1                       = New-Object system.Windows.Forms.Panel
$Panel1.height                = 639
$Panel1.width                 = 219
$Panel1.location              = New-Object System.Drawing.Point(6,54)

$Label3                       = New-Object system.Windows.Forms.Label
$Label3.text                  = "System Tools"
$Label3.AutoSize              = $true
$Label3.width                 = 230
$Label3.height                = 25
$Label3.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Label3.location              = New-Object System.Drawing.Point(15,12)
$Label3.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',24)

$winacti                      = New-Object system.Windows.Forms.Button
$winacti.text                 = "Activate Windows"
$winacti.width                = 204
$winacti.height               = 75
$winacti.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$winacti.location             = New-Object System.Drawing.Point(4,25)
$winacti.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$Debloat                      = New-Object system.Windows.Forms.Button
$Debloat.text                 = "Debloat Windows"
$Debloat.width                = 204
$Debloat.height               = 75
$Debloat.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Debloat.location             = New-Object System.Drawing.Point(4,105)
$Debloat.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$discord                      = New-Object system.Windows.Forms.Button
$discord.text                 = "Discord Server"
$discord.width                = 204
$discord.height               = 75
$discord.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$discord.location             = New-Object System.Drawing.Point(4,475)
$discord.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$twitter                      = New-Object system.Windows.Forms.Button
$twitter.text                 = "My Twitter"
$twitter.width                = 204
$twitter.height               = 75
$twitter.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$twitter.location             = New-Object System.Drawing.Point(4,555)
$twitter.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$Form.controls.AddRange(@($Panel1,$Panel2,$Label3,$Label15,$Panel4,$Label4,$Panel3))
$Panel1.controls.AddRange(@($winacti,$Debloat,$discord,$twitter,$Label5))

$winacti.Add_Click({
    Write-Host "Removing Existing key (if any).."
    slmgr.vbs /upk
    Start-Sleep -s 2
    Write-Host "Getting OS..."
    $P = (Get-ComputerInfo).OsName
    Write-Host Got $P
    Start-Sleep -s 2
    Write-Host Activating..
    Write-Host 'If you are on Windows 11, it will use the same activation as Windows 10. Activation will still proceed normally.'
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
    Write-Host 'You may now exit to the tool or use the debloater.'
    Write-Host "Thank you for using Kanji's AIO Windows Tool! Be sure to follow my socials below."
})

$Debloat.Add_Click({
    $ErrorActionPreference = 'SilentlyContinue'
        #This function finds any AppX/AppXProvisioned package and uninstalls it, except for Freshpaint, Windows Calculator, Windows Store, and Windows Photos.
        #Also, to note - This does NOT remove essential system services/software/etc such as .NET framework installations, Cortana, Edge, etc.

        #This is the switch parameter for running this script as a 'silent' script, for use in MDT images or any type of mass deployment without user interaction.

        Function Begin-SysPrep {

            Write-Host "Starting Sysprep Fixes"
   
            # Disable Windows Store Automatic Updates
            Write-Host "Adding Registry key to Disable Windows Store Automatic Updates"
            $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
            If (!(Test-Path $registryPath)) {
                Mkdir $registryPath
                New-ItemProperty $registryPath AutoDownload -Value 2 
            }
            Set-ItemProperty $registryPath AutoDownload -Value 2

            #Stop WindowsStore Installer Service and set to Disabled
            Write-Host "Stopping InstallService"
            Stop-Service InstallService
            Write-Host "Setting InstallService Startup to Disabled"
            Set-Service InstallService -StartupType Disabled
        }
        
        Function CheckDMWService {

            Param([switch]$Debloat)
  
            If (Get-Service dmwappushservice | Where-Object { $_.StartType -eq "Disabled" }) {
                Set-Service dmwappushservice -StartupType Automatic
            }

            If (Get-Service dmwappushservice | Where-Object { $_.Status -eq "Stopped" }) {
                Start-Service dmwappushservice
            } 
        }

        Function DebloatAll {
            #Removes AppxPackages
            Get-AppxPackage | Where { !($_.Name -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.Name) } | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where { !($_.DisplayName -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.DisplayName) } | Remove-AppxProvisionedPackage -Online
            Get-AppxPackage -AllUsers | Where { !($_.Name -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.Name) } | Remove-AppxPackage
        }
  
        #Creates a PSDrive to be able to access the 'HKCR' tree
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
  
        Function Remove-Keys {         
            #These are the registry keys that it will delete.
          
            $Keys = @(
          
                #Remove Background Tasks
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
          
                #Windows File
                "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
          
                #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
          
                #Scheduled Tasks to delete
                "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
          
                #Windows Protocol Keys
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
             
                #Windows Share Target
                "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            )
      
            #This writes the output of each key it is removing and also removes the keys listed above.
            ForEach ($Key in $Keys) {
                Write-Host "Removing $Key from registry"
                Remove-Item $Key -Recurse
            }
        }
          
        Function Protect-Privacy { 
  
            #Creates a PSDrive to be able to access the 'HKCR' tree
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
          
            #Disables Windows Feedback Experience
            Write-Host "Disabling Windows Feedback Experience program"
            $Advertising = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
            If (Test-Path $Advertising) {
                Set-ItemProperty $Advertising Enabled -Value 0
            }
          
            #Stops Cortana from being used as part of your Windows Search Function
            Write-Host "Stopping Cortana from being used as part of your Windows Search Function"
            $Search = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
            If (Test-Path $Search) {
                Set-ItemProperty $Search AllowCortana -Value 0
            }
          
            #Stops the Windows Feedback Experience from sending anonymous data
            Write-Host "Stopping the Windows Feedback Experience program"
            $Period1 = 'HKCU:\Software\Microsoft\Siuf'
            $Period2 = 'HKCU:\Software\Microsoft\Siuf\Rules'
            $Period3 = 'HKCU:\Software\Microsoft\Siuf\Rules\PeriodInNanoSeconds'
            If (!(Test-Path $Period3)) { 
                mkdir $Period1
                mkdir $Period2
                mkdir $Period3
                New-ItemProperty $Period3 PeriodInNanoSeconds -Value 0
            }
                 
            Write-Host "Adding Registry key to prevent bloatware apps from returning"
            #Prevents bloatware applications from returning
            $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
            If (!(Test-Path $registryPath)) {
                Mkdir $registryPath
                New-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 
            }          
      
            Write-Host "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
            $Holo = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic'    
            If (Test-Path $Holo) {
                Set-ItemProperty $Holo FirstRunSucceeded -Value 0
            }
      
            #Disables live tiles
            Write-Host "Disabling live tiles"
            $Live = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'    
            If (!(Test-Path $Live)) {
                mkdir $Live  
                New-ItemProperty $Live NoTileApplicationNotification -Value 1
            }
      
            #Turns off Data Collection via the AllowTelemtry key by changing it to 0
            Write-Host "Turning off Data Collection"
            $DataCollection = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection'    
            If (Test-Path $DataCollection) {
                Set-ItemProperty $DataCollection AllowTelemetry -Value 0
            }
      
            #Disables People icon on Taskbar
            Write-Host "Disabling People icon on Taskbar"
            $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
            If (Test-Path $People) {
                Set-ItemProperty $People PeopleBand -Value 0
            }
  
            #Disables suggestions on start menu
            Write-Host "Disabling suggestions on the Start Menu"
            $Suggestions = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'    
            If (Test-Path $Suggestions) {
                Set-ItemProperty $Suggestions SystemPaneSuggestionsEnabled -Value 0
            }
            
            Write-Host "Disabling Bing Search when using Search via the Start Menu"
            $BingSearch = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
            If (Test-Path $BingSearch) {
                Set-ItemProperty $BingSearch DisableSearchBoxSuggestions -Value 1
            }
            
            Write-Host "Removing CloudStore from registry if it exists"
            $CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
            If (Test-Path $CloudStore) {
                Stop-Process Explorer.exe -Force
                Remove-Item $CloudStore -Recurse -Force
                Start-Process Explorer.exe -Wait
            }

  
            #Loads the registry keys/values below into the NTUSER.DAT file which prevents the apps from redownloading. Credit to a60wattfish
            reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Value 0
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name PreInstalledAppsEnabled -Value 0
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name OemPreInstalledAppsEnabled -Value 0
            reg unload HKU\Default_User
      
            #Disables scheduled tasks that are considered unnecessary 
            Write-Host "Disabling scheduled tasks"
            #Get-ScheduledTask -TaskName XblGameSaveTaskLogon | Disable-ScheduledTask
            Get-ScheduledTask -TaskName XblGameSaveTask | Disable-ScheduledTask
            Get-ScheduledTask -TaskName Consolidator | Disable-ScheduledTask
            Get-ScheduledTask -TaskName UsbCeip | Disable-ScheduledTask
            Get-ScheduledTask -TaskName DmClient | Disable-ScheduledTask
            Get-ScheduledTask -TaskName DmClientOnScenarioDownload | Disable-ScheduledTask
        }

        Function UnpinStart {
            # https://superuser.com/a/1442733
            # Requires -RunAsAdministrator

$START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

            $layoutFile="C:\Windows\StartMenuLayout.xml"

            #Delete layout file if it already exists
            If(Test-Path $layoutFile)
            {
                Remove-Item $layoutFile
            }

            #Creates the blank layout file
            $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

            $regAliases = @("HKLM", "HKCU")

            #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
            foreach ($regAlias in $regAliases){
                $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                $keyPath = $basePath + "\Explorer" 
                IF(!(Test-Path -Path $keyPath)) { 
                    New-Item -Path $basePath -Name "Explorer"
                }
                Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
                Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
            }

            #Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
            Stop-Process -name explorer
            Start-Sleep -s 5
            $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
            Start-Sleep -s 5

            #Enable the ability to pin items again by disabling "LockedStartLayout"
            foreach ($regAlias in $regAliases){
                $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                $keyPath = $basePath + "\Explorer" 
                Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
            }

            #Restart Explorer and delete the layout file
            Stop-Process -name explorer

            # Uncomment the next line to make clean start menu default for all new users
            #Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

            Remove-Item $layoutFile
        }
        
        Function CheckInstallService {
  
            If (Get-Service InstallService | Where-Object { $_.Status -eq "Stopped" }) {  
                Start-Service InstallService
                Set-Service InstallService -StartupType Automatic 
            }
        }
  
        Write-Host "Initiating Sysprep"
        Begin-SysPrep
        Write-Host "Removing bloatware apps."
        DebloatAll
        Write-Host "Removing leftover bloatware registry keys."
        Remove-Keys
        Write-Host "Checking to see if any Allowlisted Apps were removed, and if so re-adding them."
        FixWhitelistedApps
        Write-Host "Stopping telemetry, disabling unneccessary scheduled tasks, and preventing bloatware from returning."
        Protect-Privacy
        Write-Host "Unpinning tiles from the Start Menu."
        UnpinStart
        Write-Host "Setting the 'InstallService' Windows service back to 'Started' and the Startup Type 'Automatic'."
        CheckDMWService
        CheckInstallService
        Write-Host Uninstalling OneDrive
        If (Test-Path "$env:USERPROFILE\OneDrive\*") {
            Write-Host "Files found within the OneDrive folder! Checking to see if a folder named OneDriveBackupFiles exists."
            Start-Sleep 1
              
            If (Test-Path "$env:USERPROFILE\Desktop\OneDriveBackupFiles") {
                Write-Host "A folder named OneDriveBackupFiles already exists on your desktop. All files from your OneDrive location will be moved to that folder." 
            }
            else {
                If (!(Test-Path "$env:USERPROFILE\Desktop\OneDriveBackupFiles")) {
                    Write-Host "A folder named OneDriveBackupFiles will be created and will be located on your desktop. All files from your OneDrive location will be located in that folder."
                    New-item -Path "$env:USERPROFILE\Desktop" -Name "OneDriveBackupFiles"-ItemType Directory -Force
                    Write-Host "Successfully created the folder 'OneDriveBackupFiles' on your desktop."
                }
            }
            Start-Sleep 1
            Move-Item -Path "$env:USERPROFILE\OneDrive\*" -Destination "$env:USERPROFILE\Desktop\OneDriveBackupFiles" -Force
            Write-Host "Successfully moved all files/folders from your OneDrive folder to the folder 'OneDriveBackupFiles' on your desktop."
            Start-Sleep 1
            Write-Host "Proceeding with the removal of OneDrive."
            Start-Sleep 1
        }
        Else {
            Write-Host "Either the OneDrive folder does not exist or there are no files to be found in the folder. Proceeding with removal of OneDrive."
            Start-Sleep 1
            Write-Host "Enabling the Group Policy 'Prevent the usage of OneDrive for File Storage'."
            $OneDriveKey = 'HKLM:Software\Policies\Microsoft\Windows\OneDrive'
            If (!(Test-Path $OneDriveKey)) {
                Mkdir $OneDriveKey
                Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
            }
            Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
        }

        Write-Host "Uninstalling OneDrive. Please wait..."
    
        New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        $ExplorerReg1 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
        $ExplorerReg2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
        Stop-Process -Name "OneDrive*"
        Start-Sleep 2
        If (!(Test-Path $onedrive)) {
            $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
        Start-Sleep 2
        Write-Host "Stopping explorer"
        Start-Sleep 1
        taskkill.exe /F /IM explorer.exe
        Start-Sleep 3
        Write-Host "Removing leftover files"
        If (Test-Path "$env:USERPROFILE\OneDrive") {
            Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive") {
            Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") {
            Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
            Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
        }
        Write-Host "Removing OneDrive from windows explorer"
        If (!(Test-Path $ExplorerReg1)) {
            New-Item $ExplorerReg1
        }
        Set-ItemProperty $ExplorerReg1 System.IsPinnedToNameSpaceTree -Value 0 
        If (!(Test-Path $ExplorerReg2)) {
            New-Item $ExplorerReg2
        }
        Set-ItemProperty $ExplorerReg2 System.IsPinnedToNameSpaceTree -Value 0
        Write-Host "Restarting Explorer that was shut down before."
        Start-Process explorer.exe -NoNewWindow
        Write-Host "OneDrive has been successfully uninstalled!"
        
        Remove-item env:OneDrive
        Write-Host "Finished all tasks. `n"
})

$discord.Add_Click({
    Write-Host "Joining Kanji's Discord server..."
    Start-Process "https://discord.gg/kanji"
})

$twitter.Add_Click({
    Write-Host "Going to Kanji's Twitter."
    Start-Process "https://twitter.com/kanjishere"
})

[void]$Form.ShowDialog()
