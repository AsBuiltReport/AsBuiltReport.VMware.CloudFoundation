function Get-AbrVcfvCenterServer {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VCF vCenter Server information.
    .DESCRIPTION
    Documents VCF vCenter Server information in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "vCenter InfoLevel set at $($InfoLevel.vCenter)."
    }

    process {
        $VcfvCenter = Get-VCFvCenter
        if (($VcfvCenter) -and ($InfoLevel.vCenter -gt 0)) {
            Write-PscriboMessage "Collecting VCF vCenter Server information for $($VcfHost.fqdn)."
            Section -Style Heading2 'vCenter Server' {
                $VcfvCenterInfo = [PSCustomObject]@{
                    'Id' = $VcfvCenter.id
                    'Name' = $VcfvCenter.fqdn
                    'IP Address' = $VcfvCenter.ipAddress
                    'Version' = $VcfvCenter.version
                }

                $TableParams = @{
                    Name = "vCenter Server - $($VcfManager.fqdn)"
                    List = $true
                    ColumnWidths = 50, 50
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VcfvCenterInfo | Table @TableParams
            }
        }
    }

    end {}
}