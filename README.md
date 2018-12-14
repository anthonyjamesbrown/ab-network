---
external help file: ab-network-help.xml
Module Name: ab-network
online version:
schema: 2.0.0
---

# AB-NETWORK

## SYNOPSIS
This project contains functions used to collect data from different Network data collector applications and to store that data in a centralized SQL database.

The applications being collected from are:

InfoBlox
ServiceNow (ITAM table)
NetMRI
Orion
AD Sites and Services

The Create Network DB SQL script included in this project is badly out of date.  It will need to create an updated version.

The DB aside this module should demonstrate pulling data from a variety of tools using REST calls and working with a SQL database.

## DESCRIPTION
This project contains a number of useful functions for working with commonly used Network Management tools.

Functions include:

[Compare-Cidr](.\docs\Compare-Cidr.md)

[Convert-CidrToBinary](.\docs\Convert-CidrToBinary.md)

[Get-IPAMDataNetworkContainers](.\docs\Get-IPAMDataNetworkContainers.md)

[Get-IPAMDataNetworks](.\docs\Get-IPAMDataNetworks.md)

[Get-ITAMNetworkData](.\docs\Get-ITAMNetworkData.md)

[Get-NetMRIDeviceComponents](.\docs\Get-NetMRIDeviceComponents.md)

[Get-NetMRIDevices](.\docs\Get-NetMRIDevices.md)

[Get-OrionNodes](.\docs\Get-OrionNodes.md)

[Invoke-DataBaseCleanup](.\docs\Invoke-DataBaseCleanup.md)

[Invoke-DataCollection](.\docs\Invoke-DataCollection.md)

[Invoke-FullDataCollection](.\docs\Invoke-FullDataCollection.md)

See the docs directory for more information.

## RELATED LINKS
