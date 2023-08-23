function Get-AbrVcfCluster {
    <#
    .SYNOPSIS
        Used by As Built Report to retrieve VCF Cluster information.
    .DESCRIPTION
        Documents the configuration of VCF Clusters in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "Cluster InfoLevel set at $($InfoLevel.Cluster)."
    }

    process {
        if (($VcfClusters) -and ($InfoLevel.Cluster -gt 0)) {
            Section -Style Heading2 'Clusters' {
                $VcfClusterInfo = foreach ($VcfCluster in $VcfClusters) {
                    try {
                        Write-PscriboMessage "Collecting VCF Cluster information for $($VcfCluster.name)."
                        [PSCustomObject] @{
                            'Id' = $VcfCluster.id
                            'Name' = $VcfCluster.name
                            'Datastore Type' = $VcfCluster.primaryDatastoreType
                            'Datastore Name' = $VcfCluster.primaryDatastoreName
                            'Stretched Cluster' = Switch ($VcfCluster.isstretched) {
                                $true { 'Yes' }
                                $false { 'No' }
                            }
                            'Hosts' = & {
                                $VcfClusterHosts = foreach ($vcfhost in $($vcfcluster.hosts)) {
                                    $VcfHostLookup."$($vcfhost.id)"
                                }
                                ($VcfClusterHosts | Sort-Object) -join ', '
                            }
                            'No. of Hosts' = ($VcfCluster.hosts.id).count
                        }
                    } catch {
                        Write-PscriboMessage -IsWarning $_.Exception.Message
                    }
                }

                if ($InfoLevel.Cluster -ge 2) {
                    foreach ($VcfCluster in $VcfClusterInfo) {
                        Section -Style Heading3 $($VcfCluster.name) {
                            $TableParams = @{
                                Name = "Cluster $($VcfCluster.name) - $($VcfManager.fqdn)"
                                List = $true
                                Columns = 'Id', 'Name', 'Hosts', 'Datastore Type', 'Datastore Name', 'Stretched Cluster'
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $VcfCluster | Table @TableParams
                        }
                    }
                } else {
                    $TableParams = @{
                        Name = "Clusters - $($VcfManager.fqdn)"
                        List = $false
                        Columns = 'Name', 'No. of Hosts', 'Datastore Type', 'Stretched Cluster'
                        ColumnWidths = 25, 25, 25, 25
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VcfClusterInfo | Table @TableParams
                }
            }
        }
    }
    end {}
}