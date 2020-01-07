function Start-MELCloudDevice {
<#
.Synopsis
   Start your selected MELCloud device  
.EXAMPLE
   Start-MELCloudDevice -DeviceID <DeviceID> -ContextKey <Your_ContextKey>

   ContextKey can be found by using the "Get-MELCloudContextKey" function
   DeviceID can be found by using the "List-MELCLoudDevices" function
.INPUTS
   ContextKey
   DeviceID
.OUTPUTS
   If successful, write the current Power, Temperature and FanSpeed to the console
   The default Temperature is set to 20 degrees celsius and a FanSpeed of 2.     
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
        [string[]]$ContextKey

)


PROCESS {

    try {
        

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = "https://app.melcloud.com/Mitsubishi.Wifi.Client/Device/SetAta"

        $ContentType ="application/json; charset=UTF-8"

        $Header = @{

        "X-MitsContextKey"="$ContextKey"
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

        EffectiveFlags = '1'
        LocalIPAddress = 'null'
        RoomTemperature = '19.5'
        SetTemperature = "20"
        SetFanSpeed = '2'
        #OperationMode 1 = Heating
        #OperationMode 3 = Cooling
        OperationMode = '1'
        VaneHorizontal = '8'
        VaneVertical = '2'
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
        DefaultHeatingSeterature = 'null'
        DefaultCoolingSetTemperature = '20'
        HideVaneControls = 'false'
        HideDryModeControl = 'false'
        RoomTemperatureLabel = '0'
        InStandbyMode = 'false'
        TemperatureIncrementOverride = '0'
        ProhibitSetTemperature ='false'
        ProhibitOperationMode = 'true'
        ProhibitPower = 'false'
        DeviceID = "$DeviceID"
        DeviceType = '0'
        LastCommunication = "$(Get-Date -Format s)"
        NextCommunication = "$((Get-Date).AddMinutes(1).ToString("yyy-MM-ddTHH:mm:ss"))"
        Power = 'True'
        HasPendingCommand = 'true'
        Offline = 'false'
        Scene = 'null'
        SceneOwner = 'null'

        
        } | ConvertTo-Json


    
        $Start = Invoke-WebRequest -Uri $Uri -Headers $Header -ContentType $ContentType -Body $Body -Method POST

        Write-Host "Starting up your selected device.." -ForegroundColor Yellow
        
        $Start | ConvertFrom-Json | select Power, SetTemperature, SetFanSpeed

    }

    catch {
    
        Write-Warning "An unexpected error occurred. Please verify your DeviceID and ContextKey and try again." 
    
    }

 }
        

}