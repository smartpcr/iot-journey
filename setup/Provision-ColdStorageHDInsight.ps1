[CmdletBinding()]
Param
(
	[ValidateNotNullOrEmpty()][Parameter (Mandatory = $True)][string]$SubscriptionName,
    [ValidateNotNullOrEmpty()][Parameter (Mandatory = $True)][String]$StorageAccountName,
    [ValidateNotNullOrEmpty()][Parameter (Mandatory = $False)][String]$ContainerName = "hdinsight",
    [ValidateNotNullOrEmpty()][Parameter (Mandatory=$False)][string]$ClusterName = "hdinsight-iot",
    [ValidateNotNullOrEmpty()][Parameter (Mandatory=$False)][int]$ClusterNodes = 2,
	[ValidateNotNullOrEmpty()][Parameter (Mandatory = $False)][String]$Location = "Central US"
)
PROCESS
{
    .\Init.ps1

    Load-Module -ModuleName Validation -ModuleLocation .\modules

    # Validate input.
    Test-OnlyLettersAndNumbers "StorageAccountName" $StorageAccountName
    Test-OnlyLettersNumbersAndHyphens "ContainerName" $ContainerName

    # Load modules.
    Load-Module -ModuleName Config -ModuleLocation .\modules
    Load-Module -ModuleName AzureStorage -ModuleLocation .\modules

    Add-AzureAccount

    $StorageAccountInfo = Provision-StorageAccount -StorageAccountName $StorageAccountName `
                                             -ContainerName $ContainerName `
                                             -Location $Location


    if(!(Get-AzureHDInsightCluster -Name $ClusterName))
    {
        Write-Verbose "Creating a new HDInsight cluster named: [$ClusterName]. This operation may take several minutes to complete."

        $Credential = Get-Credential -UserName "admin" -Message "Provide a password for the new HDInsight cluster. The password must contain lowercase letters, numbers, and special characters."

        # Create a new HDInsight cluster
        New-AzureHDInsightCluster -Name $ClusterName -Location $Location `
                                  -DefaultStorageAccountName "$StorageAccountName.blob.core.windows.net" `
                                  -DefaultStorageAccountKey $StorageAccountInfo.AccountKey `
                                  -DefaultStorageContainerName $ClusterName `
                                  -ClusterSizeInNodes $ClusterNodes `
                                  -Credential $Credential
    }
    else
    {
        Write-Verbose "An HDInsight cluster named: [$ClusterName] already exists."
    }

    Write-Output "Provision Finished OK"
}