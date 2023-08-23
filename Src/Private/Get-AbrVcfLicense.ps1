function Get-AbrVcfLicense {
        <#
    .SYNOPSIS
        Used by As Built Report to retrieve VCF Licensing information.
    .DESCRIPTION
        Documents VCF Licensing information in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "Licensing InfoLevel set at $($InfoLevel.Licensing)."
    }

    process {
        $VcfLicenses = Get-VcfLicenseKey
        if (($VcfLicenses) -and ($InfoLevel.Licensing -gt 0)) {
            Write-PscriboMessage "Collecting VCF Licensing information for $($VcfManager.fqdn)."
            Section -Style Heading2 "Licensing" {
                $VcfLicenseInfo = foreach ($VcfLicense in $VcfLicenses) {
                    try {
                        [PSCustomObject] @{
                            'Product Name' = ($VcfLicense.description).Trim( 'License')
                            'License Key' = Switch ($Options.ShowLicenseKeys) {
                                $true { $VcfLicense.key }
                                $false { "*****-*****-*****" + $VcfLicense.key.Substring(17)}
                            }
                            'Description' = $VcfLicense.description
                            'Status' = Switch ($VcfLicense.licenseKeyValidity.licenseKeyStatus) {
                                'NEVER_EXPIRES' { 'Never Expires' }
                                'ACTIVE' { ' Active' }
                                default { $VcfLicense.licenseKeyValidity.licenseKeyStatus }
                            }
                            'Expiry Date' = Switch ($VcfLicense.licenseKeyValidity.expiryDate) {
                                $null { '--' }
                                default { ($VcfLicense.licenseKeyValidity.expiryDate).ToShortDateString() }
                            }
                            'Unit' = Switch ($VcfLicense.licenseKeyUsage.licenseUnit) {
                                'CPUPACKAGE' { 'CPU Packages' }
                                'SERVER' { 'Server' }
                                default { $VcfLicense.licenseKeyUsage.licenseUnit }
                            }
                            'Used' = $VcfLicense.licenseKeyUsage.used
                            'Available'= $VcfLicense.licenseKeyUsage.remaining
                            'Total' = $VcfLicense.licenseKeyUsage.total
                        }
                    } catch {
                        Write-PscriboMessage -IsWarning $_.Exception.Message
                    }
                }

                if ($InfoLevel.Licensing -ge 2) {
                    foreach ($VcfLicense in $VcfLicenseInfo) {
                        Section -Style Heading3 $($VcfLicense.description).Trim( 'License') {
                            $TableParams = @{
                                Name = "$($VcfLicense.description) - $($VcfManager.fqdn)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $VcfLicense | Table @TableParams
                        }
                    }
                } else {
                    $TableParams = @{
                        Name = "Licensing - $($VcfManager.fqdn)"
                        List = $false
                        Columns = 'Product Name', 'License Key', 'Status', 'Expiry Date'
                        ColumnWidths = 30, 40, 15, 15
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VcfLicenseInfo | Table @TableParams
                }
            }
        }
    }

    end {}
}