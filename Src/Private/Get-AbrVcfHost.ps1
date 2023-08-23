function Get-AbrVcfHost {
    <#
    .SYNOPSIS
        Used by As Built Report to retrieve VCF Host information.
    .DESCRIPTION
        Documents the configuration of VCF Hosts in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "Host InfoLevel set at $($InfoLevel.Host)."
    }

    process {
        if (($VcfHosts) -and ($InfoLevel.Host -gt 0)) {
            Section -Style Heading2 'Hosts' {
                $VcfHostInfo = foreach ($VcfHost in $VcfHosts) {
                    try {
                        $VcfCluster = Get-VCFCluster -id $VcfHost.cluster.id
                        Write-PscriboMessage "Collecting VCF Host information for $($VcfHost.fqdn)."
                        [PSCustomObject] @{
                            'Id' = $VcfHost.id
                            'FQDN' = $VcfHost.fqdn
                            'Host IP' = ($VcfHost.ipAddresses | Where-Object {$_.type -eq 'Management'}).ipaddress
                            'IP Addresses' = "$(($VcfHost.ipAddresses | Where-Object {$_.type -eq 'Management'}).ipaddress) [Management] $([Environment]::NewLine) $(($VcfHost.ipAddresses | Where-Object {$_.type -eq 'vSAN'}).ipaddress) [vSAN] $([Environment]::NewLine) $(($VcfHost.ipAddresses | Where-Object {$_.type -eq 'vMotion'}).ipaddress) [vMotion]"
                            'Vendor' = $VcfHost.hardwareVendor
                            'Model' = $VcfHost.hardwareModel
                            'ESXi Version' = $VcfHost.esxiVersion
                            'Host State' = "$($TextInfo.ToTitleCase(($VcfHost.Status).ToLower())) ($($VcfWorkloadDomainLookup."$($VcfHost.domain.id)"))"
                            'Cluster' = $VcfCluster.name
                            'CPU' = "$($vcfhost.cpu.cpucores.manufacturer | Select-Object -First 1)"
                            'CPU Cores' = $vcfhost.cpu.cores
                            'Memory' = "$([math]::Round($vcfhost.memory.totalCapacityMB / 1024, 0)) GB"
                            'CPU / Memory Usage' = "CPU: $([math]::Round(($vcfhost.cpu.usedFrequencyMHz / $vcfhost.cpu.frequencyMHz) * 100, 0))%; Memory: $([math]::Round(($vcfhost.memory.usedCapacityMB / $vcfhost.memory.totalCapacityMB) * 100, 0))%"
                            #"Storage" = "$([math]::Round($vcfhost.storage.totalCapacityMB / 1024 / 1024, 0)) TB"
                            "NICs" = $vcfhost.physicalNics.count
                        }
                    } catch {
                        Write-PscriboMessage -IsWarning $_.Exception.Message
                    }
                }

                if ($InfoLevel.Host -ge 2) {
                    foreach ($VcfHost in $VcfHostInfo) {
                        Section -Style Heading3 $($VcfHost.fqdn) {
                            $TableParams = @{
                                Name = "Host $($VcfHost.fqdn) - $($VcfManager.fqdn)"
                                List = $true
                                Columns = 'Id', 'FQDN', 'IP Addresses', 'Vendor', 'Model', 'ESXi Version', 'Cluster', 'CPU', 'CPU Cores', 'Memory', 'CPU / Memory Usage', 'NICs'
                                ColumnWidths = 50,50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $VcfHost | Table @TableParams
                        }
                    }
                } else {
                    $TableParams = @{
                        Name = "Hosts - $($VcfManager.fqdn)"
                        List = $false
                        Columns = 'FQDN', 'Host State', 'Host IP', 'ESXi Version', 'Cluster'
                        ColumnWidths = 20, 20, 20, 20, 20
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VcfHostInfo | Table @TableParams
                }
            }
        }
    }
    end {}
}