param (
    [Parameter(Mandatory=$true)]
    [object] $volIds
)


# Split multiple Volume IDs into array - this is to handle for multiple EBS volumes across multiple instances
$volIds = $volIds.split('vol')
$volIds = $volIds | ForEach-Object {"vol$_"}

# Get disks
$disks = Get-Disk

# Loop through each disk, checking the disk serial number against the passed in Volume IDs
# Disks that match a passed in Volume ID are formatted
foreach ($disk in $disks)
{
	$serialNumber = $disk.SerialNumber;
	foreach ($vol in $volIds)
    {
        if ($vol.Equals($serialNumber))
	    {
		    write-host $disk.SerialNumber
            $disk | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -UseMaximumSize -DriveLetter Z | Format-Volume -FileSystem ReFS
	    }
    }
}


