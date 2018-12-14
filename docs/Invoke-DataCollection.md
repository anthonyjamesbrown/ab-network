---
external help file: AB-Network-help.xml
Module Name: AB-Network
online version: https://github.com/solarwinds/OrionSDK/wiki/REST
schema: 2.0.0
---

# Invoke-DataCollection

## SYNOPSIS
Queries a Networking datasource and syncs the data to the database

## SYNTAX

```
Invoke-DataCollection [-Source] <String> [<CommonParameters>]
```

## DESCRIPTION
This function queries one of the Networking datasources and inserts a new dataset into the database

## EXAMPLES

### EXAMPLE 1
```
Invoke-DataCollection -Source 'orion'
```

## PARAMETERS

### -Source
This parameter is used to specifiy which Networking datasource to query

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
