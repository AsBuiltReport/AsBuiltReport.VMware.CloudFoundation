function Get-AbrVcfCertificateAuthority {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VCF Certificate Authority information.
    .DESCRIPTION
    Documents VCF Certificate Authority information in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "Security InfoLevel set at $($InfoLevel.Security.CA)."
    }

    process {
        $VcfCertAuthority = Get-VCFCertificateAuthority
        if (($VcfCertAuthority) -and ($InfoLevel.Security.CA -gt 0)) {
            Write-PscriboMessage "Collecting VCF Certificate Authority information for $($VcfHost.fqdn)."
            Section -Style Heading3 'Certificate Authority' {
                $VcfCertAuthInfo = [PSCustomObject]@{
                    'Certificate Authority Type' = $VcfCertAuthority.Id
                    'CA Server URL' = $VcfCertAuthority.serverUrl
                    'Username' = $VcfCertAuthority.Username
                    'Template Name' = $VcfCertAuthority.templateName
                }

                $TableParams = @{
                    Name = "Certificate Authority - $($VcfManager.fqdn)"
                    List = $true
                    ColumnWidths = 50, 50
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VcfCertAuthInfo | Table @TableParams
            }
        }
    }

    end {}
}