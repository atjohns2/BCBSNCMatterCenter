# Get the current directory of the script
Function ScriptRoot {Split-Path $MyInvocation.ScriptName}
$ScriptDirectory = (ScriptRoot)

# Function is used to read values from Excel file
Function Read-FromExcel([string]$ExcelFilePath,[string] $SheetName, [string[]]$Value, [string]$LogFilePath){
      try
      {
          $temp = ""          
          $Assembly = [Reflection.Assembly]::LoadFile(“C:\NewMatterCenter\tree\master\cloud\src\deployments\Scripts\Helper Utilities\Microsoft.Legal.MatterCenter.Common.dll”)
          $excelValues = [Microsoft.Legal.MatterCenter.Common.ExcelOperations]::ReadFromExcel($ExcelFilePath,$SheetName)
          for($i = 0; $i -lt $Value.Length; $i++){
              if($i -ne 0) {
                   $temp += ";"
               }
              $temp += $excelValues.Item($Value[$i])
          }
          return $temp
      }
      catch
      {
            $ErrorMessage = $Error[0].Exception.ErrorRecord.Exception.Message                             
            Write-Log $LogFilePath $ErrorMessage
            return $false
      }
}

Function ReadSheet-FromExcel([string]$ExcelFilePath,[string] $SheetName, [string]$LogFilePath){
       try{
           $temp = ""          
           $Assembly = [Reflection.Assembly]::LoadFile(“C:\NewMatterCenter\tree\master\cloud\src\deployments\Scripts\Helper Utilities\Microsoft.Legal.MatterCenter.Common.dll”)
           $excelValues = [Microsoft.Legal.MatterCenter.Common.ExcelOperations]::ReadSheet($ExcelFilePath,$SheetName)
           return $excelValues
          }
      catch
      {
            $ErrorMessage = $Error[0].Exception.ErrorRecord.Exception.Message                             
            Write-Log $LogFilePath $ErrorMessage
            return $false
      }
}

# Function is used to write to log file
Function Write-Log() 
{
    param(
        
        [parameter(Mandatory=$false)]            
        [ValidateNotNullOrEmpty()] 
        [string] $ErrorLogFilePath
        
       ,[parameter(Mandatory=$true)]            
        [ValidateNotNullOrEmpty()] 
        [string] $ErrorMessage

        )

    Write-Host $ErrorMessage -ForegroundColor Red
    ($ErrorMessage + " occurred at" + (Get-Date -format "dd-MMM-yyyy HH:mm")) | Out-File $ErrorLogFilePath -Append
}

Function Show-Message([string] $Message, [string] $Type, [bool] $Newline = $true)
{
	$timestamp = Get-Date -Format G
	$Message = $timestamp + " - " + $Message
    switch ($Type)
    {
        ([MessageType]::Success)
        { 
        if($Newline) {
            Write-Host $Message -ForegroundColor Green
           }
           else {
            Write-Host $Message -ForegroundColor Green -NoNewline
           }
        }
        ([MessageType]::Warning) 
        { 
            if($Newline) {
                Write-Host $Message -ForegroundColor Yellow     
            }
            else {
                Write-Host $Message -ForegroundColor Yellow -NoNewline
            }
        }
        ([MessageType]::Failure)
        {
            if($Newline) { 
                Write-Host $Message -ForegroundColor Red 
            }
            else {
                Write-Host $Message -ForegroundColor Red -NoNewline
            }
        }
        Default { Write-Host $Message -ForegroundColor White }
    }
	# Write into log file
	if(-not [String]::IsNullOrEmpty($Message)) {
		#($Message) | Out-File $LogFile -Append
	}
}