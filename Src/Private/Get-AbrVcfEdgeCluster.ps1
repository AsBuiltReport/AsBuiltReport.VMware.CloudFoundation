function Get-AbrVcfEdgeCluster {
    <#
    .SYNOPSIS
        Used by As Built Report to retrieve VCF NSX Edge Cluster configuration information.
    .DESCRIPTION
        Documents the VCF NSX Edge Cluster configuration in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "EdgeCluster InfoLevel set at $($InfoLevel.NSX.EdgeCluster)."
    }

    process {
        $VcfEdgeClusters = Get-VCFEdgeCluster
        if (($VcfEdgeClusters) -and ($InfoLevel.NSX.EdgeCluster -gt 0)) {
            Section -Style Heading2 'Edge Clusters' {
                $VcfEdgeClusterInfo = foreach ($VcfEdgeCluster in $VcfEdgeClusters) {
                    [PSCustomObject]@{
                        'Id' = $VcfEdgeCluster.Id
                        'Name' = $VcfEdgeCluster.name
                        'Clusters' = $VcfClusterLookup."$($VcfEdgeCluster.clusters.id)"
                        'NSX-T Cluster' = $VcfEdgeCluster.nsxtcluster.vipFqdn
                        'Edge Nodes' = $VcfEdgeCluster.edgenodes.hostname -join ', '
                    }
                }

                $TableParams = @{
                    Name = "Edge Clusters - $($VcfManager.fqdn)"
                    List = $true
                    ColumnWidths = 50, 50
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VcfEdgeClusterInfo | Table @TableParams
            }
        }
    }
}