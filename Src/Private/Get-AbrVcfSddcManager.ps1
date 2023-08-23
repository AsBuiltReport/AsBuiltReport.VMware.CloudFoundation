
function Get-AbrVcfSddcManager {
    <#
    .SYNOPSIS
        Used by As Built Report to retrieve SDDC Manager information.
    .DESCRIPTION
        Documents the configuration of SDDC Manager in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "SDDC InfoLevel set at $($InfoLevel.SDDC)."
    }

    process {
        $global:VcfManager = Get-VCFManager
        if (($VcfManager) -and ($InfoLevel.SDDC -gt 0)) {
            Write-PscriboMessage "Collecting SDDC Manager information for $($VcfManager.fqdn)."
            Section -Style Heading2 "SDDC Manager" {
                try {
                    $SddcMgrInfo = [PSCustomObject] @{
                        'Id' = $VcfManager.id
                        'Name' = $VcfManager.fqdn
                        'IP Address' = $VcfManager.ipAddress
                        'Version' = $VcfManager.version
                    }
                } catch {
                    Write-PscriboMessage -IsWarning $_.Exception.Message
                }

                $TableParams = @{
                    Name = "SDDC Manager - $($VcfManager.fqdn)"
                    List = $true
                    ColumnWidths = 50, 50
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $SddcMgrInfo | Table @TableParams
            }
        }
    }
    end {}

}