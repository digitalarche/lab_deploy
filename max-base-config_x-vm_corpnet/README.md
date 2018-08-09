﻿# MAX Skunkworks Lab - X VM Base Configuration for Corpnet (v1.0)

**IMPORTANT**: Only deploy this template into a subscription with an existing ExpressRoute circuit, and to a region with an ER circuit. The template will automatically choose the correct ER virtual network based on subscription and location.

**Choose one of these subscription/region combinations:**

| Subscription             | Region(s)
| :-------------------     | :-------------------
| MAXLAB R&D Primary       | West US
| MAXLAB R&D Self Service  | South Central US
| MAXLAB R&D INT 1         | West US 2 <br> West Central US
| MAXLAB R&D INT 2         | West US 2

**Time to deploy**: 40+ minutes

The **X VM Base Configuration for Corpnet** provisions a test environment on an existing corpnet-connected ER circuit consisting of a Windows Server 2012 R2 or 2016 Active Directory domain controller using the specified domain name, one or more application servers running Windows Server 2012 R2 or 2016, and optionally one or more client VMs running Windows 10. All member VMs are joined to the domain.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Foualabadmins%2Flab_deploy%2Fmaster%2Fmax-base-config_x-vm_corpnet%2Fazuredeploy.json" target="_blank">
<img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Foualabadmins%2Flab_deploy%2Fmaster%2Fmax-base-config_x-vm_corpnet%2Fazuredeploy.json" target="_blank">
<img src="http://armviz.io/visualizebutton.png"/>
</a>

## Usage

You can deploy this template in one of two ways:

+ Click the "Deploy to Azure" button to open the deployment UI in the Azure portal
+ Execute the PowerShell script at https://raw.githubusercontent.com/oualabadmins/lab_deploy/master/max-base-config_x-vm_corpnet/scripts/Deploy-TLG-X.ps1 on your local computer. Note that you'll need the AzureRM PowerShell module to do this. You can install it by running the following from an elevated PowerShell console:

    ```PowerShell
    Install-Module AzureRM -Force
    ```

## Solution overview and deployed resources

The following resources are deployed as part of the solution:

+ **AD DC VM**: Windows Server 2012 R2 or 2016 VM configured as a domain controller and DNS with static private IP address
+ **App Server VM(s)**: Windows Server 2012 R2 or 2016 VM(s) joined to the domain. IIS is installed, and C:\Files containing example.txt is shared as "Files".
+ **Client VM(s)**: Windows 10 client(s) joined to the domain
+ **Storage account**: Diagnostics storage account, and client VM storage account if indicated. ADDC and App Server VMs in the deployment use managed disks, so no storage accounts are created for VHDs.
+ **NSG**: Network security group configured to allow inbound traffic on ports 80, 443, 3389, 5985 and 5986.
+ **Network interfaces**: 1 NIC per VM with dynamic private IP address
+ **JoinDomain**: Each member VM uses the **JsonADDomainExtension** extension to join the domain.
+ **BGInfo**: The **BGInfo** extension is applied to all VMs.
+ **Antimalware**: The **iaaSAntimalware** extension is applied to all VMs with basic scheduled scan and exclusion settings.

## Solution notes

* The domain user *User1* is created in the domain and added to the Domain Admins group. User1's password is the one you provide in the *adminPassword* parameter.
* The *App server* and *Client* VM resources depend on the **ADDC** resource deployment to ensure that the AD domain exists prior to execution of the JoinDomain extensions. The asymmetric VM deployment adds a few minutes to the overall deployment time.
* You can specify the tenant subnet in the *subnetCIDR* parameter. For most deployments, the default subnet 10.0.0.0/24 will work fine.
* Remember, when you RDP to your VM, you will use **domain\adminusername** for the custom domain of your environment, _not_ your corpnet credentials.

## Known issues

* The client VM deployment may take longer than expected, and then appear to fail. The client VMs and extensions may or may not deploy successfully. This is due to an ongoing Azure client deployment bug, and only happens when the client VM size is smaller than DS4_v2.

`Tags: TLG, Test Lab Guide, Base Configuration`
___
Developed by the **MAX Skunkworks Lab**  
Author: Kelley Vice (kvice@microsoft.com)  
https://github.com/maxskunkworks

![alt text](images/maxskunkworkslogo-small.jpg "MAX Skunkworks")

Last update: _8/8/2018_

## Changelog

+ **8/8/2018**: Original commit, derived from https://github.com/oualabadmins/lab_deploy/tree/master/max-base-config_x-vm.