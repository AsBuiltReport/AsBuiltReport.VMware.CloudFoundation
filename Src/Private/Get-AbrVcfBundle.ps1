function Get-AbrVcfBundle {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VCF Software Bundle information.
    .DESCRIPTION
    Documents VCF Software Bundle information in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "Bundles InfoLevel set at $($InfoLevel.LCM.Bundles)."
    }

    process {
        $VcfBundles = Get-VCFBundle | Sort-Object releasedDate -Descending
        if (($VcfBundles) -and ($InfoLevel.LCM.Bundles -gt 0)) {
            Write-PscriboMessage "Collecting software bundle information for $($VcfHost.fqdn)."
            Section -Style Heading4 'Bundle Managment' {
                $VcfBundleInfo = foreach ($VcfBundle in $VcfBundles) {
                    try {
                        [PSCustomObject]@{
                            'Bundle Type' = Switch ($VcfBundle.components.type) {
                                "VCENTER" { 'vCenter Server' }
                                "NSX_T_MANAGER" { 'NSX-T Manager' }
                                "VRSLCM" { 'vRealize Suite Lifecycle Manager' }
                                "VRLI" { 'vRealize Log Insight' }
                                "VRA" { 'vRealize Automation' }
                                "VROPS" { 'vRealise Operations Manager' }
                                "WSA" { 'Workspace ONE Access'}
                                default { $VcfBundle.components.type }
                            }
                            'Version' = $VcfBundle.Version
                            #'Vendor' = $VcfBundle.components.vendor
                            #'Description' = $VcfBundle.description
                            'Release Date' = ($VcfBundle.releasedDate).ToShortDateString()
                            'Size GB' = [math]::Round($VcfBundle.sizeMB / 1024 / 1024 / 1024, 1)
                            'Availability Status' = Switch ($VcfBundle.components.imageType) {
                                "INSTALL" { 'Install Only Bundle' }
                                "PATCH" { 'Patch/Upgrade Bundle' }
                                default { $VcfBundle.components.imageType }
                            }
                            'Download Status' = $TextInfo.ToTitleCase(($VcfBundle.downloadStatus).ToLower())
                        }
                    } catch {
                        Write-PscriboMessage -IsWarning $_.Exception.Message
                    }
                }

                $TableParams = @{
                    Name = "Bundle Management - $($VcfManager.fqdn)"
                    List = $false
                    ColumnWidths = 22, 17, 14, 10, 22, 15
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VcfBundleInfo | Table @TableParams
            }
        }
    }

    end {}
}