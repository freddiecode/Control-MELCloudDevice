function Get-MELCloudDeviceInfo {
<#
.Synopsis
   Will list technical information about each of your MELCloudDevice(es).  
.EXAMPLE
   Get-MELCloudDeviceInfo -ContextKey <Your_ContextKey>
.INPUTS
   ContextKey
.OUTPUTS
   DeviceType                   : 0
   CanCool                      : True
   CanHeat                      : True
   CanDry                       : True
   HasAutomaticFanSpeed         : True
   AirDirectionFunction         : True
   SwingFunction                : True
   NumberOfFanSpeeds            : 5
   UseTemperatureA              : True
   TemperatureIncrementOverride : 0
   TemperatureIncrement         : 0,5
   MinTempCoolDry               : 16,0
   MaxTempCoolDry               : 31,0
   MinTempHeat                  : 10,0
   MaxTempHeat                  : 31,0
   MinTempAutomatic             : 16,0
   MaxTempAutomatic             : 31,0
   LegacyDevice                 : False
   UnitSupportsStandbyMode      : True
   HasWideVane                  : False

   /The output has been cut off due to large output/
   
.NOTES
   Author:     Freddie Christiansen
   Website:    https://www.cloudpilot.no
   LinkedIn:   https://www.linkedin.com/in/freddie-christiansen-64305b106
.LINK
   https://www.cloudpilot.no/blog/Control-your-Mitsubishi-heat-pump-using-PowerShell/
#>
    [CmdletBinding()]

param(
  
    [Parameter(Mandatory = $True, 
    ValueFromPipeline = $True, 
    HelpMessage = "Enter your ContextKey")]
    [Alias('CT')]
    [string[]]$ContextKey

)

BEGIN {}



PROCESS {



        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = "https://app.melcloud.com/Mitsubishi.Wifi.Client/User/ListDevices"


        $Header = @{ 
        
        "Accept"="application/json, text/javascript, */*; q=0.01"
        "Referer"="https://app.melcloud.com/"
        "X-MitsContextKey"="$ContextKey"
        "X-Requested-With"="XMLHttpRequest"
        "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"
        "Sec-Fetch-Mode"="cors"
        
        }
        
        

        
    try {

       $Dev = Invoke-WebRequest -Uri $Uri -Headers $Header -Method GET

       $Info =  $Dev.Content | ConvertFrom-Json | ConvertTo-Json -Depth 6 | ConvertFrom-Json
       
       $DevInfo =  $Dev.Content | ConvertFrom-Json | ConvertTo-Json -Depth 6 | ConvertFrom-Json
       

    }

    catch {
    
    Write-Error "An unexpected error occurred. Please try again." -Category ConnectionError
    
    }

       
 }



END {

    
    $DevInfo.value.Structure.Devices.Device | Select-Object * -ExcludeProperty ListHistory24Formatters
    

}


}