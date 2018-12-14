---
external help file: AB-Network-help.xml
Module Name: AB-Network
online version:
schema: 2.0.0
---

# Convert-CidrToBinary

## SYNOPSIS
Converts a CIDR formatted network into its binary representation

## SYNTAX

```
Convert-CidrToBinary [-Cidr] <String> [<CommonParameters>]
```

## DESCRIPTION
This function converts a CIDR formatted network into its binary representaion and only returns the network portion

## EXAMPLES

### EXAMPLE 1
```
Convert-CidrToBinary -Cidr '10.156.72.0/24'
```

000010101001110001001000

## PARAMETERS

### -Cidr
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
