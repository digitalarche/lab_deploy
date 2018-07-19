﻿<#  Deploy-MAX-X.ps1
    Kelley Vice 7/17/2018

    This script deploys the X VM Base Configuration to your Azure RM subscription.
    You must have the AzureRM PowerShell module installed on your computer to run this script.
    To install the AzureRM module, execute the following command from an elevated PowerShell prompt:
        Install-Module AzureRM -Force

    7/19/2018 - Revised for the max-base-config_x-vm template

#>

# Provide parameter values
$subscription = "subscription name"
$resourceGroup = "resource group name"
$location = "location, i.e. West US"

$configName = "" # The name of the deployment, i.e. BaseConfig01. Do not use spaces or special characters other than _ or -. Used to concatenate resource names for the deployment.
$domainName = "" # The FQDN of the new AD domain.
$serverOS = "2016-Datacenter" # The OS of application servers in your deployment, i.e. 2016-Datacenter or 2012-R2-Datacenter.
$adminUserName = "" # The name of the domain administrator account to create, i.e. globaladmin.
$adminPassword = "" # The administrator account password.
$deployClientVm = "Yes" # Yes or No
$numberOfAppVms = "1" # Number of app server VMs to deploy
$numberOfClientVms = "1" # Number of client VMs to deploy
$vmSize = "Standard_DS2_v2" # Select a VM size for all server VMs in your deployment.
$dnsLabelPrefix = "" # DNS label prefix for public IPs. Must be lowercase and match the regular expression: ^[a-z][a-z0-9-]{1,61}[a-z0-9]$.
$subnetCIDR = "" # The CIDR subnet for your virtual network, i.e. 10.0.0.0/24.
$_artifactsLocation = "https://raw.githubusercontent.com/oualabadmins/lab_deploy/master/max-base-config_3-vm" # Location of template artifacts.
$_artifactsLocationSasToken = "" # Enter SAS token here if needed.
$templateUri = "$_artifactsLocation/azuredeploy.json"

# Add parameters to array
$parameters = @{}
$parameters.Add("configName",$configName)
$parameters.Add("domainName",$domainName)
$parameters.Add("serverOS",$serverOS)
$parameters.Add("adminUserName",$adminUserName)
$parameters.Add("adminPassword",$adminPassword)
$parameters.Add("deployClientVm",$deployClientVm)
$parameters.Add("numberOfAppVms",$numberOfAppVms)
$parameters.Add("numberOfClientVms",$numberOfClientVms)
$parameters.Add("vmSize",$vmSize)
$parameters.Add("dnsLabelPrefix",$dnsLabelPrefix)
$parameters.Add("subnetCIDR",$subnetCIDR)
$parameters.Add("_artifactsLocation",$_artifactsLocation)
$parameters.Add("_artifactsLocationSasToken",$_artifactsLocationSasToken)

# Log in to Azure subscription
Connect-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $subscription

# Deploy resource group
New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# Deploy template
New-AzureRmResourceGroupDeployment -Name $configName -ResourceGroupName $resourceGroup `
  -TemplateUri $templateUri -TemplateParameterObject $parameters -DeploymentDebugLogLevel All