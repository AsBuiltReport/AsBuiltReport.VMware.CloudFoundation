function Get-AbrVcfNetwork {
            <#
    .SYNOPSIS
        Used by As Built Report to retrieve VCF DNS & NTP information.
    .DESCRIPTION
        Documents VCF DNS & NTP information in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "Network InfoLevel set at $($InfoLevel.Network)."
    }

    process {
        $VcfDns = Get-VCFConfigurationDNS
        $VcfNtp = Get-VCFConfigurationNTP
        if ($InfoLevel.Network -gt 0) {
            Section -Style Heading2 'Network' {
                if ($VcfDns) {
                    Write-PscriboMessage "Collecting VCF DNS configuration information for $($VcfManager.fqdn)."
                    Section -Style Heading3 'DNS Servers' {
                        try {
                            $VcfDnsInfo = [PSCustomObject] @{
                                'Primary DNS Server' = $VcfDns.ipAddress
                                #'Alternative DNS Server'
                            }
                        } catch {
                            Write-PscriboMessage -IsWarning $_.Exception.Message
                        }

                        $TableParams = @{
                            Name = "DNS Servers - $($VcfManager.fqdn)"
                            List = $true
                            ColumnWidths = 50, 50
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $VcfDnsInfo | Table @TableParams
                    }
                }

                if ($VcfNtp) {
                    Write-PscriboMessage "Collecting VCF NTP configuration information for $($VcfManager.fqdn)."
                    Section -Style Heading3 'NTP Servers' {
                        try {
                            $VcfNtpInfo = [PSCustomObject] @{
                                'NTP Servers' = $VcfNtp.ipAddress -join ', '
                            }
                        } catch {
                            Write-PscriboMessage -IsWarning $_.Exception.Message
                        }

                        $TableParams = @{
                            Name = "NTP Servers - $($VcfManager.fqdn)"
                            List = $true
                            ColumnWidths = 50, 50
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $VcfNtpInfo | Table @TableParams
                    }
                }
            }
        }
    }

    end {}
}