---
external help file: AB-Network-help.xml
Module Name: AB-Network
online version:
schema: 2.0.0
---

# Compare-Cidr

## SYNOPSIS
Determines if one of the CIDR parameters is a subnet of the other.

## SYNTAX

```
Compare-Cidr [-Cidr1] <String> [-Cidr2] <String> [<CommonParameters>]
```

## DESCRIPTION
This function returns true if one of the CIDR addresses passed into it is a subnet of the other CIDR address passed to it. 
Parameter order does not matter.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Cidr1
This parameter is a standard CIDR formatted network address

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

### -Cidr2
This parameter is a standard CIDR formatted network address

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
