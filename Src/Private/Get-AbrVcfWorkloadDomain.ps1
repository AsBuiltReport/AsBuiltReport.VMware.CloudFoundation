
function Get-AbrVcfWorkloadDomain {
    <#
    .SYNOPSIS
        Used by As Built Report to retrieve VCF Workload Domain information.
    .DESCRIPTION
        Documents the configuration of VCF Workload Domains in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "Workload Domain InfoLevel set at $($InfoLevel.WorkloadDomain)."
    }

    process {
        if (($VcfWorkloadDomains) -and ($InfoLevel.WorkloadDomain -gt 0)) {
            Section -Style Heading2 "Workload Domains" {
                $VcfWorkloadDomainInfo = foreach ($VcfWorkloadDomain in $VcfWorkloadDomains) {
                    try {
                        $VcfCluster = Get-VCFCluster -id $VcfWorkloadDomain.clusters.id
                        Write-PscriboMessage "Collecting VCF Workload Domain information for $($VcfWorkloadDomain.name)."
                        [PSCustomObject] @{
                            'Id' = $VcfWorkloadDomain.id
                            'Name' = $VcfWorkloadDomain.name
                            'Status' = $TextInfo.ToTitleCase(($VcfWorkloadDomain.Status).ToLower())
                            'Type' = $TextInfo.ToTitleCase(($VcfWorkloadDomain.type).ToLower())
                            'vCenter' = $VcfWorkloadDomain.vcenters.fqdn
                            'Cluster' = $VcfCluster.name
                            'Hosts' = $VcfCluster.hosts.count
                            'NSX-T Cluster' = $VcfWorkloadDomain.nsxtcluster.vipFqdn
                        }
                    } catch {
                        Write-PscriboMessage -IsWarning $_.Exception.Message
                    }
                }

                if ($InfoLevel.WorkloadDomain -ge 2) {
                    foreach ($VcfWorkloadDomain in $VcfWorkloadDomainInfo) {
                        Section -Style Heading3 $($VcfWorkloadDomain.name) {
                            $TableParams = @{
                                Name = "Workload Domain $($VcfWorkloadDomain.name) - $($VcfManager.fqdn)"
                                List = $true
                                ColumnWidths = 50,50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $VcfWorkloadDomain | Table @TableParams
                        }
                    }
                } else {
                    $TableParams = @{
                        Name = "Workload Domains - $($VcfManager.fqdn)"
                        List = $false
                        Columns = 'Name', 'Status', 'Type', 'vCenter', 'Cluster', 'Hosts', 'NSX-T Cluster'
                        ColumnWidths = 16, 10, 16, 17, 17, 8, 16
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VcfWorkloadDomainInfo | Table @TableParams
                }
            }
        }
    }
    end {}

}