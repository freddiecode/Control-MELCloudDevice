function Get-MELCloudContextKey {
<#
.Synopsis
   Use this cmdlet to retrieve your API-key (named $ContextKey) needed to authenticate against the MELCloud API
    
.INPUTS
   Your MELCloud username (email address)
   Your MELCloud password

.EXAMPLE
   Get-MelCloudContextKey -Credentials <Your username/email>

.OUTPUT
   ContextKey                      RegistredOwner        CountryName LanguageCode
   ----------                      --------------        ----------- ------------
   <12345678912345678912345678912>  <FirstName LastName>    <Norway>   <no>          

   Hint: Copy the ContextKey into a variable for further use. I.E: $Key = <YourAPIKey>.
         Then, use the $Key variable when passing HTTP-request to the API.
.NOTES
   Author:     Freddie Christiansen
   Website:    https://www.cloudpilot.no
   LinkedIn:   https://www.linkedin.com/in/freddie-christiansen-64305b106

.LINK
   https://www.cloudpilot.no/blog/Control-your-Mitsubishi-heat-pump-using-PowerShell/
#>
    [CmdletBinding()]

param(
  

     [Parameter(Mandatory = $True)]   
     [ValidateNotNull()]
     [System.Management.Automation.PSCredential]
     [System.Management.Automation.Credential()]
     $Credential = [System.Management.Automation.PSCredential]::Empty
    
        
)

BEGIN {}



PROCESS {


        $Username = $Credential.UserName
        $Password = $Credential.GetNetworkCredential().Password      

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = "https://app.melcloud.com/Mitsubishi.Wifi.Client/Login/ClientLogin"

        $ContentType = "application/json; charset=UTF-8"

        $Body = @{
    
        "Email" = "$Username"
        "Password" = "$Password"
        Language = '13'
        AppVersion = '1.18.5.1'
        Persist = 'True'
        CaptchaResponse = ''


        } | ConvertTo-Json



        $Header = @{

           
         "Accept" = "application/json, text/javascript, */*; q=0.01"
         "Referer" = "https://app.melcloud.com/"
         "Origin" = "https://app.melcloud.com"
         "X-Requested-With" = "XMLHttpRequest"
         "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"
         "Sec-Fetch-Mode" = "cors"


        }

        


    
        $LoginData = Invoke-WebRequest -Method POST -Uri $Uri -Body $Body -Headers $Header -ContentType $ContentType
        $Logon = $LoginData.Content | ConvertFrom-Json


        foreach ( $item in $Logon ) {

        $Settings = $item | Select-Object -Property *

        try {

            $Properties = @{

                ContextKey = $Settings.LoginData.ContextKey
                RegistredOwner = $Settings.LoginData.Name
                LanguageCode = $Settings.LoginData.LanguageCode
                CountryName = $Settings.LoginData.CountryName
              

                }

            $obj = New-Object -TypeName PSObject -Property $Properties

            Write-Output $obj

            
            
                }


        catch {

                    Write-Warning "An unexpected error occurred. Please try again."

                
                
              }
        

      }

      
}

    

END {}


}


           