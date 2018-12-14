SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CollectionData]    Script Date: 8/4/2014 9:44:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataSets](
	[DataSetID] [int] IDENTITY(1,1) NOT NULL,
	[RecordStatus] [varchar](50) NULL,
	[DateCollected] [datetime] NULL,
	[Source] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[DataSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Orion](
	[Rid]	[int]	IDENTITY(1,1) NOT NULL,
	[DataSetID] [int] NOT NULL,
	[NodeID] [int] NOT NULL,
	[NodeName]	[varchar](50) NULL,	
	[SysName]	[varchar](50) NULL,	
	[IP_Address]	[varchar](50) NULL,	
	[Caption]	[varchar](50) NULL,	
	[Contact]	[varchar](50) NULL,	
	[Location]	[varchar](50) NULL,	
	[Description]	[varchar](255) NULL,	
	[MachineType]	[varchar](50) NULL,	
	[Manufacturer]	[varchar](50) NULL,	
	[Model]	[varchar](50) NULL,	
	[ServiceTag]	[varchar](50) NULL,	
	[NodeDescription]	[varchar](255) NULL,	
	[StatusDescription]	[varchar](100) NULL,	
	[Vendor]	[varchar](50) NULL,	
	[IOSImage]	[varchar](50) NULL,	
	[IOSVersion]	[varchar](50) NULL,	
	[Alert]	[varchar](50) NULL,	
	[BusinessLine]	[varchar](50) NULL,	
	[CustomRole]	[varchar](50) NULL,	
	[CustomVendor]	[varchar](50) NULL,	
	[Imported_From_NCM]	[varchar](50) NULL,	
	[Region]	[varchar](50) NULL,	
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NetMRINode](
	[Rid]	[int]	IDENTITY(1,1) NOT NULL,
	[DataSetID]	[int]	NOT NULL,
	[DeviceID]	[varchar](50) NULL,
	[DeviceFirstOccurrenceTime]	[varchar](50) NULL,
	[DeviceIPDotted]	[varchar](50) NULL,
	[DeviceMAC]	[varchar](50) NULL,
	[DeviceModel]	[varchar](50) NULL,
	[DeviceName]	[varchar](50) NULL,
	[DeviceStartTime]	[varchar](50) NULL,
	[DeviceSysContact]	[varchar](50) NULL,
	[DeviceSysDescr]	[varchar](50) NULL,
	[DeviceSysLocation]	[varchar](50) NULL,
	[DeviceSysName]	[varchar](50) NULL,
	[DeviceTimestamp]	[varchar](50) NULL,
	[DeviceType]	[varchar](50) NULL,
	[DeviceVendor]	[varchar](50) NULL,
	[DeviceVersion]	[varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NetMRINodeComponent](
	[Rid]	[int]	IDENTITY(1,1) NOT NULL,
	[DataSetID]	[int]	NOT NULL,
	[DeviceID]	[varchar](50) NULL,
	[DevicePhysicalID]	[varchar](50) NULL,
	[PhysicalAlias]	[varchar](50) NULL,
	[PhysicalAssetID]	[varchar](50) NULL,
	[PhysicalClass]	[varchar](50) NULL,
	[PhysicalContainedIn]	[varchar](50) NULL,
	[PhysicalDescr]	[varchar](50) NULL,
	[PhysicalEndTime]	[varchar](50) NULL,
	[PhysicalFirmwareRev]	[varchar](50) NULL,
	[PhysicalHardwareRev]	[varchar](50) NULL,
	[PhysicalIndex]	[varchar](50) NULL,
	[PhysicalMfgName]	[varchar](50) NULL,
	[PhysicalModelName]	[varchar](50) NULL,
	[PhysicalName]	[varchar](50) NULL,
	[PhysicalParentRelPos]	[varchar](50) NULL,
	[PhysicalSerialNum]	[varchar](50) NULL,
	[PhysicalSoftwareRev]	[varchar](50) NULL,
	[PhysicalStartTime]	[varchar](50) NULL,
	[PhysicalTimestamp]	[varchar](50) NULL,
	[PhysicalVendorType]	[varchar](50) NULL,
	[UnitState]	[varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IPAMNetwork](
	[Rid]	[int]	IDENTITY(1,1) NOT NULL,
	[DataSetID]	[int]	NOT NULL,
	[EntryType]	[varchar](50),
	[Ref]	[varchar](100) NULL,
	[Network_view]	[varchar](50) NULL,
	[Network_container]	[varchar](50) NULL,
	[Network]	[varchar](50) NULL,
	[Itam]	[varchar](50) NULL,
	[Conflict]	[varchar](50) NULL,
	[Country]	[varchar](50) NULL,
	[Region]	[varchar](50) NULL,
	[City]	[varchar](50) NULL,
	[Site]	[varchar](50) NULL,
	[Env]	[varchar](50) NULL,
	[Zone]	[varchar](50) NULL,
	[Vlan]	[varchar](50) NULL,
	[Sz]	[varchar](50) NULL,
	[Comment]	[varchar](100) NULL,
	[Type]	[varchar](50) NULL,
	[Fxn]	[varchar](50) NULL,
	[Host_device]	[varchar](50) NULL,
	[interface]	[varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ITAM](
	[Rid]	[int]	IDENTITY(1,1) NOT NULL,
	[DataSetID]	[int]	NOT NULL,
	[Display_name]	[varchar](100) NULL,
	[Install_status]	[varchar](50) NULL,
	[Ci]	[varchar](100) NULL,
	[Serial_number]	[varchar](50) NULL,
	[u_asset_name]	[varchar](50) NULL,
	[location]	[varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ADSites](
	[Rid]	[int]	IDENTITY(1,1) NOT NULL,
	[DataSetID]	[int]	NOT NULL,
	[Name]	[varchar](50) NULL,
	[Created]	[varchar](50) NULL,
	[Description]	[varchar](50) NULL,
	[ObjectGUID]	[varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ADSubnets](
	[Rid]	[int]	IDENTITY(1,1) NOT NULL,
	[DataSetID]	[int]	NOT NULL,
	[Name]	[varchar](50) NULL,
	[Created]	[varchar](50) NULL,
	[Location]	[varchar](100) NULL,
	[ObjectGUID]	[varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ADSiteLinks](
	[Rid]	[int]	IDENTITY(1,1) NOT NULL,
	[DataSetID]	[int]	NOT NULL,
	[Name] 	[varchar](50) NULL,
	[Created]	[varchar](50) NULL,
	[Cost]	[int] NULL,
	[ObjectGUID]	[varchar](50) NULL,
	[Frequency]	[int] NULL,
	[SitesIncluded]	[varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
