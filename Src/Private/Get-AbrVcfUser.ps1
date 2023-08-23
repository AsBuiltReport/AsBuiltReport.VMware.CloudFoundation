function Get-AbrVcfUser {
            <#
    .SYNOPSIS
        Used by As Built Report to retrieve VCF User information.
    .DESCRIPTION
        Documents VCF User information in Word/HTML/Text formats using PScribo.
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
        Write-PScriboMessage "User InfoLevel set at $($InfoLevel.Security.Users)."
    }

    process {
        $VcfUsers = Get-VCFUser | Sort-Object Name
        if (($VcfUsers) -and ($InfoLevel.Security.Users -gt 0)) {
            Section -Style Heading3 'Users' {
                Write-PscriboMessage "Collecting VCF user information for $($VcfManager.fqdn)."
                $VcfUserInfo = foreach ($VcfUser in $VcfUsers) {
                    try {
                        [PSCustomObject] @{
                            'User/Group Name' = $VcfUser.name
                            'Type' = $TextInfo.ToTitleCase(($VcfUser.type).ToLower())
                            'Domain' = $VcfUser.Domain
                            'Role' = $VcfRoleLookup."$($VcfUser.role.id)"
                        }
                    } catch {
                        Write-PscriboMessage -IsWarning $_.Exception.Message
                    }
                }

                $TableParams = @{
                    Name = "Users - $($VcfManager.fqdn)"
                    List = $false
                    ColumnWidths = 40, 15, 25, 20
                }
                if ($Report.ShowTableCaptions) {
                    $TableParams['Caption'] = "- $($TableParams.Name)"
                }
                $VcfUserInfo | Table @TableParams
            }
        }
    }

    end {}
}