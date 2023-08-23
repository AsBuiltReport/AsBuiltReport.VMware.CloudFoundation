function Invoke-AsBuiltReport.VMware.CloudFoundation {
    <#
    .SYNOPSIS
        PowerShell script to document the configuration of VMware CloudFoundation in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of VMware CloudFoundation in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:
        Github:
        Credits:        Iain Brighton (@iainbrighton) - PScribo module

    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.VMware.CloudFoundation
    #>

	# Do not remove or add to these parameters
    param (
        [String[]] $Target,
        [PSCredential] $Credential
    )

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    # Convert PSCredential object
    $Username = $Credential.UserName.ToString()
    $Password = $Credential.GetNetworkCredential().Password

    # Used to set values to TitleCase where required
    $TextInfo = (Get-Culture).TextInfo

    #region foreach loop
    foreach ($SddcManager in $Target) {
		try {
            Write-PScriboMessage "Connecting to SDDC Manager '$SddcManager'."
            Request-VCFToken -fqdn $SddcManager -username $Username -password $Password
        } catch {
            Write-PscriboMessage -IsWarning $_.Exception.Message
        }

        # VCF Host Lookup Hashtable
        Write-PScriboMessage 'Creating VCF Host lookup hashtable.'
        $VcfHostLookup = @{}
        $VcfHosts = Get-VCFHost | Sort-Object fqdn
        foreach ($VcfHost in $VcfHosts) {
            $VcfHostLookup.($VcfHost.Id) = $VcfHost.fqdn
        }

        # VCF Domain Lookup Hashtable
        Write-PScriboMessage 'Creating VCF Domain lookup hashtable.'
        $VcfWorkloadDomainLookup = @{}
        $VcfWorkloadDomains = Get-VCFWorkloadDomain | Sort-Object name
        foreach ($VcfWorkloadDomain in $VcfWorkloadDomains) {
            $VcfWorkloadDomainLookup.($VcfWorkloadDomain.id) = $VcfWorkloadDomain.name
        }

        # VCF Domain Lookup Hashtable
        Write-PScriboMessage 'Creating VCF Cluster lookup hashtable.'
        $VcfClusterLookup = @{}
        $VcfClusters = Get-VCFCluster | Sort-Object name
        foreach ($VcfCluster in $VcfClusters) {
            $VcfClusterLookup.($VcfCluster.id) = $VcfCluster.name
        }

        # VCF Role Lookup Hashtable
        Write-PScriboMessage 'Creating VCF Role lookup hashtable.'
        $VcfRoleLookup = @{}
        $VcfRoles = Get-VCFRole
        foreach ($VcfRole in $VcfRoles) {
            $VcfRoleLookup.($VcfRole.Id) = $VcfRole.Description
        }

		#region SDDC Manager Section
        Section -Style Heading1 "SDDC Manager - $($SddcManager)" {
            Get-AbrVcfSddcManager
            Get-AbrVcfvCenterServer
            Get-AbrVcfWorkloadDomain
            Get-AbrVcfEdgeCluster
            Get-AbrVcfCluster
            Get-AbrVcfHost
            Get-AbrVcfNetwork
            Get-AbrVcfLicense
            Get-AbrVcfBackupConfig
            if ($InfoLevel.Security.PSObject.Properties.Value -ne 0) {
                Section -Style Heading2 'Security' {
                    Get-AbrVcfUser
                    Get-AbrVcfCertificateAuthority
                }
            }
            Get-AbrVcfvRealizeSuite
            if ($InfoLevel.LCM.PSObject.Properties.Value -ne 0) {
                Section -Style Heading2 'LifeCycle Management' {
                    Get-AbrVcfBundle
                }
            }
        }
	}
	#endregion foreach loop
}
