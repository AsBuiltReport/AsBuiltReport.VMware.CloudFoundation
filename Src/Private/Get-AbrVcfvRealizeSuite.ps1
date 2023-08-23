function Get-AbrVcfvRealizeSuite {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VCF vRealize Suite product information.
    .DESCRIPTION
    Documents VCF vRealize Suite product information in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "vRealize Suite InfoLevel set at $($InfoLevel.vRealize)."
    }

    process {
        $vRSLCM = Get-VCFvRSLCM
        $vRA = Get-VCFvRA
        $vROPs = Get-VCFvROPS
        $vRLI = Get-VCFvRLI
        $WSA = Get-VCFWSA
        if (($vRSLCM -or $vRA -or $vROPS -or $vRLI -or $WSA) -and ($InfoLevel.vRealize -gt 0)) {
            Section -Style Heading2 'vRealize Suite' {
                if ($vRSLCM) {
                    Write-PscriboMessage "Collecting vRSLCM information for $($VcfHost.fqdn)."
                    Section -Style Heading3 'vRealize Suite Lifecycle Manager' {
                        $vRSLCMInfo = [PSCustomObject]@{
                            'Name' = $vRSLCM.fqdn
                            'IP Address' = $vRSLCM.ipAddress
                            'Version' = $vRSLCM.Version
                            'Status ' = $TextInfo.ToTitleCase(($vRSLCM.Status).ToLower())
                        }

                        $TableParams = @{
                            Name = "vRealize Suite Lifecycle Manager - $($VcfManager.fqdn)"
                            List = $true
                            ColumnWidths = 50, 50
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $vRSLCMInfo | Table @TableParams
                    }

                    if ($vRA) {
                        Write-PscriboMessage "Collecting vRA information for $($VcfHost.fqdn)."
                        Section -Style Heading3 'vRealize Automation' {
                            $vRAInfo = [PSCustomObject]@{
                                'Name' = $vRA.fqdn
                                'IP Address' = $vRA.ipAddress
                                'Version' = $vRA.Version
                                'Status ' = $TextInfo.ToTitleCase(($vRA.Status).ToLower())
                            }

                            $TableParams = @{
                                Name = "vRealize Automation - $($VcfManager.fqdn)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $vRAInfo | Table @TableParams
                        }
                    }

                    if ($vROPs) {
                        Write-PscriboMessage "Collecting vROPs information for $($VcfHost.fqdn)."
                        Section -Style Heading3 'vRealize Operations Manager' {
                            $vROPsInfo = [PSCustomObject]@{
                                'Name' = $vROPs.fqdn
                                'IP Address' = $vROPs.ipAddress
                                'Version' = $vROPs.Version
                                'Status ' = $TextInfo.ToTitleCase(($vROPs.Status).ToLower())
                            }

                            $TableParams = @{
                                Name = "vRealize Operations Manager - $($VcfManager.fqdn)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $vROPsInfo | Table @TableParams
                        }
                    }

                    if ($vRLI) {
                        Write-PscriboMessage "Collecting vRLI information for $($VcfHost.fqdn)."
                        Section -Style Heading3 'vRealize Log Insight' {
                            $vRLIInfo = [PSCustomObject]@{
                                'Name' = $vRLI.fqdn
                                'IP Address' = $vRLI.ipAddress
                                'Version' = $vRLI.Version
                                'Status ' = $TextInfo.ToTitleCase(($vRLI.Status).ToLower())
                            }

                            $TableParams = @{
                                Name = "vRealize Log Insight - $($VcfManager.fqdn)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $vRLIInfo | Table @TableParams
                        }
                    }

                    if ($WSA) {
                        Write-PscriboMessage "Collecting WSA information for $($VcfHost.fqdn)."
                        Section -Style Heading3 'Workspace ONE Access' {
                            $WSAInfo = [PSCustomObject]@{
                                'Name' = $WSA.fqdn
                                'IP Address' = $WSA.ipAddress
                                'Version' = $WSA.Version
                                'Status ' = $TextInfo.ToTitleCase(($WSA.Status).ToLower())
                            }

                            $TableParams = @{
                                Name = "Workspace ONE Access - $($VcfManager.fqdn)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $WSAInfo | Table @TableParams
                        }
                    }
                }
            }
        }
    }
}