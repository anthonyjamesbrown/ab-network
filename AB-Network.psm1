function Get-DBConnectionString
{
    <#
        .SYNOPSIS
            This function returns a connection string for the UCS database.
        .DESCRIPTION
            This function is a easy place to store the connection information for the UCS database.
        .EXAMPLE
            PS C:\PS Script\UCS> Get-DBConnectionString
            Server=<DataBase\Instance>;Database=AB_Test;Integrated Security=true
    #>   
    [CmdletBinding()]
    param()

    $DBServer = 'ABSQL'
    $DBName   = 'AB_Test'

    $ConnectionString = "Server=$DBServer;Database=$DBName;Integrated Security=true"
    $ConnectionString
} # end function Get-DBConnectionString

function Get-DatabaseData 
{
    <#
        .SYNOPSIS
            Returns a dataset object.
        .DESCRIPTION
            Returns a dataset object by executed a query against a database based on the connection string supplied.
        .PARAMETER ConnectionString
            This parameter is required to connect to a database to run a query.  This is a standard format connection string.
            A default is used if not supplied.  To see the default run cmdlet: Get-UCSConnectionString.
        .PARAMETER Query
            This parameter is the database query to run.  This ideally would be a select statment of some kind.
        .EXAMPLE
            PS C:\> Get-DatabaseData -verbose -connectionString (Get-UCSConnectionString) -query "Select InstanceName From UCSInstances Where Status = 'Online'"
    #>   
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$false
        )]
        [Alias("conn","cs")]
        [string]
        $connectionString = (Get-DBConnectionString),

        [Parameter(
            Mandatory=$true
        )]
        [string]
        $query
    ) # end param

    $connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString

    $command = $connection.CreateCommand()
    $command.CommandText = $query

    $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter $command
    $dataset = New-Object -TypeName System.Data.DataSet
    $adapter.Fill($dataset) | Out-Null

    $dataset.Tables[0]
} # end function Get-DatabaseData

function Invoke-DatabaseQuery 
{
    <#
        .SYNOPSIS
            Invokes a database command.
        .DESCRIPTION
            This function is for running commands against a database other than select statements.  This function does not return anything.
        .PARAMETER ConnectionString
            This parameter is required to connect to a database to run a query.  This is a standard format connection string.
            A default is used if not supplied.  To see the default run cmdlet: Get-UCSConnectionString.
        .PARAMETER Query
            This parameter is required.  This is the query that will be executed against the database specified in the connectionstring.
        .EXAMPLE
            PS C:\> Invoke-DatabaseQuery -verbose -connectionString (Get-UCSConnectionString) -query "Update UCSInstance Set Status = 'offline' where InstanceName = 'LABUCS001'"
    #>   
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$false
        )]
        [Alias("conn","cs")]
        [string]
        $connectionString  = (Get-DBConnectionString),
        
        [Parameter(
            Mandatory=$true
        )]
        [string]
        $query
    ) # end param

    Write-Verbose $query
    $connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString

    $command = $connection.CreateCommand()
    $command.CommandText = $query

    $connection.Open()
    $command.ExecuteNonQuery()

    $connection.close()
} # end function Invoke-DatabaseQuery  
 
function Invoke-FlattenObjects 
{
    <#
        .SYNOPSIS
            Flattens data collected from IPAM
        .DESCRIPTION
            This function is called to take an array of objects collected from IPAM and return a new flattened data array.
        .PARAMETER Data
            This parameter is an array of IPAM data objects.
    #>
    param(
        [Parameter(
            Mandatory=$true
        )]
        $Data
    ) # end param

    # Loop through the data and create a new custom object with all the previously nested data members in the extattrs field on the same level
    $Data | ForEach-Object {
        $Record = $_
        $extattrs = $Record.extattrs
        $obj = [pscustomobject]@{
            'ref'               = $Record._ref
            'network_view'      = $Record.network_view
            'network_container' = $Record.network_container
            'network'           = $Record.network
            'itam'              = $extattrs.ITAM.value
            'conflict'          = $extattrs.conflict.value
            'country'           = $extattrs.Country.value
            'region'            = $extattrs.Region.value
            'city'              = $extattrs.city.value    
            'site'              = $extattrs.Site.value
            'env'               = $extattrs.ENV.value
            'zone'              = $extattrs.zone.value
            'vlan'              = $extattrs.VLAN.value
            'sz'                = $extattrs.sz.value
            'comment'           = $Record.comment
            'type'              = $extattrs.Type.value
            'fxn'               = $extattrs.fxn.value            
            'host_device'       = $extattrs.host_device.value
            'interface'         = $extattrs.interface.value                                                                               
        }
        $obj
    } # end foreach ($Data)
} # end function Invoke-FlattenObject

function Format-NetMRIDeviceObject
{
    param(
        [Parameter(
            Mandatory=$true
        )]
        $Data
    ) # end param

    # Loop through the data and create a new custom object with all the previously nested data members in the extattrs field on the same level
    $Data | ForEach-Object {
        $Record = $_
       
        $obj = [pscustomobject]@{
            'DeviceFirstOccurrenceTime' = $Record.DeviceFirstOccurrenceTime
            'DeviceID'                  = $Record.DeviceID
            'DeviceIPDotted'            = $Record.DeviceIPDotted
            'DeviceMAC'                 = $Record.DeviceMAC
            'DeviceModel'               = $Record.DeviceModel
            'DeviceName'                = $Record.DeviceName
            'DeviceStartTime'           = $Record.DeviceStartTime
            'DeviceSysContact'          = $Record.DeviceSysContact
            'DeviceSysDescr'            = $Record.DeviceSysDescr
            'DeviceSysLocation'         = $Record.DeviceSysLocation
            'DeviceSysName'             = $Record.DeviceSysName
            'DeviceTimestamp'           = $Record.DeviceTimestamp
            'DeviceType'                = $Record.DeviceType
            'DeviceVendor'              = $Record.DeviceVendor 
            'DeviceVersion'             = $Record.DeviceVersion
        } # End obj
        $obj            
    } # End Loop
} # end function Format-NetMRIDeviceObject

function Format-NetMRIDeviceComponentObject
{
    param(
        [Parameter(
            Mandatory=$true
        )]
        $Data
    ) # end param

    # Loop through the data and create a new custom object with all the previously nested data members in the extattrs field on the same level
    $Data | ForEach-Object {
        $Record = $_
       
        $obj = [pscustomobject]@{
            'DeviceID'             = $Record.DeviceID
            'DevicePhysicalID'     = $Record.DevicePhysicalID
            'PhysicalAlias'        = $Record.PhysicalAlias
            'PhysicalAssetID'      = $Record.PhysicalAssetID
            'PhysicalClass'        = $Record.PhysicalClass
            'PhysicalContainedIn'  = $Record.PhysicalContainedIn
            'PhysicalDescr'        = $Record.PhysicalDescr
            'PhysicalEndTime'      = $Record.PhysicalEndTime
            'PhysicalFirmwareRev'  = $Record.PhysicalFirmwareRev
            'PhysicalHardwareRev'  = $Record.PhysicalHardwareRev
            'PhysicalIndex'        = $Record.PhysicalIndex
            'PhysicalMfgName'      = $Record.PhysicalMfgName
            'PhysicalModelName'    = $Record.PhysicalModelName
            'PhysicalName'         = $Record.PhysicalName
            'PhysicalParentRelPos' = $Record.PhysicalParentRelPos
            'PhysicalSerialNum'    = $Record.PhysicalSerialNum
            'PhysicalSoftwareRev'  = $Record.PhysicalSoftwareRev
            'PhysicalStartTime'    = $Record.PhysicalStartTime
            'PhysicalTimestamp'    = $Record.PhysicalTimestamp
            'PhysicalVendorType'   = $Record.PhysicalVendorType
            'UnitState'            = $Record.UnitState
        } # End Obj
        $obj            
    } # End Loop Data
} # end function Format-NetMRIDeviceComponentObject

function Get-NetMRIDevices
{
    <#
        .SYNOPSIS
            Return all of the Device objects in NetMRI
        .DESCRIPTION
            This function makes a REST call to the NetMRI interface and pulls back all of the device objects
        .PARAMETER Cred
            This parameter is a standard PSCredential.  This is used when connecting to the NetMRI REST interface
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [System.Management.Automation.PSCredential]
        $Cred
    ) # end param

    # if no Cred is passed, prompt for one
    if(!$Cred) { $Cred = Get-Credential}

    # REST Parameters
    $selectstring = "DeviceFirstOccurrenceTime,DeviceID,DeviceIPDotted,DeviceMAC,DeviceModel,DeviceName,DeviceStartTime,DeviceSysContact,DeviceSysDescr,DeviceSysLocation,DeviceSysName,DeviceTimestamp,DeviceType,DeviceVendor,DeviceVersion"
    $Uri = "http://<netmri_url>/api/2.10/devices/index?limit=6000&select=$selectstring"  # The base URI for the NetMRI WAPI REST interface

    Try
    {
        # We are required to make a Rest Call to the authenticate module first in order to authenticate the session for subsequent calls.
        # The WebSession is stored as $MySession
        # The NetMRI does not support passing a PSCredential object normally used in Invoke-RestMethod, instead you have to break out the username and password explictly
        Invoke-RestMethod -Method Get -Uri "http://<netmri_url>/api/2.10/authenticate.json?username=$($aCred.UserName)&password=$($aCred.GetNetworkCredential().password)" -SessionVariable MySession
        $TempResultRaw = Invoke-RestMethod -Method Get -Uri "$Uri" -WebSession $MySession
        # The size of the JSON data returned exceeds what the ConvertFrom-Json cmdlet can handle so instead we create our own JavaScriptSerializer with a larger buffer to perform the conversion
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
        $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
        $jsonserial.MaxJsonLength = 200MB
        $TempResult = $jsonserial.DeserializeObject($TempResultRaw)
        $Results = Format-NetMRIDeviceObject -Data $TempResult.devices
        $Results = $Results | Where-Object { ($_ | Get-Member | Measure-Object | Select-Object -ExpandProperty Count) -gt 4 }

        $Results
    }
    Catch
    {
        Throw "Error retrieving data: $_"
    } # End Try
} # end function Get-NetMRIDevices

function Get-NetMRIDeviceComponents
{
    <#
        .SYNOPSIS
            Return all of the Device objects in NetMRI
        .DESCRIPTION
            This function makes a REST call to the NetMRI interface and pulls back all of the device component objects
        .PARAMETER Cred
            This parameter is a standard PSCredential.  This is used when connecting to the NetMRI REST interface
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [System.Management.Automation.PSCredential]
        $Cred
    ) # end param

    # if no Cred is passed, prompt for one
    if(!$Cred) { $Cred = Get-Credential}

    # REST Parameters
    $Start = 0
    $Limit = 2000

    $SelectString = "DeviceID,DevicePhysicalID,PhysicalAlias,PhysicalAssetID,PhysicalClass,PhysicalContainedIn,PhysicalDescr,PhysicalEndTime,PhysicalFirmwareRev,PhysicalHardwareRev,PhysicalIndex,PhysicalMfgName,PhysicalModelName,PhysicalName,PhysicalParentRelPos,PhysicalSerialNum,PhysicalSoftwareRev,PhysicalStartTime,PhysicalTimestamp,PhysicalVendorType,UnitState"
    #$Uri = "http://<netmri_url>/api/2.10/device_physicals/search?limit=10000&PhysicalName=Chassis"  # The base URI for the NetMRI WAPI REST interface

    Try
    {
        # We are required to make a Rest Call to the authenticate module first in order to authenticate the session for subsequent calls.
        # The WebSession is stored as $MySession
        # The NetMRI does not support passing a PSCredential object normally used in Invoke-RestMethod, instead you have to break out the username and password explictly
        Invoke-RestMethod -Method Get -Uri "http://<netmri_url>/api/2.10/authenticate.json?username=$($Cred.UserName)&password=$($Cred.GetNetworkCredential().password)" -SessionVariable MySession
        $Results = @()
        $First = $true
        do
        {           
            $Uri = "http://<netmri_url>/api/2.10/device_physicals/index?start=$Start&limit=$Limit&select=$SelectString"  # The base URI for the NetMRI WAPI REST interface
            $TempResult = Invoke-RestMethod -Method Get -Uri "$Uri" -WebSession $MySession

            Write-Verbose "$Start of $($TempResult.total)"     

            if($First)
            {
                $Start = ($TempResult.current) + 1
                $First = $false
            }
            else
            {
                $Start += $Limit
            }
            $Results += $TempResult.device_physicals
            #$Results += Format-NetMRIDeviceComponentObject -Data $TempResult.device_physicals                   
        } 
        Until($Start -gt $TempResult.total)
        #$Results = $Results | ? { ($_ | get-member | measure | Select -ExpandProperty Count) -gt 4 }
        $Results
    }
    Catch
    {
        Throw "Error retrieving data: $_"
    }
} # end function Get-NetMRIDeviceComponents

function Invoke-IgnoreSelfSignedCerts 
{
    <#
        .SYNOPSIS
            This function allows the REST call to the IPAM interface that is using a self-signed cert to be allowed
    #>
    add-type -TypeDefinition  @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
} # end function Invoke-IgnoreSelfSignedCerts

function Get-OrionNodes
{
    <#
        .SYNOPSIS
            Returns Node data from Orion
        .DESCRIPTION
            This function makes a REST API call into Orion and returns a number of useful fields.
        .PARAMETER Cred
            This parameter is a standard PSCredential.  This is used when connecting to the Orion PS Module           
        .LINK 
            https://github.com/solarwinds/OrionSDK/wiki/REST
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [System.Management.Automation.PSCredential]
        $Cred
    ) # end param

    Invoke-IgnoreSelfSignedCerts

    # The query below is pulling fields that I thought would be of the most use, but there are many more available.  The OrionSDK has a tool called SWQL Studio for exploring the data model.
    $Query = "SELECT+A.NodeID,A.NodeName,A.SysName,A.IP_Address,A.Caption,A.Contact,A.Location,A.Description,A.MachineType,C.Manufacturer,C.Model,C.ServiceTag,A.NodeDescription,A.StatusDescription,A.Vendor,A.IOSImage,A.IOSVersion,B.Alert,B.BusinessLine,B.CustomRole,B.CustomVendor,B.Imported_From_NCM,B.Region+FROM+Orion.Nodes+A+LEFT+OUTER+JOIN+Orion.NodesCustomProperties+B+ON+A.NodeID=B.NodeID+LEFT+OUTER+JOIN+Orion.HardwareHealth.HardwareInfo+C+ON+A.NodeID=C.NodeID"

    $Uri = "https://orionnpm.company.net:17778/SolarWinds/InformationService/v3/Json/Query?query=$Query"  # The base URI for the Orion REST API

    Try
    {
        $TempResultRaw = Invoke-RestMethod -Method Get -Uri "$Uri" -Credential $Cred

        $TempResultRaw.Results
    }
    Catch
    {
        Throw "Error retrieving data: $_"
    } # End Try
} # end function Get-OrionNodes

function Get-ITAMNetworkData
{
    <#
    .SYNOPSIS
        Returns device inventory data from Service-Now
    .DESCRIPTION
        This function makes a REST API call into Service-Now and returns a number of useful fields.
    .PARAMETER Cred
        This parameter is a standard PSCredential.  This is used when connecting to the Orion PS Module           
    #>
    [CmdletBinding()]
    Param()

    $user = "sn.hardwareAPI.RO.local"
    $pass = "************"

    # Build auth header
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

    # Set proper headers
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
    $headers.Add('Accept','application/json')

    $baseURI    = "https://somecompany.service-now.com/api/now/table/"
    $table      = "alm_hardware"
    $query      = "u_asset_nameLIKECISCO%5EORmodelLIKECISCO%5EORciLIKECISCO"
    $excludeRef = 'true'
    $displayVal = 'true'
    $fields     = 'display_name,install_status,ci,serial_number,u_asset_name,location'

    $URI = "$($baseURI)$($table)?sysparm_query=$($query)&sysparm_exclude_reference_link=$($excludeRef)&sysparm_display_value=$($displayVal)&sysparm_fields=$($fields)"   

    Try
    {
        $TempResultRaw = Invoke-RestMethod -Method Get -Uri $Uri -Headers $headers

        <#
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
        $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
        $jsonserial.MaxJsonLength = 200MB
        $TempResult = $jsonserial.DeserializeObject($TempResultRaw)

        $Custom = $TempResult.result | % { New-Object -TypeName PSCustomObject -Property $_ }
        $Custom
        #>
        $TempResultRaw.result
    }
    Catch
    {
        Throw "Error retrieving data: $_"
    } # End Try
} # end function Get-ITAMNetworkData

function Get-IPAMDataNetworks
{
    <#
        .SYNOPSIS
            Return all of the NETWORK objects in IPAM
        .DESCRIPTION
            This function makes a REST call to the IPAM interface and pulls back all of the network objects
        .PARAMETER Cred
            This parameter is a standard PSCredential.  This is used when connecting to the IPAM REST interface
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [System.Management.Automation.PSCredential]
        $Cred
    ) # end param

    Invoke-IgnoreSelfSignedCerts # This is required since the IPAM interface is using a self-signed cert
    [Net.ServicePointManager]::SecurityProtocol = 'Tls11','Tls12','tls'

    # if no Cred is passed, prompt for one
    if(!$Cred) { $Cred = Get-Credential} 

    # REST Parameters
    $PageSize = 500                                                        # This is how many objects should be returned per page 500 is near the max for this call
    $BaseUri = "https://thegrid/wapi/v2.2/"                                # The base URI for the IPAM REST interface, not the version number
    $Fields = "network_view,network,comment,network_container,extattrs"    # The fields that will be collected
    $Object = "network"                                                    # The object type to query, this function queries for network objects
    $NextPageID = "NotStarted"                                             # This object type has more objects than can be returned at once so paging must be used, this intializes the NextPageID

    # Create an empty AllResults array to hold the objects that are returned from the REST query
    $AllResults = @()

    # Construct the URI string.  Note that the initial query is using _paging = 1 and _return_as_object = 1
    #  Since paging must be used passing those two options causes an object to be returned that contains the results and a NextPageID that will be used
    #  to cycle through the rest of the page results until there is no NextPageID
    $Uri = "$($BaseUri)$($Object)?_paging=1&_return_as_object=1&_max_results=$($PageSize)&_return_fields=$($Fields)"

    # Initialize a page counter to 0 to count how many pages we collected data from
    $PageCount = 0

    # Loop through all of the data pages
    do
    {
        # Check to see if we have already made the initial call
        if($NextPageID -notlike "NotStarted")
        {
            # Make a REST call using the NextPageID to recieve the next page of results
            $Uri = "$($BaseUri)$($Object)?_page_id=$($NextPageID)"
        } # End if

        Try
        {
            # This is the first call to make the initial call
            $TempResultRaw = Invoke-RestMethod -Method Get -Uri "$Uri" -Credential $Cred

            # Because IPAM objects have been imported from multiple sources some of the Meta-Data field names are capitalized for some object and not for others.  
            #  The data returned is in JSON format and we need to convert it.  In order to have the fields treated the same we fix the case issue on the problem fields using replace.
            $TempResult = $TempResultRaw.Replace("region","Region").Replace("conflict", "Conflict").Replace("country", "Country").Replace("env","ENV") | ConvertFrom-Json
        }
        Catch
        {
            Throw "Error retrieving data: $_"
        } # End Try

        # Grab the NextPageID from the data returned by the REST call.
        $NextPageID = $TempResult.next_page_id
         
        # Append the results data to the AllResults array    
        $AllResults += $TempResult.result

        $PageCount++ # Increment PageCounter for reporting

        Write-Verbose "Page Count: $PageCount, Results Count: $($AllResults.Count)"
    } # End Do
    until (-not $TempResult.next_page_id)

    # Pass the results to the Invoke-FlattenObjects function to flatten out the data structure
    $FinalResults = Invoke-FlattenObjects -Data $AllResults
    $FinalResults

} # end function Get-IPAMDataNetworks

function Get-IPAMDataNetworkContainers
{
    <#
        .SYNOPSIS
            Return all of the NETWORKContainers objects in IPAM
        .DESCRIPTION
            This function makes a REST call to the IPAM interface and pulls back all of the network_container objects
        .PARAMETER Cred
            This parameter is a standard PSCredential.  This is used when connecting to the IPAM REST interface
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [System.Management.Automation.PSCredential]
        $Cred
    )

    Invoke-IgnoreSelfSignedCerts # This is required since the IPAM interface is using a self-signed cert
    [Net.ServicePointManager]::SecurityProtocol = 'Tls11','Tls12','tls'

    # if no Cred is passed, prompt for one
    if(!$Cred) { $Cred = Get-Credential}

    # REST Parameters
    $PageSize = 600                                                     # This is how many objects should be returned per page 600 is large enough to get all of the objects
    $BaseUri = "https://thegrid/wapi/v2.2/"                             # The base URI for the IPAM REST interface, not the version number
    $Fields = "network_view,network,comment,network_container,extattrs" # The fields that will be collected
    $Object = "networkcontainer"                                        # The object type to query, this function queries for networkcontainer objects

    # Construct the URI string. The number of network containers is small enough that paging is not required.
    $Uri = "$($BaseUri)$($Object)?_max_results=$($PageSize)&_return_fields=$($Fields)"

    Try
    {
        # Because IPAM objects have been imported from multiple sources some of the Meta-Data field names are capitalized for some object and not for others.  
        #  The data returned is in JSON format and we need to convert it.  In order to have the fields treated the same we fix the case issue on the problem fields using replace.
        $TempResultRaw = Invoke-RestMethod -Method Get -Uri "$Uri" -Credential $Cred
        $TempResult = $TempResultRaw.Replace("region","Region").Replace("conflict", "Conflict").Replace("country", "Country").Replace("env","ENV") | ConvertFrom-Json
    }
    Catch
    {
        Throw "Error retrieving data: $_"
    } # End Try

    # Pass the results to the Invoke-FlattenObjects function to flatten out the data structure
    $FinalResults = Invoke-FlattenObjects -Data $TempResult
    $FinalResults
} # end function Get-IPAMDataNetworkContainers

function Convert-CidrToBinary
{
    <#
        .SYNOPSIS
            Converts a CIDR formatted network into its binary representation
        .DESCRIPTION
            This function converts a CIDR formatted network into its binary representaion and only returns the network portion
        .PARAMETER CIDR
            This parameter is a standard CIDR formatted network address
        .EXAMPLE
            PS C:\> Convert-CidrToBinary -Cidr '10.156.72.0/24'
            000010101001110001001000
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [ValidatePattern('^(\d{1,3}.){3}\d{1,3}[\/]\d{1,2}$')]
        [string]
        $Cidr
    )

    #$NetMask = $Cidr.Split("/")[1]                               # Pull the NetworkMask part out of the CIDR
    $TempIP = ($Cidr.Split("/")[0]).Split(".")                   # Pull the NetworkAddress part out of the CIDR
    $IP1 = ([Convert]::ToString($TempIP[0], 2)).PadLeft(8, '0')  # Isolate the first octant fromt he network address, convert to binary and pad
    $IP2 = ([Convert]::ToString($TempIP[1], 2)).PadLeft(8, '0')  # Isolate the second octant fromt he network address, convert to binary and pad
    $IP3 = ([Convert]::ToString($TempIP[2], 2)).PadLeft(8, '0')  # Isolate the third octant fromt he network address, convert to binary and pad
    $IP4 = ([Convert]::ToString($TempIP[3], 2)).PadLeft(8, '0')  # Isolate the fourth octant fromt he network address, convert to binary and pad
    $BinaryIP = "$IP1$IP2$IP3$IP4"                               # Concatenate the binary for all 4 parts
    #$BinaryNetAddress = $BinaryIP.Substring(0,$NetMask)          # Pull out the portion that represents the Network Address part based on the SubnetMask value
    #$BinaryNetAddress
    $BinaryIP                                            # Return it
} # end function Convert-CidrToBinary

function Convert-IPToBinary
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [ValidatePattern('^(\d{1,3}.){3}\d{1,3}$')]
        [string]
        $IP
    )

    $TempIP = $IP.Split(".")                                     # Pull the NetworkAddress part out of the CIDR
    $IP1 = ([Convert]::ToString($TempIP[0], 2)).PadLeft(8, '0')  # Isolate the first octant fromt he network address, convert to binary and pad
    $IP2 = ([Convert]::ToString($TempIP[1], 2)).PadLeft(8, '0')  # Isolate the second octant fromt he network address, convert to binary and pad
    $IP3 = ([Convert]::ToString($TempIP[2], 2)).PadLeft(8, '0')  # Isolate the third octant fromt he network address, convert to binary and pad
    $IP4 = ([Convert]::ToString($TempIP[3], 2)).PadLeft(8, '0')  # Isolate the fourth octant fromt he network address, convert to binary and pad
    $BinaryIP = "$IP1$IP2$IP3$IP4"                               # Concatenate the binary for all 4 parts
    $BinaryIP                                                    # Return it
} # end function Convert-IPToBinary

function Get-ShortName
{
    Param([string]$Name)
    if($Name.Contains(".")) {
        $ShortName = $Name.Split(".")[0]
    } else {
        $ShortName = $Name
    }
    if($ShortName.Contains("(")) {
        $ShortName = $ShortName.Split("(")[0].TrimEnd()
    }
    $ShortName
}

function Compare-Cidr
{
    <#
        .SYNOPSIS
            Determines if one of the CIDR parameters is a subnet of the other.
        .DESCRIPTION
            This function returns true if one of the CIDR addresses passed into it is a subnet of the other CIDR address passed to it.  Parameter order does not matter.
        .PARAMETER CIDR1
            This parameter is a standard CIDR formatted network address
        .PARAMETER CIDR2
            This parameter is a standard CIDR formatted network address
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [ValidatePattern('^(\d{1,3}.){3}\d{1,3}[\/]\d{1,2}$')]
        [string]
        $Cidr1,

        [Parameter(
            Mandatory=$true
        )]
        [ValidatePattern('^(\d{1,3}.){3}\d{1,3}[\/]\d{1,2}$')]
        [string]
        $Cidr2
    )

    [int]$NetMask1 = $Cidr1.Split("/")[1]
    $BinAddress1 = Convert-CidrToBinary -Cidr $Cidr1

    [int]$NetMask2 = $Cidr2.Split("/")[1]
    $BinAddress2 = Convert-CidrToBinary -Cidr $Cidr2

    if($NetMask1 -lt $NetMask2)
    {
        if($BinAddress1 -eq $BinAddress2.SubString(0, $NetMask1))
        {
            return $true
        }  
        else
        {
            return $false
        } # end if
    }
    else
    {
        if($BinAddress2 -eq $BinAddress1.SubString(0, $NetMask2))
        {
            return $true
        }  
        else
        {
            return $false
        } # end if
    } # end if ($NetMask1 -lt $NetMask2)
} # end function Compare-Cidr

function Get-OrionNetworks
{
    param($IP_Addresses)

    $Networks = Get-DatabaseData -connectionString (Get-DBConnectionString) -query "select network,subnetbits,CIDRBinary from IBNetworks where Network_view = 'default'"

    $NetDict = @{}

    foreach($Network In $Networks)
    {
        $NetBin = $Network.CIDRBinary.Substring(0, $Network.subnetbits)
        if($NetDict.Keys -notcontains $NetBin) { $NetDict.Add($NetBin,$Network.network)}
    } # end foreach

    $Results = @{}

    foreach($IP in $IP_Addresses)
    {
        $NetworkEntry = 'Not Found'
        if($null -ne $IP -and $IP -ne "")
        {
            $IPBinary = Convert-IPToBinary -IP $IP
            for($i=32; $i -gt 7; $i--)
            { 
                $Key = $($IPBinary.Substring(0,$i))
                if($NetDict.Keys -contains $key)
                {
                    $NetworkEntry = $NetDict["$key"]
                    break
                } # end if
            } # end for
        } # end if

        if($Results.Keys -notcontains $IP) { $Results.Add($IP,$NetworkEntry) }
           
    } # end $Networks foreach loop
    $Results  
} # end function Get-OrionNetworks

function Invoke-DataCollection
{
    <#
        .SYNOPSIS
            Queries a Networking datasource and syncs the data to the database
        .DESCRIPTION
            This function queries one of the Networking datasources and inserts a new dataset into the database
        .PARAMETER SOURCE
            This parameter is used to specifiy which Networking datasource to query
        .EXAMPLE
            PS C:\> Invoke-DataCollection -Source 'orion'
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [ValidateSet("adsitelinks", "adsites", "adsubnets", "ibnetworks", "itam", "netmridevices", "netmricomponents", "orion", "netcollector")]
        [string]
        $Source
    ) # end param

    Import-Module ActiveDirctory -ErrorAction SilentlyContinue

    $ConnectionString = Get-DBConnectionString

    #region creds
    $secpasswd = ConvertTo-SecureString “************” -AsPlainText -Force
    $acred = New-Object System.Management.Automation.PSCredential (“!anthony.brown”, $secpasswd)
    $cred = New-Object System.Management.Automation.PSCredential (“anthony.brown”, $secpasswd)
    #endregion

    switch($Source)
    {
        "adsitelinks"
        {
            $DateTime = Get-Date            

            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set RecordStatus = 'historical' Where Source = '$Source'"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into H_$Source Select * From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into DataSets (RecordStatus,DateCollected,Source) values ('Active','$DateTime','$Source')"
            $DataSetID = (Get-DatabaseData -verbose -connectionString $ConnectionString -query "Select DataSetID From DataSets Where Source = '$Source' and RecordStatus = 'Active'").DataSetID

            # Collect from HQDomain
            $SiteLinks = Get-ADReplicationSiteLink -Filter * -Properties Created
            $SiteLinks | ForEach-Object {
                $TableName = 'ADSiteLinks'
                $Fields =  "DataSetID,Name,Created,Cost,ObjectGUID,Frequency,SitesIncluded,Domain"
                $Values =  "'$DataSetID','$($_.Name)','$($_.Created)','$($_.Cost)','$($_.ObjectGUID)','$($_.ReplicationFrequencyInMinutes)','$($_.SitesIncluded)','HQDomain'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $SiteLinks = $null

            # Collect from NEW_STERLING
            $SiteLinks = Get-ADReplicationSiteLink -Filter * -Properties Created -Server 'WPNPRDC1TN-VM'
            $SiteLinks | ForEach-Object {
                $TableName = 'ADSiteLinks'
                $Fields =  "DataSetID,Name,Created,Cost,ObjectGUID,Frequency,SitesIncluded,Domain"
                $Values =  "'$DataSetID','$($_.Name)','$($_.Created)','$($_.Cost)','$($_.ObjectGUID)','$($_.ReplicationFrequencyInMinutes)','$($_.SitesIncluded)','NEW_STERLING'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $SiteLinks = $null

            $Time = (Get-Date).Subtract($DateTime)
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set CollectionTime = '$($Time.ToString())' Where DataSetID = $DataSetID"
        } # end adsitelinks switch option

        "adsites"
        {
            $DateTime = Get-Date            

            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set RecordStatus = 'historical' Where Source = '$Source'"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into H_$Source Select * From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into DataSets (RecordStatus,DateCollected,Source) values ('Active','$DateTime','$Source')"
            $DataSetID = (Get-DatabaseData -verbose -connectionString $ConnectionString -query "Select DataSetID From DataSets Where Source = '$Source' and RecordStatus = 'Active'").DataSetID

            # Collect form HQDomain
            $Sites = Get-ADReplicationSite -Filter * -Properties Created
            $Sites | ForEach-Object {
                $TableName = 'ADSites'
                $Fields =  "DataSetID,Name,Created,Description,ObjectGUID,DN,Domain"
                $Values =  "'$DataSetID','$($_.Name)','$($_.Created)','$($_.Description)','$($_.ObjectGUID)','$($_.DistinguishedName)','HQDomain'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop   
            $Sites = $null   
            
            # Collect from NEW_STERLING
            $Sites = Get-ADReplicationSite -Filter * -Properties Created -Server 'WPNPRDC1TN-VM'
            $Sites | ForEach-Object {
                $TableName = 'ADSites'
                $Fields =  "DataSetID,Name,Created,Description,ObjectGUID,DN,Domain"
                $Values =  "'$DataSetID','$($_.Name)','$($_.Created)','$($_.Description)','$($_.ObjectGUID)','$($_.DistinguishedName)','NEW_STERLING'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop   
            $Sites = $null   
              
            $Time = (Get-Date).Subtract($DateTime)
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set CollectionTime = '$($Time.ToString())' Where DataSetID = $DataSetID"
        } # end adsites switch option

        "adsubnets"
        {
            $DateTime = Get-Date            

            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set RecordStatus = 'historical' Where Source = '$Source'"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into H_$Source Select * From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into DataSets (RecordStatus,DateCollected,Source) values ('Active','$DateTime','$Source')"
            $DataSetID = (Get-DatabaseData -verbose -connectionString $ConnectionString -query "Select DataSetID From DataSets Where Source = '$Source' and RecordStatus = 'Active'").DataSetID

            # Collect from HQDomain
            $Subnets = Get-ADReplicationSubnet -Filter * -Properties Created
            $Subnets | ForEach-Object {
                $TableName = 'ADSubnets'
                $Fields =  "DataSetID,Name,Created,Location,ObjectGUID,CIDRBinary,SubnetBits,Site,Domain"
                $Values =  "'$DataSetID','$($_.Name)','$($_.Created)','$($_.Location)','$($_.ObjectGUID)','$(Convert-CidrToBinary -Cidr $_.Name)','$($_.Name.Split("/")[1])','$($_.Site)','HQDomain'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $Subnets = $null 

            # Collect from NEW_STERLING
            $Subnets = Get-ADReplicationSubnet -Filter * -Properties Created -Server 'WPNPRDC1TN-VM'
            $Subnets | ForEach-Object {
                $TableName = 'ADSubnets'
                $Fields =  "DataSetID,Name,Created,Location,ObjectGUID,CIDRBinary,SubnetBits,Site,Domain"
                $Values =  "'$DataSetID','$($_.Name)','$($_.Created)','$($_.Location)','$($_.ObjectGUID)','$(Convert-CidrToBinary -Cidr $_.Name)','$($_.Name.Split("/")[1])','$($_.Site)','NEW_STERLING'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $Subnets = $null 

            $Time = (Get-Date).Subtract($DateTime)
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set CollectionTime = '$($Time.ToString())' Where DataSetID = $DataSetID"                   
        } # end adsubnets switch option

        "ibnetworks"
        {
            $DateTime = Get-Date
            $IBNetworks = Get-IPAMDataNetworks -Cred $acred

            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set RecordStatus = 'historical' Where Source = '$Source'"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into H_$Source Select * From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into DataSets (RecordStatus,DateCollected,Source) values ('Active','$DateTime','$Source')"
            $DataSetID = (Get-DatabaseData -verbose -connectionString $ConnectionString -query "Select DataSetID From DataSets Where Source = '$Source' and RecordStatus = 'Active'").DataSetID

            $IBNetworks | ForEach-Object {
                [string]$comment = $_.comment
                $comment = $comment.Replace("'", "''")
                $TableName = 'IBNetworks'
                $Fields =  "DataSetID,EntryType,ref,network_view,network_container,network,itam,conflict,country,region,city,site,env,zone,vlan,sz,comment,type,fxn,host_device,interface,CIDRBinary,SubnetBits"
                $Values =  "'$DataSetID','Network','$($_.ref)','$($_.network_view)','$($_.network_container)','$($_.network)','$($_.itam)','$($_.conflict)','$($_.country)','$($_.region)','$($_.city)','$($_.site)','$($_.env)','$($_.zone)','$($_.vlan)','$($_.sz)','$comment','$($_.type)','$($_.fxn)','$($_.host_device)','$($_.interface)','$(Convert-CidrToBinary -Cidr $_.Network)','$($_.Network.Split("/")[1])'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $IBNetworks = $null

            $IBNetworkContainers = Get-IPAMDataNetworkContainers -Cred $cred

            $IBNetworkContainers | ForEach-Object {
                [string]$comment = $_.comment
                $comment = $comment.Replace("'", "''")
                $TableName = 'IBNetworks'
                $Fields =  "DataSetID,EntryType,ref,network_view,network_container,network,itam,conflict,country,region,city,site,env,zone,vlan,sz,comment,type,fxn,host_device,interface,CIDRBinary,SubnetBits"
                $Values =  "'$DataSetID','Container','$($_.ref)','$($_.network_view)','$($_.network_container)','$($_.network)','$($_.itam)','$($_.conflict)','$($_.country)','$($_.region)','$($_.city)','$($_.site)','$($_.env)','$($_.zone)','$($_.vlan)','$($_.sz)','$comment','$($_.type)','$($_.fxn)','$($_.host_device)','$($_.interface)','$(Convert-CidrToBinary -Cidr $_.Network)','$($_.Network.Split("/")[1])'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $IBNetworkContainers =  $null 
            $Time = (Get-Date).Subtract($DateTime)
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set CollectionTime = '$($Time.ToString())' Where DataSetID = $DataSetID"     
        } # end ibnetworks switch option

        "itam"
        {
            $DateTime = Get-Date
            $ITAMData = Get-ITAMNetworkData

            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set RecordStatus = 'historical' Where Source = '$Source'"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into H_$Source Select * From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into DataSets (RecordStatus,DateCollected,Source) values ('Active','$DateTime','$Source')"
            $DataSetID = (Get-DatabaseData -verbose -connectionString $ConnectionString -query "Select DataSetID From DataSets Where Source = '$Source' and RecordStatus = 'Active'").DataSetID

            $ITAMData| ForEach-Object {
                $TableName = 'ITAM'
                $Fields =  "DataSetID,display_name,install_status,ci,serial_number,u_asset_name,location"
                $Values =  "'$DataSetID','$($_.display_name)','$($_.install_status)','$($_.ci)','$($_.serial_number)','$($_.u_asset_name)','$($_.location)'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $ITAMData = $null 
            $Time = (Get-Date).Subtract($DateTime)
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set CollectionTime = '$($Time.ToString())' Where DataSetID = $DataSetID"                   
        } # end itam switch option

        "netmridevices"
        {
            $DateTime = Get-Date
            $NetMRIData = Get-NetMRIDevices -Cred $aCred

            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set RecordStatus = 'historical' Where Source = '$Source'"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into H_$Source Select * From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into DataSets (RecordStatus,DateCollected,Source) values ('Active','$DateTime','$Source')"
            $DataSetID = (Get-DatabaseData -verbose -connectionString $ConnectionString -query "Select DataSetID From DataSets Where Source = '$Source' and RecordStatus = 'Active'").DataSetID

            $NetMRIData| ForEach-Object {
                $ShortName = Get-ShortName -Name $_.DeviceName
                $TableName = 'NetMRIDevices'
                $Fields =  "DataSetID,DeviceID,DeviceFirstOccurrenceTime,DeviceIPDotted,DeviceMAC,DeviceModel,DeviceName,DeviceStartTime,DeviceSysContact,DeviceSysDescr,DeviceSysLocation,DeviceSysName,DeviceTimestamp,DeviceType,DeviceVendor,DeviceVersion,ShortName"
                $Values =  "'$DataSetID','$($_.DeviceID)','$($_.DeviceFirstOccurrenceTime)','$($_.DeviceIPDotted)','$($_.DeviceMAC)','$($_.DeviceModel)','$($_.DeviceName)','$($_.DeviceStartTime)','$($_.DeviceSysContact)','$($_.DeviceSysDescr)','$($_.DeviceSysLocation)','$($_.DeviceSysName)','$($_.DeviceTimestamp)','$($_.DeviceType)','$($_.DeviceVendor)','$($_.DeviceVersion)','$ShortName'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $NetMRIData = $null   
            $Time = (Get-Date).Subtract($DateTime)
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set CollectionTime = '$($Time.ToString())' Where DataSetID = $DataSetID"                  
        } # end netmridevices switch option

        "netmricomponents"
        {

            $DateTime = Get-Date

            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set RecordStatus = 'historical' Where Source = '$Source'"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From H_$Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into H_$Source Select * From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into DataSets (RecordStatus,DateCollected,Source) values ('Active','$DateTime','$Source')"
            $DataSetID = (Get-DatabaseData -verbose -connectionString $ConnectionString -query "Select DataSetID From DataSets Where Source = '$Source' and RecordStatus = 'Active'").DataSetID

            $Start = 0
            $Limit = 2000

            $SelectString = "DeviceID,DevicePhysicalID,PhysicalAlias,PhysicalAssetID,PhysicalClass,PhysicalContainedIn,PhysicalDescr,PhysicalEndTime,PhysicalFirmwareRev,PhysicalHardwareRev,PhysicalIndex,PhysicalMfgName,PhysicalModelName,PhysicalName,PhysicalParentRelPos,PhysicalSerialNum,PhysicalSoftwareRev,PhysicalStartTime,PhysicalTimestamp,PhysicalVendorType,UnitState"            

            Try
            {
                # We are required to make a Rest Call to the authenticate module first in order to authenticate the session for subsequent calls.
                # The WebSession is stored as $MySession
                # The NetMRI does not support passing a PSCredential object normally used in Invoke-RestMethod, instead you have to break out the username and password explictly
                Invoke-RestMethod -Method Get -Uri "http://<netmri_url>/api/2.10/authenticate.json?username=$($aCred.UserName)&password=$($aCred.GetNetworkCredential().password)" -SessionVariable MySession
                $First = $true
                do
                {           
                    $Uri = "http://<netmri_url>/api/2.10/device_physicals/index?start=$Start&limit=$Limit&select=$SelectString"  # The base URI for the NetMRI WAPI REST interface
                    $TempResult = Invoke-RestMethod -Method Get -Uri "$Uri" -WebSession $MySession

                    Write-Verbose "$Start of $($TempResult.total)"     

                    if($First)
                    {
                        $Start = ($TempResult.current) + 1
                        $First = $false
                    }
                    else
                    {
                        $Start += $Limit
                    }
                    $Results += Format-NetMRIDeviceComponentObject -Data $TempResult.device_physicals  
                    $Results = $Results | Where-Object { ($_ | Get-Member | Measure-Object | Select-Object -ExpandProperty Count) -gt 4 }  
                                
                    $Results| ForEach-Object {
                        $TableName = 'NetMRIComponents'
                        $Fields =  "DataSetID,DeviceID,DevicePhysicalID,PhysicalAlias,PhysicalAssetID,PhysicalClass,PhysicalContainedIn,PhysicalDescr,PhysicalEndTime,PhysicalFirmwareRev,PhysicalHardwareRev,PhysicalIndex,PhysicalMfgName,PhysicalModelName,PhysicalName,PhysicalParentRelPos,PhysicalSerialNum,PhysicalSoftwareRev,PhysicalStartTime,PhysicalTimestamp,PhysicalVendorType,UnitState"
                        $Values =  "'$DataSetID','$($_.DeviceID)','$($_.DevicePhysicalID)','$($_.PhysicalAlias)','$($_.PhysicalAssetID)','$($_.PhysicalClass)','$($_.PhysicalContainedIn)','$($_.PhysicalDescr)','$($_.PhysicalEndTime)','$($_.PhysicalFirmwareRev)','$($_.PhysicalHardwareRev)','$($_.PhysicalIndex)','$($_.PhysicalMfgName)','$($_.PhysicalModelName)','$($_.PhysicalName)','$($_.PhysicalParentRelPos)','$($_.PhysicalSerialNum)','$($_.PhysicalSoftwareRev)','$($_.PhysicalStartTime)','$($_.PhysicalTimestamp)','$($_.PhysicalVendorType)','$($_.UnitState)'"
                        $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
                    }
                    $Results = $null  
                                   
                } # End do loop
                Until($Start -gt $TempResult.total)

            }
            Catch
            {
                Throw "Error retrieving data: $_"
            } # End Try
            $Time = (Get-Date).Subtract($DateTime)
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set CollectionTime = '$($Time.ToString())' Where DataSetID = $DataSetID"
        
        } # end netmricomponents switch option

        "orion"
        {
            $DateTime = Get-Date
            $OrionData = Get-OrionNodes -Cred $Cred

            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set RecordStatus = 'historical' Where Source = '$Source'"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into H_$Source Select * From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Delete From $Source"
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into DataSets (RecordStatus,DateCollected,Source) values ('Active','$DateTime','$Source')"
            $DataSetID = (Get-DatabaseData -verbose -connectionString $ConnectionString -query "Select DataSetID From DataSets Where Source = '$Source' and RecordStatus = 'Active'").DataSetID

            $NetDict = Get-OrionNetworks -IP_Addresses $OrionData.IP_Address

            $OrionData| ForEach-Object {
                [string]$StatusDescription = $_.StatusDescription
                $StatusDescription = $StatusDescription.Replace("'", "''")
                $ShortName = Get-ShortName -Name $_.NodeName

                if($null -ne $_.IP_Address -and $_.IP_Address -ne "")
                {
                    $Network = $NetDict["$($_.IP_Address)"]
                }
                else 
                {
                    $Network = 'NA'
                } # end if

                $TableName = 'Orion'
                $Fields =  "DataSetID,NodeID,NodeName,SysName,IP_Address,Caption,Contact,Location,Description,MachineType,Manufacturer,Model,ServiceTag,NodeDescription,StatusDescription,Vendor,IOSImage,IOSVersion,Alert,BusinessLine,CustomRole,CustomVendor,Imported_From_NCM,Region,ShortName,Network"
                $Values =  "'$DataSetID','$($_.NodeID)','$($_.NodeName)','$($_.SysName)','$($_.IP_Address)','$($_.Caption)','$($_.Contact)','$($_.Location)','$($_.Description)','$($_.MachineType)','$($_.Manufacturer)','$($_.Model)','$($_.ServiceTag)','$($_.NodeDescription)','$($StatusDescription)','$($_.Vendor)','$($_.IOSImage)','$($_.IOSVersion)','$($_.Alert)','$($_.BusinessLine)','$($_.CustomRole)','$($_.CustomVendor)','$($_.Imported_From_NCM)','$($_.Region)','$ShortName','$Network'"
                $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Insert Into $TableName ($Fields) values ($Values)"
            } # End Loop
            $OrionData = $null 
            $Time = (Get-Date).Subtract($DateTime)
            $null = Invoke-DatabaseQuery -connectionString $ConnectionString -query "Update DataSets Set CollectionTime = '$($Time.ToString())' Where DataSetID = $DataSetID"
        } # end orion switch option
    } # end switch
} # end function Invoke-DataCollection

function Invoke-DataBaseCleanup
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true
        )]
        [int]
        $DaysOld,

        [switch]
        $Force
    )
    Process
    {
        [datetime]$OlderThanDate = (get-date).AddDays(-($DaysOld))
        $DataSetIDs = Get-DatabaseData -connectionString (Get-DBConnectionString) -query "Select DataSetID From DataSets Where RecordStatus = 'historical' and DateCollected <= '$($OlderThanDate.ToString('MM/dd/yyyy'))'"
        $DataSetIDs.DataSetID | ForEach-Object { 
            if($Force -or $PSCmdlet.ShouldContinue("Do you want to delete DataSetID?: $_", 'Delete DataSet')) 
            {
                $null = Invoke-DatabaseQuery -connectionString (Get-DBConnectionString) -query "exec DeleteDataSet $_"
            } # End if
        } # End Loop
    } # End Process
} # end function Invoke-DataBaseCleanup

function Invoke-FullDataCollection
{
    Invoke-DataCollection -Source adsitelinks
    Invoke-DataCollection -Source adsites
    Invoke-DataCollection -Source adsubnets
    Invoke-DataCollection -Source ibnetworks
    Invoke-DataCollection -Source itam
    Invoke-DataCollection -Source orion
    #Invoke-DataCollection -Source netmridevices
    #Invoke-DataCollection -Source netmricomponents

} # end function Invoke-FullDataCollection



Export-ModuleMember -Function Compare-Cidr
Export-ModuleMember -Function Convert-CidrToBinary
Export-ModuleMember -Function Get-IPAMDataNetworkContainers
Export-ModuleMember -Function Get-IPAMDataNetworks
Export-ModuleMember -Function Get-OrionNodes
Export-ModuleMember -Function Get-NetMRIDevices
Export-ModuleMember -Function Get-NetMRIDeviceComponents
Export-ModuleMember -Function Get-ITAMNetworkData
Export-ModuleMember -Function Invoke-DataCollection
Export-ModuleMember -Function Invoke-DataBaseCleanup
Export-ModuleMember -Function Invoke-FullDataCollection
