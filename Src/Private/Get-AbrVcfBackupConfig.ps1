function Get-AbrVcfBackupConfig {
    <#
    .SYNOPSIS
        Used by As Built Report to retrieve VCF backup configuration information.
    .DESCRIPTION
        Documents the VCF backup configuration in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
        Credits:        Iain Brighton (@iainbrighton) - PScribo module

    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.VMware.CloudFoundation
    #>
    [CmdletBinding()]
    param (

    )

    begin {
        Write-PScriboMessage "Backup InfoLevel set at $($InfoLevel.Backup)."
    }

    process {
        $VcfBackup = Get-VCFBackupConfiguration
        if (($VcfBackup) -and ($InfoLevel.Backup -gt 0)) {
            Section -Style Heading2 'Backup Configuration' {
                $VcfBackupInfo = [PSCustomObject]@{
                    'Host FQDN / IP' = $VcfBackup.server
                    'Port' = $VcfBackup.port
                    'Transfer Protocol' = $VcfBackup.protocol
                    'Username' = $VcfBackup.username
                    'Backup Directory' = $VcfBackup.directoryPath
                }

                $TableParams = @{
                    Name = "Backup Configuration - $($VcfManager.fqdn)"
                    List = $true
                    ColumnWidths = 50, 50
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VcfBackupInfo | Table @TableParams
            }
        }
    }

    end {}
}