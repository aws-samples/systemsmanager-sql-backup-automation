
$backupDir = "Z:\Backups"
$Bucket="sql-backup-auto-blog-test"
$Bucket_Prefix='Backup'
$Filespec='*.bak'


$Files = Get-ChildItem -Path $backupDir -Name $Filespec

foreach ($file in $Files)
{
  Write-S3Object -BucketName $Bucket -File ($backupDir + "\" + $file) -Key ($Bucket_Prefix + "/" + $file) -region ap-southeast-2
  Write-Output ($backupDir + "\" + $file) " uploaded to " ($Bucket + ":\" + $Bucket_Prefix + "\" + $file)
}
