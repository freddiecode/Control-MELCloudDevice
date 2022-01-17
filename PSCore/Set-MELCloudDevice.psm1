function Set-MELCloudDevice {
<#
.Synopsis
   Allows you to set different settings on your MELCloud device
     
.EXAMPLE
   Set-MELCloudDevice -DeviceID <DeviceID> -ContextKey <YourContextKey> -Temperature <10-31 degrees celsius> -FanSpeed <"1" to "5"> -VaneHorizontal <"1" to "5"> -VaneVertical <"1" to "5">`
   -Mode <"Heating" or "Cooling"> -HorizontalSwing<"On" or "Off"> -VerticalSwing <"On" or "Off">
    
   ContextKey can be found by using the "Get-MELCloudContextKey" function
   DeviceID can be found by using the "Get-MELCloudDevices" function

.INPUTS
   DeviceID                      
   ContextKey          
   Temperature         
   FanSpeed            
   VaneHorizontal      
   VaneVertical        
   Mode          
   HorizontalSwing     
   VerticalSwing

.OUTPUTS
   Writes current Power, Temperature, FanSpeed, OperationMode, VaneHorizontal and VaneVertical settings to the console
      
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
        ValueFromPipeline = $False,
        HelpMessage = "Enter your DeviceID)")]
        [Alias('DevID')]
        [string[]]$DeviceID,


        [Parameter(Mandatory = $True,
        ValueFromPipeline = $False,
        HelpMessage = "Enter your ContextKey")]
        [Alias('CT')]
        [string[]]$ContextKey,

        [Parameter(Mandatory = $True,
        ValueFromPipeline = $False,
        HelpMessage = "Select your Mode)")]
        [ValidateSet ('Heating','Cooling', ignorecase=$True)]
        [Alias('ModeSelect')]
        [string[]]$Mode,

        [Parameter(Mandatory = $True,
        ValueFromPipeline = $False,
        HelpMessage = "Enter your desired temperature")]
        [ValidateRange (10,31)]
        [Alias('Temp')]
        [string[]]$Temperature,

        [Parameter(Mandatory = $True,
        ValueFromPipeline = $False,
        HelpMessage = "Set fan speed")]
        [ValidateRange (1,5)]
        [Alias('Fan')]
        [int[]]$FanSpeed,

        [Parameter(Mandatory = $False,
        ValueFromPipeline = $False)]
        [ValidateRange (1,5)]
        [Alias('VaneHorizon')]
        [string[]]$VaneHorizontal,

        [Parameter(Mandatory = $False,
        ValueFromPipeline = $False)]
        [ValidateRange (1,5)]
        [Alias('VaneVert')]
        [string[]]$VaneVertical,

        [Parameter(Mandatory = $False,
        ValueFromPipeline = $False)]
        [ValidateSet ('On','Off', ignorecase=$True)]
        [Alias('HorizonSwing')]
        [string[]]$HorizontalSwing,

        [Parameter(Mandatory = $False,
        ValueFromPipeline = $False)]
        [ValidateSet ('On','Off', ignorecase=$True)]
        [Alias('VertSwing')]
        [string[]]$VerticalSwing

)

BEGIN {}


PROCESS {

        try {

        #OperationMode 1 = Heating | OperationMode 3 = Cooling
        if ($Mode -eq "Heating") {$ModeSetting = "1"}
        else {$ModeSetting = "3"}
        
        if ($HorizontalSwing -eq "On") {$VaneHorizontal = "12"}
        else {}

        if ($VerticalSwing -eq "On") {$VaneVertical = "7"}
        else {}


        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $URL = "https://app.melcloud.com/Mitsubishi.Wifi.Client/Device/SetAta"

        $ContentType ="application/json; charset=UTF-8"

        $Header = @{

        "X-MitsContextKey"= "$ContextKey"
        "Sec-Fetch-Site"="same-origin"
        "Origin"="https://app.melcloud.com"
        "Accept-Encoding"="gzip, deflate, br"
        "Accept-Language"="nb-NO,nb;q=0.9,no;q=0.8,nn;q=0.7,en-US;q=0.6,en;q=0.5"
        "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"
        "Sec-Fetch-Mode"="cors"; "Accept"="application/json, text/javascript, */*; q=0.01"
        "Referer"="https://app.melcloud.com/"
        "X-Requested-With"="XMLHttpRequest"
        "Cookie"="policyaccepted=true"
        
        }
        
        $Body = @{
        
        EffectiveFlags = '14'
        LocalIPAddress = 'null'
        RoomTemperature = '18'
        SetTemperature = "$Temperature"
        SetFanSpeed = "$FanSpeed"
        OperationMode = "$ModeSetting"
        VaneHorizontal = "$VaneHorizontal"
        VaneVertical = "$VaneVertical"
        Name = 'null'
        NumberOfFanSpeeds = '5'
        WeatherObservations = @(
        'Date = 2019-10-28T18:00:00',
        'Sunrise = 2019-10-28T07:30:00',
        'Sunset = 2019-10-28T16:28:00',
        'Condition = 116',
        'ID = 235253258',
        'Humidity =66',
        'Temperature = 1',
        'Icon = wsymbol_0008_clear_sky_night',
        'ConditionName = Delvis skyet',
        'Day = 1',
        'WeatherType = 0',
        'Date = 2019-10-29T03:00:00',
        'Sunrise = 2019-10-29T07:33:00',
        'Sunset = 2019-10-29T16:25:00',
        'Condition = 116',
        'ID = 235621797',
        'Humidity = 72',
        'Temperature = -3',
        'Icon = wsymbol_0008_clear_sky_night',
        'ConditionName = Delvis skyet',
        'Day = 1',
        'WeatherType = 2',
        'Date = 2019-10-29T15:00:00',
        'Sunrise = 2019-10-29T07:33:00',
        'Sunset = 2019-10-29T16:25:00',
        'Condition = 116',
        'ID = 235621801',
        'Humidity = 55',
        'Temperature = 1',
        'Icon = wsymbol_0002_sunny_intervals',
        'ConditionName = Delvis skyet',
        'Day = 2',
        'WeatherType = 1',
        'Date = 2019-10-30T03:00:00',
        'Sunrise = 2019-10-30T07:35:00',
        'Sunset = 2019-10-30T16:22:00',
        'Condition = 116',
        'ID = 235986677',
        'Humidity = 66',
        'Temperature = -3',
        'Icon = wsymbol_0008_clear_sky_night',
        'ConditionName = Delvis skyet',
        'Day = 2',
        'WeatherType = 2')
        ErrorMessage = 'null'
        ErrorCode = '8000'
        DefaultHeatingSeterature = '21'
        DefaultCoolingSetTemperature = '21'
        HideVaneControls = 'false'
        HideDryModeControl = 'false'
        RoomTemperatureLabel = '0'
        InStandbyMode = 'false'
        TemperatureIncrementOverride = '0'
        ProhibitSetTemperature ='false'
        ProhibitOperationMode = 'false'
        ProhibitPower = 'false'
        DeviceID = "$DeviceID"
        DeviceType = '0'
        LastCommunication = "$(Get-Date -Format s)"
        NextCommunication = "$((Get-Date).AddMinutes(1).ToString("yyyy-MM-ddTHH:mm:ss"))"
        Power = 'true'
        HasPendingCommand = 'true'
        Offline = 'false'
        Scene = 'null'
        SceneOwner = 'null'
        
        } | ConvertTo-Json

        
        $Set = Invoke-RestMethod -Uri $URL -Headers $Header -ContentType $ContentType -Body $Body -Method POST
        $Set | ConvertFrom-Json | Select-Object Power, SetTemperature, SetFanSpeed, OperationMode, VaneHorizontal, VaneVertical | Format-Table -AutoSize

        }

        catch {


        Write-Error "An unexpected error occurred. Please try again." -Category ConnectionError


        }

}

END {}
        


}
