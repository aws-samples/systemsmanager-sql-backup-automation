
Import-Module SQLPS -DisableNameChecking
$hostname = [System.Net.Dns]::GetHostName()
$backupDir = "Z:\Backups"
New-Item -Path $backupDir -ItemType Directory
Set-Location SQLSERVER:\SQL\$hostname

foreach ($item in (Get-ChildItem))
{
   Write-Output "Running Backup for all the databases on $item Instance"
   $SQLINSTNAME = $item -replace '\[','' -replace '\]',''
   Set-Location SQLSERVER:\SQL\$SQLINSTNAME\Databases
   foreach ($dbs in (Get-ChildItem))
    {
            $dbname = $dbs.Name
            $backupFileName = "FullBackup-{0}-{1}.bak" -f [DateTime]::Now.ToString("yyyy-MM-dd"), $dbname
            $backupFilePath = "{1}\{0}" -f $backupFileName, $backupDir
            try {
                  Backup-SqlDatabase -Database $dbname -BackupFile $backupFilePath
                  Write-Output "$dbname backup completed" 
                }
            catch
            {
              "$dbname is Secondary Replica, backup not possible"
            }
    }
}
 