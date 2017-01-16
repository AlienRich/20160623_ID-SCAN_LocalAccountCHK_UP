$LoginID = "Domain\DomainAdminID"
$CredMonitoradm = Get-Credential -Credential $LoginID
$host.ui.RawUI.WindowTitle = “USE-ID ::: $LoginID”
#####################################################################################################################
#####################################################################################################################
$SubNet = "192.168.1"
for ($N = 1 ; $N -lt 255 ; $N++)
{$IP=$SubNet+"."+$N
$computername = "$IP"
if (test-connection $IP -Quiet -Count 1) {
                $adsi = [ADSI]"WinNT://$computername"
                $SRVUGList = $adsi.Children | where {$_.SchemaClassName -eq 'user'} | 
                    Foreach-Object {
                    $groups = $_.Groups() | Foreach-Object {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}
                    ##  $_ | Select-Object @{n='UserName';e={$_.Name}},@{n='Groups';e={$groups -join ';'}}
                    $_ | Select-Object @{n='Local-ID';e={$_.Name}},@{n='Local-Groups';e={$groups -join ';'}}
                    }
                $SRVUGList | add-member -Name "IP" -Value $computername -MemberType NoteProperty
                $SRVUGList | Export-Csv -NoTypeInformation -Append -Encoding UTF8 -Path .\$SubNet.xx_List-Local-User-Group.csv
            ####--------------------------------------------------------------------------------------------------------------------
                $LocalAccount = Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" -comp $IP -Credential $CredMonitoradm | select @{n='Local-ID';e={$_.Name}},Caption,PasswordExpires,Disabled
                $LocalAccount | add-member -Name "IP" -Value $computername -MemberType NoteProperty
                $LocalAccount | Export-Csv -NoTypeInformation -Append -Encoding UTF8 -Path .\$SubNet.xx_List-Local-User-Msg.csv
           } 
     else {write-host "This IP is offline：$IP" -ForegroundColor Red
           "This IP is offline：$IP" | Out-File .\$SubNet.xx_ConnectError.Log -Append}
	}
#####################################################################################################################
#####################################################################################################################
