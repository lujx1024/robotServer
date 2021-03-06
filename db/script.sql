USE [master]
GO
/****** Object:  Database [G2Robot]    Script Date: 2017/8/15 15:16:38 ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'G2Robot')
BEGIN
CREATE DATABASE [G2Robot]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'G2Robot', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLSERVER2014\MSSQL\DATA\CLOUD_G2ROBOT.mdf' , SIZE = 19512704KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'G2Robot_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLSERVER2014\MSSQL\DATA\CLOUD_G2ROBOT_log.ldf' , SIZE = 14539584KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
END

GO
ALTER DATABASE [G2Robot] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [G2Robot].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [G2Robot] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [G2Robot] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [G2Robot] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [G2Robot] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [G2Robot] SET ARITHABORT OFF 
GO
ALTER DATABASE [G2Robot] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [G2Robot] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [G2Robot] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [G2Robot] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [G2Robot] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [G2Robot] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [G2Robot] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [G2Robot] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [G2Robot] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [G2Robot] SET  DISABLE_BROKER 
GO
ALTER DATABASE [G2Robot] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [G2Robot] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [G2Robot] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [G2Robot] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [G2Robot] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [G2Robot] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [G2Robot] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [G2Robot] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [G2Robot] SET  MULTI_USER 
GO
ALTER DATABASE [G2Robot] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [G2Robot] SET DB_CHAINING OFF 
GO
ALTER DATABASE [G2Robot] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [G2Robot] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [G2Robot] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'G2Robot', N'ON'
GO
USE [G2Robot]
GO
/****** Object:  User [xuchen]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'xuchen')
CREATE USER [xuchen] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [quickdone]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'quickdone')
CREATE USER [quickdone] FOR LOGIN [quickdone] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IZ23X63EFC3Z\hongjiangli]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'IZ23X63EFC3Z\hongjiangli')
CREATE USER [IZ23X63EFC3Z\hongjiangli] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [hongjiangli]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'hongjiangli')
CREATE USER [hongjiangli] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [gongpeicai]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'gongpeicai')
CREATE USER [gongpeicai] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [xuchen]
GO
ALTER ROLE [db_datareader] ADD MEMBER [quickdone]
GO
ALTER ROLE [db_owner] ADD MEMBER [hongjiangli]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [hongjiangli]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [hongjiangli]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [hongjiangli]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [hongjiangli]
GO
ALTER ROLE [db_datareader] ADD MEMBER [hongjiangli]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [hongjiangli]
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_AUTHENTICATE_PASSPORT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_AUTHENTICATE_PASSPORT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-26
-- Description:	验证请求TAG是否通过
-- =============================================
CREATE FUNCTION [dbo].[FUNC_AUTHENTICATE_PASSPORT]
(
	   @PASSPORT AS NVARCHAR(4000)
	  ,@AUTHENTICATION AS NVARCHAR(4000)
)
RETURNS BIT
AS
BEGIN

	DECLARE @RET   BIT

	IF EXISTS
	(
		SELECT TAG FROM DBO.FUNC_GET_TAGS_TABLE(@AUTHENTICATION)
		WHERE TAG NOT IN 
		(	
			SELECT TAG FROM DBO.FUNC_GET_TAGS_TABLE(@PASSPORT) 
		)
	)
		SET @RET = 0
	ELSE
		SET @RET = 1


	RETURN @RET

END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-26
-- Description:	验证请求TAG是否通过
-- =============================================
CREATE FUNCTION [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID]
(
	   @TAGS AS NVARCHAR(4000)
	  ,@ROBOT_ID AS BIGINT
)
RETURNS BIT
AS
BEGIN

	DECLARE @RET   BIT

	IF EXISTS
	(
		SELECT  TAG 
		FROM TBl_ROBOT_TAGS 
		WHERE  
		ROBOT_ID = @ROBOT_ID 
		AND
		(
			CHARINDEX(TBl_ROBOT_TAGS.TAG + '','', @TAGS ) = 1
			OR CHARINDEX('','' + TBl_ROBOT_TAGS.TAG + '','', @TAGS ) > 0
			OR CHARINDEX('','' + TBl_ROBOT_TAGS.TAG, @TAGS ) = LEN(@TAGS) - LEN(TBl_ROBOT_TAGS.TAG)
		)
	)
		SET @RET = 1
	ELSE
		SET @RET = 0


	RETURN @RET

END




' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'








-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-09
-- Description:	验证请求TAG是否通过
-- =============================================
CREATE FUNCTION [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V2]
(
	   @TAGS AS NVARCHAR(4000)
	  ,@ROBOT_ID AS BIGINT
)
RETURNS BIGINT
AS
BEGIN

	DECLARE @RET   BIGINT

	SELECT  @RET = COUNT(TAG)
	FROM TBl_ROBOT_TAGS 
	WHERE  
	ROBOT_ID = @ROBOT_ID 
	AND
	(
		
		  CHARINDEX(TBl_ROBOT_TAGS.TAG + '','', @TAGS ) = 1
		OR CHARINDEX('','' + TBl_ROBOT_TAGS.TAG + '','', @TAGS ) > 0
		OR 
		(
			CHARINDEX('','' + TBl_ROBOT_TAGS.TAG, @TAGS )  > 0 
			AND CHARINDEX('','' + TBl_ROBOT_TAGS.TAG, @TAGS ) = LEN(@TAGS) - LEN(TBl_ROBOT_TAGS.TAG)
		)
		OR TBl_ROBOT_TAGS.TAG  = @TAGS
	)
	RETURN @RET

END









' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V3]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V3]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-11
-- Description:	验证请求TAG是否通过
-- =============================================
CREATE FUNCTION [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V3]
(
	   @VOICE_ID AS BIGINT
	  ,@ROBOT_ID AS BIGINT
)
RETURNS BIGINT
AS
BEGIN

	RETURN (SELECT  COUNT(TBL_VOICE_TAG.TAG)
	FROM   TBl_ROBOT_TAGS 
		 , TBL_VOICE_TAG
	WHERE  
		ROBOT_ID = @ROBOT_ID 
	AND VOICE_ID = @VOICE_ID
	AND TBl_ROBOT_TAGS.TAG =  TBL_VOICE_TAG.TAG )

END












' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-22
-- Description:	验证请求TAG是否通过，自动关联企业TAG和行业TAG
-- =============================================
CREATE FUNCTION [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4]
(
	   @VOICE_ID AS BIGINT
	  ,@ROBOT_ID AS BIGINT
)
RETURNS BIGINT
AS
BEGIN

	RETURN (SELECT  COUNT(TBL_VOICE_TAG.TAG)
	FROM   VIEW_ROBOT_TAGS 
		 , TBL_VOICE_TAG
	WHERE  
		ROBOT_ID = @ROBOT_ID 
	AND VOICE_ID = @VOICE_ID
	AND VIEW_ROBOT_TAGS.TAG =  TBL_VOICE_TAG.TAG )

END












' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_USER_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_USER_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-26
-- Description:	验证请求TAG是否通过
-- =============================================
CREATE FUNCTION [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_USER_ID]
(
	   @VOICE_ID AS BIGINT
	  ,@USER_ID AS BIGINT
)
RETURNS BIGINT
AS
BEGIN

	RETURN (SELECT  COUNT(TBL_VOICE_TAG.TAG)
	FROM   TBl_ROBOT_TAGS 
		 , TBL_VOICE_TAG
	WHERE  
		ROBOT_ID  IN (SELECT ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST WHERE USER_ID = @USER_ID) 
	AND VOICE_ID = @VOICE_ID
	AND TBl_ROBOT_TAGS.TAG =  TBL_VOICE_TAG.TAG )

END













' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_USER_ID_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_USER_ID_V2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-22
-- Description:	验证请求TAG是否通过，自动关联行业，企业TAG
-- =============================================
CREATE FUNCTION [dbo].[FUNC_AUTHENTICATE_PASSPORT_BY_USER_ID_V2]
(
	   @VOICE_ID AS BIGINT
	  ,@USER_ID AS BIGINT
)
RETURNS BIGINT
AS
BEGIN

	RETURN (SELECT  COUNT(TBL_VOICE_TAG.TAG)
	FROM   VIEW_ROBOT_TAGS 
		 , TBL_VOICE_TAG
	WHERE  
		ROBOT_ID  IN (SELECT ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST WHERE USER_ID = @USER_ID) 
	AND VOICE_ID = @VOICE_ID
	AND VIEW_ROBOT_TAGS.TAG =  TBL_VOICE_TAG.TAG )

END













' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_AUTO_GEN_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_AUTO_GEN_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-23
-- Description:	自动生成ID
-- =============================================
CREATE FUNCTION [dbo].[FUNC_AUTO_GEN_ID]
(
	@TABLE_NAME AS NVARCHAR(100)
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @GEN_ID AS BIGINT 

	EXEC SP_AUTO_GEN_ID @TABLE_NAME, @GEN_ID OUTPUT

	RETURN  @GEN_ID

END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_CHECK_ROBOT_APP_VERSION_REQUIRED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_CHECK_ROBOT_APP_VERSION_REQUIRED]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-4-14
-- Description:	检查版本要求
-- =============================================
CREATE FUNCTION [dbo].[FUNC_CHECK_ROBOT_APP_VERSION_REQUIRED] (
	 @IMEI AS NVARCHAR(50)
	,@APP_ID AS BIGINT
	,@CHECK_VERSION  NVARCHAR(50)
)
RETURNS BIT

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
 

	DECLARE @RET BIT
	DECLARE @CURRENT_DB_VERSION AS NVARCHAR(50)
	DECLARE @REQURIED_VERSION_NAME AS NVARCHAR(500)

	SELECT  @CURRENT_DB_VERSION = MAX(ENT_DB_VERSION.NAME)  
		FROM ENT_DB_VERSION

	SELECT @REQURIED_VERSION_NAME = REQURIED_VERSION_NAME
	FROM VIEW_ROBOT_APP_VERSION_REQUIRED
	WHERE VIEW_ROBOT_APP_VERSION_REQUIRED.DB_VERSION = @CURRENT_DB_VERSION
	AND ROBOT_IMEI = @IMEI
	AND APP_ID = @APP_ID

	-- 小于所需版本，返回 0
	IF @REQURIED_VERSION_NAME IS NOT NULL AND @CHECK_VERSION < @REQURIED_VERSION_NAME
		SET @RET = 0
	ELSE
		SET @RET = 1

	RETURN @RET
END

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_CHECK_SMART_DIALOG_CLIENT_VERSION_REQUIRED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_CHECK_SMART_DIALOG_CLIENT_VERSION_REQUIRED]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-23
-- Description:	会话客户端最低版本要求
-- =============================================
CREATE FUNCTION [dbo].[FUNC_CHECK_SMART_DIALOG_CLIENT_VERSION_REQUIRED] (
	@CLIENT_VERSION  NVARCHAR(50)
)
RETURNS BIT

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
 

	DECLARE @RET BIT

    -- Insert statements for procedure here
	IF EXISTS(
	SELECT 
		TBL_VERSION_REQUIRED.REQURIED_CLIENT_VERSION
	FROM
	TBL_VERSION_REQUIRED
	, (
		SELECT MAX(ENT_DB_VERSION.NAME) AS CURRENT_DB_VERSION
		FROM ENT_DB_VERSION
	) DB_VERSION
	WHERE DB_VERSION.CURRENT_DB_VERSION = TBL_VERSION_REQUIRED.DB_VERSION
	AND @CLIENT_VERSION >= TBL_VERSION_REQUIRED.REQURIED_CLIENT_VERSION )
		SET @RET = 1
	ELSE
		SET @RET = 0 

	RETURN @RET
END

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_FILLED_CONFIG_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_FILLED_CONFIG_VALUE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-08
-- Description:	给字串设 config 值，可递归设值
-- =============================================
CREATE FUNCTION [dbo].[FUNC_FILLED_CONFIG_VALUE] 
(
	 @input AS NVARCHAR(max) 
    ,@IMEI  AS NVARCHAR(1024)
)
RETURNS NVARCHAR(max)
AS
BEGIN
	DECLARE	 @PRE_INPUT AS NVARCHAR(MAX) 
	SET @PRE_INPUT = @INPUT
	WHILE CHARINDEX(''$'', @INPUT) <> 0
	BEGIN
		SELECT
			@INPUT = 
			REPLACE(@INPUT , ''$'' + [NAME] + ''$'', [VALUE])
		  FROM [VIEW_ROBOT_MAX_PRIORITY_CONFIG]
			 WHERE [ROBOT_IMEI] = @IMEI
			AND @INPUT LIKE (''%$'' + [NAME] + ''$%'')

		IF @PRE_INPUT = @INPUT
			BREAK
		ELSE
		   SET	@PRE_INPUT = @INPUT	 
	END

	RETURN @input

END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_FILLED_CONFIG_VALUE_NO_RESC]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_FILLED_CONFIG_VALUE_NO_RESC]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-16
-- Description:	给字串设 config 值
-- =============================================
CREATE FUNCTION [dbo].[FUNC_FILLED_CONFIG_VALUE_NO_RESC] 
(
	 @input AS NVARCHAR(max) 
    ,@IMEI  AS NVARCHAR(1024)
)
RETURNS NVARCHAR(max)
AS
BEGIN
	-- Add the T-SQL statements to compute the return value here
	-- SELECT <@ResultVar, sysname, @Result> = <@Param1, sysname, @p1>
		SELECT
		@input = 
		replace(@input , ''$'' + [NAME] + ''$'', [VALUE])
		  --  [NAME]
		  -- , [VALUE]
		  -- ,[DESCRIPTION]
	  FROM [G2Robot].[dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG]
		 where [ROBOT_IMEI] = @IMEI
		and @input like (''%$'' + [NAME] + ''$%'')

	RETURN @input
END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_FILLED_REQUEST_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_FILLED_REQUEST_VALUE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	给字串设 request属性值
-- =============================================
CREATE FUNCTION [dbo].[FUNC_FILLED_REQUEST_VALUE] 
(
	 @input AS NVARCHAR(max) 
    ,@requestId  AS NVARCHAR(1024)
)
RETURNS NVARCHAR(max)
AS
BEGIN
	-- Add the T-SQL statements to compute the return value here
		SELECT
		@input = 
		replace(@input , ''@'' + PROPERTY_NAME, PROPERTY_VALUE)
	  FROM TBL_REQUEST_PROPERTY
		 where REQUEST_ID = @requestId
		and @input like (''%@'' + PROPERTY_NAME + ''%'')

	RETURN @input
END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_FILLED_REQUEST_VALUE_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_FILLED_REQUEST_VALUE_V2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	给字串设 request属性值
-- =============================================
CREATE FUNCTION [dbo].[FUNC_FILLED_REQUEST_VALUE_V2] 
(
	 @input AS NVARCHAR(max) 
    ,@requestId  AS NVARCHAR(1024)
)
RETURNS NVARCHAR(max)
AS
BEGIN
	-- Add the T-SQL statements to compute the return value here
	--DECLARE @PROPERTY_NAME   TABLE(NAME NVARCHAR(120)) 

	--INSERT INTO @PROPERTY_NAME

		SELECT
		@input = 
		replace(@input , ''@'' + NAME , DBO.[FUNC_GET_REQUEST_PROPERTY_VALUE_V2](@REQUESTID, NAME))
	  FROM ENT_REQUEST 
	       ,(SELECT NAME FROM SYSCOLUMNS WHERE ID=OBJECT_ID(''ENT_REQUEST'')) PROPERTY_NAME

		 where ID = @requestId
		and @input like (''%@'' + NAME + ''%'')

	RETURN @input
END



' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_FILLED_SESSION_CONTEXT_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_FILLED_SESSION_CONTEXT_VALUE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	给字串设 SESSION CONTEXT 值
-- =============================================
CREATE FUNCTION [dbo].[FUNC_FILLED_SESSION_CONTEXT_VALUE] 
(
	 @input AS NVARCHAR(max) 
    ,@ROBOT_ID  AS BIGINT
)
RETURNS NVARCHAR(max)
AS
BEGIN
	-- Add the T-SQL statements to compute the return value here
		SELECT
		@input = 
		replace(@input , ''~'' + CTX_NAME, CTX_VALUE)
	  FROM TBL_ROBOT_SESSION_CONTEXT
		 where ROBOT_ID = @ROBOT_ID
		and @input like (''%~'' + CTX_NAME + ''%'')

	RETURN @input
END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_CONFIG_OWNER_NAME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_CONFIG_OWNER_NAME]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-3-22
-- Description:	配置所属名
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_CONFIG_OWNER_NAME]
(
	@OWNER_TYPE BIGINT,
	@OWNER_ID   BIGINT
)
RETURNS NVARCHAR(1024)
AS
BEGIN

	DECLARE @RET NVARCHAR(1024)

	SET @RET = ''未知''
	IF @OWNER_TYPE = 1 
		SET @RET = ''系统配置''

	IF @OWNER_TYPE = 2
		SELECT @RET = NAME FROM ENT_INDUSTRY WHERE ID = @OWNER_ID

	IF @OWNER_TYPE = 3
		SELECT @RET = NAME FROM ENT_USER_GROUP WHERE ID = @OWNER_ID

	IF @OWNER_TYPE = 4
		SELECT @RET = NAME FROM TBL_USER_GROUP_SCENE WHERE ID = @OWNER_ID

	RETURN @RET

END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_CONFIG_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_CONFIG_VALUE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-1-6
-- Description:	获取指定配置信息
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_CONFIG_VALUE] 
(
	 @IMEI NVARCHAR(50)
	,@CFG_NAME NVARCHAR(50)
	,@DEFAULT_VALUE NVARCHAR(MAX) = ''''
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @CTX_VALUE  NVARCHAR(MAX)

	SELECT @CTX_VALUE = [VALUE]       
    FROM  [VIEW_ROBOT_MAX_PRIORITY_CONFIG]
    WHERE @IMEI = ROBOT_IMEI AND NAME = @CFG_NAME

	RETURN ISNULL(@CTX_VALUE, @DEFAULT_VALUE)

END

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_CONTEXT_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_CONTEXT_VALUE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-30
-- Description:	获取上下文信息
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_CONTEXT_VALUE] 
(
	 @ROBOT_ID BIGINT
	,@CTX_NAME NVARCHAR(50)
	,@DEFAULT_VALUE NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @CTX_VALUE  NVARCHAR(MAX)

	SELECT  @CTX_VALUE = ISNULL( CTX_VALUE, @DEFAULT_VALUE)
	FROM TBL_ROBOT_SESSION_CONTEXT 
    WHERE @ROBOT_ID = ROBOT_ID AND CTX_NAME = @CTX_NAME

	RETURN ISNULL(@CTX_VALUE, @DEFAULT_VALUE)

END

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ENTITY_ID_BY_NAME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_ENTITY_ID_BY_NAME]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-08
-- Description:	根据实体 NAME 获取 ID
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_ENTITY_ID_BY_NAME]
(
	  @TABLE_NAME AS NVARCHAR(100)
	, @NAME AS NVARCHAR(50)
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @ID AS BIGINT 

	EXEC SP_GET_ENTITY_ID_BY_NAME @TABLE_NAME, @NAME, @ID OUTPUT

	RETURN  @ID

END

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_MANUAL_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_MANUAL_VOICE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-1-5
-- Description:	判断人工构造的voice是否存在
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_MANUAL_VOICE]
(
	@ROBOT_ID BIGINT
)
RETURNS BIGINT
AS
BEGIN

	-- null   不存在
	-- -1     放弃手动
	-- 其他值 手动构造的voice
	RETURN 
	(
		SELECT VOICE_ID FROM TBL_ROBOT_MANUAL_TALK_CACHE 
		-- 人工构造的VOICE只有 3 秒生存周期
		WHERE ROBOT_ID = @ROBOT_ID AND DATEDIFF(MILLISECOND, CREATE_DATETIME ,  GETDATE()) <= cast(  dbo.FUNC_GET_META_SETTINGS(''MANUAL_VOICE_LIFE_CYCLE_MILLS'', ''3000'') as bigint)
	)
END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_MAX_MATCHED_FLOW_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_MAX_MATCHED_FLOW_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'














































-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-24
-- Description:	判断给定语料是否存在匹配
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_MAX_MATCHED_FLOW_ID]
(
	@INPUT_STRING AS NVARCHAR(1024)
)
RETURNS BIGINT

AS
BEGIN
	DECLARE @VOICE_GROUP_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
	DECLARE @ACT_CNT AS BIGINT
	DECLARE @USE_FULLY_MATCH BIT
	DECLARE @MAX_ACT_CNT AS BIGINT
	DECLARE @MAX_MATCHED_KEY_WORD_GROUP_FLOW_ID AS BIGINT

	SET @MAX_ACT_CNT = 0
 
	DECLARE CUR_CHECK_KW_ENTIRELY
	CURSOR FOR 

	SELECT KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT
	FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
	WHERE 
	(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0) AND ENABLE = 1
	GROUP BY KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID
	ORDER BY USE_FULLY_MATCH DESC, CNT DESC

	OPEN CUR_CHECK_KW_ENTIRELY

	FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
	@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
		WHERE ID = @KEY_WORD_GROUP_FLOW_ID AND INC_1_EXC_0 = 1

 
		IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT 
		BEGIN
 

			-- 先严格匹配
			IF  @USE_FULLY_MATCH = 1
				IF DBO.FUNC_IS_FULLY_MATCHED(@INPUT_STRING, @KEY_WORD_GROUP_FLOW_ID) = 1 
				BEGIN
 					SET @MAX_MATCHED_KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID
					BREAK		
				END	
				ELSE
				BEGIN
					GOTO NEXT_ITEM
				END
			IF @MAX_ACT_CNT < @ACT_CNT
			BEGIN
			 
				SET @MAX_ACT_CNT = @ACT_CNT
				SET @MAX_MATCHED_KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID
			END
		END

		NEXT_ITEM:
		FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
		@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
	END
	CLOSE CUR_CHECK_KW_ENTIRELY
	DEALLOCATE CUR_CHECK_KW_ENTIRELY		
 
	RETURN @MAX_MATCHED_KEY_WORD_GROUP_FLOW_ID
END 
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_META_SETTINGS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_META_SETTINGS]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-2
-- Description:	获取系统元设置
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_META_SETTINGS]
(
	 @NAME NVARCHAR(120)
	,@DEFAULT_VALUE NVARCHAR(4000) = ''N/A''
)
RETURNS NVARCHAR(4000)
AS
BEGIN
	DECLARE @VALUE  NVARCHAR(4000)

	SELECT  @VALUE = ISNULL( VALUE, @DEFAULT_VALUE)
	FROM ENT_SYSTEM_META_SETTINGS 
    WHERE    NAME = @NAME

	RETURN ISNULL(@VALUE, @DEFAULT_VALUE)
END



' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_PINYIN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_PINYIN]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- Batch submitted through debugger: SQLQuery7.sql|7|0|C:\Users\ADMINI~1\AppData\Local\Temp\1\~vsC4BA.sql


CREATE function [dbo].[FUNC_GET_PINYIN](@str varchar(1024))
returns varchar(8000)
as
begin
 declare @re varchar(8000),@crs varchar(10)
 declare @strlen int 
 select @strlen=len(@str),@re=''''
 while @strlen>0
 begin     
      select top 1 @re=py+ '' '' +@re,@strlen=@strlen-1 
      from ENT_PINYIN4  where ch<=substring(@str,@strlen,1) 
      order by ch collate Chinese_PRC_CS_AS_KS_WS  desc 
      if @@rowcount=0
        select @re=substring(@str,@strlen,1)+ @re,@strlen=@strlen-1
   end
 return(@re)
end

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_PINYIN_BY_CASE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_PINYIN_BY_CASE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- Batch submitted through debugger: SQLQuery7.sql|7|0|C:\Users\ADMINI~1\AppData\Local\Temp\1\~vsC4BA.sql


CREATE function [dbo].[FUNC_GET_PINYIN_BY_CASE](@str varchar(1024))
returns varchar(8000)
as
begin
 declare @re varchar(8000),@crs varchar(10)
 declare @strlen int 
 select @strlen=len(@str),@re=''''
 while @strlen>0
 begin  
  set @crs= substring(@str,@strlen,1)
      select @re=
        case
        when @crs<''吖'' then @crs
        when @crs<=''厑'' then ''a''
        when @crs<=''靉'' then ''ai''
        when @crs<=''黯'' then ''an''
        when @crs<=''醠'' then ''ang''
        when @crs<=''驁'' then ''ao''
        when @crs<=''欛'' then ''ba''
        when @crs<=''瓸'' then ''bai''
        when @crs<=''瓣'' then ''ban''
        when @crs<=''鎊'' then ''bang''
        when @crs<=''鑤'' then ''bao''
        when @crs<=''鐾'' then ''bei''
        when @crs<=''輽'' then ''ben''
        when @crs<=''鏰'' then ''beng''
        when @crs<=''鼊'' then ''bi''
        when @crs<=''變'' then ''bian''
        when @crs<=''鰾'' then ''biao''
        when @crs<=''彆'' then ''bie''
        when @crs<=''鬢'' then ''bin''
        when @crs<=''靐'' then ''bing''
        when @crs<=''蔔'' then ''bo''
        when @crs<=''簿'' then ''bu''
        when @crs<=''囃'' then ''ca''
        when @crs<=''乲'' then ''cai''
        when @crs<=''爘'' then ''can''
        when @crs<=''賶'' then ''cang''
        when @crs<=''鼜'' then ''cao''
        when @crs<=''簎'' then ''ce''
        when @crs<=''笒'' then ''cen''
        when @crs<=''乽'' then ''ceng''
        when @crs<=''詫'' then ''cha''
        when @crs<=''囆'' then ''chai''
        when @crs<=''顫'' then ''chan''
        when @crs<=''韔'' then ''chang''
        when @crs<=''觘'' then ''chao''
        when @crs<=''爡'' then ''che''
        when @crs<=''讖'' then ''chen''
        when @crs<=''秤'' then ''cheng''
        when @crs<=''鷘'' then ''chi''
        when @crs<=''銃'' then ''chong''
        when @crs<=''殠'' then ''chou''
        when @crs<=''矗'' then ''chu''
        when @crs<=''踹'' then ''chuai''
        when @crs<=''鶨'' then ''chuan''
        when @crs<=''愴'' then ''chuang''
        when @crs<=''顀'' then ''chui''
        when @crs<=''蠢'' then ''chun''
        when @crs<=''縒'' then ''chuo''
        when @crs<=''嗭'' then ''ci''
        when @crs<=''謥'' then ''cong''
        when @crs<=''輳'' then ''cou''
        when @crs<=''顣'' then ''cu''
        when @crs<=''爨'' then ''cuan''
        when @crs<=''臎'' then ''cui''
        when @crs<=''籿'' then ''cun''
        when @crs<=''錯'' then ''cuo''
        when @crs<=''橽'' then ''da''
        when @crs<=''靆'' then ''dai''
        when @crs<=''饏'' then ''dan''
        when @crs<=''闣'' then ''dang''
        when @crs<=''纛'' then ''dao''
        when @crs<=''的'' then ''de''
        when @crs<=''扽'' then ''den''
        when @crs<=''鐙'' then ''deng''
        when @crs<=''螮'' then ''di''
        when @crs<=''嗲'' then ''dia''
        when @crs<=''驔'' then ''dian''
        when @crs<=''鑃'' then ''diao''
        when @crs<=''嚸'' then ''die''
        when @crs<=''顁'' then ''ding''
        when @crs<=''銩'' then ''diu''
        when @crs<=''霘'' then ''dong''
        when @crs<=''鬭'' then ''dou''
        when @crs<=''蠹'' then ''du''
        when @crs<=''叾'' then ''duan''
        when @crs<=''譵'' then ''dui''
        when @crs<=''踲'' then ''dun''
        when @crs<=''鵽'' then ''duo''
        when @crs<=''鱷'' then ''e''
        when @crs<=''摁'' then ''en''
        when @crs<=''鞥'' then ''eng''
        when @crs<=''樲'' then ''er''
        when @crs<=''髮'' then ''fa''
        when @crs<=''瀪'' then ''fan''
        when @crs<=''放'' then ''fang''
        when @crs<=''靅'' then ''fei''
        when @crs<=''鱝'' then ''fen''
        when @crs<=''覅'' then ''feng''
        when @crs<=''梻'' then ''fo''
        when @crs<=''鴀'' then ''fou''
        when @crs<=''猤'' then ''fu''
        when @crs<=''魀'' then ''ga''
        when @crs<=''瓂'' then ''gai''
        when @crs<=''灨'' then ''gan''
        when @crs<=''戇'' then ''gang''
        when @crs<=''鋯'' then ''gao''
        when @crs<=''獦'' then ''ge''
        when @crs<=''給'' then ''gei''
        when @crs<=''搄'' then ''gen''
        when @crs<=''堩'' then ''geng''
        when @crs<=''兣'' then ''gong''
        when @crs<=''購'' then ''gou''
        when @crs<=''顧'' then ''gu''
        when @crs<=''詿'' then ''gua''
        when @crs<=''恠'' then ''guai''
        when @crs<=''鱹'' then ''guan''
        when @crs<=''撗'' then ''guang''
        when @crs<=''鱥'' then ''gui''
        when @crs<=''謴'' then ''gun''
        when @crs<=''腂'' then ''guo''
        when @crs<=''哈'' then ''ha''
        when @crs<=''饚'' then ''hai''
        when @crs<=''鶾'' then ''han''
        when @crs<=''沆'' then ''hang''
        when @crs<=''兞'' then ''hao''
        when @crs<=''靏'' then ''he''
        when @crs<=''嬒'' then ''hei''
        when @crs<=''恨'' then ''hen''
        when @crs<=''堼'' then ''heng''
        when @crs<=''鬨'' then ''hong''
        when @crs<=''鱟'' then ''hou''
        when @crs<=''鸌'' then ''hu''
        when @crs<=''蘳'' then ''hua''
        when @crs<=''蘾'' then ''huai''
        when @crs<=''鰀'' then ''huan''
        when @crs<=''鎤'' then ''huang''
        when @crs<=''顪'' then ''hui''
        when @crs<=''諢'' then ''hun''
        when @crs<=''夻'' then ''huo''
        when @crs<=''驥'' then ''ji''
        when @crs<=''嗧'' then ''jia''
        when @crs<=''鑳'' then ''jian''
        when @crs<=''謽'' then ''jiang''
        when @crs<=''釂'' then ''jiao''
        when @crs<=''繲'' then ''jie''
        when @crs<=''齽'' then ''jin''
        when @crs<=''竸'' then ''jing''
        when @crs<=''蘔'' then ''jiong''
        when @crs<=''欍'' then ''jiu''
        when @crs<=''爠'' then ''ju''
        when @crs<=''羂'' then ''juan''
        when @crs<=''钁'' then ''jue''
        when @crs<=''攈'' then ''jun''
        when @crs<=''鉲'' then ''ka''
        when @crs<=''乫'' then ''kai''
        when @crs<=''矙'' then ''kan''
        when @crs<=''閌'' then ''kang''
        when @crs<=''鯌'' then ''kao''
        when @crs<=''騍'' then ''ke''
        when @crs<=''褃'' then ''ken''
        when @crs<=''鏗'' then ''keng''
        when @crs<=''廤'' then ''kong''
        when @crs<=''鷇'' then ''kou''
        when @crs<=''嚳'' then ''ku''
        when @crs<=''骻'' then ''kua''
        when @crs<=''鱠'' then ''kuai''
        when @crs<=''窾'' then ''kuan''
        when @crs<=''鑛'' then ''kuang''
        when @crs<=''鑎'' then ''kui''
        when @crs<=''睏'' then ''kun''
        when @crs<=''穒'' then ''kuo''
        when @crs<=''鞡'' then ''la''
        when @crs<=''籟'' then ''lai''
        when @crs<=''糷'' then ''lan''
        when @crs<=''唥'' then ''lang''
        when @crs<=''軂'' then ''lao''
        when @crs<=''餎'' then ''le''
        when @crs<=''脷'' then ''lei''
        when @crs<=''睖'' then ''leng''
        when @crs<=''瓈'' then ''li''
        when @crs<=''倆'' then ''lia''
        when @crs<=''纞'' then ''lian''
        when @crs<=''鍄'' then ''liang''
        when @crs<=''瞭'' then ''liao''
        when @crs<=''鱲'' then ''lie''
        when @crs<=''轥'' then ''lin''
        when @crs<=''炩'' then ''ling''
        when @crs<=''咯'' then ''liu''
        when @crs<=''贚'' then ''long''
        when @crs<=''鏤'' then ''lou''
        when @crs<=''氇'' then ''lu''
        when @crs<=''鑢'' then ''lv''
        when @crs<=''亂'' then ''luan''
        when @crs<=''擽'' then ''lue''
        when @crs<=''論'' then ''lun''
        when @crs<=''鱳'' then ''luo''
        when @crs<=''嘛'' then ''ma''
        when @crs<=''霢'' then ''mai''
        when @crs<=''蘰'' then ''man''
        when @crs<=''蠎'' then ''mang''
        when @crs<=''唜'' then ''mao''
        when @crs<=''癦'' then ''me''
        when @crs<=''嚜'' then ''mei''
        when @crs<=''們'' then ''men''
        when @crs<=''霥'' then ''meng''
        when @crs<=''羃'' then ''mi''
        when @crs<=''麵'' then ''mian''
        when @crs<=''廟'' then ''miao''
        when @crs<=''鱴'' then ''mie''
        when @crs<=''鰵'' then ''min''
        when @crs<=''詺'' then ''ming''
        when @crs<=''謬'' then ''miu''
        when @crs<=''耱'' then ''mo''
        when @crs<=''麰'' then ''mou''
        when @crs<=''旀'' then ''mu''
        when @crs<=''魶'' then ''na''
        when @crs<=''錼'' then ''nai''
        when @crs<=''婻'' then ''nan''
        when @crs<=''齉'' then ''nang''
        when @crs<=''臑'' then ''nao''
        when @crs<=''呢'' then ''ne''
        when @crs<=''焾'' then ''nei''
        when @crs<=''嫩'' then ''nen''
        when @crs<=''能'' then ''neng''
        when @crs<=''嬺'' then ''ni''
        when @crs<=''艌'' then ''nian''
        when @crs<=''釀'' then ''niang''
        when @crs<=''脲'' then ''niao''
        when @crs<=''钀'' then ''nie''
        when @crs<=''拰'' then ''nin''
        when @crs<=''濘'' then ''ning''
        when @crs<=''靵'' then ''niu''
        when @crs<=''齈'' then ''nong''
        when @crs<=''譳'' then ''nou''
        when @crs<=''搙'' then ''nu''
        when @crs<=''衄'' then ''nv''
        when @crs<=''瘧'' then ''nue''
        when @crs<=''燶'' then ''nuan''
        when @crs<=''桛'' then ''nuo''
        when @crs<=''鞰'' then ''o''
        when @crs<=''漚'' then ''ou''
        when @crs<=''袙'' then ''pa''
        when @crs<=''磗'' then ''pai''
        when @crs<=''鑻'' then ''pan''
        when @crs<=''胖'' then ''pang''
        when @crs<=''礮'' then ''pao''
        when @crs<=''轡'' then ''pei''
        when @crs<=''喯'' then ''pen''
        when @crs<=''喸'' then ''peng''
        when @crs<=''鸊'' then ''pi''
        when @crs<=''騙'' then ''pian''
        when @crs<=''慓'' then ''piao''
        when @crs<=''嫳'' then ''pie''
        when @crs<=''聘'' then ''pin''
        when @crs<=''蘋'' then ''ping''
        when @crs<=''魄'' then ''po''
        when @crs<=''哛'' then ''pou''
        when @crs<=''曝'' then ''pu''
        when @crs<=''蟿'' then ''qi''
        when @crs<=''髂'' then ''qia''
        when @crs<=''縴'' then ''qian''
        when @crs<=''瓩'' then ''qiang''
        when @crs<=''躈'' then ''qiao''
        when @crs<=''籡'' then ''qie''
        when @crs<=''藽'' then ''qin''
        when @crs<=''櫦'' then ''qing''
        when @crs<=''瓗'' then ''qiong''
        when @crs<=''糗'' then ''qiu''
        when @crs<=''覻'' then ''qu''
        when @crs<=''勸'' then ''quan''
        when @crs<=''礭'' then ''que''
        when @crs<=''囕'' then ''qun''
        when @crs<=''橪'' then ''ran''
        when @crs<=''讓'' then ''rang''
        when @crs<=''繞'' then ''rao''
        when @crs<=''熱'' then ''re''
        when @crs<=''餁'' then ''ren''
        when @crs<=''陾'' then ''reng''
        when @crs<=''馹'' then ''ri''
        when @crs<=''穃'' then ''rong''
        when @crs<=''嶿'' then ''rou''
        when @crs<=''擩'' then ''ru''
        when @crs<=''礝'' then ''ruan''
        when @crs<=''壡'' then ''rui''
        when @crs<=''橍'' then ''run''
        when @crs<=''鶸'' then ''ruo''
        when @crs<=''栍'' then ''sa''
        when @crs<=''虄'' then ''sai''
        when @crs<=''閐'' then ''san''
        when @crs<=''喪'' then ''sang''
        when @crs<=''髞'' then ''sao''
        when @crs<=''飋'' then ''se''
        when @crs<=''篸'' then ''sen''
        when @crs<=''縇'' then ''seng''
        when @crs<=''霎'' then ''sha''
        when @crs<=''曬'' then ''shai''
        when @crs<=''鱔'' then ''shan''
        when @crs<=''緔'' then ''shang''
        when @crs<=''潲'' then ''shao''
        when @crs<=''欇'' then ''she''
        when @crs<=''瘮'' then ''shen''
        when @crs<=''賸'' then ''sheng''
        when @crs<=''瓧'' then ''shi''
        when @crs<=''鏉'' then ''shou''
        when @crs<=''虪'' then ''shu''
        when @crs<=''誜'' then ''shua''
        when @crs<=''卛'' then ''shuai''
        when @crs<=''腨'' then ''shuan''
        when @crs<=''灀'' then ''shuang''
        when @crs<=''睡'' then ''shui''
        when @crs<=''鬊'' then ''shun''
        when @crs<=''鑠'' then ''shuo''
        when @crs<=''乺'' then ''si''
        when @crs<=''鎹'' then ''song''
        when @crs<=''瘶'' then ''sou''
        when @crs<=''鷫'' then ''su''
        when @crs<=''算'' then ''suan''
        when @crs<=''鐩'' then ''sui''
        when @crs<=''潠'' then ''sun''
        when @crs<=''蜶'' then ''suo''
        when @crs<=''襨'' then ''ta''
        when @crs<=''燤'' then ''tai''
        when @crs<=''賧'' then ''tan''
        when @crs<=''燙'' then ''tang''
        when @crs<=''畓'' then ''tao''
        when @crs<=''蟘'' then ''te''
        when @crs<=''朰'' then ''teng''
        when @crs<=''趯'' then ''ti''
        when @crs<=''舚'' then ''tian''
        when @crs<=''糶'' then ''tiao''
        when @crs<=''餮'' then ''tie''
        when @crs<=''乭'' then ''ting''
        when @crs<=''憅'' then ''tong''
        when @crs<=''透'' then ''tou''
        when @crs<=''鵵'' then ''tu''
        when @crs<=''褖'' then ''tuan''
        when @crs<=''駾'' then ''tui''
        when @crs<=''坉'' then ''tun''
        when @crs<=''籜'' then ''tuo''
        when @crs<=''韤'' then ''wa''
        when @crs<=''顡'' then ''wai''
        when @crs<=''贎'' then ''wan''
        when @crs<=''朢'' then ''wang''
        when @crs<=''躛'' then ''wei''
        when @crs<=''璺'' then ''wen''
        when @crs<=''齆'' then ''weng''
        when @crs<=''齷'' then ''wo''
        when @crs<=''鶩'' then ''wu''
        when @crs<=''衋'' then ''xi''
        when @crs<=''鏬'' then ''xia''
        when @crs<=''鼸'' then ''xian''
        when @crs<=''鱌'' then ''xiang''
        when @crs<=''斆'' then ''xiao''
        when @crs<=''躞'' then ''xie''
        when @crs<=''釁'' then ''xin''
        when @crs<=''臖'' then ''xing''
        when @crs<=''敻'' then ''xiong''
        when @crs<=''齅'' then ''xiu''
        when @crs<=''蓿'' then ''xu''
        when @crs<=''贙'' then ''xuan''
        when @crs<=''瀥'' then ''xue''
        when @crs<=''鑂'' then ''xun''
        when @crs<=''齾'' then ''ya''
        when @crs<=''灩'' then ''yan''
        when @crs<=''樣'' then ''yang''
        when @crs<=''鑰'' then ''yao''
        when @crs<=''岃'' then ''ye''
        when @crs<=''齸'' then ''yi''
        when @crs<=''檼'' then ''yin''
        when @crs<=''譍'' then ''ying''
        when @crs<=''喲'' then ''yo''
        when @crs<=''醟'' then ''yong''
        when @crs<=''鼬'' then ''you''
        when @crs<=''爩'' then ''yu''
        when @crs<=''願'' then ''yuan''
        when @crs<=''鸙'' then ''yue''
        when @crs<=''韻'' then ''yun''
        when @crs<=''雥'' then ''za''
        when @crs<=''縡'' then ''zai''
        when @crs<=''饡'' then ''zan''
        when @crs<=''臟'' then ''zang''
        when @crs<=''竈'' then ''zao''
        when @crs<=''稄'' then ''ze''
        when @crs<=''鱡'' then ''zei''
        when @crs<=''囎'' then ''zen''
        when @crs<=''贈'' then ''zeng''
        when @crs<=''醡'' then ''zha''
        when @crs<=''瘵'' then ''zhai''
        when @crs<=''驏'' then ''zhan''
        when @crs<=''瞕'' then ''zhang''
        when @crs<=''羄'' then ''zhao''
        when @crs<=''鷓'' then ''zhe''
        when @crs<=''黮'' then ''zhen''
        when @crs<=''證'' then ''zheng''
        when @crs<=''豒'' then ''zhi''
        when @crs<=''諥'' then ''zhong''
        when @crs<=''驟'' then ''zhou''
        when @crs<=''鑄'' then ''zhu''
        when @crs<=''爪'' then ''zhua''
        when @crs<=''跩'' then ''zhuai''
        when @crs<=''籑'' then ''zhuan''
        when @crs<=''戅'' then ''zhuang''
        when @crs<=''鑆'' then ''zhui''
        when @crs<=''稕'' then ''zhun''
        when @crs<=''籱'' then ''zhuo''
        when @crs<=''漬'' then ''zi''
        when @crs<=''縱'' then ''zong''
        when @crs<=''媰'' then ''zou''
        when @crs<=''謯'' then ''zu''
        when @crs<=''攥'' then ''zuan''
        when @crs<=''欈'' then ''zui''
        when @crs<=''銌'' then ''zun''
        when @crs<=''咗'' then ''zuo''
        else  @crs end+''''+@re,@strlen=@strlen-1 
   end
 return(@re)
end

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_PINYIN_DEPAND_TABLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_PINYIN_DEPAND_TABLE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[FUNC_GET_PINYIN_DEPAND_TABLE](@STR NVARCHAR(2000))   
RETURNS VARCHAR(8000)   
AS  
BEGIN  
declare @re varchar(8000)
DECLARE @STRLEN AS INT 
 SELECT @STRLEN=LEN(@STR),@RE=''''
 WHILE @STRLEN>0
 BEGIN     
      SELECT TOP 1 @RE=UPPER(SUBSTRING(PY,1,1) )+SUBSTRING(PY,2,LEN(PY))+@RE,@STRLEN=@STRLEN-1 
      FROM ENT_PINYIN3 A WHERE CHR<=SUBSTRING(@STR,@STRLEN,1) 
      ORDER BY CHR COLLATE CHINESE_PRC_CS_AS_KS_WS  DESC 
      IF @@ROWCOUNT=0
        SELECT @RE=SUBSTRING(@STR,@STRLEN,1)+@RE,@STRLEN=@STRLEN-1
   END
 RETURN(@RE)  
END  
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_REQUEST_PROPERTY_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_REQUEST_PROPERTY_VALUE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	根据请求ID和请求
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_REQUEST_PROPERTY_VALUE]
(
	@REQUEST_ID NVARCHAR(120)
	,@PROPERTY_NAME NVARCHAR(120)
)
RETURNS NVARCHAR(4000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PROPERTY_VALUE NVARCHAR(4000)

	SELECT
        @PROPERTY_VALUE = [PROPERTY_VALUE]
    FROM  TBL_REQUEST_PROPERTY
	WHERE	[REQUEST_ID] = @REQUEST_ID
		AND [PROPERTY_NAME] = @PROPERTY_NAME
	
	RETURN @PROPERTY_VALUE

END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_REQUEST_PROPERTY_VALUE_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_REQUEST_PROPERTY_VALUE_V2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	根据请求ID和请求
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_REQUEST_PROPERTY_VALUE_V2]
(
	@REQUEST_ID NVARCHAR(120)
	,@PROPERTY_NAME NVARCHAR(120)
)
RETURNS NVARCHAR(4000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PROPERTY_VALUE NVARCHAR(120)
	EXEC SP_GET_REQUEST_PROPERTY_VALUE_V2 @REQUEST_ID, @PROPERTY_NAME, @PROPERTY_VALUE OUTPUT
	RETURN @PROPERTY_VALUE

END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ROBOT_ID_BY_SN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_ROBOT_ID_BY_SN]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-7
-- Description:	根据SN号获取ID
-- =============================================
CREATE   FUNCTION [dbo].[FUNC_GET_ROBOT_ID_BY_SN]
(
	@SN NVARCHAR(50)
)
RETURNS BIGINT
AS
BEGIN
	RETURN
	(
		SELECT [ID]
		FROM   [ENT_ROBOT]
		WHERE  IMEI = @SN
	)	
END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ROBOT_SN_BY_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_ROBOT_SN_BY_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-7
-- Description:	根据SN号获取ID
-- =============================================
CREATE   FUNCTION [dbo].[FUNC_GET_ROBOT_SN_BY_ID]
(
	@ROBOT_ID  BIGINT
)
RETURNS NVARCHAR(50)
AS
BEGIN
	RETURN
	(
		SELECT IMEI
		FROM   [ENT_ROBOT]
		WHERE  ID = @ROBOT_ID
	)	
END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_ROBOT_SN_LIST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_ROBOT_SN_LIST]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-04
-- Description:	获取公司下的机器人列表
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_ROBOT_SN_LIST]
(
	@USER_GROUP_ID BIGINT
)
RETURNS NVARCHAR(max)
AS
BEGIN
	DECLARE @IMEIS NVARCHAR(max)
	SET @IMEIS = ''''
	 

	SELECT
			@IMEIS = @IMEIS + 
			(
				CASE @IMEIS WHEN '''' THEN  ('''''''' +   [ROBOT_IMEI]  + '''''''' )
									ELSE  ('','''''' +  [ROBOT_IMEI]  + '''''''')	
				END
			)
	  FROM [VIEW_ROBOT_USER_BINDLIST]
	WHERE  [ACTIVDATE_USER_ID] = @USER_GROUP_ID 
	ORDER BY [ROBOT_IMEI]

	RETURN   ''('' + CASE @IMEIS WHEN '''' THEN '''''''''''' ELSE @IMEIS END + '')''
END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_TAGS_TABLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_TAGS_TABLE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-26
-- Description:	根据逗号分割数据产生tag表
-- a, b, c 产生 tags 表 包含 a b c 三行数据
-- =============================================
CREATE FUNCTION  [dbo].[FUNC_GET_TAGS_TABLE]
(	
	@TAG_STR AS VARCHAR(4000)
)
RETURNS @TAGS TABLE(TAG NVARCHAR(120) NOT NULL PRIMARY KEY, IDX BIGINT DEFAULT 0, AMOUNT BIGINT DEFAULT 0 ) 
AS
 BEGIN 
 
	--  
	-- DECLARE @TAGS Table(TAG nvarchar(50) not null)

	DECLARE @B INT
	DECLARE @E INT
	DECLARE @LEN INT
	DECLARE @COUNT INT
	DECLARE @ITEM NVARCHAR(120)

	SET @B = 1
	SET @E = 1
	SET @LEN = LEN(@TAG_STR)+1
	SET @COUNT = 0

	WHILE @E < @LEN
	BEGIN
		SET @E  = CHARINDEX('','', @TAG_STR, @B)  
		
		SET @E = (CASE @E WHEN 0 THEN @LEN  ELSE @E END)
		SET @ITEM = SUBSTRING(@TAG_STR,  @B, @E-@B)
		SET @ITEM = LTRIM(RTRIM(@ITEM))

		IF @ITEM <> ''''
			IF (NOT EXISTS(SELECT * FROM @TAGS WHERE TAG = @ITEM))
			BEGIN
				SET @COUNT = @COUNT + 1
				INSERT INTO @TAGS (TAG, IDX)VALUES (@ITEM, @COUNT)
			END

		SET @B = @E + 1
	END 
	
	UPDATE @TAGS SET AMOUNT = @COUNT
	RETURN  

END 




' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_THIRD_PARTY_API_PARAMS_STRING]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_THIRD_PARTY_API_PARAMS_STRING]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-23
-- Description:	第三方服务的 参数拼装
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_THIRD_PARTY_API_PARAMS_STRING]
(
	  @THIRD_PARTY_API_ID as BIGINT -- API ID
	, @IS_HEADER as bit				-- 是否为HEADER
	, @THIRD_PARTY_API_PARAMS_VALUE_ID    AS BIGINT  -- 参数
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @RET  AS NVARCHAR(MAX)
DECLARE @PARAM_NAME AS NVARCHAR(50)
DECLARE @DEFAULT_VALUE AS NVARCHAR(500)
DECLARE @VALUE AS NVARCHAR(2000)


SET @RET = ''''

DECLARE CUR_GET_TP_PARAMS
CURSOR FOR SELECT 
       [PARAM_NAME]
	  , DEFAULT_VALUE
  FROM  VIEW_VALID_THIRD_PARTY_API_PARAMS WHERE [ID] = @THIRD_PARTY_API_ID AND [HEADER_0_BODY_1] = @IS_HEADER

OPEN CUR_GET_TP_PARAMS
FETCH NEXT FROM CUR_GET_TP_PARAMS INTO 
	  @PARAM_NAME, @DEFAULT_VALUE

WHILE @@FETCH_STATUS = 0
BEGIN
	

	SET @VALUE = NULL
	IF @THIRD_PARTY_API_PARAMS_VALUE_ID IS NOT NULL
		SELECT @VALUE = [PARAM_VALUE]
		FROM [TBL_THIRD_PARTY_API_PARAMS_VALUE]
		WHERE [THIRD_PARTY_API_PARAM_NAME] = @PARAM_NAME 
		AND   [THIRD_PARTY_API_ID] = @THIRD_PARTY_API_ID
		AND   [ID] = @THIRD_PARTY_API_PARAMS_VALUE_ID

	IF @VALUE IS NULL
		SET @VALUE = @DEFAULT_VALUE

	IF @VALUE IS NOT NULL 
	BEGIN
		IF @RET <> ''''
			SET @RET = @RET + ''&''

		SET @RET = @RET + @PARAM_NAME + ''='' + @VALUE
	END

	FETCH NEXT FROM CUR_GET_TP_PARAMS INTO 
	@PARAM_NAME, @DEFAULT_VALUE
END
CLOSE CUR_GET_TP_PARAMS
DEALLOCATE CUR_GET_TP_PARAMS


RETURN @RET  
END





' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-20
-- Description:	第三方服务的 参数拼装 新版本
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2]
(
	  @THIRD_PARTY_API_ID as BIGINT -- API ID
	, @IS_HEADER as bit				-- 是否为HEADER
	, @THIRD_PARTY_API_PARAMS_VALUE_ID    AS BIGINT  -- 参数
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @RET  AS NVARCHAR(MAX)
DECLARE @PARAM_NAME AS NVARCHAR(50)
DECLARE @PARAM_ID AS BIGINT

DECLARE @DEFAULT_VALUE AS NVARCHAR(500)
DECLARE @VALUE AS NVARCHAR(2000)



SET @RET = ''''

IF ISNULL(@THIRD_PARTY_API_ID, 0) = 0
	RETURN @RET

DECLARE CUR_GET_TP_PARAMS
CURSOR FOR SELECT 
        VIEW_VALID_THIRD_PARTY_API_PARAMS_V2.PARAM_ID
	  , VIEW_VALID_THIRD_PARTY_API_PARAMS_V2.PARAM_NAME
	  , VIEW_VALID_THIRD_PARTY_API_PARAMS_V2.DEFAULT_VALUE
  FROM  VIEW_VALID_THIRD_PARTY_API_PARAMS_V2 WHERE VIEW_VALID_THIRD_PARTY_API_PARAMS_V2.API_ID = @THIRD_PARTY_API_ID 
  AND [HEADER_0_BODY_1] = @IS_HEADER

OPEN CUR_GET_TP_PARAMS
FETCH NEXT FROM CUR_GET_TP_PARAMS INTO 
	  @PARAM_ID, @PARAM_NAME, @DEFAULT_VALUE

WHILE @@FETCH_STATUS = 0
BEGIN
	

	SET @VALUE = NULL
	IF @THIRD_PARTY_API_PARAMS_VALUE_ID IS NOT NULL
		SELECT @VALUE = [PARAM_VALUE]
		FROM [TBL_THIRD_PARTY_API_PARAM_VALUE]
		WHERE [TBL_THIRD_PARTY_API_PARAM_VALUE].THIRD_PARTY_API_PARAM_ID = @PARAM_ID
		AND   [TBL_THIRD_PARTY_API_PARAM_VALUE].THIRD_PARTY_API_PARAM_VALUE_ID = @THIRD_PARTY_API_PARAMS_VALUE_ID


	IF @VALUE IS NULL
		SET @VALUE = @DEFAULT_VALUE

	IF @VALUE IS NOT NULL 
	BEGIN
		IF @RET <> ''''
			SET @RET = @RET + ''&''

		SET @RET = @RET + @PARAM_NAME + ''='' + @VALUE
	END

	FETCH NEXT FROM CUR_GET_TP_PARAMS INTO 
	@PARAM_ID, @PARAM_NAME, @DEFAULT_VALUE
END
CLOSE CUR_GET_TP_PARAMS
DEALLOCATE CUR_GET_TP_PARAMS


RETURN @RET  
END





' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_VOICE_COUNT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_VOICE_COUNT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-12
-- Description:	获得应答组总数
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_VOICE_COUNT]
(
	 @VOICE_GROUP_ID AS BIGINT
	,@MODEL AS NVARCHAR(1024)  
)
RETURNS BIGINT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @VOICE_COUNT AS BIGINT

	IF @VOICE_GROUP_ID = -1
	BEGIN
		SELECT @VOICE_COUNT = COUNT(*)
		FROM VIEW_VOICE_GROUP
		WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
		AND (CHARINDEX(@MODEL, ISNULL(VOICE_INC_PROP, @MODEL))>0)
		AND (CHARINDEX(@MODEL, ISNULL(VOICE_EXC_PROP, REVERSE(@MODEL))) = 0)
		AND VOICE_CAT = ''2''

		-- PRINT ''UNDETIFY GROUP''
	END
	ELSE
	BEGIN
		SELECT @VOICE_COUNT = COUNT(*)
		FROM VIEW_VOICE_GROUP
		WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
		AND (CHARINDEX(@MODEL, ISNULL(VOICE_INC_PROP, @MODEL))>0)
		AND (CHARINDEX(@MODEL, ISNULL(VOICE_EXC_PROP, REVERSE(@MODEL))) = 0)

		-- PRINT ''NORMAL GROUP''
	END

	RETURN @VOICE_COUNT

END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_VOICE_COUNT_BY_ROBOT_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_VOICE_COUNT_BY_ROBOT_ID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-12
-- Description:	获得应答组总数以ROBOT_ID
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_VOICE_COUNT_BY_ROBOT_ID]
(
	 @VOICE_GROUP_ID AS BIGINT
	,@ROBOT_ID AS BIGINT
)
RETURNS BIGINT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @VOICE_COUNT AS BIGINT

	IF @VOICE_GROUP_ID = -1
	BEGIN
		SELECT @VOICE_COUNT = COUNT(VIEW_VOICE_GROUP.ID)
		FROM VIEW_VOICE_GROUP
		WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
 	    AND dbo.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID](VOICE_INC_PROP, @ROBOT_ID) = 1
 		AND VOICE_CAT = ''2''

 	END
	ELSE
	BEGIN
		SELECT @VOICE_COUNT = COUNT(VIEW_VOICE_GROUP.ID)
		FROM VIEW_VOICE_GROUP
		WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
 	    AND dbo.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID](VOICE_INC_PROP, @ROBOT_ID) = 1
	END

	RETURN @VOICE_COUNT

END


' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_VOICE_COUNT_BY_TAGS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_GET_VOICE_COUNT_BY_TAGS]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-12
-- Description:	获得应答组总数以tags
-- =============================================
CREATE FUNCTION [dbo].[FUNC_GET_VOICE_COUNT_BY_TAGS]
(
	 @VOICE_GROUP_ID AS BIGINT
	,@TAGS AS NVARCHAR(1024)  
)
RETURNS BIGINT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @VOICE_COUNT AS BIGINT

	IF @VOICE_GROUP_ID = -1
	BEGIN
		SELECT @VOICE_COUNT = COUNT(*)
		FROM VIEW_VOICE_GROUP
		WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
 	    AND DBO.FUNC_AUTHENTICATE_PASSPORT(@TAGS, VOICE_INC_PROP) = 1
		AND VOICE_CAT = ''2''

 	END
	ELSE
	BEGIN
		SELECT @VOICE_COUNT = COUNT(*)
		FROM VIEW_VOICE_GROUP
		WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
 	    AND DBO.FUNC_AUTHENTICATE_PASSPORT(@TAGS, VOICE_INC_PROP) = 1
	END

	RETURN @VOICE_COUNT

END

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_HAS_CURRENT_SESSION_EXPIRED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_HAS_CURRENT_SESSION_EXPIRED]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-3-30
-- Description:	判断当前登录是否有效
-- =============================================
CREATE FUNCTION [dbo].[FUNC_HAS_CURRENT_SESSION_EXPIRED]
(
	@SESSION_ID NVARCHAR(4000)
)
RETURNS BIT
AS
BEGIN

	DECLARE @RET BIT
	SET @RET = 0

	IF NOT EXISTS(
	SELECT   USER_LASTEST_STATUS_WSS_SESSION_ID  FROM VIEW_USER_ROBOT_BIND_LIST WHERE USER_LASTEST_STATUS_WSS_SESSION_ID = @SESSION_ID)
		SET @RET  = 1

	RETURN  @RET
END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_IS_ADMIN_ACCOUNT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_IS_ADMIN_ACCOUNT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-3-27
-- Description:	判断是否是管理员账号
-- =============================================
CREATE FUNCTION [dbo].[FUNC_IS_ADMIN_ACCOUNT]
(
	-- Add the parameters for the function here
	@USER_NAME NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @RET BIT

	-- Add the T-SQL statements to compute the return value here
	IF 	EXISTS(SELECT NAME FROM ENT_ADMIN WHERE NAME = @USER_NAME)
		SET @RET = 1
	ELSE
		SET @RET = 0

	-- Return the result of the function
	RETURN @RET

END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_IS_FULLY_MATCHED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_IS_FULLY_MATCHED]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-17
-- Description:	判断是否严格匹配
-- =============================================
CREATE FUNCTION [dbo].[FUNC_IS_FULLY_MATCHED] 
(
	  @INPUT AS NVARCHAR(4000)
	, @FLOW_ID AS BIGINT
)
RETURNS BIT
AS
BEGIN
	DECLARE @INPUT_IT AS NVARCHAR(4000)
	 
	SET @INPUT_IT = @INPUT

	SELECT @INPUT_IT = REPLACE(@INPUT_IT, KEY_WORD, '''') 
	FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
	WHERE 
	(CHARINDEX([KEY_WORD], @INPUT) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 1) AND ENABLE = 1
	AND KEY_WORD_GROUP_FLOW_ID = @FLOW_ID
	GROUP BY KEY_WORD_GROUP_FLOW_ID, VOICE_GROUP_ID,KEY_WORD_GROUP_ID,KEY_WORD
	ORDER BY KEY_WORD_GROUP_FLOW_ID DESC

  	RETURN CASE WHEN @INPUT_IT <> '''' THEN 0 ELSE 1 END
END

' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_IS_USER_IN_SAME_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_IS_USER_IN_SAME_GROUP]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-24
-- Description:	判断两个用户是否同属一个组织
-- =============================================
CREATE FUNCTION [dbo].[FUNC_IS_USER_IN_SAME_GROUP]
(
	 @USER_ID_1 BIGINT
	,@USER_ID_2 BIGINT
)
RETURNS BIT
AS
BEGIN

	DECLARE @GID_1 AS BIGINT
	DECLARE @GID_2 AS BIGINT

	SET @GID_1 = (SELECT [USER_GROUP_ID] FROM [ENT_USER]  WHERE ID = @USER_ID_1)
	SET @GID_2 = (SELECT [USER_GROUP_ID] FROM [ENT_USER]  WHERE ID = @USER_ID_2)
 
	RETURN CASE  WHEN @GID_1 = @GID_2 THEN 1 ELSE 0 END
END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_KEYWORD_MODIFIER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_KEYWORD_MODIFIER]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-24
-- Description:	修改搜索关键字
-- =============================================
CREATE FUNCTION [dbo].[FUNC_KEYWORD_MODIFIER]
(
	-- Add the parameters for the function here
	@KW nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	SET @KW =  (case @KW when ''null'' then '''' else @KW  end )
	SET @KW = ''%'' + ISNULL(@KW, '''') + ''%''
	RETURN @KW
END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_PINYIN_CONVERT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_PINYIN_CONVERT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-1-5
-- Description:	拼音转换，模糊计算
-- =============================================
CREATE FUNCTION [dbo].[FUNC_PINYIN_CONVERT] 
(
	@SOURCE VARCHAR(4000)
)
RETURNS VARCHAR(4000)
AS
BEGIN 

	-- Add the T-SQL statements to compute the return value here
	SELECT @SOURCE = REPLACE(@SOURCE, [SOURCE], [DESTINATION] )
	FROM ENT_PINYIN_COVERTOR
	WHERE ENABLED = 1

	-- Return the result of the function
	RETURN @SOURCE

END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_VERIFY_CLIENT_WORDS_VERSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_VERIFY_CLIENT_WORDS_VERSION]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-4-30
-- Description:	验证语料编辑工具客户端版本是否合法
-- =============================================
CREATE FUNCTION [dbo].[FUNC_VERIFY_CLIENT_WORDS_VERSION]
(
	 @VERSION  nvarchar(20)
)
RETURNS BIT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ret bit

	if isnull( @VERSION ,'''') < ''1.4.3''
		set @ret = 0
	else
		set @ret = 1

	return @ret

END
' 
END

GO
/****** Object:  Table [dbo].[ENT_ADMIN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ADMIN]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_ADMIN](
	[ID] [bigint] NOT NULL CONSTRAINT [DF_ENT_ADMIN_ID]  DEFAULT (CONVERT([bigint],datediff(second,'1970-1-1 00:00:00',getdate()),(0))*(1000)+datepart(millisecond,getdate())),
	[NAME] [nvarchar](50) NOT NULL,
	[PASSWORD] [nvarchar](50) NOT NULL,
	[EMAIL] [nvarchar](100) NOT NULL,
	[RIGHTS] [bigint] NOT NULL,
	[ENABLED] [bit] NOT NULL,
 CONSTRAINT [PK_ENT_ADMIN] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_BIZ_MENU_ENTRY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_BIZ_MENU_ENTRY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_BIZ_MENU_ENTRY](
	[NAME] [nvarchar](50) NOT NULL,
	[LABEL] [nvarchar](500) NOT NULL CONSTRAINT [DF_ENT_BIZ_MENU_ENTRY_LABEL]  DEFAULT (N'请选择业务'),
	[DESCRIPTION] [nvarchar](250) NULL,
 CONSTRAINT [PK_ENT_BIZ_MENU_ENTRY] PRIMARY KEY CLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_CONFIG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_CONFIG](
	[NAME] [nvarchar](256) NOT NULL,
	[OWNER_ID] [bigint] NOT NULL CONSTRAINT [DF_ENT_CONFIG_OWNER_ID]  DEFAULT ((0)),
	[OWNER_TYPE] [bigint] NOT NULL CONSTRAINT [DF_ENT_CONFIG_OWNER_TYPE]  DEFAULT ((1)),
	[TYPE] [varchar](50) NOT NULL CONSTRAINT [DF_ENT_CONFIG_TYPE]  DEFAULT ('string'),
	[VALUE] [nvarchar](max) NOT NULL,
	[LEVEL] [bigint] NOT NULL CONSTRAINT [DF_ENT_CONFIG_LEVEL]  DEFAULT ((0)),
	[LIMIT_L] [varchar](50) NULL,
	[LIMIT_H] [varchar](50) NULL,
	[CANDIDATE] [nvarchar](4000) NULL,
	[PATTERN] [varchar](50) NULL,
	[DESCRIPTION] [nvarchar](128) NOT NULL,
	[UI_ORDER] [bigint] NOT NULL CONSTRAINT [DF_ENT_CONFIG_UI_ORDER]  DEFAULT ((0)),
 CONSTRAINT [PK_ENT_CONFIG] PRIMARY KEY CLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ENT_CONFIG_BAKUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_CONFIG_BAKUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_CONFIG_BAKUP](
	[NAME] [nvarchar](256) NULL,
	[TYPE] [varchar](50) NULL,
	[VALUE] [nvarchar](max) NULL,
	[LEVEL] [bigint] NULL,
	[LIMIT_L] [varchar](50) NULL,
	[LIMIT_H] [varchar](50) NULL,
	[CANDIDATE] [nvarchar](4000) NULL,
	[PATTERN] [varchar](50) NULL,
	[DESCRIPTION] [nvarchar](128) NULL,
	[OWNER_ID] [bigint] NULL,
	[OWNER_TYPE] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ENT_CONFIG_MODULE_BIT_MASK]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_CONFIG_MODULE_BIT_MASK]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_CONFIG_MODULE_BIT_MASK](
	[NAME] [nvarchar](50) NOT NULL,
	[VALUE] [bigint] NOT NULL,
	[ENABLED] [bit] NOT NULL CONSTRAINT [DF_ENT_CONFIG_MODULE_BIT_MASK_ENABLED]  DEFAULT ((1))
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_CUSTOMER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_CUSTOMER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_CUSTOMER](
	[ID] [nvarchar](100) NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[NICK_NAME] [nvarchar](50) NULL,
	[ENGLISH_NAME] [nvarchar](50) NULL,
	[SEX] [bit] NULL,
	[CUSTOMER_GROUP_ID] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ENT_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_DB_VERSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_DB_VERSION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_DB_VERSION](
	[NAME] [nvarchar](50) NOT NULL,
	[PUB_DATETIME] [datetime] NULL CONSTRAINT [DF_ENT_DB_VERSION_PUB_DATETIME]  DEFAULT (getdate()),
	[DESCRIPTION] [nvarchar](max) NOT NULL,
	[SCRIPTS] [nvarchar](max) NULL,
 CONSTRAINT [PK_ENT_DB_VERSION] PRIMARY KEY CLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_DIALOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_DIALOG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_DIALOG](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[REQUEST] [nvarchar](max) NOT NULL,
	[REQUEST_EP_SN] [nvarchar](250) NULL,
	[REQUEST_MODEL] [nvarchar](4000) NULL,
	[REQUEST_CLIENT_IP] [nvarchar](50) NULL,
	[REQUEST_CLIENT_VERSION] [nvarchar](120) NULL,
	[REQUEST_ADDR] [nvarchar](2000) NULL,
	[RESPONSE_1] [nvarchar](max) NULL,
	[RESPONSE_2] [nvarchar](max) NULL,
	[RESPONSE_3] [nvarchar](max) NULL,
	[RESPONSE_4] [nvarchar](max) NULL,
	[RESPONSE_5] [nvarchar](max) NULL,
	[RESPONSE_6] [nvarchar](max) NULL,
	[RESPONSE_7] [nvarchar](max) NULL,
	[RESPONSE_8] [nvarchar](max) NULL,
	[RESPONSE_9] [nvarchar](max) NULL,
	[RESPONSE_10] [nvarchar](max) NULL,
	[RESPONSE_11] [nvarchar](max) NULL,
	[RESPONSE_12] [nvarchar](max) NULL,
	[RESPONSE_13] [nvarchar](max) NULL,
	[RESPONSE_14] [nvarchar](max) NULL,
	[RESPONSE_15] [nvarchar](max) NULL,
	[RESPONSE_16] [nvarchar](max) NULL,
	[EXEC_MILLSECS] [bigint] NULL,
	[DATE_TIME] [datetime] NOT NULL CONSTRAINT [DF_ENT_DIALOG_DATETIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_ENT_DIALOG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_DIALOG_BACKUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_DIALOG_BACKUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_DIALOG_BACKUP](
	[ID] [bigint] NOT NULL,
	[REQUEST] [nvarchar](max) NOT NULL,
	[REQUEST_EP_SN] [nvarchar](250) NULL,
	[REQUEST_MODEL] [nvarchar](4000) NULL,
	[REQUEST_CLIENT_IP] [nvarchar](50) NULL,
	[REQUEST_CLIENT_VERSION] [nvarchar](120) NULL,
	[REQUEST_ADDR] [nvarchar](2000) NULL,
	[RESPONSE_1] [nvarchar](max) NULL,
	[RESPONSE_2] [nvarchar](max) NULL,
	[RESPONSE_3] [nvarchar](max) NULL,
	[RESPONSE_4] [nvarchar](max) NULL,
	[RESPONSE_5] [nvarchar](max) NULL,
	[RESPONSE_6] [nvarchar](max) NULL,
	[RESPONSE_7] [nvarchar](max) NULL,
	[RESPONSE_8] [nvarchar](max) NULL,
	[RESPONSE_9] [nvarchar](max) NULL,
	[RESPONSE_10] [nvarchar](max) NULL,
	[RESPONSE_11] [nvarchar](max) NULL,
	[RESPONSE_12] [nvarchar](max) NULL,
	[RESPONSE_13] [nvarchar](max) NULL,
	[RESPONSE_14] [nvarchar](max) NULL,
	[RESPONSE_15] [nvarchar](max) NULL,
	[RESPONSE_16] [nvarchar](max) NULL,
	[EXEC_MILLSECS] [bigint] NULL,
	[DATE_TIME] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_ENTITY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ENTITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_ENTITY](
	[TYPE] [nvarchar](50) NOT NULL,
	[NAME] [nvarchar](500) NOT NULL,
	[VALUE] [nvarchar](4000) NOT NULL,
	[ENABLED] [bit] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_EXAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_EXAM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_EXAM](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DESCRIPTION] [nvarchar](50) NULL,
 CONSTRAINT [PK_ENT_EXAM] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_FEEDBACK]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_FEEDBACK]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_FEEDBACK](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[USER] [varchar](50) NOT NULL,
	[E_MAIL] [varchar](128) NOT NULL,
	[TITLE] [varchar](256) NOT NULL,
	[CONTENT] [varchar](4000) NOT NULL,
	[TIME] [datetime] NOT NULL CONSTRAINT [DF_ENT_FEEDBACK_TIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_TBL_FEEDBACK] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[CNAME] [nvarchar](50) NULL,
	[FULL_NAME] [nvarchar](300) NOT NULL,
	[ENABLED] [bit] NOT NULL CONSTRAINT [DF_ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY_ENABLED]  DEFAULT ((1)),
 CONSTRAINT [PK_ENT_HUAQIN_2016_PROVIDER_COMPANY] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_HW_SPEC]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_HW_SPEC]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_HW_SPEC](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[ENABLED] [bit] NOT NULL,
	[DESCRIPTION] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_ENT_HW_SPEC] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_INDUSTRY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_INDUSTRY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_INDUSTRY](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[ENABLED] [bit] NOT NULL,
	[DESCRIPTION] [nvarchar](250) NOT NULL,
	[TAG] [nvarchar](50) NULL,
 CONSTRAINT [PK_ENT_INDUSTRY] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_KEY_WORDS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_KEY_WORDS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_KEY_WORDS](
	[ID] [bigint] NOT NULL,
	[KW] [nvarchar](8) NOT NULL,
	[CAT] [bigint] NOT NULL CONSTRAINT [DF_ENT_KEY_WORDS_CAT]  DEFAULT ((0)),
	[SOUND] [varchar](128) NOT NULL,
 CONSTRAINT [PK_ENT_KEY_WORDS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ENT_OPERATION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_OPERATION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_OPERATION](
	[NAME] [nvarchar](50) NOT NULL,
	[BIT_ORDER] [smallint] NOT NULL,
	[DESCRIPTION] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_ENT_OPERATION] PRIMARY KEY CLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_PINYIN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_PINYIN]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_PINYIN](
	[ID] [bigint] NOT NULL,
	[NAME] [varchar](8) NOT NULL,
	[DESCRIPTION] [nvarchar](50) NOT NULL CONSTRAINT [DF_ENT_PINYIN_DESCRIPTION]  DEFAULT (N'N/A'),
 CONSTRAINT [PK_ENT_PINYIN] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ENT_PINYIN_COVERTOR]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_PINYIN_COVERTOR]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_PINYIN_COVERTOR](
	[SOURCE] [varchar](10) NOT NULL,
	[DESTINATION] [varchar](10) NOT NULL,
	[ENABLED] [bit] NOT NULL CONSTRAINT [DF_ENT_PINYIN_COVERTOR_ENABLED]  DEFAULT ((1))
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ENT_PINYIN2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_PINYIN2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_PINYIN2](
	[chr] [nchar](1) NULL,
	[py] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_PINYIN3]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_PINYIN3]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_PINYIN3](
	[py] [nvarchar](20) NULL,
	[chr] [nchar](1) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_PINYIN4]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_PINYIN4]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_PINYIN4](
	[ch] [nchar](1) NOT NULL,
	[py] [nvarchar](50) NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_REQUEST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_REQUEST]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_REQUEST](
	[ID] [nvarchar](120) NOT NULL,
	[path] [nvarchar](4000) NULL,
	[input] [nvarchar](4000) NULL,
	[lexer] [nvarchar](4000) NULL,
	[sn] [nvarchar](4000) NULL,
	[robot_id] [nvarchar](20) NULL,
	[tag] [nvarchar](1024) NULL,
	[randint] [nvarchar](50) NULL,
	[user_agent] [nvarchar](4000) NULL,
	[start] [nvarchar](120) NULL,
	[timegreeting] [nvarchar](50) NULL,
	[client_ip] [nvarchar](50) NULL,
	[current_date] [nvarchar](50) NULL,
	[h_version] [nvarchar](120) NULL,
	[h_latitude] [nvarchar](50) NULL,
	[h_longtitude] [nvarchar](50) NULL,
	[h_city] [nvarchar](50) NULL,
	[h_addr] [nvarchar](500) NULL,
	[h_country] [nvarchar](50) NULL,
	[h_addrdesc] [nvarchar](500) NULL,
	[h_street] [nvarchar](500) NULL,
	[datetime] [datetime] NULL CONSTRAINT [DF_ENT_REQUEST_DATETIME]  DEFAULT (getdate()),
	[exec_start_datetime] [datetime] NULL CONSTRAINT [DF_ENT_REQUEST_exec_start_datetime]  DEFAULT (getdate()),
 CONSTRAINT [PK_ENT_REQUEST] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_RESOURCE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_RESOURCE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_RESOURCE](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[DESCRIPTION] [nvarchar](max) NULL,
 CONSTRAINT [PK_ENT_RESOURCE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_ROBOT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ROBOT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_ROBOT](
	[ID] [bigint] NOT NULL CONSTRAINT [DF_ENT_ROBOT_ID]  DEFAULT (CONVERT([bigint],datediff(second,'1970-1-1 00:00:00',getdate()),(0))*(1000)+datepart(millisecond,getdate())),
	[IMEI] [nvarchar](50) NOT NULL,
	[NAME] [nvarchar](500) NOT NULL,
	[ACTIVATE_DATETIME] [datetime] NOT NULL,
	[ACTIVATE_USER_ID] [bigint] NOT NULL,
	[MANUAL_MODE] [bit] NOT NULL CONSTRAINT [DF_ENT_ROBOT_MANUAL_MODE]  DEFAULT ((0)),
	[DESCRIPTION] [nvarchar](500) NULL,
	[USER_GROUP_SCENE_ID] [bigint] NULL,
	[HW_SPEC_ID] [bigint] NOT NULL CONSTRAINT [DF_ENT_ROBOT_HW_SPEC_ID]  DEFAULT ((1)),
 CONSTRAINT [PK_ENT_ROBOT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_ROBOT_APP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ROBOT_APP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_ROBOT_APP](
	[ID] [bigint] NOT NULL CONSTRAINT [DF_TBL_APP_VERSION_LIST_ID]  DEFAULT (CONVERT([bigint],datediff(second,'1970-1-1 00:00:00',getdate()),(0))*(1000)+datepart(millisecond,getdate())),
	[PACKAGE_NAME] [nvarchar](100) NOT NULL,
	[APP_NAME] [nvarchar](50) NOT NULL,
	[EXCLUSIVE] [bit] NOT NULL CONSTRAINT [DF_TBL_ROBOT_APP_EXCLUSIVE]  DEFAULT ((0)),
	[ENABLE] [bit] NOT NULL CONSTRAINT [DF_ENT_ROBOT_APP_ENABLE]  DEFAULT ((1)),
	[DESCRIPTION] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_TBL_APP_VERSION_LIST_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_ROOM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ROOM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_ROOM](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[POISITION] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_ENT_ROOM] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_RTC_SESSION_STATUS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_RTC_SESSION_STATUS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_RTC_SESSION_STATUS](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[DESCRIPTION] [nvarchar](4000) NULL,
 CONSTRAINT [PK_ENT_RTC_SESSION_STATUS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_SYSTEM_META_SETTINGS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_SYSTEM_META_SETTINGS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_SYSTEM_META_SETTINGS](
	[NAME] [nvarchar](50) NOT NULL,
	[VALUE] [nvarchar](4000) NULL,
	[DESCRIPTION] [nvarchar](120) NULL,
 CONSTRAINT [PK_ENT_SYSTEM_META_SETTINGS] PRIMARY KEY CLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_THIRD_PARTY_API]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_THIRD_PARTY_API](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[ENABLE] [bit] NOT NULL CONSTRAINT [DF_ENT_THIRD_PARTY_API_ENABLE]  DEFAULT ((1)),
	[URL] [nvarchar](500) NOT NULL,
	[METHOD] [nvarchar](50) NOT NULL CONSTRAINT [DF_ENT_THIRD_PARTY_API_METHOD]  DEFAULT (N'GET'),
	[RUN_AT_SERVER] [bit] NOT NULL CONSTRAINT [DF_ENT_THIRD_PARTY_API_RUN_AT_SERVER]  DEFAULT ((1)),
	[RESULT_TYPE] [nvarchar](50) NULL CONSTRAINT [DF_ENT_THIRD_PARTY_API_RESULT_TYPE]  DEFAULT (N'JSON'),
	[DESCRIPTION] [nvarchar](500) NULL,
 CONSTRAINT [PK_ENT_THIRD_PARTY_API] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_THIRD_PARTY_API_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_THIRD_PARTY_API_PARAM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_THIRD_PARTY_API_PARAM](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[HEADER_0_BODY_1] [bit] NOT NULL CONSTRAINT [DF_ENT_THIRD_PARTY_API_PARAM_HEADER_0_BODY_1]  DEFAULT ((1)),
	[OPTIONAL] [bit] NOT NULL CONSTRAINT [DF_ENT_THIRD_PARTY_API_PARAM_OPTIONAL]  DEFAULT ((0)),
	[DEFAULT_VALUE] [nvarchar](500) NULL,
	[DESCRIPTION] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_ENT_THIRD_PARTY_API_PARAM] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](500) NOT NULL,
	[THIRD_PARTY_API_ID] [bigint] NOT NULL,
	[ENABLED] [bit] NOT NULL,
	[DESCRIPTION] [nvarchar](500) NULL,
 CONSTRAINT [PK_ENT_THIRD_PARTY_API_PARAM_VALUE_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_THIRD_PARTY_API_PARAMS_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_THIRD_PARTY_API_PARAMS_VALUE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_THIRD_PARTY_API_PARAMS_VALUE](
	[ID] [bigint] NOT NULL,
	[THIRD_PARTY_API_ID] [bigint] NOT NULL,
	[ENABLED] [bit] NOT NULL,
	[DESCIRPTION] [nvarchar](50) NULL,
 CONSTRAINT [PK_ENT_THIRD_PARTY_API_PARAMS_VALUE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[THIRD_PARTY_API_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_USER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_USER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_USER](
	[ID] [bigint] NOT NULL CONSTRAINT [DF_ENT_USER_ID]  DEFAULT (CONVERT([bigint],datediff(second,'1970-1-1 00:00:00',getdate()),(0))*(1000)+datepart(millisecond,getdate())),
	[NAME] [nvarchar](50) NOT NULL,
	[PASSWORD] [nvarchar](50) NOT NULL,
	[USER_GROUP_ID] [bigint] NOT NULL,
	[DESCRIPTION] [nvarchar](50) NOT NULL,
	[EMAIL] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ENT_USER] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_USER_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_USER_GROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_USER_GROUP](
	[ID] [bigint] NOT NULL CONSTRAINT [DF_ENT_GROUP_ID]  DEFAULT (CONVERT([bigint],datediff(second,'1970-1-1 00:00:00',getdate()),(0))*(1000)+datepart(millisecond,getdate())),
	[INDUSTRY_ID] [bigint] NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[TAG] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ENT_GROUP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_VISITORS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_VISITORS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_VISITORS](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[PHONE] [nvarchar](50) NOT NULL,
	[COMPANY] [nvarchar](50) NOT NULL,
	[EVENT] [nvarchar](50) NOT NULL,
	[TAREGET] [nvarchar](50) NOT NULL,
	[DATE_TIME] [datetime] NULL CONSTRAINT [DF_ENT_VISITORS_DATE_TIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_ENT_VISITORS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_VOICE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_VOICE](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[PATH] [nvarchar](1024) NULL,
	[EMOTION] [nvarchar](1024) NULL,
	[TEXT] [nvarchar](4000) NULL,
	[COMMAND] [bigint] NULL,
	[COMMAND_PARAM] [nvarchar](max) NULL,
	[THIRD_PARTY_API_ID] [bigint] NULL,
	[THIRD_PARTY_API_PARAMS_VALUE_ID] [bigint] NULL,
	[INC_PROP] [varchar](800) NULL,
	[EXC_PROP] [nvarchar](800) NULL,
	[CAT] [nvarchar](50) NOT NULL CONSTRAINT [DF_ENT_VOICE_CAT]  DEFAULT ((1)),
	[FIXED_PARAM_1] [bigint] NULL,
	[FIXED_PARAM_2] [bigint] NULL,
	[FIXED_PARAM_3] [bigint] NULL,
	[FIXED_PARAM_4] [bigint] NULL,
	[FIXED_PARAM_5] [bigint] NULL,
	[ENABLED] [bit] NOT NULL CONSTRAINT [DF_ENT_VOICE_ENABLED]  DEFAULT ((1)),
	[DESCRIPTION] [nvarchar](1024) NOT NULL CONSTRAINT [DF_ENT_VOICE_DESCRIPTION]  DEFAULT (N'螺趣语义解析'),
 CONSTRAINT [PK_ENT_VOICE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ENT_VOICE_COMMAND]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_VOICE_COMMAND]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_VOICE_COMMAND](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[DESCRIPTION] [nvarchar](500) NULL,
 CONSTRAINT [PK_ENT_VOICE_COMMAND] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_VOICE_GROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_VOICE_GROUP](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[DESCRIPTION] [nvarchar](50) NULL,
 CONSTRAINT [PK_ENT_VOICE_GROUP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ENT_VOICE_GROUP] UNIQUE NONCLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_WORD_GROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_WORD_GROUP](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[DESCRIPTION] [nvarchar](200) NULL,
 CONSTRAINT [PK_ENT_WORD_GROUP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ENT_WORD_GROUP] UNIQUE NONCLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ENT_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_WORD_GROUP_FLOW]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_WORD_GROUP_FLOW](
	[ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[DESCRIPTION] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ENT_WORD_GROUP_FLOW] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ENT_WORD_GROUP_FLOW] UNIQUE NONCLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_BIZ_MENUITEM_ACTION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_BIZ_MENUITEM_ACTION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_BIZ_MENUITEM_ACTION](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ACTION] [nvarchar](200) NULL,
	[URI] [nvarchar](4000) NULL,
	[TYPE] [nvarchar](max) NULL,
	[EXTRA] [nvarchar](50) NULL,
	[PACKAGE_NAME] [nvarchar](4000) NULL,
	[CLASS_NAME] [nvarchar](256) NULL,
	[DESCRIPTION] [nvarchar](max) NULL,
 CONSTRAINT [PK_TBL_BIZ_MENUITEM_ACTION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_BIZ_MENUTREE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_BIZ_MENUTREE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_BIZ_MENUTREE](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[LABEL] [nvarchar](500) NOT NULL,
	[EXTRA] [nvarchar](max) NULL,
	[OWNER_MENU] [nvarchar](50) NOT NULL,
	[PARENT_ID] [bigint] NULL,
	[MENUITEM_ACTION_ID] [bigint] NULL,
	[SEQ] [bigint] NOT NULL CONSTRAINT [DF_TBL_BIZ_MENUTREE_SEQ]  DEFAULT ((1)),
 CONSTRAINT [PK_TBL_BIZ_MENUTREE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC](
	[HW_SPEC_ID] [bigint] NOT NULL,
	[NAME] [nvarchar](256) NOT NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[DESCRIPTION] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC] PRIMARY KEY CLUSTERED 
(
	[HW_SPEC_ID] ASC,
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY](
	[INDUSTRY_ID] [bigint] NOT NULL,
	[NAME] [nvarchar](256) NOT NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[DESCRIPTION] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY] PRIMARY KEY CLUSTERED 
(
	[INDUSTRY_ID] ASC,
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT](
	[ROBOT_ID] [bigint] NOT NULL,
	[NAME] [nvarchar](256) NOT NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[DESCRIPTION] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT] PRIMARY KEY CLUSTERED 
(
	[ROBOT_ID] ASC,
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP](
	[USER_GROUP_ID] [bigint] NOT NULL,
	[NAME] [nvarchar](256) NOT NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[DESCRIPTION] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP] PRIMARY KEY CLUSTERED 
(
	[USER_GROUP_ID] ASC,
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE](
	[USER_GROUP_SCENE_ID] [bigint] NOT NULL,
	[NAME] [nvarchar](256) NOT NULL,
	[VALUE] [nvarchar](max) NOT NULL,
	[DESCRIPTION] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE] PRIMARY KEY CLUSTERED 
(
	[USER_GROUP_SCENE_ID] ASC,
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[COMPANY_ID] [bigint] NOT NULL,
	[METTING_ROW_NUM] [bigint] NOT NULL,
	[METTING_COL_NUM] [bigint] NOT NULL,
	[DINNER_NO] [nvarchar](50) NOT NULL,
	[ENABLED] [bit] NOT NULL CONSTRAINT [DF_TBL_PROVIDER_METTINGS_ENABLED]  DEFAULT ((1)),
 CONSTRAINT [PK_TBL_PROVIDER_METTINGS] PRIMARY KEY CLUSTERED 
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT](
	[ROBOT_ID] [bigint] NOT NULL,
	[CONFIG_NAME] [nvarchar](256) NOT NULL,
	[VALUE] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_TBL_INHERIT_CONFIG_FOR_ROBOT] PRIMARY KEY CLUSTERED 
(
	[ROBOT_ID] ASC,
	[CONFIG_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP](
	[USER_GROUP_ID] [bigint] NOT NULL,
	[CONFIG_NAME] [nvarchar](256) NOT NULL,
	[VALUE] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_TBL_GROUP_INHERIT_CONFIG] PRIMARY KEY CLUSTERED 
(
	[USER_GROUP_ID] ASC,
	[CONFIG_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ML_DIALOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ML_DIALOG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ML_DIALOG](
	[ROBOT_IMEI] [nvarchar](50) NULL,
	[TEXT] [nvarchar](500) NULL,
	[ANSWER] [nvarchar](max) NOT NULL,
	[PROVIDER] [varchar](30) NULL,
	[CREATE_DATETIME] [datetime] NULL,
	[UPDATE_DATETIME] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_NEWS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_NEWS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_NEWS](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NEWS_TIME] [datetime] NULL,
	[PICTURES] [image] NULL,
	[TITLE] [varchar](50) NOT NULL,
	[CONTENT] [xml] NOT NULL,
 CONSTRAINT [PK_TBL_NEWS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_OPERATION_LOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_OPERATION_LOG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_OPERATION_LOG](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ADMIN_NAME] [nvarchar](50) NOT NULL,
	[ACTION] [nvarchar](50) NOT NULL,
	[OBJECT_NAME] [nvarchar](50) NOT NULL,
	[VALUE_SET] [nvarchar](max) NULL,
	[DATE_TIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_OPERATION_LOG_DATE_TIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_TBL_OPERATION_LOG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ORDER_ROOM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ORDER_ROOM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ORDER_ROOM](
	[ROOM_ID] [bigint] NOT NULL,
	[ORDER_DATE] [nvarchar](50) NOT NULL,
	[NIGHT] [bit] NOT NULL,
	[ORDER_NAME] [nvarchar](50) NOT NULL,
	[MOBILE_PHONE] [nvarchar](50) NOT NULL,
	[SUBMIT_DATETIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_ORDER_ROOM_SUBMIT_DATETIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_TBL_ORDER_ROOM] PRIMARY KEY CLUSTERED 
(
	[ROOM_ID] ASC,
	[ORDER_DATE] ASC,
	[NIGHT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_QUESTION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_QUESTION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_QUESTION](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TITLE] [nvarchar](4000) NOT NULL,
	[Q_INDEX] [bigint] NOT NULL,
	[EXAM_ID] [bigint] NOT NULL,
	[DESCRIPTION] [nvarchar](50) NULL,
 CONSTRAINT [PK_TBL_QUESTION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_QUESTION_ANSWER_CANDIDATES]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_QUESTION_ANSWER_CANDIDATES]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_QUESTION_ANSWER_CANDIDATES](
	[QUESTION_ID] [bigint] NOT NULL,
	[LABEL] [nvarchar](50) NOT NULL,
	[C_INDEX] [bigint] NOT NULL,
	[C_CONTENT] [nvarchar](256) NOT NULL,
	[THE_ANSWER] [bit] NOT NULL,
 CONSTRAINT [PK_TBL_QUESTION_ANSWER_CANDIDATES] PRIMARY KEY CLUSTERED 
(
	[QUESTION_ID] ASC,
	[LABEL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_REQUEST_PROPERTY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_REQUEST_PROPERTY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_REQUEST_PROPERTY](
	[REQUEST_ID] [nvarchar](120) NOT NULL,
	[PROPERTY_NAME] [nvarchar](120) NOT NULL,
	[PROPERTY_VALUE] [nvarchar](4000) NOT NULL,
	[IS_NUMERIC] [bit] NOT NULL,
 CONSTRAINT [PK_TBL_REQUEST_PROPERTY] PRIMARY KEY CLUSTERED 
(
	[REQUEST_ID] ASC,
	[PROPERTY_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_REQUEST_PROPERTY_BACKUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_REQUEST_PROPERTY_BACKUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_REQUEST_PROPERTY_BACKUP](
	[REQUEST_ID] [nvarchar](120) NOT NULL,
	[PROPERTY_NAME] [nvarchar](120) NOT NULL,
	[PROPERTY_VALUE] [nvarchar](4000) NOT NULL,
	[IS_NUMERIC] [bit] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_REQUEST_RECOMMEND]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_REQUEST_RECOMMEND]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_REQUEST_RECOMMEND](
	[REQUEST_ID] [nvarchar](120) NULL,
	[RECOMMEND_FLOW_ID] [bigint] NULL,
	[MATCHED_DEGREE] [bigint] NULL,
	[GRANULARITY] [bigint] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_APP_EXCLUDE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUDE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_APP_EXCLUDE](
	[ROBOT_APP_ID] [bigint] NOT NULL,
	[USER_GROUP_ID] [bigint] NOT NULL,
 CONSTRAINT [PK_TBL_ROBOT_APP_EXCLUDE] PRIMARY KEY CLUSTERED 
(
	[ROBOT_APP_ID] ASC,
	[USER_GROUP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_APP_EXCLUSIVE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUSIVE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_APP_EXCLUSIVE](
	[ROBOT_APP_ID] [bigint] NOT NULL,
	[USER_GROUP_ID] [bigint] NOT NULL,
 CONSTRAINT [PK_TBL_ROBOT_APP_EXCLUSIVE] PRIMARY KEY CLUSTERED 
(
	[ROBOT_APP_ID] ASC,
	[USER_GROUP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_APP_VERSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_VERSION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_APP_VERSION](
	[ROBOT_APP_ID] [bigint] NOT NULL,
	[VERSION_CODE] [bigint] NOT NULL,
	[VERSION_NAME] [nvarchar](500) NOT NULL,
	[DOWNLOAD_URL] [nvarchar](500) NOT NULL,
	[RELEASE_NOTE] [nvarchar](500) NOT NULL,
	[PUBLISH_DATETIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_ROBOT_APP_VERSION_LIST_PUBLISH_DATETIME]  DEFAULT (getdate()),
	[ENABLED] [bit] NOT NULL CONSTRAINT [DF_TBL_ROBOT_APP_VERSION_ENABLED]  DEFAULT ((1)),
 CONSTRAINT [PK_TBL_ROBOT_APP_VERSION_LIST] PRIMARY KEY CLUSTERED 
(
	[ROBOT_APP_ID] ASC,
	[VERSION_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_APP_VERSION_REQUIRED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_VERSION_REQUIRED]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_APP_VERSION_REQUIRED](
	[DB_VERSION] [nvarchar](50) NOT NULL,
	[ROBOT_APP_ID] [bigint] NOT NULL,
	[VERSION_CODE] [bigint] NOT NULL,
	[EXTRA] [nchar](10) NULL,
 CONSTRAINT [PK_TBL_ROBOT_APP_VERSION_REQUIRED] PRIMARY KEY CLUSTERED 
(
	[DB_VERSION] ASC,
	[ROBOT_APP_ID] ASC,
	[VERSION_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_MANUAL_TALK_CACHE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_MANUAL_TALK_CACHE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_MANUAL_TALK_CACHE](
	[ROBOT_ID] [bigint] NOT NULL,
	[VOICE_ID] [bigint] NOT NULL,
	[CREATE_DATETIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_ROBOT_MANUAL_TALK_CACHE_CREATE_DATETIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_TBL_ROBOT_MANUAL_TALK_CACHE] PRIMARY KEY CLUSTERED 
(
	[ROBOT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_OFFER_SESSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_OFFER_SESSION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_OFFER_SESSION](
	[ID] [bigint] NOT NULL,
	[OFFER_ROBOT_ID] [bigint] NOT NULL,
	[ANSWER_USER_ID] [bigint] NOT NULL,
	[OFFER_DATETIME] [datetime] NOT NULL,
	[CONNECTED_DATETIME] [datetime] NOT NULL,
	[DISCONNECTED_DATETIME] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_SESSION_CONTEXT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_SESSION_CONTEXT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_SESSION_CONTEXT](
	[ROBOT_ID] [bigint] NOT NULL,
	[CTX_NAME] [nvarchar](50) NOT NULL,
	[CTX_VALUE] [nvarchar](max) NULL,
	[EXPR_SECS] [bigint] NOT NULL,
	[DESCRIPTION] [nvarchar](50) NULL,
	[CREATE_DATETIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_ROBOT_SESSION_CONTEXT_CREATE_DATETIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_TBL_ROBOT_SESSION_CONTEXT] PRIMARY KEY CLUSTERED 
(
	[ROBOT_ID] ASC,
	[CTX_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_STATUS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_STATUS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_STATUS](
	[ROBOT_ID] [bigint] NOT NULL,
	[UPDATE_DATETIME] [datetime] NOT NULL,
	[WSS_SESSION_ID] [nvarchar](500) NULL,
	[ONLINE] [bit] NOT NULL,
	[EXTRA_INFO] [nvarchar](max) NULL,
 CONSTRAINT [PK_TBL_ROBOT_STATUS_1] PRIMARY KEY CLUSTERED 
(
	[ROBOT_ID] ASC,
	[UPDATE_DATETIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_ROBOT_TAGS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_TAGS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_ROBOT_TAGS](
	[ROBOT_ID] [bigint] NOT NULL,
	[TAG] [nvarchar](120) NOT NULL,
	[TAG_STR] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_ENT_ROBOT_TAGS] PRIMARY KEY CLUSTERED 
(
	[ROBOT_ID] ASC,
	[TAG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_RTC_SESSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RTC_SESSION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_RTC_SESSION](
	[ID] [bigint] NOT NULL CONSTRAINT [DF_TBL_RTC_SESSION_ID]  DEFAULT (CONVERT([bigint],datediff(second,'1970-1-1 00:00:00',getdate()),(0))*(1000)+datepart(millisecond,getdate())),
	[ROBOT_ID] [bigint] NOT NULL,
	[USER_ID] [bigint] NOT NULL,
	[ROBOT_INITIATE] [bit] NOT NULL,
	[CREATE_DATETIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_RTC_SESSION_CREATE_DATE]  DEFAULT (getdate()),
 CONSTRAINT [PK_TBL_RTC_SESSION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_RTC_SESSION_SIGNAL_CACHE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RTC_SESSION_SIGNAL_CACHE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_RTC_SESSION_SIGNAL_CACHE](
	[RTC_SESSION_ID] [bigint] NOT NULL,
	[TYPE] [nvarchar](50) NOT NULL,
	[DATA] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_RTC_SESSION_STATUS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RTC_SESSION_STATUS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_RTC_SESSION_STATUS](
	[RTC_SESSION_ID] [bigint] NOT NULL,
	[UPDATE_DATETIME] [datetime] NOT NULL,
	[STATUS] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_RTC_SESSION_STATUS] PRIMARY KEY CLUSTERED 
(
	[RTC_SESSION_ID] ASC,
	[UPDATE_DATETIME] ASC,
	[STATUS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_RUNTIME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_RUNTIME](
	[ID] [bigint] NOT NULL,
	[ROBOT_IMEI] [nvarchar](50) NOT NULL,
	[MESSAGE] [nvarchar](2000) NOT NULL,
	[DESCRIPTION] [nvarchar](4000) NOT NULL,
	[NOTE] [text] NOT NULL,
	[DATE_TIME] [datetime] NULL CONSTRAINT [DF_TBL_RUNTIME_DATE_TIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_TBL_RUNTIME] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_RUNTIME_BACKUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME_BACKUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_RUNTIME_BACKUP](
	[ID] [bigint] NOT NULL,
	[ROBOT_IMEI] [nvarchar](50) NOT NULL,
	[MESSAGE] [nvarchar](2000) NOT NULL,
	[DESCRIPTION] [nvarchar](4000) NOT NULL,
	[NOTE] [text] NOT NULL,
	[DATE_TIME] [datetime] NULL CONSTRAINT [DF_TBL_RUNTIME_BACKUP_DATE_TIME]  DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_RUNTIME_DATA]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME_DATA]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_RUNTIME_DATA](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ROBOT_ID] [nvarchar](50) NOT NULL,
	[APP] [nvarchar](4000) NOT NULL,
	[TYPE] [nvarchar](50) NOT NULL,
	[MSG] [nvarchar](4000) NOT NULL,
	[DETAILS] [nvarchar](max) NOT NULL,
	[DATE_TIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_RUNTIME_DATA_DATE_TIME]  DEFAULT (getdate()),
 CONSTRAINT [PK_TBL_RUNTIME_DATA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_RUNTIME_DATA_BACKUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME_DATA_BACKUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_RUNTIME_DATA_BACKUP](
	[ID] [bigint] NOT NULL,
	[ROBOT_ID] [nvarchar](50) NOT NULL,
	[APP] [nvarchar](4000) NOT NULL,
	[TYPE] [nvarchar](50) NOT NULL,
	[MSG] [nvarchar](4000) NOT NULL,
	[DETAILS] [nvarchar](max) NOT NULL,
	[DATE_TIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_RUNTIME_DATA_BACKUP_DATE_TIME]  DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_THIRD_PARTY_API_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM](
	[THIRD_PARTY_API_ID] [bigint] NOT NULL,
	[THIRD_PARTY_API_PARAM_ID] [bigint] NOT NULL,
	[DESCRIPTION] [nvarchar](1024) NULL,
 CONSTRAINT [PK_TBL_THIRD_PARTY_API_PARAM] PRIMARY KEY CLUSTERED 
(
	[THIRD_PARTY_API_ID] ASC,
	[THIRD_PARTY_API_PARAM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE](
	[THIRD_PARTY_API_PARAM_VALUE_ID] [bigint] NOT NULL,
	[THIRD_PARTY_API_PARAM_ID] [bigint] NOT NULL,
	[PARAM_VALUE] [nvarchar](2000) NOT NULL,
	[DESCRIPTION] [nvarchar](50) NULL,
 CONSTRAINT [PK_TBL_THIRD_PARTY_API_PARAM_VALUE_1] PRIMARY KEY CLUSTERED 
(
	[THIRD_PARTY_API_PARAM_VALUE_ID] ASC,
	[THIRD_PARTY_API_PARAM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_THIRD_PARTY_API_PARAMS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAMS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_THIRD_PARTY_API_PARAMS](
	[THIRD_PARTY_API_ID] [bigint] NOT NULL,
	[PARAM_NAME] [nvarchar](50) NOT NULL,
	[HEADER_0_BODY_1] [bit] NOT NULL CONSTRAINT [DF_TBL_THIRD_PARTY_API_PARAMS_HEADER_0_BODY_1]  DEFAULT ((1)),
	[OPTIONAL] [bit] NOT NULL CONSTRAINT [DF_TBL_THIRD_PARTY_API_PARAMS_OPTIONAL]  DEFAULT ((0)),
	[DEFAULT_VALUE] [nvarchar](500) NULL,
 CONSTRAINT [PK_TBL_THIRD_PARTY_API_PARAMS] PRIMARY KEY CLUSTERED 
(
	[THIRD_PARTY_API_ID] ASC,
	[PARAM_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_THIRD_PARTY_API_PARAMS_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAMS_VALUE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_THIRD_PARTY_API_PARAMS_VALUE](
	[ID] [bigint] NOT NULL,
	[THIRD_PARTY_API_ID] [bigint] NOT NULL,
	[THIRD_PARTY_API_PARAM_NAME] [nvarchar](50) NOT NULL,
	[PARAM_VALUE] [nvarchar](2000) NOT NULL,
	[DESCRIPTION] [nvarchar](50) NULL,
 CONSTRAINT [PK_TBL_THIRD_PARTY_API_PARAMS_VALUE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[THIRD_PARTY_API_ID] ASC,
	[THIRD_PARTY_API_PARAM_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_USER_GROUP_SCENE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_USER_GROUP_SCENE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_USER_GROUP_SCENE](
	[ID] [bigint] NOT NULL,
	[USER_GROUP_ID] [bigint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[ENABLED] [bit] NOT NULL CONSTRAINT [DF_TBL_USER_GROUP_SCENE_ENABLED]  DEFAULT ((1)),
	[DESCRIPTION] [nvarchar](500) NOT NULL,
	[TAG] [nvarchar](50) NULL,
 CONSTRAINT [PK_TBL_USER_GROUP_SCENE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_USER_OFFER_SESSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_USER_OFFER_SESSION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_USER_OFFER_SESSION](
	[ID] [bigint] NOT NULL,
	[OFFER_USER_ID] [bigint] NOT NULL,
	[ANSWER_USER_ID] [bigint] NOT NULL,
	[OFFER_DATETIME] [datetime] NOT NULL,
	[CONNECTED_DATETIME] [datetime] NOT NULL,
	[DISCONNECTED_DATETIME] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_USER_STATUS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_USER_STATUS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_USER_STATUS](
	[USER_ID] [bigint] NOT NULL,
	[UPDATE_DATETIME] [datetime] NOT NULL,
	[ONLINE] [bit] NOT NULL,
	[EXTRA_INFO] [nvarchar](max) NULL,
	[WSS_SESSION_ID] [nvarchar](500) NULL,
 CONSTRAINT [PK_TBL_USER_STATUS_1] PRIMARY KEY CLUSTERED 
(
	[USER_ID] ASC,
	[UPDATE_DATETIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_VERSION_REQUIRED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_VERSION_REQUIRED]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_VERSION_REQUIRED](
	[DB_VERSION] [nvarchar](50) NOT NULL,
	[REQURIED_CLIENT_VERSION] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_ENT_VERSION_REQUIRED] PRIMARY KEY CLUSTERED 
(
	[DB_VERSION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_VOICE_GROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_VOICE_GROUP](
	[ID] [bigint] NOT NULL,
	[VOICE_ID] [bigint] NOT NULL,
	[DESCRIPTION] [nvarchar](250) NOT NULL CONSTRAINT [DF_TBL_VOICE_GROUP_DESCRIPTION]  DEFAULT (N'N/A'),
 CONSTRAINT [PK_TBL_VOICE_GROUP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[VOICE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_VOICE_TAG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_VOICE_TAG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_VOICE_TAG](
	[VOICE_ID] [bigint] NOT NULL,
	[TAG] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_VOICE_TAG] PRIMARY KEY CLUSTERED 
(
	[VOICE_ID] ASC,
	[TAG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_WORD_GROUP](
	[GROUP_ID] [bigint] NOT NULL,
	[KEY_WORD_ID] [bigint] NOT NULL,
	[DESCRIPTION] [nvarchar](1024) NULL,
 CONSTRAINT [PK_TBL_WORD_GROUP] PRIMARY KEY CLUSTERED 
(
	[KEY_WORD_ID] ASC,
	[GROUP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_WORD_GROUP_FLOW](
	[ID] [bigint] NOT NULL,
	[GROUP_FLOW_ORDER] [bigint] NULL,
	[WORD_GROUP_ID] [bigint] NOT NULL,
	[USE_SOUND] [bit] NOT NULL CONSTRAINT [DF_TBL_WORD_GROUP_FLOW_USE_SOUND]  DEFAULT ((0)),
	[INC_1_EXC_0] [bit] NOT NULL CONSTRAINT [DF_TBL_WORD_GROUP_FLOW_INC_0_EXC_1]  DEFAULT ((1)),
	[DESCRIPTION] [nvarchar](1024) NULL,
 CONSTRAINT [PK_TBL_WORD_GROUP_FLOW] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[WORD_GROUP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE](
	[ID] [bigint] NOT NULL,
	[WORD_GROUP_FLOW_ID] [bigint] NOT NULL,
	[VOICE_GROUP_ID] [bigint] NOT NULL,
	[USE_FLOW_ORDER] [bit] NOT NULL CONSTRAINT [DF_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_USE_FLOW_ORDER]  DEFAULT ((0)),
	[USE_FULLY_MATCH] [bit] NOT NULL CONSTRAINT [DF_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_USE_FULLY_MATCH]  DEFAULT ((0)),
	[ENABLE] [bit] NOT NULL CONSTRAINT [DF_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENABLE]  DEFAULT ((1)),
	[DESCRIPTION] [nvarchar](50) NOT NULL CONSTRAINT [DF_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_DESCRIPTION]  DEFAULT (N'N/A'),
 CONSTRAINT [PK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE] PRIMARY KEY CLUSTERED 
(
	[WORD_GROUP_FLOW_ID] ASC,
	[VOICE_GROUP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[REQUEST] [varchar](800) NOT NULL,
	[VOICE_ID] [bigint] NOT NULL,
	[CREATE_USER_ID] [bigint] NOT NULL,
	[UPDATE_USER_ID] [bigint] NOT NULL,
	[CREATE_DATETIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_ORIGNAL_WORD_GROUP_TO_VOICE_GROUP_RULE_CREATE_DATETIME]  DEFAULT (getdate()),
	[UPDATE_DATETIME] [datetime] NOT NULL CONSTRAINT [DF_TBL_ORIGNAL_WORD_GROUP_TO_VOICE_GROUP_RULE_UPDATE_DATETIME]  DEFAULT (getdate()),
	[RESPONSE_VOICE_GROUP_ID] [bigint] NULL,
	[GEN_WORD_GROUP_FLOW_ID] [bigint] NULL,
	[GEN_DATETIME] [datetime] NULL,
 CONSTRAINT [PK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[VIEW_CONFIG_COMMON]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_CONFIG_COMMON]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_CONFIG_COMMON]
AS
SELECT   OWNER_ID, OWNER_TYPE, ''系统默认'' AS OWNER_NAME, NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN, 
                DESCRIPTION
FROM      dbo.ENT_CONFIG
WHERE   (OWNER_TYPE = 1)
' 
GO
/****** Object:  View [dbo].[VIEW_CONFIG_INDUSTRY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_CONFIG_INDUSTRY]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [dbo].[VIEW_CONFIG_INDUSTRY]
AS

SELECT  OWNER_ID, OWNER_TYPE, ENT_INDUSTRY.NAME AS OWNER_NAME,  CFG.NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN, CFG.DESCRIPTION
FROM
(SELECT   OWNER_ID, OWNER_TYPE,  NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN, 
                DESCRIPTION
FROM      dbo.ENT_CONFIG 
WHERE   (OWNER_TYPE = 2)) AS CFG
INNER JOIN ENT_INDUSTRY ON (OWNER_ID = ENT_INDUSTRY.ID)

' 
GO
/****** Object:  View [dbo].[VIEW_CONFIG_USER_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_CONFIG_USER_GROUP]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [dbo].[VIEW_CONFIG_USER_GROUP]
AS
 

SELECT  OWNER_ID, OWNER_TYPE, ENT_USER_GROUP.NAME AS OWNER_NAME,  CFG.NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN, DESCRIPTION
FROM
(SELECT   OWNER_ID, OWNER_TYPE,  NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN, 
                DESCRIPTION
FROM      dbo.ENT_CONFIG 
WHERE   (OWNER_TYPE = 3)) AS CFG
INNER JOIN ENT_USER_GROUP ON (OWNER_ID = ENT_USER_GROUP.ID)


' 
GO
/****** Object:  View [dbo].[VIEW_CONFIG_USER_GROUP_SCENE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_CONFIG_USER_GROUP_SCENE]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [dbo].[VIEW_CONFIG_USER_GROUP_SCENE]
AS
 

SELECT  OWNER_ID, OWNER_TYPE, TBL_USER_GROUP_SCENE.NAME AS OWNER_NAME,  CFG.NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN, CFG.DESCRIPTION
FROM
(SELECT   OWNER_ID, OWNER_TYPE,  NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN, 
                DESCRIPTION
FROM      dbo.ENT_CONFIG 
WHERE   (OWNER_TYPE = 4)) AS CFG
INNER JOIN TBL_USER_GROUP_SCENE ON (OWNER_ID = TBL_USER_GROUP_SCENE.ID)


' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_STATUS_LASTEST_UPDATETIME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_STATUS_LASTEST_UPDATETIME]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_STATUS_LASTEST_UPDATETIME]
AS
SELECT     dbo.ENT_ROBOT.ID AS ROBOT_ID, ISNULL(MAX(dbo.TBL_ROBOT_STATUS.UPDATE_DATETIME), ''1970-1-1'') AS LATEST_UPDATE_DATETIME
FROM         dbo.ENT_ROBOT LEFT OUTER JOIN
                      dbo.TBL_ROBOT_STATUS ON dbo.ENT_ROBOT.ID = dbo.TBL_ROBOT_STATUS.ROBOT_ID
GROUP BY dbo.ENT_ROBOT.ID
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_LATEST_STATUS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_LATEST_STATUS]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_ROBOT_LATEST_STATUS]
AS
SELECT     dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.ROBOT_ID, 
                      dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME AS UPDATE_DATETIME, 
                      ISNULL(dbo.TBL_ROBOT_STATUS.WSS_SESSION_ID, '''') AS WSS_SESSION_ID , CAST(ISNULL(dbo.TBL_ROBOT_STATUS.ONLINE, 0) AS BIT) AS ONLINE, 
                      ISNULL(dbo.TBL_ROBOT_STATUS.EXTRA_INFO,'''') AS EXTRA_INFO,  dbo.ENT_ROBOT.NAME AS ROBOT_NAME
FROM    ENT_ROBOT 
LEFT JOIN VIEW_ROBOT_STATUS_LASTEST_UPDATETIME  
                       ON dbo.ENT_ROBOT.ID = dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.ROBOT_ID 
LEFT JOIN TBL_ROBOT_STATUS ON 					    
                      dbo.TBL_ROBOT_STATUS.UPDATE_DATETIME = dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME
and dbo.ENT_ROBOT.ID = dbo.TBL_ROBOT_STATUS.ROBOT_ID



' 
GO
/****** Object:  View [dbo].[VIEW_USER_STATUS_LASTEST_UPDATETIME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_USER_STATUS_LASTEST_UPDATETIME]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_USER_STATUS_LASTEST_UPDATETIME]
AS
SELECT     dbo.ENT_USER.ID AS USER_ID, ISNULL(MAX(dbo.TBL_USER_STATUS.UPDATE_DATETIME), ''1970-1-1 0:0:0'') AS LATEST_UPDATE_DATETIME
FROM         dbo.ENT_USER LEFT OUTER JOIN
                      dbo.TBL_USER_STATUS ON dbo.ENT_USER.ID = dbo.TBL_USER_STATUS.USER_ID
GROUP BY dbo.ENT_USER.ID
' 
GO
/****** Object:  View [dbo].[VIEW_USER_LASTEST_STATUS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_USER_LASTEST_STATUS]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_USER_LASTEST_STATUS]
AS
SELECT     dbo.VIEW_USER_STATUS_LASTEST_UPDATETIME.USER_ID, 
                      dbo.VIEW_USER_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME AS UPDATE_DATETIME, ISNULL( dbo.TBL_USER_STATUS.WSS_SESSION_ID, '''') AS WSS_SESSION_ID, 
                      ISNULL(dbo.TBL_USER_STATUS.ONLINE, CAST(0 AS BIT)) AS ONLINE, ISNULL( dbo.TBL_USER_STATUS.EXTRA_INFO, '''') AS EXTRA_INFO , 
                      dbo.ENT_USER_GROUP.ID AS USER_GROUP_ID, dbo.ENT_USER_GROUP.NAME AS USER_GROUP_NAME, 
                      dbo.ENT_USER.NAME AS USER_NAME
FROM         dbo.VIEW_USER_STATUS_LASTEST_UPDATETIME LEFT OUTER JOIN
                      dbo.TBL_USER_STATUS ON dbo.TBL_USER_STATUS.USER_ID = dbo.VIEW_USER_STATUS_LASTEST_UPDATETIME.USER_ID AND 
                      dbo.TBL_USER_STATUS.UPDATE_DATETIME = dbo.VIEW_USER_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME INNER JOIN
                      dbo.ENT_USER ON dbo.ENT_USER.ID = dbo.VIEW_USER_STATUS_LASTEST_UPDATETIME.USER_ID INNER JOIN
                      dbo.ENT_USER_GROUP ON dbo.ENT_USER.USER_GROUP_ID = dbo.ENT_USER_GROUP.ID
' 
GO
/****** Object:  View [dbo].[VIEW_USER_ROBOT_BIND_LIST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_USER_ROBOT_BIND_LIST]'))
EXEC dbo.sp_executesql @statement = N'


/**
	一个视图搞定机器人与用户的绑定关系，机器人的状态用户的状态全在此
*/
CREATE VIEW [dbo].[VIEW_USER_ROBOT_BIND_LIST]
AS
SELECT     A.ROBOT_ID, A.ROBOT_NAME, A.ROBOT_IMEI, A.ROBOT_HW_SPEC_ID, A.ROBOT_HW_SPEC_NAME  , 
					  ISNULL(A.USER_GROUP_INDUSTRY_ID, 0) AS USER_GROUP_INDUSTRY_ID, 
					  isnull( A.USER_GROUP_INDUSTRY_NAME, ''未设置'') AS USER_GROUP_INDUSTRY_NAME, 
					  ISNULL( A.USER_GROUP_SCENE_ID, 0) AS USER_GROUP_SCENE_ID , 
					  ISNULL(A.USER_GROUP_SCENE_NAME, ''默认分组'') AS USER_GROUP_SCENE_NAME, 
					  A.ROBOT_ACTIVATE_DATETIME, 
					  A.ROBOT_MANUAL_MODE,
					  isnull(A.USER_GROUP_INDUSTRY_TAG, '''') as USER_GROUP_INDUSTRY_TAG,
					  A.USER_GROUP_TAG,
                      dbo.VIEW_ROBOT_LATEST_STATUS.UPDATE_DATETIME AS ROBOT_LATEST_STATUS_UPDATE_DATETIME, 
                      dbo.VIEW_ROBOT_LATEST_STATUS.WSS_SESSION_ID AS ROBOT_LATEST_STATUS_WSS_SESSION_ID, 
                      dbo.VIEW_ROBOT_LATEST_STATUS.ONLINE AS ROBOT_LATEST_STATUS_ONLINE, 
                      dbo.VIEW_ROBOT_LATEST_STATUS.EXTRA_INFO AS ROBOT_LATEST_STATUS_EXTRA_INFO, U.ID AS USER_ID, 
                      CAST((CASE WHEN U.ID = A.ROBOT_ACTIVATE_USER_ID THEN 1 ELSE 0 END) AS BIT) AS IS_ACTIVATE_USER, U.NAME AS USER_NAME, 
                      U.PASSWORD AS USER_PASSWORD, A.USER_GROUP_ID, A.USER_GROUP_NAME, 
                      dbo.VIEW_USER_LASTEST_STATUS.UPDATE_DATETIME AS USER_LASTEST_STATUS_UPDATE_DATETIME, 
                      dbo.VIEW_USER_LASTEST_STATUS.WSS_SESSION_ID AS USER_LASTEST_STATUS_WSS_SESSION_ID, 
                      dbo.VIEW_USER_LASTEST_STATUS.UPDATE_DATETIME, dbo.VIEW_USER_LASTEST_STATUS.ONLINE AS USER_LASTEST_STATUS_ONLINE, 
                      dbo.VIEW_USER_LASTEST_STATUS.EXTRA_INFO AS USER_LASTEST_STATUS_EXTRA_INFO, U.EMAIL AS USER_EMAIL
FROM         (SELECT     dbo.ENT_USER.USER_GROUP_ID, dbo.ENT_USER_GROUP.NAME AS USER_GROUP_NAME, dbo.ENT_ROBOT.ID AS ROBOT_ID, ENT_ROBOT.HW_SPEC_ID AS ROBOT_HW_SPEC_ID, ENT_HW_SPEC.NAME AS ROBOT_HW_SPEC_NAME,
                                              dbo.ENT_ROBOT.NAME AS ROBOT_NAME, dbo.ENT_ROBOT.ACTIVATE_USER_ID AS ROBOT_ACTIVATE_USER_ID, 
                                              dbo.ENT_ROBOT.IMEI AS ROBOT_IMEI, dbo.ENT_ROBOT.ACTIVATE_DATETIME AS ROBOT_ACTIVATE_DATETIME,
											  ENT_ROBOT.USER_GROUP_SCENE_ID AS USER_GROUP_SCENE_ID,
											  TBL_USER_GROUP_SCENE.NAME  AS USER_GROUP_SCENE_NAME,
											  ENT_USER_GROUP.INDUSTRY_ID AS USER_GROUP_INDUSTRY_ID,
											  ENT_USER_GROUP.TAG AS USER_GROUP_TAG,
											  ENT_INDUSTRY.TAG AS USER_GROUP_INDUSTRY_TAG,
											  ENT_INDUSTRY.NAME AS USER_GROUP_INDUSTRY_NAME,
ENT_ROBOT.MANUAL_MODE AS ROBOT_MANUAL_MODE
                       FROM          dbo.ENT_USER INNER JOIN
                                              dbo.ENT_USER_GROUP ON dbo.ENT_USER.USER_GROUP_ID = dbo.ENT_USER_GROUP.ID 
											  INNER JOIN ENT_ROBOT ON dbo.ENT_USER.ID = dbo.ENT_ROBOT.ACTIVATE_USER_ID
											  INNER JOIN ENT_HW_SPEC ON dbo.ENT_HW_SPEC.ID = dbo.ENT_ROBOT.HW_SPEC_ID

											  LEFT JOIN ENT_INDUSTRY ON ENT_USER_GROUP.INDUSTRY_ID = ENT_INDUSTRY.ID
											  LEFT JOIN TBL_USER_GROUP_SCENE ON ENT_ROBOT.USER_GROUP_SCENE_ID = TBL_USER_GROUP_SCENE.ID
											  
											  ) AS A INNER JOIN
                      dbo.ENT_USER AS U ON U.USER_GROUP_ID = A.USER_GROUP_ID LEFT OUTER JOIN
                      dbo.VIEW_USER_LASTEST_STATUS ON dbo.VIEW_USER_LASTEST_STATUS.USER_ID = U.ID LEFT OUTER JOIN
                      dbo.VIEW_ROBOT_LATEST_STATUS ON dbo.VIEW_ROBOT_LATEST_STATUS.ROBOT_ID = A.ROBOT_ID






' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_CONFIG_WITH_OWNER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_CONFIG_WITH_OWNER]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_CONFIG_WITH_OWNER]
AS

-- 第一优先级， 共同默认；行业默认；企业默认；场景默认

-- 通用默认
SELECT     
0 AS PRIORITY
, OWNER_ID
, OWNER_NAME
, dbo.ENT_ROBOT.ID AS ROBOT_ID
, dbo.ENT_ROBOT.IMEI AS ROBOT_IMEI
, VIEW_CONFIG_COMMON.NAME
, VIEW_CONFIG_COMMON.VALUE
, VIEW_CONFIG_COMMON.DESCRIPTION
FROM        
 VIEW_CONFIG_COMMON , ENT_ROBOT

UNION

-- 行业默认
SELECT  
2 AS PRIORITY 
, OWNER_ID
, OWNER_NAME + ''默认'' AS OWNER_NAME
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI
, VIEW_CONFIG_INDUSTRY.NAME
, VIEW_CONFIG_INDUSTRY.VALUE
, VIEW_CONFIG_INDUSTRY.DESCRIPTION
FROM VIEW_CONFIG_INDUSTRY, VIEW_USER_ROBOT_BIND_LIST
WHERE VIEW_CONFIG_INDUSTRY.OWNER_ID = VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_ID

UNION

-- 企业默认
SELECT  
4 AS PRIORITY 
, OWNER_ID
, OWNER_NAME 
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI
, VIEW_CONFIG_USER_GROUP.NAME
, VIEW_CONFIG_USER_GROUP.VALUE
, VIEW_CONFIG_USER_GROUP.DESCRIPTION
FROM VIEW_CONFIG_USER_GROUP, VIEW_USER_ROBOT_BIND_LIST
WHERE VIEW_CONFIG_USER_GROUP.OWNER_ID = VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID

UNION

-- 场景默认
SELECT  
6 AS PRIORITY 
, OWNER_ID
, OWNER_NAME 
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI
, VIEW_CONFIG_USER_GROUP_SCENE.NAME
, VIEW_CONFIG_USER_GROUP_SCENE.VALUE
, VIEW_CONFIG_USER_GROUP_SCENE.DESCRIPTION
FROM VIEW_CONFIG_USER_GROUP_SCENE, VIEW_USER_ROBOT_BIND_LIST
WHERE VIEW_CONFIG_USER_GROUP_SCENE.OWNER_ID = VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_SCENE_ID

UNION


-- 第二优先级，行业定制
SELECT  
1 AS PRIORITY 
, VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_ID AS OWNER_ID
, VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_NAME  AS OWNER_NAME
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI
, TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY.NAME
, TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY.VALUE
, TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY.DESCRIPTION
FROM TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY, VIEW_USER_ROBOT_BIND_LIST
WHERE TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY.INDUSTRY_ID = VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_ID

UNION

-- 第三优先级，企业定制
SELECT  
3 AS PRIORITY 
, VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID AS OWNER_ID
, VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_NAME AS OWNER_NAME
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI
, TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.NAME
, TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.VALUE
, TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.DESCRIPTION
FROM TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP, VIEW_USER_ROBOT_BIND_LIST
WHERE TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.USER_GROUP_ID = VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID

UNION
	
-- 第四优先级，场景定制
SELECT  
5 AS PRIORITY 
, VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_SCENE_ID AS OWNER_ID
, VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_SCENE_NAME  AS OWNER_NAME
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI
, TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE.NAME
, TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE.VALUE
, TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE.DESCRIPTION
FROM TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE, VIEW_USER_ROBOT_BIND_LIST
WHERE TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE.USER_GROUP_SCENE_ID = VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_SCENE_ID

UNION	
-- 第五优先级，机器定制
SELECT  
7 AS PRIORITY 
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID  AS OWNER_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_NAME   AS OWNER_NAME
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI
, TBL_CUSTOMIZED_CONFIG_FOR_ROBOT.NAME
, TBL_CUSTOMIZED_CONFIG_FOR_ROBOT.VALUE
, TBL_CUSTOMIZED_CONFIG_FOR_ROBOT.DESCRIPTION
FROM TBL_CUSTOMIZED_CONFIG_FOR_ROBOT, VIEW_USER_ROBOT_BIND_LIST
WHERE TBL_CUSTOMIZED_CONFIG_FOR_ROBOT.ROBOT_ID = VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID


UNION

-- 最高优先级，机器硬件规格
SELECT  
255 AS PRIORITY 
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID  AS OWNER_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_NAME   AS OWNER_NAME
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID
, VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI
, TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC.NAME
, TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC.VALUE
, TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC.DESCRIPTION
FROM TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC, VIEW_USER_ROBOT_BIND_LIST
WHERE TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC.HW_SPEC_ID = VIEW_USER_ROBOT_BIND_LIST.ROBOT_HW_SPEC_ID

		  		  
/*
UNION
SELECT     OWNER_TYPE AS PRIORITY, OWNER_ID, ''系统默认'' AS OWNER_NAME, dbo.ENT_ROBOT.ID AS ROBOT_ID, dbo.ENT_ROBOT.IMEI AS ROBOT_IMEI, 
                      dbo.ENT_CONFIG.NAME, dbo.ENT_CONFIG.VALUE, dbo.ENT_CONFIG.DESCRIPTION
FROM         dbo.ENT_CONFIG CROSS JOIN
  			VIEW_USER_ROBOT_BIND_LIST ON 
                      dbo.TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.USER_GROUP_ID = dbo.VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID
		   WHERE ENT_CONFIG.OWNER_ID = 0

UNION

SELECT     2 AS PRIORITY, dbo.VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID AS OWNER_ID, 
                      dbo.VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_NAME AS OWNER_NAME, dbo.VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID, 
                      dbo.VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI, dbo.TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.NAME, 
                      dbo.TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.VALUE, dbo.TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.DESCRIPTION
FROM         dbo.TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP INNER JOIN
                      dbo.VIEW_USER_ROBOT_BIND_LIST ON 
                      dbo.TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP.USER_GROUP_ID = dbo.VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID
UNION
SELECT     3 AS PRIORITY, ENT_ROBOT_1.ID AS OWNER_ID, ENT_ROBOT_1.NAME AS OWNER_NAME, ENT_ROBOT_1.ID AS ROBOT_ID, 
                      ENT_ROBOT_1.IMEI AS ROBOT_IMEI, dbo.TBL_CUSTOMIZED_CONFIG_FOR_ROBOT.NAME, dbo.TBL_CUSTOMIZED_CONFIG_FOR_ROBOT.VALUE, 
                      dbo.TBL_CUSTOMIZED_CONFIG_FOR_ROBOT.DESCRIPTION
FROM         dbo.TBL_CUSTOMIZED_CONFIG_FOR_ROBOT INNER JOIN
                      dbo.ENT_ROBOT AS ENT_ROBOT_1 ON dbo.TBL_CUSTOMIZED_CONFIG_FOR_ROBOT.ROBOT_ID = ENT_ROBOT_1.ID
*/








' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_CONFIG_FOR_EDITOR]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_CONFIG_FOR_EDITOR]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[VIEW_ROBOT_CONFIG_FOR_EDITOR]
AS
SELECT     TOP (100) PERCENT dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.PRIORITY
, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_IMEI
, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.NAME
, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.VALUE
, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.OWNER_ID
, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.OWNER_NAME
, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_ID
, ISNULL(ENT_CONFIG.CANDIDATE, '''') AS CANDIDATE
, ENT_CONFIG.DESCRIPTION
, ENT_CONFIG.LEVEL
, ISNULL(ENT_CONFIG.LIMIT_H, '''') AS LIMIT_H
, ISNULL(ENT_CONFIG.LIMIT_L, '''') AS LIMIT_L
, ISNULL(ENT_CONFIG.PATTERN, '''') AS PATTERN
, ENT_CONFIG.TYPE

FROM         VIEW_ROBOT_CONFIG_WITH_OWNER INNER JOIN
                          
						(SELECT     MAX(PRIORITY) AS PRIORITY, NAME, ROBOT_IMEI
                            FROM          dbo.VIEW_ROBOT_CONFIG_WITH_OWNER AS VIEW_ROBOT_CONFIG_WITH_OWNER_1
                            GROUP BY NAME, ROBOT_IMEI) AS MAX_PRIORITY_CONFIG_WITH_OWNER ON 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.PRIORITY = MAX_PRIORITY_CONFIG_WITH_OWNER.PRIORITY AND 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.NAME = MAX_PRIORITY_CONFIG_WITH_OWNER.NAME AND 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_IMEI = MAX_PRIORITY_CONFIG_WITH_OWNER.ROBOT_IMEI
		INNER JOIN ENT_CONFIG ON (ENT_CONFIG.NAME = VIEW_ROBOT_CONFIG_WITH_OWNER.NAME)

ORDER BY dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_IMEI



' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_CONFIG_FOR_EDITOR_MAIN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_CONFIG_FOR_EDITOR_MAIN]'))
EXEC dbo.sp_executesql @statement = N'



CREATE VIEW [dbo].[VIEW_ROBOT_CONFIG_FOR_EDITOR_MAIN]
AS
 
 SELECT * FROM VIEW_ROBOT_CONFIG_FOR_EDITOR 
 WHERE VIEW_ROBOT_CONFIG_FOR_EDITOR.LEVEL & 1 <> 0





' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_CONFIG_FOR_APP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_CONFIG_FOR_APP]'))
EXEC dbo.sp_executesql @statement = N'






CREATE VIEW [dbo].[VIEW_ROBOT_CONFIG_FOR_APP]
AS
 
 SELECT VIEW_ROBOT_CONFIG_FOR_EDITOR.NAME
 , VIEW_ROBOT_CONFIG_FOR_EDITOR.VALUE 
 , VIEW_ROBOT_CONFIG_FOR_EDITOR.ROBOT_IMEI
 FROM VIEW_ROBOT_CONFIG_FOR_EDITOR 
 WHERE VIEW_ROBOT_CONFIG_FOR_EDITOR.LEVEL & 2 > 0








' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER]
AS
SELECT     TOP (100) PERCENT dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.PRIORITY, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_IMEI, 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.NAME, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.VALUE, 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.DESCRIPTION, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.OWNER_ID, 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.OWNER_NAME, dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_ID
FROM         dbo.VIEW_ROBOT_CONFIG_WITH_OWNER INNER JOIN
                          (SELECT     MAX(PRIORITY) AS PRIORITY, NAME, ROBOT_IMEI
                            FROM          dbo.VIEW_ROBOT_CONFIG_WITH_OWNER AS VIEW_ROBOT_CONFIG_WITH_OWNER_1
                            GROUP BY NAME, ROBOT_IMEI) AS MAX_PRIORITY_CONFIG_WITH_OWNER ON 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.PRIORITY = MAX_PRIORITY_CONFIG_WITH_OWNER.PRIORITY AND 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.NAME = MAX_PRIORITY_CONFIG_WITH_OWNER.NAME AND 
                      dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_IMEI = MAX_PRIORITY_CONFIG_WITH_OWNER.ROBOT_IMEI
ORDER BY dbo.VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_IMEI
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_BELONG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_BELONG]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_BELONG]
AS
SELECT DISTINCT ROBOT_ID, ROBOT_IMEI, ROBOT_NAME, USER_GROUP_ID, USER_GROUP_NAME
FROM         dbo.VIEW_USER_ROBOT_BIND_LIST
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_APP_LASTEST_VERSION_CODE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_APP_LASTEST_VERSION_CODE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_APP_LASTEST_VERSION_CODE]
AS
SELECT     dbo.ENT_ROBOT_APP.ID AS ROBOT_APP_ID, MAX(dbo.TBL_ROBOT_APP_VERSION.VERSION_CODE) AS LASTEST_VERSION_CODE
FROM         dbo.ENT_ROBOT_APP LEFT OUTER JOIN
                      dbo.TBL_ROBOT_APP_VERSION ON dbo.ENT_ROBOT_APP.ID = dbo.TBL_ROBOT_APP_VERSION.ROBOT_APP_ID AND 
                      dbo.TBL_ROBOT_APP_VERSION.ENABLED = 1
GROUP BY dbo.ENT_ROBOT_APP.ID
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_APP_LASTEST_VERSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_APP_LASTEST_VERSION]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_ROBOT_APP_LASTEST_VERSION]
AS
SELECT     dbo.ENT_ROBOT_APP.ID AS ROBOT_APP_ID, dbo.ENT_ROBOT_APP.APP_NAME, dbo.ENT_ROBOT_APP.PACKAGE_NAME, 
                      dbo.ENT_ROBOT_APP.DESCRIPTION,
 ISNULL(dbo.VIEW_ROBOT_APP_LASTEST_VERSION_CODE.LASTEST_VERSION_CODE, ''0'') AS LASTEST_VERSION_CODE,
ISNULL(                      dbo.TBL_ROBOT_APP_VERSION.VERSION_NAME, ''N/A'') AS VERSION_NAME,
ISNULL(dbo.TBL_ROBOT_APP_VERSION.DOWNLOAD_URL, ''N/A'') AS DOWNLOAD_URL,
isnull(                      dbo.TBL_ROBOT_APP_VERSION.RELEASE_NOTE, ''N/A'') AS RELEASE_NOTE,
isnull(dbo.TBL_ROBOT_APP_VERSION.PUBLISH_DATETIME, ''1970-1-1'') AS PUBLISH_DATETIME, 

dbo.ENT_ROBOT_APP.ENABLE
FROM         dbo.ENT_ROBOT_APP LEFT OUTER JOIN
                      dbo.VIEW_ROBOT_APP_LASTEST_VERSION_CODE ON 
                      dbo.ENT_ROBOT_APP.ID = dbo.VIEW_ROBOT_APP_LASTEST_VERSION_CODE.ROBOT_APP_ID LEFT OUTER JOIN
                      dbo.TBL_ROBOT_APP_VERSION ON dbo.ENT_ROBOT_APP.ID = dbo.TBL_ROBOT_APP_VERSION.ROBOT_APP_ID AND 
                      dbo.VIEW_ROBOT_APP_LASTEST_VERSION_CODE.LASTEST_VERSION_CODE = dbo.TBL_ROBOT_APP_VERSION.VERSION_CODE
' 
GO
/****** Object:  View [dbo].[VIEW_VALID_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VALID_THIRD_PARTY_API]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_VALID_THIRD_PARTY_API]
AS
SELECT     NAME, URL, METHOD, DESCRIPTION, ID, RUN_AT_SERVER, RESULT_TYPE
FROM         dbo.ENT_THIRD_PARTY_API
WHERE     (ENABLE = 1)
' 
GO
/****** Object:  View [dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS_V2]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS_V2]
AS
SELECT     dbo.VIEW_VALID_THIRD_PARTY_API.ID AS API_ID
, dbo.VIEW_VALID_THIRD_PARTY_API.NAME AS API_NAME
, dbo.VIEW_VALID_THIRD_PARTY_API.URL, 
                      dbo.VIEW_VALID_THIRD_PARTY_API.METHOD
					  , dbo.VIEW_VALID_THIRD_PARTY_API.DESCRIPTION, 
					  ENT_THIRD_PARTY_API_PARAM.ID AS PARAM_ID
                      ,dbo.ENT_THIRD_PARTY_API_PARAM.NAME AS PARAM_NAME
					  , dbo.ENT_THIRD_PARTY_API_PARAM.HEADER_0_BODY_1, 
                      dbo.ENT_THIRD_PARTY_API_PARAM.DEFAULT_VALUE,
					   dbo.ENT_THIRD_PARTY_API_PARAM.OPTIONAL, 
                      dbo.VIEW_VALID_THIRD_PARTY_API.RUN_AT_SERVER, dbo.VIEW_VALID_THIRD_PARTY_API.RESULT_TYPE
FROM         dbo.VIEW_VALID_THIRD_PARTY_API INNER JOIN
                      dbo.TBL_THIRD_PARTY_API_PARAM 
					  ON 
					  (dbo.VIEW_VALID_THIRD_PARTY_API.ID = dbo.TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_ID)
					  INNER JOIN ENT_THIRD_PARTY_API_PARAM ON
					  (
					  ENT_THIRD_PARTY_API_PARAM.ID = TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID
					  )



' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_APP_BIND_LIST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_APP_BIND_LIST]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_ROBOT_APP_BIND_LIST]
AS
SELECT     VERSION_MAIN_INFO.APP_OWNER, VERSION_MAIN_INFO.APP_ID, VERSION_MAIN_INFO.APP_PACKAGE_NAME, VERSION_MAIN_INFO.APP_NAME, 
                      VERSION_MAIN_INFO.DESCRIPTION, VERSION_MAIN_INFO.ROBOT_IMEI, VERSION_MAIN_INFO.ROBOT_NAME, 
                      VERSION_MAIN_INFO.USER_GROUP_ID, VERSION_MAIN_INFO.USER_GROUP_NAME, 
                      dbo.VIEW_ROBOT_APP_LASTEST_VERSION.LASTEST_VERSION_CODE, 
                      dbo.VIEW_ROBOT_APP_LASTEST_VERSION.VERSION_NAME AS LASTEST_VERSION_NAME, 
                      dbo.VIEW_ROBOT_APP_LASTEST_VERSION.DOWNLOAD_URL, dbo.VIEW_ROBOT_APP_LASTEST_VERSION.RELEASE_NOTE, 
                      dbo.VIEW_ROBOT_APP_LASTEST_VERSION.PUBLISH_DATETIME, dbo.VIEW_ROBOT_APP_LASTEST_VERSION.ENABLE
FROM         (SELECT     ''公用'' AS APP_OWNER, dbo.ENT_ROBOT_APP.ID AS APP_ID, dbo.ENT_ROBOT_APP.PACKAGE_NAME AS APP_PACKAGE_NAME, 
                                              dbo.ENT_ROBOT_APP.APP_NAME, dbo.ENT_ROBOT_APP.DESCRIPTION, dbo.VIEW_ROBOT_BELONG.ROBOT_IMEI, 
                                              dbo.VIEW_ROBOT_BELONG.ROBOT_NAME, dbo.VIEW_ROBOT_BELONG.USER_GROUP_ID, 
                                              dbo.VIEW_ROBOT_BELONG.USER_GROUP_NAME
                       FROM          dbo.ENT_ROBOT_APP CROSS JOIN
                                              dbo.VIEW_ROBOT_BELONG
                       WHERE      (dbo.ENT_ROBOT_APP.EXCLUSIVE = 0)

				EXCEPT

				SELECT     ''公用'' AS APP_OWNER, dbo.ENT_ROBOT_APP.ID AS APP_ID, dbo.ENT_ROBOT_APP.PACKAGE_NAME AS APP_PACKAGE_NAME, 
                                              dbo.ENT_ROBOT_APP.APP_NAME, dbo.ENT_ROBOT_APP.DESCRIPTION, dbo.VIEW_ROBOT_BELONG.ROBOT_IMEI, 
                                              dbo.VIEW_ROBOT_BELONG.ROBOT_NAME, dbo.VIEW_ROBOT_BELONG.USER_GROUP_ID, 
                                              dbo.VIEW_ROBOT_BELONG.USER_GROUP_NAME
                       FROM          
                                    VIEW_ROBOT_BELONG 
									INNER JOIN TBL_ROBOT_APP_EXCLUDE ON ( VIEW_ROBOT_BELONG.USER_GROUP_ID = TBL_ROBOT_APP_EXCLUDE.USER_GROUP_ID)
									INNER JOIN ENT_ROBOT_APP ON (TBL_ROBOT_APP_EXCLUDE.ROBOT_APP_ID = ENT_ROBOT_APP.ID)

                       WHERE      (dbo.ENT_ROBOT_APP.EXCLUSIVE = 0)

                       UNION
                       SELECT     ''专属'' AS APP_OWNER, ENT_ROBOT_APP_1.ID AS APP_ID, ENT_ROBOT_APP_1.PACKAGE_NAME AS APP_PACKAGE_NAME, 
                                             ENT_ROBOT_APP_1.APP_NAME, ENT_ROBOT_APP_1.DESCRIPTION, VIEW_ROBOT_BELONG_1.ROBOT_IMEI, 
                                             VIEW_ROBOT_BELONG_1.ROBOT_NAME, VIEW_ROBOT_BELONG_1.USER_GROUP_ID, 
                                             VIEW_ROBOT_BELONG_1.USER_GROUP_NAME
                       FROM         dbo.TBL_ROBOT_APP_EXCLUSIVE INNER JOIN
                                             dbo.VIEW_ROBOT_BELONG AS VIEW_ROBOT_BELONG_1 ON 
                                             dbo.TBL_ROBOT_APP_EXCLUSIVE.USER_GROUP_ID = VIEW_ROBOT_BELONG_1.USER_GROUP_ID INNER JOIN
                                             dbo.ENT_ROBOT_APP AS ENT_ROBOT_APP_1 ON dbo.TBL_ROBOT_APP_EXCLUSIVE.ROBOT_APP_ID = ENT_ROBOT_APP_1.ID) 
                      AS VERSION_MAIN_INFO LEFT OUTER JOIN
                      dbo.VIEW_ROBOT_APP_LASTEST_VERSION ON dbo.VIEW_ROBOT_APP_LASTEST_VERSION.ROBOT_APP_ID = VERSION_MAIN_INFO.APP_ID
' 
GO
/****** Object:  View [dbo].[VIEW_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VOICE]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[VIEW_VOICE]
AS
SELECT     dbo.ENT_VOICE.ID, dbo.ENT_VOICE.NAME, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(dbo.ENT_VOICE.PATH, ''{1}'', ISNULL(R1.VALUE, ''{1}'')), 
                      ''{2}'', ISNULL(R2.VALUE, ''{2}'')), ''{3}'', ISNULL(R3.VALUE, ''{3}'')), ''{4}'', ISNULL(R4.VALUE, '''')), ''{5}'', ISNULL(R5.VALUE, ''{5}'')) AS PATH, 
                      REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(dbo.ENT_VOICE.TEXT, ''{1}'', ISNULL(R1.VALUE, ''{1}'')), ''{2}'', ISNULL(R2.VALUE, ''{2}'')), ''{3}'', 
                      ISNULL(R3.VALUE, ''{3}'')), ''{4}'', ISNULL(R4.VALUE, '''')), ''{5}'', ISNULL(R5.VALUE, ''{5}'')) AS TEXT, dbo.ENT_VOICE.CAT, dbo.ENT_VOICE.DESCRIPTION, 
                      dbo.ENT_VOICE.COMMAND, dbo.ENT_VOICE.COMMAND_PARAM, dbo.VIEW_VALID_THIRD_PARTY_API.NAME AS THIRD_PARTY_API_NAME, 
                      dbo.VIEW_VALID_THIRD_PARTY_API.METHOD AS THIRD_PARTY_API_METHOD, 
                      dbo.FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2(dbo.ENT_VOICE.THIRD_PARTY_API_ID, 0, 
                      dbo.ENT_VOICE.THIRD_PARTY_API_PARAMS_VALUE_ID) AS THIRD_PARTY_API_HEADER_PARAMS, 
                      dbo.VIEW_VALID_THIRD_PARTY_API.URL + N''?'' + dbo.FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2(dbo.VIEW_VALID_THIRD_PARTY_API.ID, 1, 
                      dbo.ENT_VOICE.THIRD_PARTY_API_PARAMS_VALUE_ID) AS THIRD_PARTY_API_URL, 
                      dbo.VIEW_VALID_THIRD_PARTY_API.RESULT_TYPE AS THIRD_PARTY_API_RESULT_TYPE, 
                      dbo.VIEW_VALID_THIRD_PARTY_API.RUN_AT_SERVER AS THIRD_PARTY_API_RUN_AT_SERVER, dbo.ENT_VOICE.INC_PROP, 
                      dbo.ENT_VOICE.EXC_PROP, dbo.ENT_VOICE.EMOTION, dbo.ENT_VOICE.ENABLED
FROM         dbo.ENT_VOICE LEFT OUTER JOIN
                      dbo.ENT_RESOURCE AS R1 ON dbo.ENT_VOICE.FIXED_PARAM_1 = R1.ID LEFT OUTER JOIN
                      dbo.ENT_RESOURCE AS R2 ON dbo.ENT_VOICE.FIXED_PARAM_2 = R2.ID LEFT OUTER JOIN
                      dbo.ENT_RESOURCE AS R3 ON dbo.ENT_VOICE.FIXED_PARAM_3 = R3.ID LEFT OUTER JOIN
                      dbo.ENT_RESOURCE AS R4 ON dbo.ENT_VOICE.FIXED_PARAM_4 = R4.ID LEFT OUTER JOIN
                      dbo.ENT_RESOURCE AS R5 ON dbo.ENT_VOICE.FIXED_PARAM_5 = R5.ID LEFT OUTER JOIN
                      dbo.VIEW_VALID_THIRD_PARTY_API ON dbo.VIEW_VALID_THIRD_PARTY_API.ID = dbo.ENT_VOICE.THIRD_PARTY_API_ID


' 
GO
/****** Object:  View [dbo].[VIEW_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VOICE_GROUP]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_VOICE_GROUP]
AS
SELECT     dbo.VIEW_VOICE.ID, (CASE WHEN dbo.TBL_VOICE_GROUP.ID IS NULL THEN - 1 ELSE TBL_VOICE_GROUP.ID END) AS VOICE_GROUP_ID, 
                      dbo.VIEW_VOICE.NAME AS VOICE_NAME, dbo.VIEW_VOICE.PATH AS VOICE_PATH, dbo.VIEW_VOICE.TEXT AS VOICE_TEXT, 
                      dbo.VIEW_VOICE.CAT AS VOICE_CAT, dbo.VIEW_VOICE.DESCRIPTION AS VOICE_DESCRIPTION, dbo.VIEW_VOICE.COMMAND AS VOICE_COMMAND, 
                      dbo.VIEW_VOICE.COMMAND_PARAM AS VOICE_COMMAND_PARAM, dbo.VIEW_VOICE.THIRD_PARTY_API_NAME AS VOICE_THIRD_PARTY_API_NAME,
                       dbo.VIEW_VOICE.THIRD_PARTY_API_METHOD AS VOICE_THIRD_PARTY_API_METHOD, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_HEADER_PARAMS AS VOICE_THIRD_PARTY_API_HEADER_PARAMS, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_URL AS VOICE_THIRD_PARTY_API_URL, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_RESULT_TYPE AS VOICE_THIRD_PARTY_API_RESULT_TYPE, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_RUN_AT_SERVER AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER, 
                      dbo.VIEW_VOICE.INC_PROP AS VOICE_INC_PROP, dbo.VIEW_VOICE.EXC_PROP AS VOICE_EXC_PROP, 
                      dbo.VIEW_VOICE.EMOTION AS VOICE_EMOTION, dbo.VIEW_VOICE.ENABLED AS VOICE_ENABLED
FROM         dbo.VIEW_VOICE LEFT OUTER JOIN
                      dbo.TBL_VOICE_GROUP ON dbo.VIEW_VOICE.ID = dbo.TBL_VOICE_GROUP.VOICE_ID AND dbo.VIEW_VOICE.ENABLED = 1
' 
GO
/****** Object:  View [dbo].[VIEW_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_WORD_GROUP_FLOW]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_WORD_GROUP_FLOW]
AS
SELECT     dbo.ENT_KEY_WORDS.ID AS KEY_WORD_ID, dbo.ENT_KEY_WORDS.KW, dbo.ENT_KEY_WORDS.CAT AS KEY_WORD_CATEGORY, 
                      dbo.TBL_WORD_GROUP.GROUP_ID, dbo.TBL_WORD_GROUP_FLOW.ID AS GROUP_FLOW_ID, 
                      dbo.TBL_WORD_GROUP_FLOW.GROUP_FLOW_ORDER, dbo.TBL_WORD_GROUP_FLOW.INC_1_EXC_0 AS GROUP_FLOW_INC_1_EXC_0, 
                      dbo.ENT_KEY_WORDS.SOUND AS KEY_WORD_SOUND, dbo.TBL_WORD_GROUP_FLOW.USE_SOUND AS GROUP_FLOW_USE_SOUND
FROM         dbo.ENT_KEY_WORDS INNER JOIN
                      dbo.TBL_WORD_GROUP ON dbo.ENT_KEY_WORDS.ID = dbo.TBL_WORD_GROUP.KEY_WORD_ID INNER JOIN
                      dbo.TBL_WORD_GROUP_FLOW ON dbo.TBL_WORD_GROUP.GROUP_ID = dbo.TBL_WORD_GROUP_FLOW.WORD_GROUP_ID
' 
GO
/****** Object:  View [dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]'))
EXEC dbo.sp_executesql @statement = N'/*SELECT 
ENT_VOICE.NAME
,ENT_VOICE.PATH
,ENT_VOICE.FIXED_PARAM_1
,ENT_VOICE.FIXED_PARAM_2
,ENT_VOICE.FIXED_PARAM_3
,ENT_VOICE.FIXED_PARAM_4
,ENT_VOICE.FIXED_PARAM_5
,VIEW_WORD_GROUP_FLOW.KW
FROM
VIEW_WORD_GROUP_FLOW
, TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE
, TBL_VOICE_GROUP
, ENT_VOICE
WHERE
TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.WORD_GROUP_FLOW_ID = 
VIEW_WORD_GROUP_FLOW.GROUP_FLOW_ID AND
TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.VOICE_GROUP_ID = TBL_VOICE_GROUP.ID AND
ENT_VOICE.ID = TBL_VOICE_GROUP.VOICE_ID
 and CHARINDEX(VIEW_WORD_GROUP_FLOW.KW, ''今天的天气怎么样，'') > 0
 select */
CREATE VIEW [dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]
AS
SELECT     dbo.VIEW_VOICE.ID AS VOICE_ID, dbo.VIEW_VOICE.NAME AS VOICE_NAME, dbo.VIEW_VOICE.PATH AS VOICE_PATH, 
                      dbo.VIEW_VOICE.TEXT AS VOICE_TEXT, dbo.VIEW_VOICE.CAT AS VOICE_CAT, dbo.VIEW_VOICE.DESCRIPTION AS VOICE_DESCRIPTION, 
                      dbo.TBL_VOICE_GROUP.ID AS VOICE_GROUP_ID, dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.USE_FLOW_ORDER, 
                      dbo.VIEW_WORD_GROUP_FLOW.KEY_WORD_ID, dbo.VIEW_WORD_GROUP_FLOW.KW AS KEY_WORD, 
                      dbo.VIEW_WORD_GROUP_FLOW.KEY_WORD_CATEGORY, dbo.VIEW_WORD_GROUP_FLOW.GROUP_ID AS KEY_WORD_GROUP_ID, 
                      dbo.VIEW_WORD_GROUP_FLOW.GROUP_FLOW_ID AS KEY_WORD_GROUP_FLOW_ID, 
                      dbo.VIEW_WORD_GROUP_FLOW.GROUP_FLOW_ORDER AS KEY_WORD_GROUP_FLOW_ORDER, 
                      dbo.VIEW_VOICE.COMMAND AS VOICE_COMMAND, dbo.VIEW_VOICE.COMMAND_PARAM AS VOICE_COMMAND_PARAM, 
                      dbo.VIEW_WORD_GROUP_FLOW.GROUP_FLOW_INC_1_EXC_0 AS KEY_WORD_GROUP_INC_1_EXC_0, 
                      dbo.VIEW_VOICE.INC_PROP AS VOICE_INC_PROP, dbo.VIEW_VOICE.EXC_PROP AS VOICE_EXC_PROP, 
                      dbo.VIEW_VOICE.EMOTION AS VOICE_EMOTION, dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.ENABLE, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_RUN_AT_SERVER AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_RESULT_TYPE AS VOICE_THIRD_PARTY_API_RESULT_TYPE, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_URL AS VOICE_THIRD_PARTY_API_URL, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_HEADER_PARAMS AS VOICE_THIRD_PARTY_API_HEADER_PARAMS, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_METHOD AS VOICE_THIRD_PARTY_API_METHOD, 
                      dbo.VIEW_VOICE.THIRD_PARTY_API_NAME AS VOICE_THIRD_PARTY_API_NAME, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.USE_FULLY_MATCH, dbo.VIEW_VOICE.ENABLED AS VOICE_ENABLED, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.ID AS RULE_ID, dbo.VIEW_WORD_GROUP_FLOW.KEY_WORD_SOUND, 
                      dbo.VIEW_WORD_GROUP_FLOW.GROUP_FLOW_USE_SOUND
FROM         dbo.VIEW_WORD_GROUP_FLOW INNER JOIN
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE ON dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.ENABLE = 1 AND 
                      dbo.VIEW_WORD_GROUP_FLOW.GROUP_FLOW_ID = dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.WORD_GROUP_FLOW_ID INNER JOIN
                      dbo.TBL_VOICE_GROUP ON dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.VOICE_GROUP_ID = dbo.TBL_VOICE_GROUP.ID INNER JOIN
                      dbo.VIEW_VOICE ON dbo.TBL_VOICE_GROUP.VOICE_ID = dbo.VIEW_VOICE.ID
' 
GO
/****** Object:  View [dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS]
AS
SELECT     dbo.VIEW_VALID_THIRD_PARTY_API.ID, dbo.VIEW_VALID_THIRD_PARTY_API.NAME, dbo.VIEW_VALID_THIRD_PARTY_API.URL, 
                      dbo.VIEW_VALID_THIRD_PARTY_API.METHOD, dbo.VIEW_VALID_THIRD_PARTY_API.DESCRIPTION, 
                      dbo.TBL_THIRD_PARTY_API_PARAMS.PARAM_NAME, dbo.TBL_THIRD_PARTY_API_PARAMS.HEADER_0_BODY_1, 
                      dbo.TBL_THIRD_PARTY_API_PARAMS.DEFAULT_VALUE, dbo.TBL_THIRD_PARTY_API_PARAMS.OPTIONAL, 
                      dbo.VIEW_VALID_THIRD_PARTY_API.RUN_AT_SERVER, dbo.VIEW_VALID_THIRD_PARTY_API.RESULT_TYPE
FROM         dbo.VIEW_VALID_THIRD_PARTY_API INNER JOIN
                      dbo.TBL_THIRD_PARTY_API_PARAMS ON dbo.VIEW_VALID_THIRD_PARTY_API.ID = dbo.TBL_THIRD_PARTY_API_PARAMS.THIRD_PARTY_API_ID
' 
GO
/****** Object:  View [dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_SIMPLE]
AS
SELECT     KEY_WORD, VOICE_NAME, VOICE_PATH, VOICE_TEXT, VOICE_CAT, VOICE_DESCRIPTION, VOICE_COMMAND, VOICE_COMMAND_PARAM, 
                      KEY_WORD_GROUP_INC_1_EXC_0, VOICE_INC_PROP, VOICE_EXC_PROP, VOICE_EMOTION, ENABLE, VOICE_THIRD_PARTY_API_RUN_AT_SERVER, 
                      VOICE_THIRD_PARTY_API_RESULT_TYPE, VOICE_THIRD_PARTY_API_URL, VOICE_THIRD_PARTY_API_HEADER_PARAMS, 
                      VOICE_THIRD_PARTY_API_METHOD, VOICE_THIRD_PARTY_API_NAME
FROM         dbo.VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_MANUAL_TALK_CACHE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_MANUAL_TALK_CACHE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_MANUAL_TALK_CACHE]
AS
SELECT   dbo.ENT_ROBOT.IMEI, dbo.ENT_ROBOT.NAME, dbo.ENT_ROBOT.ACTIVATE_DATETIME, 
                dbo.ENT_ROBOT.ACTIVATE_USER_ID, dbo.ENT_ROBOT.MANUAL_MODE, dbo.ENT_ROBOT.DESCRIPTION, 
                dbo.VIEW_VOICE.NAME AS VOICE_NAME, dbo.VIEW_VOICE.PATH, dbo.VIEW_VOICE.TEXT, dbo.VIEW_VOICE.CAT, 
                dbo.VIEW_VOICE.DESCRIPTION AS VOICE_DESCRIPTION, dbo.VIEW_VOICE.COMMAND, 
                dbo.VIEW_VOICE.COMMAND_PARAM, dbo.VIEW_VOICE.THIRD_PARTY_API_NAME, 
                dbo.VIEW_VOICE.THIRD_PARTY_API_METHOD, dbo.VIEW_VOICE.THIRD_PARTY_API_HEADER_PARAMS, 
                dbo.VIEW_VOICE.THIRD_PARTY_API_URL, dbo.VIEW_VOICE.THIRD_PARTY_API_RESULT_TYPE, 
                dbo.VIEW_VOICE.THIRD_PARTY_API_RUN_AT_SERVER, dbo.VIEW_VOICE.INC_PROP, dbo.VIEW_VOICE.EXC_PROP, 
                dbo.VIEW_VOICE.EMOTION, dbo.VIEW_VOICE.ENABLED, dbo.TBL_ROBOT_MANUAL_TALK_CACHE.ROBOT_ID, 
                dbo.TBL_ROBOT_MANUAL_TALK_CACHE.VOICE_ID, 
                dbo.TBL_ROBOT_MANUAL_TALK_CACHE.CREATE_DATETIME
FROM      dbo.TBL_ROBOT_MANUAL_TALK_CACHE INNER JOIN
                dbo.VIEW_VOICE ON dbo.TBL_ROBOT_MANUAL_TALK_CACHE.VOICE_ID = dbo.VIEW_VOICE.ID INNER JOIN
                dbo.ENT_ROBOT ON dbo.TBL_ROBOT_MANUAL_TALK_CACHE.ROBOT_ID = dbo.ENT_ROBOT.ID
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_APP_VERSION_REQUIRED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_APP_VERSION_REQUIRED]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_ROBOT_APP_VERSION_REQUIRED]
AS
SELECT   dbo.TBL_ROBOT_APP_VERSION_REQUIRED.DB_VERSION, dbo.VIEW_ROBOT_APP_BIND_LIST.APP_ID, 
                dbo.VIEW_ROBOT_APP_BIND_LIST.APP_NAME, dbo.VIEW_ROBOT_APP_BIND_LIST.ROBOT_IMEI, 
                dbo.TBL_ROBOT_APP_VERSION_REQUIRED.VERSION_CODE AS REQURIED_VERSION_CODE, 
                dbo.TBL_ROBOT_APP_VERSION.VERSION_NAME AS REQURIED_VERSION_NAME, 
                dbo.VIEW_ROBOT_APP_BIND_LIST.LASTEST_VERSION_CODE, 
                dbo.VIEW_ROBOT_APP_BIND_LIST.LASTEST_VERSION_NAME
FROM      dbo.ENT_DB_VERSION INNER JOIN
                dbo.TBL_ROBOT_APP_VERSION_REQUIRED ON 
                dbo.ENT_DB_VERSION.NAME = dbo.TBL_ROBOT_APP_VERSION_REQUIRED.DB_VERSION INNER JOIN
                dbo.VIEW_ROBOT_APP_BIND_LIST ON 
                dbo.TBL_ROBOT_APP_VERSION_REQUIRED.ROBOT_APP_ID = dbo.VIEW_ROBOT_APP_BIND_LIST.APP_ID INNER JOIN
                dbo.TBL_ROBOT_APP_VERSION ON 
                dbo.TBL_ROBOT_APP_VERSION.VERSION_CODE = dbo.TBL_ROBOT_APP_VERSION_REQUIRED.VERSION_CODE AND 
                dbo.TBL_ROBOT_APP_VERSION.ROBOT_APP_ID = dbo.TBL_ROBOT_APP_VERSION_REQUIRED.ROBOT_APP_ID AND
				TBL_ROBOT_APP_VERSION.ENABLED = 1

' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_USER_BINDLIST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_USER_BINDLIST]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_USER_BINDLIST]
AS
SELECT     dbo.ENT_ROBOT.ID AS ROBOT_ID, dbo.ENT_ROBOT.IMEI AS ROBOT_IMEI, dbo.ENT_ROBOT.NAME AS ROBOT_NAME, 
                      dbo.ENT_ROBOT.ACTIVATE_DATETIME, dbo.ENT_ROBOT.ACTIVATE_USER_ID, dbo.ENT_USER.NAME AS ACTIVDATE_USER_NAME, 
                      dbo.ENT_USER.USER_GROUP_ID AS ACTIVDATE_USER_ID, dbo.ENT_USER_GROUP.NAME AS ACTIVDATE_USER_GROUP_NAME, 
                      dbo.TBL_ROBOT_STATUS.ONLINE AS ROBOT_ONLINE, dbo.TBL_ROBOT_STATUS.WSS_SESSION_ID AS ROBOT_SESSION_ID, 
                      dbo.TBL_ROBOT_STATUS.UPDATE_DATETIME AS ROBOT_STATUS_UPDATE_TIME
FROM         dbo.ENT_ROBOT INNER JOIN
                      dbo.ENT_USER ON dbo.ENT_ROBOT.ACTIVATE_USER_ID = dbo.ENT_USER.ID INNER JOIN
                      dbo.ENT_USER_GROUP ON dbo.ENT_USER.USER_GROUP_ID = dbo.ENT_USER_GROUP.ID LEFT OUTER JOIN
                      dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME ON 
                      dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.ROBOT_ID = dbo.ENT_ROBOT.ID LEFT OUTER JOIN
                      dbo.TBL_ROBOT_STATUS ON dbo.TBL_ROBOT_STATUS.ROBOT_ID = dbo.ENT_ROBOT.ID AND 
                      dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME = dbo.TBL_ROBOT_STATUS.UPDATE_DATETIME
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_LATEST_STATUS_drop]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_LATEST_STATUS_drop]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_LATEST_STATUS_drop]
AS
SELECT     dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.ROBOT_ID, 
                      dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME AS UPDATE_DATETIME, 
                      dbo.TBL_ROBOT_STATUS.WSS_SESSION_ID, CAST(ISNULL(dbo.TBL_ROBOT_STATUS.ONLINE, 0) AS BIT) AS ONLINE, 
                      dbo.TBL_ROBOT_STATUS.EXTRA_INFO, dbo.ENT_ROBOT.NAME AS ROBOT_NAME
FROM         dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME LEFT OUTER JOIN
                      dbo.TBL_ROBOT_STATUS ON dbo.TBL_ROBOT_STATUS.ROBOT_ID = dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.ROBOT_ID AND 
                      dbo.TBL_ROBOT_STATUS.UPDATE_DATETIME = dbo.VIEW_ROBOT_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME INNER JOIN
                      dbo.ENT_ROBOT ON dbo.ENT_ROBOT.ID = dbo.TBL_ROBOT_STATUS.ROBOT_ID
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_CONFIG]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_ROBOT_CONFIG]
AS
SELECT 
VIEW_ROBOT_CONFIG_WITH_OWNER.PRIORITY
, VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_IMEI
, VIEW_ROBOT_CONFIG_WITH_OWNER.NAME
,VIEW_ROBOT_CONFIG_WITH_OWNER.VALUE
, VIEW_ROBOT_CONFIG_WITH_OWNER.DESCRIPTION
FROM VIEW_ROBOT_CONFIG_WITH_OWNER
 
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG]
AS
SELECT     TOP (100) PERCENT dbo.VIEW_ROBOT_CONFIG.PRIORITY, dbo.VIEW_ROBOT_CONFIG.ROBOT_IMEI, dbo.VIEW_ROBOT_CONFIG.NAME, 
                      dbo.VIEW_ROBOT_CONFIG.VALUE, dbo.VIEW_ROBOT_CONFIG.DESCRIPTION
FROM         dbo.VIEW_ROBOT_CONFIG INNER JOIN
                          (SELECT     MAX(PRIORITY) AS PRIORITY, NAME, ROBOT_IMEI
                            FROM          dbo.VIEW_ROBOT_CONFIG AS VIEW_ROBOT_CONFIG_1
                            GROUP BY NAME, ROBOT_IMEI) AS MAX_PRIORITY_CONFIG ON dbo.VIEW_ROBOT_CONFIG.PRIORITY = MAX_PRIORITY_CONFIG.PRIORITY AND 
                      dbo.VIEW_ROBOT_CONFIG.NAME = MAX_PRIORITY_CONFIG.NAME AND 
                      dbo.VIEW_ROBOT_CONFIG.ROBOT_IMEI = MAX_PRIORITY_CONFIG.ROBOT_IMEI
ORDER BY dbo.VIEW_ROBOT_CONFIG.ROBOT_IMEI
' 
GO
/****** Object:  View [dbo].[VIEW_ENDPOINT_LATEST_STATUS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ENDPOINT_LATEST_STATUS]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_ENDPOINT_LATEST_STATUS]
AS
SELECT
     ROBOT_ID AS END_POINT_ID
 ,    ROBOT_NAME AS END_POINT_NAME
, UPDATE_DATETIME
, WSS_SESSION_ID
, ONLINE
, EXTRA_INFO
, CAST(1 AS BIT) AS IS_ROBOT
FROM
         dbo.VIEW_ROBOT_LATEST_STATUS
UNION
SELECT
     USER_ID AS END_POINT_ID
 ,    USER_NAME AS END_POINT_NAME
, UPDATE_DATETIME
, WSS_SESSION_ID
, ONLINE
, EXTRA_INFO
, CAST(0 AS BIT) AS IS_ROBOT
FROM
         dbo.VIEW_USER_LASTEST_STATUS
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_TAGS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_TAGS]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_ROBOT_TAGS]
AS
SELECT       dbo.ENT_ROBOT.IMEI, dbo.TBL_ROBOT_TAGS.ROBOT_ID, dbo.TBL_ROBOT_TAGS.TAG
FROM         dbo.ENT_ROBOT INNER JOIN
                      dbo.TBL_ROBOT_TAGS ON dbo.ENT_ROBOT.ID = dbo.TBL_ROBOT_TAGS.ROBOT_ID
			UNION
			SELECT 
			VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI AS IMEI,
			VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID ,
			VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_TAG AS TAG
			FROM VIEW_USER_ROBOT_BIND_LIST
			WHERE VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_TAG   is not null
			UNION
			SELECT 
			VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI AS IMEI,
			VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID ,
			VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_TAG AS TAG
			FROM VIEW_USER_ROBOT_BIND_LIST

' 
GO
/****** Object:  View [dbo].[VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME]
AS
SELECT     dbo.TBL_RTC_SESSION.ID AS RTC_SESSION_ID, ISNULL(MAX(dbo.TBL_RTC_SESSION_STATUS.UPDATE_DATETIME), ''1970-1-1'') 
                      AS LATEST_UPDATE_DATETIME
FROM         dbo.TBL_RTC_SESSION LEFT OUTER JOIN
                      dbo.TBL_RTC_SESSION_STATUS ON dbo.TBL_RTC_SESSION.ID = dbo.TBL_RTC_SESSION_STATUS.RTC_SESSION_ID
GROUP BY dbo.TBL_RTC_SESSION.ID
' 
GO
/****** Object:  View [dbo].[VIEW_RTC_SESSION_STATUS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_RTC_SESSION_STATUS]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_RTC_SESSION_STATUS]
AS
SELECT     dbo.TBL_RTC_SESSION.ID AS RTC_SESSION_ID, dbo.TBL_RTC_SESSION.ROBOT_ID, dbo.TBL_RTC_SESSION.USER_ID, 
                      dbo.TBL_RTC_SESSION.ROBOT_INITIATE, dbo.TBL_RTC_SESSION.CREATE_DATETIME, 
                      dbo.VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME, dbo.TBL_RTC_SESSION_STATUS.STATUS
FROM         dbo.TBL_RTC_SESSION INNER JOIN
                      dbo.VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME ON 
                      dbo.VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME.RTC_SESSION_ID = dbo.TBL_RTC_SESSION.ID LEFT OUTER JOIN
                      dbo.TBL_RTC_SESSION_STATUS ON 
                      dbo.VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME.LATEST_UPDATE_DATETIME = dbo.TBL_RTC_SESSION_STATUS.UPDATE_DATETIME
' 
GO
/****** Object:  View [dbo].[VIEW_BIZ_MENUTREE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_BIZ_MENUTREE]'))
EXEC dbo.sp_executesql @statement = N'/*AND [ENT_BIZ_MENU_ENTRY].NAME = ''SPIRO_EXPO_0706''*/
CREATE VIEW [dbo].[VIEW_BIZ_MENUTREE]
AS
SELECT     dbo.ENT_BIZ_MENU_ENTRY.NAME AS MENU_ENTRY_NAME, dbo.TBL_BIZ_MENUTREE.ID AS MENU_ID, 
                      dbo.TBL_BIZ_MENUTREE.LABEL AS MENU_LABEL, dbo.TBL_BIZ_MENUTREE.EXTRA AS MENU_EXTRA, 
                      dbo.TBL_BIZ_MENUTREE.PARENT_ID AS PARENT_MENU_ID, dbo.TBL_BIZ_MENUTREE.SEQ AS MENU_SEQ, 
                      dbo.TBL_BIZ_MENUITEM_ACTION.ACTION, dbo.TBL_BIZ_MENUITEM_ACTION.URI AS ACTION_URI, 
                      dbo.TBL_BIZ_MENUITEM_ACTION.TYPE AS ACTION_TYPE, dbo.TBL_BIZ_MENUITEM_ACTION.EXTRA AS ACTION_EXTRA, 
                      dbo.TBL_BIZ_MENUITEM_ACTION.PACKAGE_NAME AS ACTION_PACKAGE_NAME, 
                      dbo.TBL_BIZ_MENUITEM_ACTION.CLASS_NAME AS ACTION_CLASS_NAME
FROM         dbo.ENT_BIZ_MENU_ENTRY INNER JOIN
                      dbo.TBL_BIZ_MENUTREE ON dbo.ENT_BIZ_MENU_ENTRY.NAME = dbo.TBL_BIZ_MENUTREE.OWNER_MENU LEFT OUTER JOIN
                      dbo.TBL_BIZ_MENUITEM_ACTION ON dbo.TBL_BIZ_MENUTREE.MENUITEM_ACTION_ID = dbo.TBL_BIZ_MENUITEM_ACTION.ID
' 
GO
/****** Object:  View [dbo].[VIEW_CHAT_HISTORY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_CHAT_HISTORY]'))
EXEC dbo.sp_executesql @statement = N'



CREATE VIEW [dbo].[VIEW_CHAT_HISTORY]
AS
SELECT     TOP (100) PERCENT ID
, REQUEST
, REQUEST_EP_SN
, REQUEST_MODEL
, isnull(REQUEST_CLIENT_IP, '''') AS REQUEST_CLIENT_IP
, ISNULL(REQUEST_CLIENT_VERSION, '''') AS REQUEST_CLIENT_VERSION
, { fn IFNULL(REQUEST_ADDR, ''N/A'') } AS REQUEST_ADDR
, 
                     ISNULL(RESPONSE_1, '''') AS RESPONSE_1
					 , (CASE  SUBSTRING( REVERSE(RESPONSE_1), 1,1)   WHEN ''1'' THEN ''螺趣语义'' WHEN ''2'' THEN ''无法回答'' WHEN ''3'' THEN RESPONSE_14 WHEN ''4'' THEN ''第三方/自主提交'' WHEN ''5'' THEN ''人工模式'' END) AS KIND
					 
					 , ISNULL(RESPONSE_3, '''') AS TEXT
					 , ISNULL(RESPONSE_14, '''') AS SOURCE
                     , EXEC_MILLSECS
					 , DATE_TIME
FROM         dbo.ENT_DIALOG_BACKUP
ORDER BY DATE_TIME DESC




' 
GO
/****** Object:  View [dbo].[VIEW_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_CONFIG]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [dbo].[VIEW_CONFIG]
AS


SELECT [NAME]
      ,[OWNER_ID]
	  ,DBO.FUNC_GET_CONFIG_OWNER_NAME(OWNER_TYPE, OWNER_ID) AS OWNER_NAME
	  , OWNER_TYPE
      , CASE [OWNER_TYPE] WHEN 1 THEN ''系统配置'' WHEN 2 THEN ''行业配置'' WHEN 3 THEN ''企业配置'' WHEN 4 THEN ''场景配置'' END OWNER_TYPE_NAME
      ,[TYPE]
      ,[VALUE]
      ,[LEVEL]
      ,isnull([LIMIT_L], '''') LIMIT_L
      ,isnull([LIMIT_H], '''') LIMIT_H
      ,isnull([CANDIDATE], '''') CANDIDATE
      ,isnull([PATTERN], '''') PATTERN
      ,isnull([DESCRIPTION], '''') DESCRIPTION 
  FROM [ENT_CONFIG]




' 
GO
/****** Object:  View [dbo].[VIEW_CONFIG_MODULE_BIT_MASK]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_CONFIG_MODULE_BIT_MASK]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_CONFIG_MODULE_BIT_MASK]
AS
SELECT   ENT_CONFIG_MODULE_BIT_MASK.NAME AS NAME,  POWER(2, ENT_CONFIG_MODULE_BIT_MASK.VALUE) AS VALUE
FROM     ENT_CONFIG_MODULE_BIT_MASK
WHERE    ENT_CONFIG_MODULE_BIT_MASK.ENABLED = 1
' 
GO
/****** Object:  View [dbo].[VIEW_CONFIG_ROBOT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_CONFIG_ROBOT]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[VIEW_CONFIG_ROBOT]
AS
 
SELECT  OWNER_ID, OWNER_TYPE, ENT_ROBOT.NAME AS OWNER_NAME,  CFG.NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN
FROM
(SELECT   OWNER_ID, OWNER_TYPE,  NAME, TYPE, VALUE, [LEVEL], LIMIT_L, LIMIT_H, CANDIDATE, PATTERN, 
                DESCRIPTION
FROM      dbo.ENT_CONFIG 
WHERE   (OWNER_TYPE = 5)) AS CFG
INNER JOIN ENT_ROBOT ON (OWNER_ID = ENT_ROBOT.ID)
' 
GO
/****** Object:  View [dbo].[VIEW_DIALOG_UNKNOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_DIALOG_UNKNOW]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_DIALOG_UNKNOW]
AS
SELECT     ID, REQUEST, REQUEST_MODEL, DATETIME
FROM         dbo.ENT_DIALOG
WHERE     (RESPONSE_1 IS NULL) AND (RESPONSE_2 IS NULL) AND (RESPONSE_3 IS NULL) AND (RESPONSE_4 IS NULL) AND (RESPONSE_5 IS NULL)

' 
GO
/****** Object:  View [dbo].[VIEW_ENTITY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ENTITY]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ENTITY]
AS
SELECT     0 AS ID, '''' AS NAME, '''' AS DESCRIPTION
' 
GO
/****** Object:  View [dbo].[VIEW_FLOW_VOICE_RULE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_FLOW_VOICE_RULE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_FLOW_VOICE_RULE]
AS
SELECT     dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.ID, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.WORD_GROUP_FLOW_ID AS FLOW_ID, 
                      dbo.ENT_WORD_GROUP_FLOW.NAME AS FLOW_NAME, dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.VOICE_GROUP_ID AS VOICE_ID, 
                      dbo.ENT_VOICE_GROUP.NAME AS VOICE_NAME, dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.ENABLE, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.DESCRIPTION, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.USE_FULLY_MATCH
FROM         dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE INNER JOIN
                      dbo.ENT_VOICE_GROUP ON dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.VOICE_GROUP_ID = dbo.ENT_VOICE_GROUP.ID INNER JOIN
                      dbo.ENT_WORD_GROUP_FLOW ON 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE.WORD_GROUP_FLOW_ID = dbo.ENT_WORD_GROUP_FLOW.ID
' 
GO
/****** Object:  View [dbo].[VIEW_HUAQIN_2016_PROIVDER_CONFRENCE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_HUAQIN_2016_PROIVDER_CONFRENCE]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_HUAQIN_2016_PROIVDER_CONFRENCE]
AS
SELECT			dbo.TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS.NAME, 
				dbo.FUNC_PINYIN_CONVERT(DBO.FUNC_GET_PINYIN(TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS.NAME)) AS UNAME_PINYIN,
                dbo.ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY.NAME AS COMPANY_NAME,
                dbo.ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY.CNAME AS COMPANY_CNAME, 
				dbo.FUNC_PINYIN_CONVERT(DBO.FUNC_GET_PINYIN(ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY.CNAME)) AS CNAME_PINYIN ,
                dbo.ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY.FULL_NAME AS COMPANY_FULL_NAME, 
                dbo.TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS.METTING_ROW_NUM, 
                dbo.TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS.METTING_COL_NUM, 
                dbo.TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS.DINNER_NO
FROM      dbo.ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY INNER JOIN
                dbo.TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS ON 
                dbo.ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY.ID = dbo.TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS.COMPANY_ID
WHERE   (dbo.ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY.ENABLED = 1) AND 
                (dbo.TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS.ENABLED = 1)

' 
GO
/****** Object:  View [dbo].[VIEW_KEY_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_KEY_WORD_GROUP]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_KEY_WORD_GROUP]
AS
SELECT     dbo.TBL_WORD_GROUP.KEY_WORD_ID, dbo.TBL_WORD_GROUP.GROUP_ID, dbo.ENT_KEY_WORDS.KW, dbo.ENT_KEY_WORDS.CAT, dbo.TBL_WORD_GROUP.DESCRIPTION
FROM         dbo.ENT_KEY_WORDS INNER JOIN
                      dbo.TBL_WORD_GROUP ON dbo.ENT_KEY_WORDS.ID = dbo.TBL_WORD_GROUP.KEY_WORD_ID

' 
GO
/****** Object:  View [dbo].[VIEW_KEY_WORDS_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_KEY_WORDS_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_KEY_WORDS_SIMPLE]
AS
SELECT   ID, KW, CAT, SOUND
FROM      dbo.ENT_KEY_WORDS

' 
GO
/****** Object:  View [dbo].[VIEW_NVP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_NVP]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_NVP]
AS
SELECT   '''' AS NAME, '''' AS VALUE
' 
GO
/****** Object:  View [dbo].[VIEW_ORDER_ROOM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ORDER_ROOM]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ORDER_ROOM]
AS
SELECT     dbo.TBL_ORDER_ROOM.ROOM_ID, dbo.ENT_ROOM.NAME AS ROOM_NAME, dbo.TBL_ORDER_ROOM.ORDER_DATE, 
                      dbo.ENT_ROOM.POISITION AS ROOM_POSITION, CASE NIGHT WHEN 1 THEN ''晚上'' ELSE ''白天'' END AS PERIOD, 
                      dbo.TBL_ORDER_ROOM.ORDER_NAME, dbo.TBL_ORDER_ROOM.MOBILE_PHONE, dbo.TBL_ORDER_ROOM.SUBMIT_DATETIME, 
                      dbo.TBL_ORDER_ROOM.NIGHT
FROM         dbo.TBL_ORDER_ROOM INNER JOIN
                      dbo.ENT_ROOM ON dbo.TBL_ORDER_ROOM.ROOM_ID = dbo.ENT_ROOM.ID
' 
GO
/****** Object:  View [dbo].[VIEW_REQUEST_PROPERTY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_REQUEST_PROPERTY]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_REQUEST_PROPERTY]
AS
SELECT     TOP (100) PERCENT dbo.TBL_REQUEST_PROPERTY.REQUEST_ID, dbo.ENT_REQUEST.DATETIME, dbo.ENT_REQUEST.PATH, 
                      dbo.TBL_REQUEST_PROPERTY.PROPERTY_NAME, dbo.TBL_REQUEST_PROPERTY.PROPERTY_VALUE, 
                      dbo.TBL_REQUEST_PROPERTY.IS_NUMERIC
FROM         dbo.ENT_REQUEST INNER JOIN
                      dbo.TBL_REQUEST_PROPERTY ON dbo.ENT_REQUEST.ID = dbo.TBL_REQUEST_PROPERTY.REQUEST_ID
ORDER BY dbo.ENT_REQUEST.DATETIME DESC
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_APP_LASTEST_UPDATETIME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_APP_LASTEST_UPDATETIME]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_APP_LASTEST_UPDATETIME]
AS
SELECT     dbo.ENT_ROBOT_APP.ID AS ROBOT_APP_ID, ISNULL(MAX(dbo.TBL_ROBOT_APP_VERSION.PUBLISH_DATETIME), ''1970-1-1'') 
                      AS LATEST_PUBLISH_DATETIME
FROM         dbo.ENT_ROBOT_APP LEFT OUTER JOIN
                      dbo.TBL_ROBOT_APP_VERSION ON dbo.ENT_ROBOT_APP.ID = dbo.TBL_ROBOT_APP_VERSION.ROBOT_APP_ID
GROUP BY dbo.ENT_ROBOT_APP.ID
' 
GO
/****** Object:  View [dbo].[VIEW_ROBOT_APP_VERSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_ROBOT_APP_VERSION]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_ROBOT_APP_VERSION]
AS
SELECT     dbo.ENT_ROBOT_APP.APP_NAME, dbo.TBL_ROBOT_APP_VERSION.VERSION_CODE, dbo.TBL_ROBOT_APP_VERSION.VERSION_NAME, 
                      dbo.TBL_ROBOT_APP_VERSION.DOWNLOAD_URL, dbo.TBL_ROBOT_APP_VERSION.RELEASE_NOTE, 
                      dbo.TBL_ROBOT_APP_VERSION.PUBLISH_DATETIME, dbo.TBL_ROBOT_APP_VERSION.ENABLED, 
                      dbo.TBL_ROBOT_APP_VERSION.ROBOT_APP_ID
FROM         dbo.ENT_ROBOT_APP INNER JOIN
                      dbo.TBL_ROBOT_APP_VERSION ON dbo.ENT_ROBOT_APP.ID = dbo.TBL_ROBOT_APP_VERSION.ROBOT_APP_ID
' 
GO
/****** Object:  View [dbo].[VIEW_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_THIRD_PARTY_API_PARAM_VALUE]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[VIEW_THIRD_PARTY_API_PARAM_VALUE]
as
SELECT 
ENT_THIRD_PARTY_API_PARAM_VALUE.ID
, ENT_THIRD_PARTY_API_PARAM_VALUE.NAME AS NAME
, ENT_THIRD_PARTY_API.ID AS API_ID
, ENT_THIRD_PARTY_API.NAME AS API_NAME
, ENT_THIRD_PARTY_API_PARAM_VALUE.ENABLED
, ISNULL(ENT_THIRD_PARTY_API_PARAM_VALUE.DESCRIPTION, '''') AS DESCRIPTION

FROM 
ENT_THIRD_PARTY_API_PARAM_VALUE
INNER JOIN ENT_THIRD_PARTY_API
ON (
ENT_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_ID = ENT_THIRD_PARTY_API.ID
)

' 
GO
/****** Object:  View [dbo].[VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM]
AS
SELECT   dbo.ENT_THIRD_PARTY_API.ID AS API_ID, dbo.ENT_THIRD_PARTY_API.NAME AS API_NAME, 
                dbo.TBL_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_PARAM_VALUE_ID AS VALUE_ID, 
                dbo.ENT_THIRD_PARTY_API_PARAM_VALUE.NAME AS VALUE_NAME, 
                dbo.TBL_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_PARAM_ID AS PARAM_ID, 
                dbo.ENT_THIRD_PARTY_API_PARAM.NAME AS PARAM_NAME, 
                dbo.ENT_THIRD_PARTY_API_PARAM.DESCRIPTION AS PARAM_DESCRIPTION, 
                dbo.TBL_THIRD_PARTY_API_PARAM_VALUE.PARAM_VALUE, 
                dbo.TBL_THIRD_PARTY_API_PARAM_VALUE.DESCRIPTION
FROM      dbo.TBL_THIRD_PARTY_API_PARAM_VALUE INNER JOIN
                dbo.ENT_THIRD_PARTY_API_PARAM ON 
                dbo.TBL_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_PARAM_ID = dbo.ENT_THIRD_PARTY_API_PARAM.ID INNER
                 JOIN
                dbo.ENT_THIRD_PARTY_API_PARAM_VALUE ON 
                dbo.TBL_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_PARAM_VALUE_ID = dbo.ENT_THIRD_PARTY_API_PARAM_VALUE.ID
                 INNER JOIN
                dbo.ENT_THIRD_PARTY_API ON 
                dbo.ENT_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_ID = dbo.ENT_THIRD_PARTY_API.ID
' 
GO
/****** Object:  View [dbo].[VIEW_THIRD_PARTY_PARAM_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_THIRD_PARTY_PARAM_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'


CREATE view [dbo].[VIEW_THIRD_PARTY_PARAM_SIMPLE]
as  
SELECT [ID]
      ,isnull([NAME],'''') as NAME
	  ,HEADER_0_BODY_1
	  ,OPTIONAL
	  ,isnull(DEFAULT_VALUE, '''') as DEFAULT_VALUE
      ,isnull([DESCRIPTION], '''') as DESCRIPTION
  FROM [dbo].ENT_THIRD_PARTY_API_PARAM
 



' 
GO
/****** Object:  View [dbo].[VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE]
as
SELECT 
ENT_THIRD_PARTY_API_PARAM_VALUE.ID
, ENT_THIRD_PARTY_API_PARAM_VALUE.NAME AS NAME
, ENT_THIRD_PARTY_API.ID AS API_ID
, ENT_THIRD_PARTY_API.NAME AS API_NAME
, ENT_THIRD_PARTY_API_PARAM_VALUE.ENABLED
, ISNULL(ENT_THIRD_PARTY_API_PARAM_VALUE.DESCRIPTION, '''') AS DESCRIPTION

FROM 
ENT_THIRD_PARTY_API_PARAM_VALUE
INNER JOIN ENT_THIRD_PARTY_API
ON (
ENT_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_ID = ENT_THIRD_PARTY_API.ID
)

' 
GO
/****** Object:  View [dbo].[VIEW_THIRD_PARTY_PARAMS_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_THIRD_PARTY_PARAMS_VALUE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_THIRD_PARTY_PARAMS_VALUE]
AS
SELECT     dbo.ENT_THIRD_PARTY_API_PARAMS_VALUE.ID, dbo.ENT_THIRD_PARTY_API_PARAMS_VALUE.DESCIRPTION AS DESCRIPTION, 
                      dbo.ENT_THIRD_PARTY_API_PARAMS_VALUE.THIRD_PARTY_API_ID, dbo.ENT_THIRD_PARTY_API.NAME AS THIRD_PARTY_NAME
FROM         dbo.ENT_THIRD_PARTY_API_PARAMS_VALUE INNER JOIN
                      dbo.ENT_THIRD_PARTY_API ON dbo.ENT_THIRD_PARTY_API_PARAMS_VALUE.THIRD_PARTY_API_ID = dbo.ENT_THIRD_PARTY_API.ID
WHERE     (dbo.ENT_THIRD_PARTY_API_PARAMS_VALUE.ENABLED = 1) AND (dbo.ENT_THIRD_PARTY_API.ENABLE = 1)
' 
GO
/****** Object:  View [dbo].[VIEW_THIRD_PARTY_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_THIRD_PARTY_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'

CREATE view [dbo].[VIEW_THIRD_PARTY_SIMPLE]
as  
SELECT [ID]
      ,isnull([NAME],'''') as NAME
	  ,isnull(URL,'''') as url
	  ,isnull(METHOD, ''GET'') AS METHOD
	  ,isnull(RESULT_TYPE, ''JSON'') as RESULT_TYPE
	  ,RUN_AT_SERVER
	  ,ENABLE
      ,isnull([DESCRIPTION], '''') as DESCRIPTION
  FROM [dbo].ENT_THIRD_PARTY_API




' 
GO
/****** Object:  View [dbo].[VIEW_TODAY_CHAT_TIMELINE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_TODAY_CHAT_TIMELINE]'))
EXEC dbo.sp_executesql @statement = N'


CREATE VIEW [dbo].[VIEW_TODAY_CHAT_TIMELINE]
AS
SELECT     TOP (100) PERCENT ID
, REQUEST
, REQUEST_EP_SN
, REQUEST_MODEL
, isnull(REQUEST_CLIENT_IP, '''') AS REQUEST_CLIENT_IP
, ISNULL(REQUEST_CLIENT_VERSION, '''') AS REQUEST_CLIENT_VERSION
, { fn IFNULL(REQUEST_ADDR, ''N/A'') } AS REQUEST_ADDR
, 
                     ISNULL(RESPONSE_1, '''') AS RESPONSE_1
					 , (CASE  SUBSTRING( REVERSE(RESPONSE_1), 1,1)   WHEN ''1'' THEN ''螺趣语义'' WHEN ''2'' THEN ''无法回答'' WHEN ''3'' THEN RESPONSE_14 WHEN ''4'' THEN ''第三方/自主提交'' WHEN ''5'' THEN ''人工模式'' END) AS KIND
					 
					 , ISNULL(RESPONSE_3, '''') AS TEXT
					 , ISNULL(RESPONSE_14, '''') AS SOURCE
                     , EXEC_MILLSECS
					 , DATE_TIME
FROM         dbo.ENT_DIALOG
ORDER BY DATE_TIME DESC



' 
GO
/****** Object:  View [dbo].[VIEW_USER_GROUP_BIND_ROBOT_SN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_USER_GROUP_BIND_ROBOT_SN]'))
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		洪江力
-- Create date: 2017-03-08
-- Description:	SN绑定人脸识别组
-- =============================================


CREATE VIEW [dbo].[VIEW_USER_GROUP_BIND_ROBOT_SN]
AS
 
		SELECT ENT_ROBOT.IMEI AS ROBOT_SN, ENT_USER_GROUP.ID AS USER_GROUP_ID FROM ENT_ROBOT 
			JOIN ENT_USER 
			ON ENT_ROBOT.ACTIVATE_USER_ID = ENT_USER.ID
			JOIN ENT_USER_GROUP 
			ON ENT_USER.USER_GROUP_ID = ENT_USER_GROUP.ID


' 
GO
/****** Object:  View [dbo].[VIEW_USER_GROUP_SCENE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_USER_GROUP_SCENE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_USER_GROUP_SCENE]
AS
SELECT   dbo.TBL_USER_GROUP_SCENE.ID, dbo.TBL_USER_GROUP_SCENE.NAME, 
                dbo.TBL_USER_GROUP_SCENE.USER_GROUP_ID, dbo.ENT_USER_GROUP.NAME AS USER_GROUP_NAME
FROM      dbo.TBL_USER_GROUP_SCENE INNER JOIN
                dbo.ENT_USER_GROUP ON dbo.TBL_USER_GROUP_SCENE.USER_GROUP_ID = dbo.ENT_USER_GROUP.ID

' 
GO
/****** Object:  View [dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS_VALUE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_VALID_THIRD_PARTY_API_PARAMS_VALUE]
AS
SELECT     ID, THIRD_PARTY_API_ID, DESCIRPTION
FROM         dbo.ENT_THIRD_PARTY_API_PARAMS_VALUE
WHERE     (ENABLED = 1)
' 
GO
/****** Object:  View [dbo].[VIEW_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VALUE]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_VALUE]
AS
SELECT   '''' AS VALUE

' 
GO
/****** Object:  View [dbo].[VIEW_VOICE_GROUP_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VOICE_GROUP_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[VIEW_VOICE_GROUP_SIMPLE]
as  


SELECT [ID]
      ,[NAME]
      ,isnull([DESCRIPTION], '''') as DESCRIPTION
  FROM [dbo].[ENT_VOICE_GROUP]


' 
GO
/****** Object:  View [dbo].[VIEW_VOICE_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_VOICE_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[VIEW_VOICE_SIMPLE]
AS
SELECT     ENT_VOICE.ID
		   , ENT_VOICE.NAME
           , isnull(PATH, '''') AS PATH
			, isnull(EMOTION, '''') AS EMOTION
			, isnull(TEXT, '''') AS TEXT
			, isnull(COMMAND, 0) AS COMMAND
			, isnull(COMMAND_PARAM , '''') AS COMMAND_PARAM
			, isnull(ENT_VOICE.THIRD_PARTY_API_ID, 0) AS THIRD_PARTY_API_ID
			, isnull(ENT_THIRD_PARTY_API.NAME, '''') AS THIRD_PARTY_API_NAME
			, isnull(ENT_VOICE.THIRD_PARTY_API_PARAMS_VALUE_ID, 0) AS THIRD_PARTY_API_PARAMS_VALUE_ID
			, isnull(ENT_THIRD_PARTY_API_PARAM_VALUE.NAME, '''') AS THIRD_PARTY_API_PARAM_VALUE_NAME
			, isnull(INC_PROP, '''') AS INC_PROP
			, isnull(EXC_PROP, '''') AS EXC_PROP
			, isnull(CAT, ''1'') AS CAT
			, ENT_VOICE.ENABLED 
			, isnull(ENT_VOICE.DESCRIPTION, '''') AS DESCRIPTION
	
FROM         dbo.ENT_VOICE
			LEFT JOIN ENT_THIRD_PARTY_API ON (ENT_VOICE.THIRD_PARTY_API_ID = ENT_THIRD_PARTY_API.ID)
			LEFT JOIN ENT_THIRD_PARTY_API_PARAM_VALUE ON (ENT_VOICE.THIRD_PARTY_API_PARAMS_VALUE_ID = ENT_THIRD_PARTY_API_PARAM_VALUE.ID)


' 
GO
/****** Object:  View [dbo].[VIEW_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_WORD_GROUP]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_WORD_GROUP]
AS
SELECT     dbo.TBL_WORD_GROUP.GROUP_ID AS ID, dbo.TBL_WORD_GROUP.DESCRIPTION, dbo.TBL_WORD_GROUP.KEY_WORD_ID, 
                      dbo.ENT_KEY_WORDS.KW AS KEY_WORD, dbo.ENT_WORD_GROUP.NAME
FROM         dbo.TBL_WORD_GROUP INNER JOIN
                      dbo.ENT_WORD_GROUP ON dbo.TBL_WORD_GROUP.GROUP_ID = dbo.ENT_WORD_GROUP.ID INNER JOIN
                      dbo.ENT_KEY_WORDS ON dbo.TBL_WORD_GROUP.KEY_WORD_ID = dbo.ENT_KEY_WORDS.ID
' 
GO
/****** Object:  View [dbo].[VIEW_WORD_GROUP_FLOW_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_WORD_GROUP_FLOW_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[VIEW_WORD_GROUP_FLOW_SIMPLE]
as  


SELECT [ID]
      ,[NAME]
      ,isnull([DESCRIPTION], '''') as DESCRIPTION
  FROM [dbo].ENT_WORD_GROUP_FLOW


' 
GO
/****** Object:  View [dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]
AS
SELECT     dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.REQUEST, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.UPDATE_USER_ID, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_DATETIME, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.UPDATE_DATETIME, 
                      ISNULL(dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.GEN_WORD_GROUP_FLOW_ID, 0) as GEN_WORD_GROUP_FLOW_ID, 
                      ISNULL(dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.GEN_DATETIME, ''1970-1-1'') as GEN_DATETIME, 
                      isnull(dbo.ENT_VOICE.NAME, '''') AS NAME, 
					  isnull(dbo.ENT_VOICE.PATH, '''') AS PATH, 
                      isnull(dbo.ENT_VOICE.EMOTION, '''') AS EMOTION, 
				      isnull(dbo.ENT_VOICE.TEXT, '''')AS  TEXT, 
					  isnull(dbo.ENT_VOICE.COMMAND, 0) AS COMMAND,  
					  isnull(dbo.ENT_VOICE.COMMAND_PARAM, '''')AS  COMMAND_PARAM,  
                      isnull(dbo.ENT_VOICE.THIRD_PARTY_API_ID, 0) AS THIRD_PARTY_API_ID,  
				      isnull(dbo.ENT_VOICE.THIRD_PARTY_API_PARAMS_VALUE_ID , 0) AS THIRD_PARTY_API_PARAMS_VALUE_ID,  
			          isnull(dbo.ENT_VOICE.INC_PROP , '''') AS INC_PROP, 
			          isnull(dbo.ENT_VOICE.CAT , ''1'') AS CAT, 
                      dbo.ENT_VOICE.DESCRIPTION , 
					  dbo.TBL_VOICE_GROUP.ID AS VOICE_GROUP_ID, 
					  dbo.ENT_VOICE.ID AS VOICE_ID, 
					  dbo.ENT_VOICE.ENABLED AS VOICE_ENABLED, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.ID AS ORIGNAL_RULE_ID
FROM         
				dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL 
				INNER JOIN dbo.TBL_VOICE_GROUP 
				ON 
				(
					dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.RESPONSE_VOICE_GROUP_ID = dbo.TBL_VOICE_GROUP.ID 
				)
				INNER JOIN dbo.ENT_VOICE 
				ON 
				(
					ENT_VOICE.ID = TBL_VOICE_GROUP.VOICE_ID
					AND ENT_VOICE.CAT = ''4''					
				)
' 
GO
/****** Object:  View [dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2]
AS
SELECT     dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.REQUEST, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.UPDATE_USER_ID, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_DATETIME, 
                      dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.UPDATE_DATETIME, 
                      ISNULL(dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.GEN_WORD_GROUP_FLOW_ID, 0) AS GEN_WORD_GROUP_FLOW_ID, 
                      ISNULL(dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.GEN_DATETIME, ''1970-1-1'') AS GEN_DATETIME, 
                      ISNULL(dbo.ENT_VOICE.NAME, '''') AS NAME, ISNULL(dbo.ENT_VOICE.PATH, '''') AS PATH, ISNULL(dbo.ENT_VOICE.EMOTION, '''') AS EMOTION, 
                      ISNULL(dbo.ENT_VOICE.TEXT, '''') AS TEXT, ISNULL(dbo.ENT_VOICE.COMMAND, 0) AS COMMAND, ISNULL(dbo.ENT_VOICE.COMMAND_PARAM, '''') 
                      AS COMMAND_PARAM, ISNULL(dbo.ENT_VOICE.THIRD_PARTY_API_ID, 0) AS THIRD_PARTY_API_ID, 
                      ISNULL(dbo.ENT_VOICE.THIRD_PARTY_API_PARAMS_VALUE_ID, 0) AS THIRD_PARTY_API_PARAMS_VALUE_ID, ISNULL(dbo.ENT_VOICE.INC_PROP, 
                      '''') AS INC_PROP, ISNULL(dbo.ENT_VOICE.CAT, ''1'') AS CAT, dbo.ENT_VOICE.DESCRIPTION, dbo.ENT_VOICE.ID AS VOICE_ID, 
                      dbo.ENT_VOICE.ENABLED AS VOICE_ENABLED, dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.ID AS ORIGNAL_RULE_ID
FROM         dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL INNER JOIN
                      dbo.ENT_VOICE ON dbo.ENT_VOICE.ID = dbo.TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID
' 
GO
/****** Object:  View [dbo].[VIEW_WORD_GROUP_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VIEW_WORD_GROUP_SIMPLE]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[VIEW_WORD_GROUP_SIMPLE]
as  
SELECT [ID]
      ,[NAME]
      ,isnull([DESCRIPTION], '''') as DESCRIPTION
  FROM [dbo].[ENT_WORD_GROUP]



' 
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ENT_ADMIN]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ADMIN]') AND name = N'IX_ENT_ADMIN')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ENT_ADMIN] ON [dbo].[ENT_ADMIN]
(
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ENT_KEY_WORDS]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ENT_KEY_WORDS]') AND name = N'IX_ENT_KEY_WORDS')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ENT_KEY_WORDS] ON [dbo].[ENT_KEY_WORDS]
(
	[KW] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ENT_OPERATION]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ENT_OPERATION]') AND name = N'IX_ENT_OPERATION')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ENT_OPERATION] ON [dbo].[ENT_OPERATION]
(
	[BIT_ORDER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ENT_ROBOT]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ROBOT]') AND name = N'IX_ENT_ROBOT')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ENT_ROBOT] ON [dbo].[ENT_ROBOT]
(
	[IMEI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ENT_ROBOT_APP]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ROBOT_APP]') AND name = N'IX_ENT_ROBOT_APP')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ENT_ROBOT_APP] ON [dbo].[ENT_ROBOT_APP]
(
	[APP_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ENT_ROBOT_APP_1]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ENT_ROBOT_APP]') AND name = N'IX_ENT_ROBOT_APP_1')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ENT_ROBOT_APP_1] ON [dbo].[ENT_ROBOT_APP]
(
	[PACKAGE_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ENT_USER_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ENT_USER_GROUP]') AND name = N'IX_ENT_USER_GROUP')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ENT_USER_GROUP] ON [dbo].[ENT_USER_GROUP]
(
	[TAG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TBL_RUNTIME_DATA]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME_DATA]') AND name = N'IX_TBL_RUNTIME_DATA')
CREATE NONCLUSTERED INDEX [IX_TBL_RUNTIME_DATA] ON [dbo].[TBL_RUNTIME_DATA]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TBL_RUNTIME_DATA_1]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME_DATA]') AND name = N'IX_TBL_RUNTIME_DATA_1')
CREATE NONCLUSTERED INDEX [IX_TBL_RUNTIME_DATA_1] ON [dbo].[TBL_RUNTIME_DATA]
(
	[ROBOT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TBL_RUNTIME_DATA_2]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME_DATA]') AND name = N'IX_TBL_RUNTIME_DATA_2')
CREATE NONCLUSTERED INDEX [IX_TBL_RUNTIME_DATA_2] ON [dbo].[TBL_RUNTIME_DATA]
(
	[DATE_TIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TBL_RUNTIME_DATA_3]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME_DATA]') AND name = N'IX_TBL_RUNTIME_DATA_3')
CREATE NONCLUSTERED INDEX [IX_TBL_RUNTIME_DATA_3] ON [dbo].[TBL_RUNTIME_DATA]
(
	[TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TBL_RUNTIME_DATA_4]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TBL_RUNTIME_DATA]') AND name = N'IX_TBL_RUNTIME_DATA_4')
CREATE NONCLUSTERED INDEX [IX_TBL_RUNTIME_DATA_4] ON [dbo].[TBL_RUNTIME_DATA]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]    Script Date: 2017/8/15 15:16:39 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]') AND name = N'IX_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL')
CREATE UNIQUE NONCLUSTERED INDEX [IX_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL] ON [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]
(
	[REQUEST] ASC,
	[CREATE_USER_ID] ASC,
	[VOICE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ENT_ENTITY_ENABLED]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ENT_ENTITY] ADD  CONSTRAINT [DF_ENT_ENTITY_ENABLED]  DEFAULT ((1)) FOR [ENABLED]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_TBL_ML_DIALOG_CREATE_DATETIME]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TBL_ML_DIALOG] ADD  CONSTRAINT [DF_TBL_ML_DIALOG_CREATE_DATETIME]  DEFAULT (getdate()) FOR [CREATE_DATETIME]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_ROBOT_ENT_HW_SPEC]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_ROBOT]'))
ALTER TABLE [dbo].[ENT_ROBOT]  WITH CHECK ADD  CONSTRAINT [FK_ENT_ROBOT_ENT_HW_SPEC] FOREIGN KEY([HW_SPEC_ID])
REFERENCES [dbo].[ENT_HW_SPEC] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_ROBOT_ENT_HW_SPEC]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_ROBOT]'))
ALTER TABLE [dbo].[ENT_ROBOT] CHECK CONSTRAINT [FK_ENT_ROBOT_ENT_HW_SPEC]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE]'))
ALTER TABLE [dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE]  WITH CHECK ADD  CONSTRAINT [FK_ENT_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API] FOREIGN KEY([THIRD_PARTY_API_ID])
REFERENCES [dbo].[ENT_THIRD_PARTY_API] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE]'))
ALTER TABLE [dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE] CHECK CONSTRAINT [FK_ENT_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_USER_ENT_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_USER]'))
ALTER TABLE [dbo].[ENT_USER]  WITH CHECK ADD  CONSTRAINT [FK_ENT_USER_ENT_USER_GROUP] FOREIGN KEY([USER_GROUP_ID])
REFERENCES [dbo].[ENT_USER_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_USER_ENT_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_USER]'))
ALTER TABLE [dbo].[ENT_USER] CHECK CONSTRAINT [FK_ENT_USER_ENT_USER_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_USER_GROUP_ENT_INDUSTRY]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_USER_GROUP]'))
ALTER TABLE [dbo].[ENT_USER_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_ENT_USER_GROUP_ENT_INDUSTRY] FOREIGN KEY([INDUSTRY_ID])
REFERENCES [dbo].[ENT_INDUSTRY] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_USER_GROUP_ENT_INDUSTRY]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_USER_GROUP]'))
ALTER TABLE [dbo].[ENT_USER_GROUP] CHECK CONSTRAINT [FK_ENT_USER_GROUP_ENT_INDUSTRY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_VOICE_ENT_THIRD_PARTY_API]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_VOICE]'))
ALTER TABLE [dbo].[ENT_VOICE]  WITH CHECK ADD  CONSTRAINT [FK_ENT_VOICE_ENT_THIRD_PARTY_API] FOREIGN KEY([THIRD_PARTY_API_ID])
REFERENCES [dbo].[ENT_THIRD_PARTY_API] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_VOICE_ENT_THIRD_PARTY_API]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_VOICE]'))
ALTER TABLE [dbo].[ENT_VOICE] CHECK CONSTRAINT [FK_ENT_VOICE_ENT_THIRD_PARTY_API]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_VOICE_ENT_THIRD_PARTY_API_PARAM_VALUE]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_VOICE]'))
ALTER TABLE [dbo].[ENT_VOICE]  WITH CHECK ADD  CONSTRAINT [FK_ENT_VOICE_ENT_THIRD_PARTY_API_PARAM_VALUE] FOREIGN KEY([THIRD_PARTY_API_PARAMS_VALUE_ID])
REFERENCES [dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_VOICE_ENT_THIRD_PARTY_API_PARAM_VALUE]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_VOICE]'))
ALTER TABLE [dbo].[ENT_VOICE] CHECK CONSTRAINT [FK_ENT_VOICE_ENT_THIRD_PARTY_API_PARAM_VALUE]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_VOICE_ENT_VOICE_COMMAND]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_VOICE]'))
ALTER TABLE [dbo].[ENT_VOICE]  WITH CHECK ADD  CONSTRAINT [FK_ENT_VOICE_ENT_VOICE_COMMAND] FOREIGN KEY([COMMAND])
REFERENCES [dbo].[ENT_VOICE_COMMAND] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_VOICE_ENT_VOICE_COMMAND]') AND parent_object_id = OBJECT_ID(N'[dbo].[ENT_VOICE]'))
ALTER TABLE [dbo].[ENT_VOICE] CHECK CONSTRAINT [FK_ENT_VOICE_ENT_VOICE_COMMAND]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_BIZ_MENUTREE_TBL_BIZ_MENUTREE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_BIZ_MENUTREE]'))
ALTER TABLE [dbo].[TBL_BIZ_MENUTREE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_BIZ_MENUTREE_TBL_BIZ_MENUTREE] FOREIGN KEY([MENUITEM_ACTION_ID])
REFERENCES [dbo].[TBL_BIZ_MENUITEM_ACTION] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_BIZ_MENUTREE_TBL_BIZ_MENUTREE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_BIZ_MENUTREE]'))
ALTER TABLE [dbo].[TBL_BIZ_MENUTREE] CHECK CONSTRAINT [FK_TBL_BIZ_MENUTREE_TBL_BIZ_MENUTREE]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_BIZ_MENUTREE_TBL_BIZ_MENUTREE1]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_BIZ_MENUTREE]'))
ALTER TABLE [dbo].[TBL_BIZ_MENUTREE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_BIZ_MENUTREE_TBL_BIZ_MENUTREE1] FOREIGN KEY([PARENT_ID])
REFERENCES [dbo].[TBL_BIZ_MENUTREE] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_BIZ_MENUTREE_TBL_BIZ_MENUTREE1]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_BIZ_MENUTREE]'))
ALTER TABLE [dbo].[TBL_BIZ_MENUTREE] CHECK CONSTRAINT [FK_TBL_BIZ_MENUTREE_TBL_BIZ_MENUTREE1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]  WITH CHECK ADD  CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC_ENT_CONFIG] FOREIGN KEY([NAME])
REFERENCES [dbo].[ENT_CONFIG] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC] CHECK CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC_ENT_CONFIG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC_ENT_HW_SPEC]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]  WITH CHECK ADD  CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC_ENT_HW_SPEC] FOREIGN KEY([HW_SPEC_ID])
REFERENCES [dbo].[ENT_HW_SPEC] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC_ENT_HW_SPEC]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC] CHECK CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC_ENT_HW_SPEC]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]  WITH CHECK ADD  CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY_ENT_CONFIG] FOREIGN KEY([NAME])
REFERENCES [dbo].[ENT_CONFIG] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY] CHECK CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY_ENT_CONFIG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]  WITH CHECK ADD  CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY] FOREIGN KEY([INDUSTRY_ID])
REFERENCES [dbo].[ENT_INDUSTRY] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY] CHECK CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY_TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_ROBOT_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_ROBOT_ENT_CONFIG] FOREIGN KEY([NAME])
REFERENCES [dbo].[ENT_CONFIG] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_ROBOT_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT] CHECK CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_ROBOT_ENT_CONFIG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT] FOREIGN KEY([ROBOT_ID])
REFERENCES [dbo].[ENT_ROBOT] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT] CHECK CONSTRAINT [FK_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT_TBL_EXCLUSIVE_CONFIG_FOR_ROBOT]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_ENT_CONFIG] FOREIGN KEY([NAME])
REFERENCES [dbo].[ENT_CONFIG] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP] CHECK CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_ENT_CONFIG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP] FOREIGN KEY([USER_GROUP_ID])
REFERENCES [dbo].[ENT_USER_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP] CHECK CONSTRAINT [FK_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP_TBL_EXCLUSIVE_CONFIG_FOR_USER_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE_ENT_CONFIG] FOREIGN KEY([NAME])
REFERENCES [dbo].[ENT_CONFIG] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE] CHECK CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE_ENT_CONFIG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE_TBL_USER_GROUP_SCENE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE_TBL_USER_GROUP_SCENE] FOREIGN KEY([USER_GROUP_SCENE_ID])
REFERENCES [dbo].[TBL_USER_GROUP_SCENE] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE_TBL_USER_GROUP_SCENE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]'))
ALTER TABLE [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE] CHECK CONSTRAINT [FK_TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE_TBL_USER_GROUP_SCENE]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS_ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS]'))
ALTER TABLE [dbo].[TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS]  WITH CHECK ADD  CONSTRAINT [FK_TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS_ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY] FOREIGN KEY([COMPANY_ID])
REFERENCES [dbo].[ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS_ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS]'))
ALTER TABLE [dbo].[TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS] CHECK CONSTRAINT [FK_TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS_ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_INHERIT_CONFIG_FOR_ROBOT_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT]'))
ALTER TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_INHERIT_CONFIG_FOR_ROBOT_ENT_CONFIG] FOREIGN KEY([CONFIG_NAME])
REFERENCES [dbo].[ENT_CONFIG] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_INHERIT_CONFIG_FOR_ROBOT_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT]'))
ALTER TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT] CHECK CONSTRAINT [FK_TBL_INHERIT_CONFIG_FOR_ROBOT_ENT_CONFIG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_INHERIT_CONFIG_FOR_ROBOT_ENT_ROBOT]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT]'))
ALTER TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_INHERIT_CONFIG_FOR_ROBOT_ENT_ROBOT] FOREIGN KEY([ROBOT_ID])
REFERENCES [dbo].[ENT_ROBOT] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_INHERIT_CONFIG_FOR_ROBOT_ENT_ROBOT]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT]'))
ALTER TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_ROBOT] CHECK CONSTRAINT [FK_TBL_INHERIT_CONFIG_FOR_ROBOT_ENT_ROBOT]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_GROUP_INHERIT_CONFIG_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP]'))
ALTER TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_GROUP_INHERIT_CONFIG_ENT_CONFIG] FOREIGN KEY([CONFIG_NAME])
REFERENCES [dbo].[ENT_CONFIG] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_GROUP_INHERIT_CONFIG_ENT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP]'))
ALTER TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP] CHECK CONSTRAINT [FK_TBL_GROUP_INHERIT_CONFIG_ENT_CONFIG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_GROUP_INHERIT_CONFIG_TBL_GROUP_INHERIT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP]'))
ALTER TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_GROUP_INHERIT_CONFIG_TBL_GROUP_INHERIT_CONFIG] FOREIGN KEY([USER_GROUP_ID])
REFERENCES [dbo].[ENT_USER_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_GROUP_INHERIT_CONFIG_TBL_GROUP_INHERIT_CONFIG]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP]'))
ALTER TABLE [dbo].[TBL_INHERIT_CONFIG_FOR_USER_GROUP] CHECK CONSTRAINT [FK_TBL_GROUP_INHERIT_CONFIG_TBL_GROUP_INHERIT_CONFIG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_OPERATION_LOG_ENT_ADMIN]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_OPERATION_LOG]'))
ALTER TABLE [dbo].[TBL_OPERATION_LOG]  WITH CHECK ADD  CONSTRAINT [FK_TBL_OPERATION_LOG_ENT_ADMIN] FOREIGN KEY([ADMIN_NAME])
REFERENCES [dbo].[ENT_ADMIN] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_OPERATION_LOG_ENT_ADMIN]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_OPERATION_LOG]'))
ALTER TABLE [dbo].[TBL_OPERATION_LOG] CHECK CONSTRAINT [FK_TBL_OPERATION_LOG_ENT_ADMIN]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ORDER_ROOM_ENT_ROOM]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ORDER_ROOM]'))
ALTER TABLE [dbo].[TBL_ORDER_ROOM]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ORDER_ROOM_ENT_ROOM] FOREIGN KEY([ROOM_ID])
REFERENCES [dbo].[ENT_ROOM] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ORDER_ROOM_ENT_ROOM]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ORDER_ROOM]'))
ALTER TABLE [dbo].[TBL_ORDER_ROOM] CHECK CONSTRAINT [FK_TBL_ORDER_ROOM_ENT_ROOM]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_QUESTION_ENT_EXAM]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_QUESTION]'))
ALTER TABLE [dbo].[TBL_QUESTION]  WITH CHECK ADD  CONSTRAINT [FK_TBL_QUESTION_ENT_EXAM] FOREIGN KEY([EXAM_ID])
REFERENCES [dbo].[ENT_EXAM] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_QUESTION_ENT_EXAM]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_QUESTION]'))
ALTER TABLE [dbo].[TBL_QUESTION] CHECK CONSTRAINT [FK_TBL_QUESTION_ENT_EXAM]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_QUESTION_ANSWER_CANDIDATES_TBL_QUESTION]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_QUESTION_ANSWER_CANDIDATES]'))
ALTER TABLE [dbo].[TBL_QUESTION_ANSWER_CANDIDATES]  WITH CHECK ADD  CONSTRAINT [FK_TBL_QUESTION_ANSWER_CANDIDATES_TBL_QUESTION] FOREIGN KEY([QUESTION_ID])
REFERENCES [dbo].[TBL_QUESTION] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_QUESTION_ANSWER_CANDIDATES_TBL_QUESTION]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_QUESTION_ANSWER_CANDIDATES]'))
ALTER TABLE [dbo].[TBL_QUESTION_ANSWER_CANDIDATES] CHECK CONSTRAINT [FK_TBL_QUESTION_ANSWER_CANDIDATES_TBL_QUESTION]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_REQUEST_PROPERTY_TBL_REQUEST_PROPERTY]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_REQUEST_PROPERTY]'))
ALTER TABLE [dbo].[TBL_REQUEST_PROPERTY]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REQUEST_PROPERTY_TBL_REQUEST_PROPERTY] FOREIGN KEY([REQUEST_ID])
REFERENCES [dbo].[ENT_REQUEST] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_REQUEST_PROPERTY_TBL_REQUEST_PROPERTY]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_REQUEST_PROPERTY]'))
ALTER TABLE [dbo].[TBL_REQUEST_PROPERTY] CHECK CONSTRAINT [FK_TBL_REQUEST_PROPERTY_TBL_REQUEST_PROPERTY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_EXCLUDE_ENT_ROBOT_APP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUDE]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_EXCLUDE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ROBOT_APP_EXCLUDE_ENT_ROBOT_APP] FOREIGN KEY([ROBOT_APP_ID])
REFERENCES [dbo].[ENT_ROBOT_APP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_EXCLUDE_ENT_ROBOT_APP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUDE]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_EXCLUDE] CHECK CONSTRAINT [FK_TBL_ROBOT_APP_EXCLUDE_ENT_ROBOT_APP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_EXCLUDE_ENT_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUDE]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_EXCLUDE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ROBOT_APP_EXCLUDE_ENT_USER_GROUP] FOREIGN KEY([USER_GROUP_ID])
REFERENCES [dbo].[ENT_USER_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_EXCLUDE_ENT_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUDE]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_EXCLUDE] CHECK CONSTRAINT [FK_TBL_ROBOT_APP_EXCLUDE_ENT_USER_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_APP_EXCLUSIVE_ENT_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUSIVE]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_EXCLUSIVE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_APP_EXCLUSIVE_ENT_USER_GROUP] FOREIGN KEY([USER_GROUP_ID])
REFERENCES [dbo].[ENT_USER_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_APP_EXCLUSIVE_ENT_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUSIVE]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_EXCLUSIVE] CHECK CONSTRAINT [FK_TBL_APP_EXCLUSIVE_ENT_USER_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_APP_EXCLUSIVE_TBL_ROBOT_APP_VERSION_LIST]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUSIVE]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_EXCLUSIVE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_APP_EXCLUSIVE_TBL_ROBOT_APP_VERSION_LIST] FOREIGN KEY([ROBOT_APP_ID])
REFERENCES [dbo].[ENT_ROBOT_APP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_APP_EXCLUSIVE_TBL_ROBOT_APP_VERSION_LIST]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_EXCLUSIVE]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_EXCLUSIVE] CHECK CONSTRAINT [FK_TBL_APP_EXCLUSIVE_TBL_ROBOT_APP_VERSION_LIST]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_VERSION_ENT_ROBOT_APP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_VERSION]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_VERSION]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ROBOT_APP_VERSION_ENT_ROBOT_APP] FOREIGN KEY([ROBOT_APP_ID])
REFERENCES [dbo].[ENT_ROBOT_APP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_VERSION_ENT_ROBOT_APP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_VERSION]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_VERSION] CHECK CONSTRAINT [FK_TBL_ROBOT_APP_VERSION_ENT_ROBOT_APP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_VERSION_REQUIRED_TBL_ROBOT_APP_VERSION]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_VERSION_REQUIRED]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_VERSION_REQUIRED]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ROBOT_APP_VERSION_REQUIRED_TBL_ROBOT_APP_VERSION] FOREIGN KEY([ROBOT_APP_ID], [VERSION_CODE])
REFERENCES [dbo].[TBL_ROBOT_APP_VERSION] ([ROBOT_APP_ID], [VERSION_CODE])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_VERSION_REQUIRED_TBL_ROBOT_APP_VERSION]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_VERSION_REQUIRED]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_VERSION_REQUIRED] CHECK CONSTRAINT [FK_TBL_ROBOT_APP_VERSION_REQUIRED_TBL_ROBOT_APP_VERSION]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_VERSION_REQUIRED_TBL_ROBOT_APP_VERSION_REQUIRED]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_VERSION_REQUIRED]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_VERSION_REQUIRED]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ROBOT_APP_VERSION_REQUIRED_TBL_ROBOT_APP_VERSION_REQUIRED] FOREIGN KEY([DB_VERSION])
REFERENCES [dbo].[ENT_DB_VERSION] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_APP_VERSION_REQUIRED_TBL_ROBOT_APP_VERSION_REQUIRED]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_APP_VERSION_REQUIRED]'))
ALTER TABLE [dbo].[TBL_ROBOT_APP_VERSION_REQUIRED] CHECK CONSTRAINT [FK_TBL_ROBOT_APP_VERSION_REQUIRED_TBL_ROBOT_APP_VERSION_REQUIRED]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_SESSION_CONTEXT_TBL_ROBOT_SESSION_CONTEXT]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_SESSION_CONTEXT]'))
ALTER TABLE [dbo].[TBL_ROBOT_SESSION_CONTEXT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ROBOT_SESSION_CONTEXT_TBL_ROBOT_SESSION_CONTEXT] FOREIGN KEY([ROBOT_ID])
REFERENCES [dbo].[ENT_ROBOT] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_ROBOT_SESSION_CONTEXT_TBL_ROBOT_SESSION_CONTEXT]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_SESSION_CONTEXT]'))
ALTER TABLE [dbo].[TBL_ROBOT_SESSION_CONTEXT] CHECK CONSTRAINT [FK_TBL_ROBOT_SESSION_CONTEXT_TBL_ROBOT_SESSION_CONTEXT]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_ROBOT_TAGS_ENT_ROBOT]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_TAGS]'))
ALTER TABLE [dbo].[TBL_ROBOT_TAGS]  WITH CHECK ADD  CONSTRAINT [FK_ENT_ROBOT_TAGS_ENT_ROBOT] FOREIGN KEY([ROBOT_ID])
REFERENCES [dbo].[ENT_ROBOT] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENT_ROBOT_TAGS_ENT_ROBOT]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_ROBOT_TAGS]'))
ALTER TABLE [dbo].[TBL_ROBOT_TAGS] CHECK CONSTRAINT [FK_ENT_ROBOT_TAGS_ENT_ROBOT]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_THIRD_PARTY_API_PARAM_ENT_THIRD_PARTY_API]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM]  WITH CHECK ADD  CONSTRAINT [FK_TBL_THIRD_PARTY_API_PARAM_ENT_THIRD_PARTY_API] FOREIGN KEY([THIRD_PARTY_API_ID])
REFERENCES [dbo].[ENT_THIRD_PARTY_API] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_THIRD_PARTY_API_PARAM_ENT_THIRD_PARTY_API]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM] CHECK CONSTRAINT [FK_TBL_THIRD_PARTY_API_PARAM_ENT_THIRD_PARTY_API]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_THIRD_PARTY_API_PARAM_ENT_THIRD_PARTY_API_PARAM]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM]  WITH CHECK ADD  CONSTRAINT [FK_TBL_THIRD_PARTY_API_PARAM_ENT_THIRD_PARTY_API_PARAM] FOREIGN KEY([THIRD_PARTY_API_PARAM_ID])
REFERENCES [dbo].[ENT_THIRD_PARTY_API_PARAM] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_THIRD_PARTY_API_PARAM_ENT_THIRD_PARTY_API_PARAM]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM] CHECK CONSTRAINT [FK_TBL_THIRD_PARTY_API_PARAM_ENT_THIRD_PARTY_API_PARAM]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API_PARAM]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API_PARAM] FOREIGN KEY([THIRD_PARTY_API_PARAM_ID])
REFERENCES [dbo].[ENT_THIRD_PARTY_API_PARAM] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API_PARAM]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE] CHECK CONSTRAINT [FK_TBL_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API_PARAM]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API_PARAM_VALUE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API_PARAM_VALUE] FOREIGN KEY([THIRD_PARTY_API_PARAM_VALUE_ID])
REFERENCES [dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API_PARAM_VALUE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE] CHECK CONSTRAINT [FK_TBL_THIRD_PARTY_API_PARAM_VALUE_ENT_THIRD_PARTY_API_PARAM_VALUE]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_USER_GROUP_SCENE_ENT_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_USER_GROUP_SCENE]'))
ALTER TABLE [dbo].[TBL_USER_GROUP_SCENE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_USER_GROUP_SCENE_ENT_USER_GROUP] FOREIGN KEY([USER_GROUP_ID])
REFERENCES [dbo].[ENT_USER_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_USER_GROUP_SCENE_ENT_USER_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_USER_GROUP_SCENE]'))
ALTER TABLE [dbo].[TBL_USER_GROUP_SCENE] CHECK CONSTRAINT [FK_TBL_USER_GROUP_SCENE_ENT_USER_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_VERSION_REQUIRED_ENT_DB_VERSION]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_VERSION_REQUIRED]'))
ALTER TABLE [dbo].[TBL_VERSION_REQUIRED]  WITH CHECK ADD  CONSTRAINT [FK_TBL_VERSION_REQUIRED_ENT_DB_VERSION] FOREIGN KEY([DB_VERSION])
REFERENCES [dbo].[ENT_DB_VERSION] ([NAME])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_VERSION_REQUIRED_ENT_DB_VERSION]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_VERSION_REQUIRED]'))
ALTER TABLE [dbo].[TBL_VERSION_REQUIRED] CHECK CONSTRAINT [FK_TBL_VERSION_REQUIRED_ENT_DB_VERSION]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_VOICE_GROUP_ENT_VOICE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_VOICE_GROUP]'))
ALTER TABLE [dbo].[TBL_VOICE_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_VOICE_GROUP_ENT_VOICE] FOREIGN KEY([VOICE_ID])
REFERENCES [dbo].[ENT_VOICE] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_VOICE_GROUP_ENT_VOICE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_VOICE_GROUP]'))
ALTER TABLE [dbo].[TBL_VOICE_GROUP] CHECK CONSTRAINT [FK_TBL_VOICE_GROUP_ENT_VOICE]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_VOICE_GROUP_ENT_VOICE_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_VOICE_GROUP]'))
ALTER TABLE [dbo].[TBL_VOICE_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_VOICE_GROUP_ENT_VOICE_GROUP] FOREIGN KEY([ID])
REFERENCES [dbo].[ENT_VOICE_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_VOICE_GROUP_ENT_VOICE_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_VOICE_GROUP]'))
ALTER TABLE [dbo].[TBL_VOICE_GROUP] CHECK CONSTRAINT [FK_TBL_VOICE_GROUP_ENT_VOICE_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_VOICE_TAG_ENT_VOICE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_VOICE_TAG]'))
ALTER TABLE [dbo].[TBL_VOICE_TAG]  WITH CHECK ADD  CONSTRAINT [FK_TBL_VOICE_TAG_ENT_VOICE] FOREIGN KEY([VOICE_ID])
REFERENCES [dbo].[ENT_VOICE] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_VOICE_TAG_ENT_VOICE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_VOICE_TAG]'))
ALTER TABLE [dbo].[TBL_VOICE_TAG] CHECK CONSTRAINT [FK_TBL_VOICE_TAG_ENT_VOICE]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_ENT_KEY_WORDS]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_ENT_KEY_WORDS] FOREIGN KEY([KEY_WORD_ID])
REFERENCES [dbo].[ENT_KEY_WORDS] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_ENT_KEY_WORDS]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_ENT_KEY_WORDS]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_ENT_WORD_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_ENT_WORD_GROUP] FOREIGN KEY([GROUP_ID])
REFERENCES [dbo].[ENT_WORD_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_ENT_WORD_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_ENT_WORD_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_ENT_WORD_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_ENT_WORD_GROUP] FOREIGN KEY([WORD_GROUP_ID])
REFERENCES [dbo].[ENT_WORD_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_ENT_WORD_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_ENT_WORD_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_ENT_WORD_GROUP_FLOW]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_ENT_WORD_GROUP_FLOW] FOREIGN KEY([ID])
REFERENCES [dbo].[ENT_WORD_GROUP_FLOW] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_ENT_WORD_GROUP_FLOW]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_ENT_WORD_GROUP_FLOW]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENT_VOICE_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENT_VOICE_GROUP] FOREIGN KEY([VOICE_GROUP_ID])
REFERENCES [dbo].[ENT_VOICE_GROUP] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENT_VOICE_GROUP]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENT_VOICE_GROUP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENT_WORD_GROUP_FLOW]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENT_WORD_GROUP_FLOW] FOREIGN KEY([WORD_GROUP_FLOW_ID])
REFERENCES [dbo].[ENT_WORD_GROUP_FLOW] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENT_WORD_GROUP_FLOW]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ENT_WORD_GROUP_FLOW]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_USER] FOREIGN KEY([CREATE_USER_ID])
REFERENCES [dbo].[ENT_USER] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_USER]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_USER]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_USER1]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_USER1] FOREIGN KEY([UPDATE_USER_ID])
REFERENCES [dbo].[ENT_USER] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_USER1]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_USER1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_VOICE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_VOICE] FOREIGN KEY([VOICE_ID])
REFERENCES [dbo].[ENT_VOICE] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_VOICE]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_VOICE]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_WORD_GROUP_FLOW]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]  WITH CHECK ADD  CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_WORD_GROUP_FLOW] FOREIGN KEY([GEN_WORD_GROUP_FLOW_ID])
REFERENCES [dbo].[ENT_WORD_GROUP_FLOW] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_WORD_GROUP_FLOW]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]'))
ALTER TABLE [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL] CHECK CONSTRAINT [FK_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_ENT_WORD_GROUP_FLOW]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_TBL_THIRD_PARTY_API_PARAMS]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAMS]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAMS]  WITH CHECK ADD  CONSTRAINT [CK_TBL_THIRD_PARTY_API_PARAMS] CHECK  (([OPTIONAL]=(0) AND [DEFAULT_VALUE] IS NOT NULL OR [OPTIONAL]=(1)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_TBL_THIRD_PARTY_API_PARAMS]') AND parent_object_id = OBJECT_ID(N'[dbo].[TBL_THIRD_PARTY_API_PARAMS]'))
ALTER TABLE [dbo].[TBL_THIRD_PARTY_API_PARAMS] CHECK CONSTRAINT [CK_TBL_THIRD_PARTY_API_PARAMS]
GO
/****** Object:  StoredProcedure [dbo].[SET_RESP_PARAMS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SET_RESP_PARAMS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SET_RESP_PARAMS] AS' 
END
GO

-- =============================================
-- Author:		yinshengge
-- Create date: 2015-11-25
-- Description:	参数设置
-- =============================================
ALTER PROCEDURE [dbo].[SET_RESP_PARAMS]
		  @INPUT  AS NVARCHAR(4000) 
		, @RESPONSE_1 AS NVARCHAR(4000) OUTPUT
		, @RESPONSE_2 AS NVARCHAR(4000) OUTPUT
		, @RESPONSE_3 AS NVARCHAR(4000) OUTPUT
		, @RESPONSE_4 AS NVARCHAR(4000) OUTPUT
		, @RESPONSE_5 AS NVARCHAR(4000) OUTPUT
		, @RESPONSE_6 AS NVARCHAR(4000) OUTPUT
		, @RESPONSE_7 AS NVARCHAR(4000) OUTPUT
		, @RESPONSE_8 AS NVARCHAR(4000) OUTPUT
		, @RESPONSE_9 AS NVARCHAR(4000) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @INPUT IS NOT NULL
	BEGIN
		IF @RESPONSE_1 IS NULL
		BEGIN
			SET @RESPONSE_1 = @INPUT
			RETURN
		END


		IF @RESPONSE_2 IS NULL
		BEGIN
			SET @RESPONSE_2 = @INPUT
			RETURN
		END

		IF @RESPONSE_3 IS NULL
		BEGIN
			SET @RESPONSE_3 = @INPUT
			RETURN
		END

		IF @RESPONSE_4 IS NULL
		BEGIN
			SET @RESPONSE_4 = @INPUT
			RETURN
		END

		IF @RESPONSE_5 IS NULL
		BEGIN
			SET @RESPONSE_5 = @INPUT
			RETURN
		END

		IF @RESPONSE_6 IS NULL
		BEGIN
			SET @RESPONSE_6 = @INPUT
			RETURN
		END

		IF @RESPONSE_7 IS NULL
		BEGIN
			SET @RESPONSE_7 = @INPUT
			RETURN
		END

		IF @RESPONSE_8 IS NULL
		BEGIN
			SET @RESPONSE_8 = @INPUT
			RETURN
		END

		IF @RESPONSE_9 IS NULL
		BEGIN
			SET @RESPONSE_9 = @INPUT
			RETURN
		END

	END
	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_ACTIVATE_ROBOT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ACTIVATE_ROBOT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_ACTIVATE_ROBOT] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-4-19
-- Description:	机器人激活
-- =============================================
ALTER PROCEDURE [dbo].[SP_ACTIVATE_ROBOT]
			  @USER_NAME   AS NVARCHAR(400)
			, @PASSWORD    AS NVARCHAR(400)
			, @DIG    AS NVARCHAR(400)
			, @ROBOT_NAME  AS NVARCHAR(2000)
			, @ROBOT_IMEI  AS NVARCHAR(400)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- 验证身份
	DECLARE @USER_ID AS BIGINT

	SET @USER_ID = NULL
	SELECT @USER_ID = [ID] FROM ENT_USER WHERE NAME = @USER_NAME  
	AND (ENT_USER.PASSWORD =  @PASSWORD OR @DIG =  PASSWORD)

	IF @USER_ID IS NULL
	BEGIN
			RAISERROR (N'用户名或密码有误！',   15,  1)  
			RETURN	
	END	

	-- select  RIGHT( '123',1) 
	DECLARE @HW_SPEC_ID BIGINT
	SET @HW_SPEC_ID = 1

	IF LEN(@ROBOT_IMEI) > 16
	BEGIN
		SET @HW_SPEC_ID = CAST (RIGHT(@ROBOT_IMEI, 1) AS BIGINT)
		SET @ROBOT_IMEI = LEFT(@ROBOT_IMEI, 16)
	END

	IF NOT EXISTS(SELECT ID FROM ENT_ROBOT WHERE  @ROBOT_IMEI = IMEI) 	  
		INSERT INTO [ENT_ROBOT]
			   ([IMEI]
			   ,[NAME]
			   ,[ACTIVATE_DATETIME]
			   ,[ACTIVATE_USER_ID]
			   , HW_SPEC_ID)
		 VALUES
			   ( @ROBOT_IMEI
			   , @ROBOT_NAME
			   , GETDATE()
			   , @USER_ID 
			   , @HW_SPEC_ID)
	ELSE
	BEGIN
			RAISERROR (N'激活失败，此机器已激活！',   15,  1)  
	END

end


GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_RTC_SESSION_NEW_STATE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ADD_RTC_SESSION_NEW_STATE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_ADD_RTC_SESSION_NEW_STATE] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-4-8
-- Description:	视频会话状态存储
-- =============================================
ALTER PROCEDURE [dbo].[SP_ADD_RTC_SESSION_NEW_STATE] 
		 @ROBOT_ID AS BIGINT
		,@USER_ID AS BIGINT
		,@ROBOT_INITIATE AS BIT
		,@STATUS AS NVARCHAR(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TBL_RTC_SESSION_ID AS BIGINT

	SET @TBL_RTC_SESSION_ID = -1

	SELECT TOP 1 @TBL_RTC_SESSION_ID = [ID]
	FROM [TBL_RTC_SESSION]
	WHERE [ROBOT_ID] = @ROBOT_ID
	AND [USER_ID] = @USER_ID 
	AND [ROBOT_INITIATE] = @ROBOT_INITIATE
	ORDER BY CREATE_DATETIME DESC

	IF  @TBL_RTC_SESSION_ID <> -1  AND
		NOT EXISTS(SELECT * FROM [TBL_RTC_SESSION_STATUS] WHERE @TBL_RTC_SESSION_ID = RTC_SESSION_ID AND STATUS = @STATUS )
		



	INSERT INTO  [TBL_RTC_SESSION_STATUS]
           ([RTC_SESSION_ID]
           ,[UPDATE_DATETIME]
           ,[STATUS])
     VALUES
           (@TBL_RTC_SESSION_ID
           ,GETDATE()
           ,@STATUS)
	
	

END



GO
/****** Object:  StoredProcedure [dbo].[SP_ADMIN_LOGIN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ADMIN_LOGIN]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_ADMIN_LOGIN] AS' 
END
GO








-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-3-28
-- Description: ADMIN登录

-- =============================================
ALTER PROCEDURE [dbo].[SP_ADMIN_LOGIN] 
	-- Add the parameters for the stored procedure here
	 @USER_NAME  AS NVARCHAR(4000)  -- IN
	,@PASSWORD   AS NVARCHAR(4000)  -- IN

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 	DECLARE @USER_ID AS BIGINT 
	DECLARE @ROBOT_COUNT  AS BIGINT

	SET @ROBOT_COUNT = 0
	SET @USER_ID = NULL

	SELECT @USER_ID = ID FROM ENT_ADMIN
	WHERE NAME = @USER_NAME 
	AND 
	(
		PASSWORD = @PASSWORD 
	) 

	
	IF @USER_ID IS NOT NULL
	BEGIN
		 SELECT * FROM VIEW_USER_ROBOT_BIND_LIST
		order by [VIEW_USER_ROBOT_BIND_LIST].ROBOT_LATEST_STATUS_ONLINE desc
		, [VIEW_USER_ROBOT_BIND_LIST].ROBOT_LATEST_STATUS_UPDATE_DATETIME desc
		, [VIEW_USER_ROBOT_BIND_LIST].ROBOT_ACTIVATE_DATETIME desc
	END
	ELSE
	BEGIN
		RAISERROR (N'用户名或密码有误！',  
          15,  
          1)  
	END
END









GO
/****** Object:  StoredProcedure [dbo].[SP_AUTO_GEN_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AUTO_GEN_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_AUTO_GEN_ID] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-13
-- Description:	获取最大ID
-- =============================================
ALTER PROC [dbo].[SP_AUTO_GEN_ID]
(
	@TABLE_NAME AS NVARCHAR(100)
	, @GEN_ID AS BIGINT OUTPUT
)

AS
BEGIN

	DECLARE @SQL AS NVARCHAR(4000)
	SET @SQL = 'SELECT @GEN_IDS = ISNULL(MAX(ID), 0) + 1 FROM ' + @TABLE_NAME
	exec sp_executesql @SQL, N'@GEN_IDS int output', @GEN_ID output 
END


GO
/****** Object:  StoredProcedure [dbo].[SP_BACKUP_LOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_BACKUP_LOG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_BACKUP_LOG] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-2
-- Description:	备份log
-- =============================================
ALTER PROCEDURE [dbo].[SP_BACKUP_LOG]
	  @TABLE_NAME NVARCHAR(120)
	, @RESERVED_DAY_COUNT NVARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @SQL AS NVARCHAR(4000)

	SET @SQL = 
	' INSERT INTO  ' + @TABLE_NAME + '_BACKUP
	  SELECT * FROM  ' + @TABLE_NAME + ' WITH(UPDLOCK)
	  WHERE  DATEDIFF(D, DATE_TIME, GETDATE()) > ' +  @RESERVED_DAY_COUNT -- 保留备份

	EXEC SP_EXECUTESQL @SQL

	SET @SQL = 	
	' DELETE 	 ' + @TABLE_NAME + 
	' WHERE  DATEDIFF(D, DATE_TIME, GETDATE()) > ' +  @RESERVED_DAY_COUNT -- 删除已备份的

	EXEC SP_EXECUTESQL  @SQL

END



GO
/****** Object:  StoredProcedure [dbo].[SP_BACKUP_LOG_BY_META_SETTINGS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_BACKUP_LOG_BY_META_SETTINGS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_BACKUP_LOG_BY_META_SETTINGS] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-4
-- Description:	备份log
-- =============================================
ALTER PROCEDURE [dbo].[SP_BACKUP_LOG_BY_META_SETTINGS]
	  @TABLE_NAME NVARCHAR(120)
	, @RESERVE_SETTINGS_NAME NVARCHAR(120)

AS
BEGIN
	
	DECLARE @RESERVED_DAY_COUNT NVARCHAR(10) 
	SET @RESERVED_DAY_COUNT =  DBO.FUNC_GET_META_SETTINGS(@RESERVE_SETTINGS_NAME, '1') 
	EXEC  SP_BACKUP_LOG @TABLE_NAME, @RESERVED_DAY_COUNT
END



GO
/****** Object:  StoredProcedure [dbo].[SP_BACKUP_PLAN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_BACKUP_PLAN]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_BACKUP_PLAN] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-4
-- Description:	备份计划
-- =============================================
ALTER PROCEDURE [dbo].[SP_BACKUP_PLAN]
AS
BEGIN
	-- 工控机异常
	EXEC SP_BACKUP_LOG_BY_META_SETTINGS	'TBL_RUNTIME',      'MACHINE_EXCEPTION_RESERVED_DATE_NUM'
	-- 客户端 log
	EXEC SP_BACKUP_LOG_BY_META_SETTINGS	'TBL_RUNTIME_DATA', 'RUNTIME_LOG_RESERVED_DATE_NUM'
	-- 会话 log
	EXEC SP_BACKUP_LOG_BY_META_SETTINGS	'ENT_DIALOG',       'DIALOG_LOG_RESERVED_DATE_NUM'

	-- 删除会话属性
	DELETE FROM TBL_REQUEST_PROPERTY
	DELETE FROM [dbo].[ENT_REQUEST]

END



GO
/****** Object:  StoredProcedure [dbo].[SP_BACKUP_RUNTIME_DATA]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_BACKUP_RUNTIME_DATA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_BACKUP_RUNTIME_DATA] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-20
-- Description:	备份log
-- =============================================
ALTER PROCEDURE [dbo].[SP_BACKUP_RUNTIME_DATA]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO  [TBL_RUNTIME_DATA_BACKUP] 
	SELECT * FROM TBL_RUNTIME_DATA WITH(UPDLOCK)
	WHERE  DATEDIFF(D, DATE_TIME, GETDATE()) > 7 -- 保留7天到备份

	DELETE 	 TBL_RUNTIME_DATA WHERE  DATEDIFF(D, DATE_TIME, GETDATE()) > 7 -- 保留7天到备份
END

GO
/****** Object:  StoredProcedure [dbo].[SP_COLLECT_SESSION_CONTEXT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COLLECT_SESSION_CONTEXT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COLLECT_SESSION_CONTEXT] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-30
-- Description:	回收无效上下文信息
-- =============================================
ALTER PROCEDURE [dbo].[SP_COLLECT_SESSION_CONTEXT]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE [TBL_ROBOT_SESSION_CONTEXT] WHERE
	ABS(DATEDIFF (SECOND, GETDATE(), CREATE_DATETIME)) > EXPR_SECS

END

GO
/****** Object:  StoredProcedure [dbo].[SP_COPY_ENT_KEY_WORDS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COPY_ENT_KEY_WORDS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COPY_ENT_KEY_WORDS] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-08
-- Description:	拷贝单词
-- =============================================
ALTER PROCEDURE [dbo].[SP_COPY_ENT_KEY_WORDS]
	  @SOURCE_ID AS BIGINT 
	, @RENAME AS NVARCHAR(8)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	EXEC SP_SAVE_KEY_WORD 0, @RENAME; 
	
END


GO
/****** Object:  StoredProcedure [dbo].[SP_COPY_ENT_THIRD_PARTY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COPY_ENT_THIRD_PARTY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COPY_ENT_THIRD_PARTY] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-6
-- Description:	拷贝第三方
-- =============================================
ALTER PROCEDURE [dbo].[SP_COPY_ENT_THIRD_PARTY]
	  @SOURCE_ID AS BIGINT 
	, @RENAME AS NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- 1. 搜索源并保存数据
	INSERT INTO [ENT_THIRD_PARTY_API]
	SELECT 0 AS [ID]
      ,@RENAME
      ,ENABLE
      ,URL
      ,METHOD
      ,RUN_AT_SERVER
      ,RESULT_TYPE
      ,DESCRIPTION
     
     FROM  [ENT_THIRD_PARTY_API] WHERE ID = @SOURCE_ID

	-- 2. 子对象关联
	DECLARE @NEW_ID AS BIGINT  -- 获取NEW_ID
	EXEC SP_GET_ENTITY_ID_BY_NAME 'ENT_THIRD_PARTY_API', @RENAME, @NEW_ID OUTPUT

	INSERT INTO 
			TBL_THIRD_PARTY_API_PARAM
	SELECT  
		    @NEW_ID AS THIRD_PARTY_API_ID
		  ,	TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID
		  , TBL_THIRD_PARTY_API_PARAM.[DESCRIPTION]
	FROM   TBL_THIRD_PARTY_API_PARAM
	WHERE  THIRD_PARTY_API_ID = @SOURCE_ID

	-- 3. 输出拷贝后的值
	
	SELECT * FROM [ENT_THIRD_PARTY_API] WHERE [NAME] = @RENAME
END







GO
/****** Object:  StoredProcedure [dbo].[SP_COPY_ENT_THIRD_PARTY_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COPY_ENT_THIRD_PARTY_PARAM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COPY_ENT_THIRD_PARTY_PARAM] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-6
-- Description:	拷贝第三方API 参数
-- =============================================
ALTER PROCEDURE [dbo].[SP_COPY_ENT_THIRD_PARTY_PARAM]
	  @SOURCE_ID AS BIGINT 
	, @RENAME AS NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- 1. 搜索源并保存数据
	INSERT INTO [ENT_THIRD_PARTY_API_PARAM]
	SELECT 0 AS [ID]
      ,@RENAME
      ,HEADER_0_BODY_1
      ,OPTIONAL
      ,DEFAULT_VALUE
      ,DESCRIPTION
     
     FROM  [ENT_THIRD_PARTY_API_PARAM] WHERE ID = @SOURCE_ID

	-- 3. 输出拷贝后的值
	
	SELECT * FROM [ENT_THIRD_PARTY_API_PARAM] WHERE [NAME] = @RENAME
END







GO
/****** Object:  StoredProcedure [dbo].[SP_COPY_ENT_Third_Party_Param_Value]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COPY_ENT_Third_Party_Param_Value]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COPY_ENT_Third_Party_Param_Value] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-6
-- Description:	拷贝第三方API 参数
-- =============================================
ALTER PROCEDURE [dbo].[SP_COPY_ENT_Third_Party_Param_Value]
	  @SOURCE_ID AS BIGINT 
	, @RENAME AS NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- 1. 搜索源并保存数据
	INSERT INTO [ENT_THIRD_PARTY_API_PARAM_VALUE]
	SELECT 0 AS [ID]
      ,@RENAME
      ,THIRD_PARTY_API_ID
      ,ENABLED
      ,DESCRIPTION
     
     FROM  [ENT_THIRD_PARTY_API_PARAM_VALUE] WHERE ID = @SOURCE_ID

	-- 2. 子对象关联
	DECLARE @NEW_ID AS BIGINT  -- 获取NEW_ID
	EXEC SP_GET_ENTITY_ID_BY_NAME 'ENT_THIRD_PARTY_API_PARAM_VALUE', @RENAME, @NEW_ID OUTPUT

	INSERT INTO 
			TBL_THIRD_PARTY_API_PARAM_VALUE
	SELECT  
		    @NEW_ID AS THIRD_PARTY_API_PARAM_VALUE_ID
		  ,	TBL_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_PARAM_ID
		  , TBL_THIRD_PARTY_API_PARAM_VALUE.PARAM_VALUE
		  , TBL_THIRD_PARTY_API_PARAM_VALUE.DESCRIPTION
	FROM   TBL_THIRD_PARTY_API_PARAM_VALUE
	WHERE  THIRD_PARTY_API_PARAM_VALUE_ID = @SOURCE_ID


	-- 3. 输出拷贝后的值
	
	SELECT * FROM VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE WHERE ID = @NEW_ID
END







GO
/****** Object:  StoredProcedure [dbo].[SP_COPY_ENT_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COPY_ENT_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COPY_ENT_VOICE] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-08
-- Description:	拷贝应答
-- =============================================
ALTER PROCEDURE [dbo].[SP_COPY_ENT_VOICE]
	  @SOURCE_ID AS BIGINT 
	, @RENAME AS NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- DECLARE @KW AS NVARCHAR(8)
	-- 1. 搜索源并保存数据
	INSERT INTO ENT_VOICE
	SELECT 0 AS [ID]
      ,@RENAME
      ,[PATH]
      ,[EMOTION]
      ,[TEXT]
      ,[COMMAND]
      ,[COMMAND_PARAM]
      ,[THIRD_PARTY_API_ID]
      ,[THIRD_PARTY_API_PARAMS_VALUE_ID]
      ,[INC_PROP]
      ,[EXC_PROP]
      ,[CAT]
      ,[FIXED_PARAM_1]
      ,[FIXED_PARAM_2]
      ,[FIXED_PARAM_3]
      ,[FIXED_PARAM_4]
      ,[FIXED_PARAM_5]
	  ,[ENABLED]
      ,[DESCRIPTION]
     FROM  ENT_VOICE WHERE ID = @SOURCE_ID
	
	 

	-- 3. 输出拷贝后的值
	
	SELECT * FROM VIEW_VOICE_SIMPLE WHERE [NAME] = @RENAME
END







GO
/****** Object:  StoredProcedure [dbo].[SP_COPY_ENT_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COPY_ENT_VOICE_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COPY_ENT_VOICE_GROUP] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-08
-- Description:	拷贝应答组
-- =============================================
ALTER PROCEDURE [dbo].[SP_COPY_ENT_VOICE_GROUP]
	  @SOURCE_ID AS BIGINT 
	, @RENAME AS NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- DECLARE @KW AS NVARCHAR(8)
	-- 1. 搜索源并保存数据
	INSERT INTO ENT_VOICE_GROUP
	SELECT   0 AS ID
		   , @RENAME AS NAME
		   , DESCRIPTION
    FROM  ENT_VOICE_GROUP WHERE ID = @SOURCE_ID
	
	-- 2. 子对象关联
	DECLARE @NEW_ID AS BIGINT  -- 获取NEW_ID
	-- SET @NEW_ID = dbo.[FUNC_GET_ENTITY_ID_BY_NAME]('ENT_VOICE_GROUP', @RENAME)
	EXEC SP_GET_ENTITY_ID_BY_NAME 'ENT_VOICE_GROUP', @RENAME, @NEW_ID OUTPUT

	INSERT INTO 
			TBL_VOICE_GROUP
	SELECT  
		    @NEW_ID AS ID
		  ,	TBL_VOICE_GROUP.VOICE_ID
		  , TBL_VOICE_GROUP.[DESCRIPTION]
	FROM   TBL_VOICE_GROUP
	WHERE  ID = @SOURCE_ID

	-- 3. 输出拷贝后的值日
	
	SELECT * FROM ENT_VOICE_GROUP WHERE ID = @NEW_ID
END







GO
/****** Object:  StoredProcedure [dbo].[SP_COPY_ENT_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COPY_ENT_WORD_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COPY_ENT_WORD_GROUP] AS' 
END
GO





-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-08
-- Description:	拷贝单词组
-- =============================================
ALTER PROCEDURE [dbo].[SP_COPY_ENT_WORD_GROUP]
	  @SOURCE_ID AS BIGINT 
	, @RENAME AS NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- DECLARE @KW AS NVARCHAR(8)
	-- 1. 搜索源并保存数据
	INSERT INTO ENT_WORD_GROUP	
	SELECT   0 AS ID
		   , @RENAME AS NAME
		   , DESCRIPTION
	FROM  [ENT_WORD_GROUP] WHERE ID = @SOURCE_ID
	
	DECLARE @NEW_ID AS BIGINT
	-- SET @NEW_ID =  dbo.[FUNC_GET_ENTITY_ID_BY_NAME]('ENT_WORD_GROUP', @RENAME) 
	EXEC SP_GET_ENTITY_ID_BY_NAME 'ENT_WORD_GROUP', @RENAME, @NEW_ID OUTPUT

	-- 2. 子对象关联

	INSERT INTO 
			TBL_WORD_GROUP
	SELECT  
		    @NEW_ID AS GROUP_ID
		  , TBL_WORD_GROUP.KEY_WORD_ID
		  , TBL_WORD_GROUP.[DESCRIPTION]
	FROM   TBL_WORD_GROUP
	WHERE  GROUP_ID = @SOURCE_ID

	-- 3. 输出拷贝后的值
	
	SELECT * FROM ENT_WORD_GROUP WHERE ID = @NEW_ID
END






GO
/****** Object:  StoredProcedure [dbo].[SP_COPY_ENT_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_COPY_ENT_WORD_GROUP_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_COPY_ENT_WORD_GROUP_FLOW] AS' 
END
GO





-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-08
-- Description:	拷贝句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_COPY_ENT_WORD_GROUP_FLOW]
	  @SOURCE_ID AS BIGINT 
	, @RENAME AS NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- DECLARE @KW AS NVARCHAR(8)
	-- 1. 搜索源并保存数据
	INSERT INTO ENT_WORD_GROUP_FLOW	
	SELECT  0 AS [ID] 
		  , @RENAME  [NAME]
		  , [DESCRIPTION]
	FROM  [ENT_WORD_GROUP_FLOW]
	WHERE ID = @SOURCE_ID
	
	-- 2. 子对象关联
	DECLARE @NEW_ID AS BIGINT
	-- SET @NEW_ID =  dbo.[FUNC_GET_ENTITY_ID_BY_NAME]('ENT_WORD_GROUP_FLOW', @RENAME)
	EXEC SP_GET_ENTITY_ID_BY_NAME 'ENT_WORD_GROUP_FLOW', @RENAME, @NEW_ID OUTPUT

	INSERT INTO 
			TBL_WORD_GROUP_FLOW
	SELECT  
		    @NEW_ID AS ID
		  ,	TBL_WORD_GROUP_FLOW.GROUP_FLOW_ORDER
		  , TBL_WORD_GROUP_FLOW.WORD_GROUP_ID
		  , TBL_WORD_GROUP_FLOW.USE_SOUND
		  , TBL_WORD_GROUP_FLOW.INC_1_EXC_0
		  , TBL_WORD_GROUP_FLOW.[DESCRIPTION]
	FROM   TBL_WORD_GROUP_FLOW
	WHERE  ID = @SOURCE_ID

	-- 3. 输出拷贝后的值
	
	SELECT * FROM ENT_WORD_GROUP_FLOW WHERE ID = @NEW_ID
END






GO
/****** Object:  StoredProcedure [dbo].[SP_CUSOMER_SAVE_ORIGNAL_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSOMER_SAVE_ORIGNAL_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSOMER_SAVE_ORIGNAL_VOICE] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-22
-- Description:	用户提交语料
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSOMER_SAVE_ORIGNAL_VOICE]
		@ORIGNAL_RULE_ID   BIGINT
	   ,@VOICE_ID   BIGINT
	   ,@NAME NVARCHAR(50)
	   ,@PATH NVARCHAR(1024)
	   ,@EMOTION NVARCHAR(1024)
	   ,@TEXT NVARCHAR(1024)
	   ,@COMMAND BIGINT
	   ,@COMMAND_PARAM NVARCHAR(MAX)
	   ,@THIRD_PARTY_API_ID BIGINT
	   ,@THIRD_PARTY_API_PARAMS_VALUE_ID BIGINT
	   ,@INC_PROP NVARCHAR(4000)
	   ,@CAT NVARCHAR(50)
	   ,@REQUEST NVARCHAR(1024)
	   ,@USER_ID BIGINT
	   ,@DESCRIPTION NVARCHAR(1024)
	   ,@QUERY BIT = 1
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @VOICE_GROUP_ID BIGINT
	DECLARE @GEN_WORD_GROUP_FLOW_ID BIGINT

	SET @COMMAND = (CASE  @COMMAND WHEN 0 THEN NULL ELSE @COMMAND END)
	SET @THIRD_PARTY_API_ID = (CASE  @THIRD_PARTY_API_ID WHEN 0 THEN NULL ELSE @THIRD_PARTY_API_ID END)
	SET @THIRD_PARTY_API_PARAMS_VALUE_ID = (CASE  @THIRD_PARTY_API_PARAMS_VALUE_ID WHEN 0 THEN NULL ELSE @THIRD_PARTY_API_PARAMS_VALUE_ID END)

	-- 新建时看看是否有相同的,有的话提出来
	IF @ORIGNAL_RULE_ID IS NULL AND @VOICE_ID IS NULL		 
		SELECT  @ORIGNAL_RULE_ID = ORIGNAL_RULE_ID , @VOICE_ID = VOICE_ID
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL 
		WHERE NAME = @NAME AND REQUEST = @REQUEST AND CREATE_USER_ID = @USER_ID

	SET @INC_PROP = ISNULL(@INC_PROP, '')

	PRINT 'tag：' + @INC_PROP
    PRINT @ORIGNAL_RULE_ID
    PRINT @VOICE_ID

	IF @ORIGNAL_RULE_ID IS NULL OR @VOICE_ID IS NULL
	BEGIN
		-- 新增的默认打上企业TAG
		SELECT @INC_PROP = @INC_PROP + (CASE @INC_PROP WHEN '' THEN '' ELSE ',' END) + ENT_USER_GROUP.TAG 
		FROM   ENT_USER INNER JOIN ENT_USER_GROUP ON (ENT_USER.USER_GROUP_ID = ENT_USER_GROUP.ID)
		WHERE  ENT_USER.ID = @USER_ID

		PRINT 'ADD VOICE tag：' + @INC_PROP

		INSERT INTO [ENT_VOICE]
				   (
					[NAME]
				   ,[PATH]
				   ,[EMOTION]
				   ,[TEXT]
				   ,[COMMAND]
				   ,[COMMAND_PARAM]
				   ,[THIRD_PARTY_API_ID]
				   ,[THIRD_PARTY_API_PARAMS_VALUE_ID]
				   ,[INC_PROP]
				   ,[CAT]
				   ,[DESCRIPTION])
			 VALUES
				   (
					@NAME
				   ,@PATH
				   ,@EMOTION
				   ,@TEXT
				   ,@COMMAND
				   ,@COMMAND_PARAM
				   ,@THIRD_PARTY_API_ID
				   ,@THIRD_PARTY_API_PARAMS_VALUE_ID
				   ,@INC_PROP
				   ,@CAT
				   ,@DESCRIPTION)

		SELECT @VOICE_ID = MAX(ID) FROM [ENT_VOICE] -- WHERE [NAME] = @NAME

		-- 查找是否有对应的规则
		EXEC SP_GET_MAX_MATCHED_FLOW_ID @REQUEST, @GEN_WORD_GROUP_FLOW_ID OUTPUT,  @VOICE_GROUP_ID OUTPUT

		IF @VOICE_GROUP_ID IS NULL
		BEGIN
			-- 生成应答组
			SET  @NAME = '应答组（自助提交生成）' + @NAME
			EXEC SP_SAVE_VOICE_GROUP NULL, @NAME, @NAME, 0
			-- 获得应答组ID
			SELECT @VOICE_GROUP_ID = ID FROM ENT_VOICE_GROUP WHERE [NAME] = @NAME
		END

		-- 设置到应答组
		EXEC SP_SET_VOICE_TO_GROUP @VOICE_GROUP_ID, @VOICE_ID, 1		

		-- 插入original
		INSERT INTO  [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]
				   ([REQUEST]
				   ,[RESPONSE_VOICE_GROUP_ID]
				   ,[CREATE_USER_ID]
				   ,[UPDATE_USER_ID]
				   ,[CREATE_DATETIME]
				   ,[UPDATE_DATETIME]
				   ,[GEN_WORD_GROUP_FLOW_ID]
				   ,[GEN_DATETIME])
			 VALUES
				   (@REQUEST
				   ,@VOICE_GROUP_ID
				   ,@USER_ID
				   ,@USER_ID
				   ,GETDATE()
				   ,GETDATE()
				   ,@GEN_WORD_GROUP_FLOW_ID
				   ,CASE WHEN @GEN_WORD_GROUP_FLOW_ID IS NULL THEN NULL ELSE GETDATE() END
					)		
		SET @ORIGNAL_RULE_ID = SCOPE_IDENTITY() 
	END
	ELSE
	BEGIN
		PRINT 'UPDATE VOICE tag：' + @INC_PROP

		IF @INC_PROP = '' 
			-- 更新 tag 为空， 自动打上公司TAG
			SELECT @INC_PROP = @INC_PROP + (CASE @INC_PROP WHEN '' THEN '' ELSE ',' END) + ENT_USER_GROUP.TAG 
			FROM   ENT_USER INNER JOIN ENT_USER_GROUP ON (ENT_USER.USER_GROUP_ID = ENT_USER_GROUP.ID)
			WHERE  ENT_USER.ID = @USER_ID


		-- 更新 voice，应答
		UPDATE  [ENT_VOICE]
		   SET  
			   [NAME] = @NAME
			  ,[PATH] = @PATH
			  ,[EMOTION] = @EMOTION
			  ,[TEXT] = @TEXT
			  ,[COMMAND] = @COMMAND
			  ,[COMMAND_PARAM] = @COMMAND_PARAM
			  ,[THIRD_PARTY_API_ID] =   @THIRD_PARTY_API_ID  
			  ,[THIRD_PARTY_API_PARAMS_VALUE_ID] = @THIRD_PARTY_API_PARAMS_VALUE_ID
			  ,[INC_PROP] = @INC_PROP
		 WHERE ID = @VOICE_ID

		
		 -- 更新 REQUEST，请求
		UPDATE [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]
		SET [REQUEST] = @REQUEST
			  ,[UPDATE_USER_ID] = @USER_ID
			  ,[UPDATE_DATETIME] = GETDATE()
		WHERE ID = @ORIGNAL_RULE_ID

		DECLARE @OLD_GEN_WORD_GROUP_FLOW_ID BIGINT
		DECLARE @OLD_VOICE_GROUP_ID BIGINT

		-- 获取原来的 flow id 和 voice group id
		SELECT  @OLD_GEN_WORD_GROUP_FLOW_ID = ISNULL(GEN_WORD_GROUP_FLOW_ID, 0)
				,@OLD_VOICE_GROUP_ID = RESPONSE_VOICE_GROUP_ID
		FROM   [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]  
		WHERE ID = @ORIGNAL_RULE_ID

		-- 根据 request 重新计算 flowid 和 voice group id
		EXEC SP_GET_MAX_MATCHED_FLOW_ID @REQUEST, @GEN_WORD_GROUP_FLOW_ID OUTPUT, @VOICE_GROUP_ID OUTPUT 

		-- 对应的 flowid 和 voice group id 有变化
		IF (
				@VOICE_GROUP_ID IS NOT NULL
				AND @OLD_VOICE_GROUP_ID <> @VOICE_GROUP_ID
		    )
		BEGIN
			-- 删除旧的  voice group 挂靠
			EXEC SP_SET_VOICE_TO_GROUP @OLD_VOICE_GROUP_ID, @VOICE_ID, 0
			-- 设置到新的 voice group
			EXEC SP_SET_VOICE_TO_GROUP @VOICE_GROUP_ID, @VOICE_ID, 1
		END
		ELSE
			-- 匹配不到新的 voice group id，把旧的用回
			SET @VOICE_GROUP_ID = @OLD_VOICE_GROUP_ID
		 		

		-- 更新 orginal
		 UPDATE [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]
		   SET 
			    [UPDATE_USER_ID] = @USER_ID
			  , RESPONSE_VOICE_GROUP_ID = @VOICE_GROUP_ID
			  , GEN_WORD_GROUP_FLOW_ID = @GEN_WORD_GROUP_FLOW_ID
			  , [UPDATE_DATETIME] = GETDATE()
			  , GEN_DATETIME = GETDATE()
		 WHERE ID = @ORIGNAL_RULE_ID
	END	

	IF @QUERY = 1
		SELECT VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.*		    
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL 
		WHERE ORIGNAL_RULE_ID = @ORIGNAL_RULE_ID AND VOICE_ID = @VOICE_ID

END













GO
/****** Object:  StoredProcedure [dbo].[SP_CUSOMER_SAVE_ORIGNAL_VOICE_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSOMER_SAVE_ORIGNAL_VOICE_V2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSOMER_SAVE_ORIGNAL_VOICE_V2] AS' 
END
GO















-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-02
-- Description:	用户提交语料 第二版本
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSOMER_SAVE_ORIGNAL_VOICE_V2]
		@ORIGNAL_RULE_ID   BIGINT
	   ,@VOICE_ID   BIGINT
	   ,@NAME NVARCHAR(50)
	   ,@PATH NVARCHAR(1024)
	   ,@EMOTION NVARCHAR(1024)
	   ,@TEXT NVARCHAR(4000)
	   ,@COMMAND BIGINT
	   ,@COMMAND_PARAM NVARCHAR(MAX)
	   ,@THIRD_PARTY_API_ID BIGINT
	   ,@THIRD_PARTY_API_PARAMS_VALUE_ID BIGINT
	   ,@INC_PROP NVARCHAR(4000)
	   ,@CAT NVARCHAR(50)
	   ,@REQUEST NVARCHAR(1024)
	   ,@USER_ID BIGINT
	   ,@DESCRIPTION NVARCHAR(1024)
	   ,@QUERY BIT = 1
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @VOICE_GROUP_ID BIGINT
	DECLARE @GEN_WORD_GROUP_FLOW_ID BIGINT
	DECLARE @USER_GROUP_TAG AS NVARCHAR(50)

	-- 修正参数
	SET @ORIGNAL_RULE_ID = (CASE  @ORIGNAL_RULE_ID WHEN 0 THEN NULL ELSE @ORIGNAL_RULE_ID END)
	SET @VOICE_ID = (CASE  @VOICE_ID WHEN 0 THEN NULL ELSE @VOICE_ID END)
	SET @COMMAND = (CASE  @COMMAND WHEN 0 THEN NULL ELSE @COMMAND END)
	SET @THIRD_PARTY_API_ID = (CASE  @THIRD_PARTY_API_ID WHEN 0 THEN NULL ELSE @THIRD_PARTY_API_ID END)
	SET @THIRD_PARTY_API_PARAMS_VALUE_ID = (CASE  @THIRD_PARTY_API_PARAMS_VALUE_ID WHEN 0 THEN NULL ELSE @THIRD_PARTY_API_PARAMS_VALUE_ID END)
	SET @INC_PROP = ISNULL(@INC_PROP, '')

	-- 获取企业TAG
	SELECT  @USER_GROUP_TAG = ENT_USER_GROUP.TAG 
	FROM   ENT_USER INNER JOIN ENT_USER_GROUP ON (ENT_USER.USER_GROUP_ID = ENT_USER_GROUP.ID)
	WHERE  ENT_USER.ID = @USER_ID
	
	-- 企业TAG 没打, 则必须打上企业TAG	
	IF NOT EXISTS
	(
		SELECT TAG 
		FROM FUNC_GET_TAGS_TABLE(@INC_PROP)
		WHERE TAG = @USER_GROUP_TAG
	)
	BEGIN
		SET  @INC_PROP = @INC_PROP + (CASE @INC_PROP WHEN '' THEN '' ELSE ',' END) + @USER_GROUP_TAG
	END
 
	-- 新建时查找重复
	IF @ORIGNAL_RULE_ID IS NULL AND @VOICE_ID IS NULL		 
	BEGIN
		-- 查找目的，问法完全一样的,找相同的 ORIGNAL_RULE_ID 和 VOICE_ID
		SELECT @VOICE_ID = [VOICE_ID]
			   , @ORIGNAL_RULE_ID = [ORIGNAL_RULE_ID]
		  FROM [VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2]		
		  WHERE 
				   ISNULL(@NAME, '') = ISNULL(NAME, '')
			   AND ISNULL(@PATH, '') = ISNULL(PATH, '')
			   AND ISNULL(@EMOTION, '') = ISNULL(EMOTION, '')
			   AND ISNULL(@TEXT, '')= ISNULL(TEXT, '')
			   AND ISNULL(@COMMAND, 0) = ISNULL(COMMAND, '')
			   AND ISNULL(@COMMAND_PARAM, '') = ISNULL(COMMAND_PARAM, '')
			   AND ISNULL(@THIRD_PARTY_API_ID, 0)= ISNULL(THIRD_PARTY_API_ID, '') 
			   AND ISNULL(@THIRD_PARTY_API_PARAMS_VALUE_ID, 0)= ISNULL(THIRD_PARTY_API_PARAMS_VALUE_ID, 0)
			   AND ISNULL(@INC_PROP, '') = ISNULL(INC_PROP, '')
			   AND ISNULL(@CAT, '')= ISNULL(CAT, '')
			   AND ISNULL(@REQUEST, '') = ISNULL(REQUEST, '')
			   AND ISNULL(@USER_ID, 0)= ISNULL(CREATE_USER_ID, '') 
			   AND ISNULL(@DESCRIPTION, '') = ISNULL(DESCRIPTION, '')

		-- 查找问话目的，回复完全一样的（问法可能不一）,找相同的 VOICE_ID
		SELECT @VOICE_ID = ID
		  FROM ENT_VOICE
		  WHERE 
				   ISNULL(@NAME, '') = ISNULL(NAME, '')
			   AND ISNULL(@PATH, '') = ISNULL(PATH, '')
			   AND ISNULL(@EMOTION, '') = ISNULL(EMOTION, '')
			   AND ISNULL(@TEXT, '')= ISNULL(TEXT, '')
			   AND ISNULL(@COMMAND, 0) = ISNULL(COMMAND, '')
			   AND ISNULL(@COMMAND_PARAM, '') = ISNULL(COMMAND_PARAM, '')
			   AND ISNULL(@THIRD_PARTY_API_ID, 0)= ISNULL(THIRD_PARTY_API_ID, '') 
			   AND ISNULL(@THIRD_PARTY_API_PARAMS_VALUE_ID, 0)= ISNULL(THIRD_PARTY_API_PARAMS_VALUE_ID, 0)
			   AND ISNULL(@INC_PROP, '') = ISNULL(INC_PROP, '')
			   AND ISNULL(@CAT, '')= ISNULL(CAT, '')
			   AND ISNULL(@DESCRIPTION, '') = ISNULL(DESCRIPTION, '')

	END

	PRINT 'tag：' + @INC_PROP
    PRINT @ORIGNAL_RULE_ID
    PRINT @VOICE_ID

	IF @ORIGNAL_RULE_ID IS NULL OR @VOICE_ID IS NULL
	BEGIN
		-- 新增的默认打上企业TAG
		IF @VOICE_ID IS NULL
		BEGIN
			INSERT INTO [ENT_VOICE]
					   (
						[NAME]
					   ,[PATH]
					   ,[EMOTION]
					   ,[TEXT]
					   ,[COMMAND]
					   ,[COMMAND_PARAM]
					   ,[THIRD_PARTY_API_ID]
					   ,[THIRD_PARTY_API_PARAMS_VALUE_ID]
					   ,[INC_PROP]
					   ,[CAT]
					   ,[DESCRIPTION])
				 VALUES
					   (
						@NAME
					   ,@PATH
					   ,@EMOTION
					   ,@TEXT
					   ,@COMMAND
					   ,@COMMAND_PARAM
					   ,@THIRD_PARTY_API_ID
					   ,@THIRD_PARTY_API_PARAMS_VALUE_ID
					   ,@INC_PROP
					   ,@CAT
					   ,@DESCRIPTION)
			SELECT @VOICE_ID = MAX(ID) FROM [ENT_VOICE] -- WHERE [NAME] = @NAME
		END

		-- 查找是否有对应的规则，不再自动找规则，找规则这步只在语义扩展上做
		-- 插入original
		IF @ORIGNAL_RULE_ID IS NULL
		BEGIN
			INSERT INTO  [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]
					   (
						[REQUEST]
					   ,[VOICE_ID]
					   ,[CREATE_USER_ID]
					   ,[UPDATE_USER_ID]
					   ,[CREATE_DATETIME]
					   ,[UPDATE_DATETIME]
					   ,[GEN_WORD_GROUP_FLOW_ID]
					   ,[GEN_DATETIME])
				 VALUES
					   (@REQUEST
					   ,@VOICE_ID
					   ,@USER_ID
					   ,@USER_ID
					   ,GETDATE()
					   ,GETDATE()
					   ,NULL
					   ,CASE WHEN @GEN_WORD_GROUP_FLOW_ID IS NULL THEN NULL ELSE GETDATE() END)		
			SET @ORIGNAL_RULE_ID = SCOPE_IDENTITY() 
		END
		ELSE

			UPDATE [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]
			SET    [VOICE_ID] = @VOICE_ID
				  ,[REQUEST] = @REQUEST
				  ,[UPDATE_USER_ID] = @USER_ID
				  ,[UPDATE_DATETIME] = GETDATE()
			WHERE ID = @ORIGNAL_RULE_ID			
		 
	END
	ELSE
	BEGIN
		PRINT 'UPDATE VOICE tag：' + @INC_PROP
		-- 更新 voice，应答
		UPDATE  [ENT_VOICE]
		   SET  
			   [NAME] = @NAME
			  ,[PATH] = @PATH
			  ,[EMOTION] = @EMOTION
			  ,[TEXT] = @TEXT
			  ,[COMMAND] = @COMMAND
			  ,[COMMAND_PARAM] = @COMMAND_PARAM
			  ,[THIRD_PARTY_API_ID] =   @THIRD_PARTY_API_ID  
			  ,[THIRD_PARTY_API_PARAMS_VALUE_ID] = @THIRD_PARTY_API_PARAMS_VALUE_ID
			  ,[INC_PROP] = @INC_PROP
		 WHERE ID = @VOICE_ID

		
		 -- 更新 REQUEST，请求
		UPDATE [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL]
		SET    [REQUEST] = @REQUEST
			  ,[UPDATE_USER_ID] = @USER_ID
			  ,[UPDATE_DATETIME] = GETDATE()
		WHERE ID = @ORIGNAL_RULE_ID
		-- 不做语义扩展
	END	

	IF @QUERY = 1
		SELECT VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.*		    
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL 
		WHERE ORIGNAL_RULE_ID = @ORIGNAL_RULE_ID AND VOICE_ID = @VOICE_ID

END
















GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOM_DELETE_ORDER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSTOM_DELETE_ORDER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSTOM_DELETE_ORDER] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-31
-- Description:	生态园的客户预约系统
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSTOM_DELETE_ORDER]
	 @ROOM_ID BIGINT
	,@ORDER_DATE NVARCHAR(50)
	,@NIGHT BIT
AS
BEGIN
	SET NOCOUNT ON;
		DELETE TBL_ORDER_ROOM 
		WHERE  [ORDER_DATE] = @ORDER_DATE AND NIGHT = @NIGHT AND [ROOM_ID] = @ROOM_ID
  
END




GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOM_FIND_HUAQIN_2016_PROVIDER_CONFRENCE_INFO]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSTOM_FIND_HUAQIN_2016_PROVIDER_CONFRENCE_INFO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSTOM_FIND_HUAQIN_2016_PROVIDER_CONFRENCE_INFO] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-29
-- Description:	查找供应商大会的座次
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSTOM_FIND_HUAQIN_2016_PROVIDER_CONFRENCE_INFO]
	   @kw	 nvarchar(50)
	 , @VOICE_CAT NVARCHAR(50) OUTPUT
	 , @VOICE_COMMAND BIGINT OUTPUT
	 , @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT
	 , @VOICE_TEXT NVARCHAR(1024) OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @NAME NVARCHAR(50)
	DECLARE @COMPANY_NAME NVARCHAR(50)
	DECLARE @COMPANY_FULL_NAME NVARCHAR(300)
	DECLARE @METTING_ROW_NUM BIGINT
	DECLARE @METTING_COL_NUM BIGINT
	DECLARE @DINNER_NO BIGINT

	DECLARE @CNAME_PINYIN NVARCHAR(4000)
	DECLARE @UNAME_PINYIN NVARCHAR(4000)

	DECLARE @KW_PINYIN NVARCHAR(400)
	DECLARE @ITEM NVARCHAR(MAX)

	SET @KW_PINYIN = dbo.FUNC_PINYIN_CONVERT( DBO.FUNC_GET_PINYIN(@kw))
	PRINT @KW_PINYIN

	IF EXISTS
	(
		SELECT 
			 [NAME]
			,[COMPANY_NAME]
			,[COMPANY_FULL_NAME]
			,[METTING_ROW_NUM]
			,[METTING_COL_NUM]
			,[DINNER_NO]
		FROM [VIEW_HUAQIN_2016_PROIVDER_CONFRENCE]
		WHERE 
		UNAME_PINYIN = @KW_PINYIN
	) -- 姓名优先

		DECLARE CUR_1
		CURSOR FOR 	 
		SELECT 
			 [NAME]
			,[COMPANY_NAME]
			,[COMPANY_FULL_NAME]
			,[METTING_ROW_NUM]
			,[METTING_COL_NUM]
			,[DINNER_NO]
		FROM [VIEW_HUAQIN_2016_PROIVDER_CONFRENCE]
		WHERE 
		UNAME_PINYIN = @KW_PINYIN
	ELSE 
	DECLARE CUR_1
	CURSOR FOR 	 
		SELECT 
			 [NAME]
			,[COMPANY_NAME]
			,[COMPANY_FULL_NAME]
			,[METTING_ROW_NUM]
			,[METTING_COL_NUM]
			,[DINNER_NO]
		FROM [VIEW_HUAQIN_2016_PROIVDER_CONFRENCE]
		WHERE 
			   COMPANY_NAME = @KW_PINYIN  -- 公司名
			OR CNAME_PINYIN like ('%' + @KW_PINYIN   + '%') -- 公司中文名
			OR @KW_PINYIN   like ('%' + CNAME_PINYIN + '%') -- 公司中文名
		 
	OPEN CUR_1

	FETCH NEXT FROM CUR_1 INTO 
	  @NAME 
	, @COMPANY_NAME
	, @COMPANY_FULL_NAME 
	, @METTING_ROW_NUM 
	, @METTING_COL_NUM
	, @DINNER_NO

	IF @@FETCH_STATUS = 0
	BEGIN
		SET @ITEM = ''
	END

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @ITEM = @ITEM + @NAME + '的' +
		(
			CASE @METTING_ROW_NUM 
				WHEN 0 THEN '' 
				ELSE  
				(
					'会议座位在第' + CAST(@METTING_ROW_NUM as nvarchar(20)) + '排、第' +  CAST(@METTING_COL_NUM as nvarchar(20)) + '列，'
				) 
			END
		) 
		+
		(		 
			CASE @DINNER_NO 
			WHEN 0 THEN '' 
			WHEN 1 THEN '晚餐座位在主桌' ELSE '晚餐在' + (CAST(@DINNER_NO as nvarchar(20)) + '号桌') 
			END
		)
		+ '。'

		FETCH NEXT FROM CUR_1 INTO 
		  @NAME 
		, @COMPANY_NAME
		, @COMPANY_FULL_NAME 
		, @METTING_ROW_NUM 
		, @METTING_COL_NUM
		, @DINNER_NO

	END

	CLOSE CUR_1
	DEALLOCATE CUR_1		

	IF @ITEM IS NOT NULL
	BEGIN
		-- 能找到，语义成功
		SET @VOICE_CAT =  '3'
		SET @VOICE_TEXT = @ITEM -- ISNULL(@ITEM, '没有找到' + @kw + '的会议和餐桌座位')		
	END

END

GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOM_FIND_ORDER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSTOM_FIND_ORDER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSTOM_FIND_ORDER] AS' 
END
GO





-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-31
-- Description:	找到指定人的预约
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSTOM_FIND_ORDER]
	   @keyword NVARCHAR(50)
	 , @VOICE_COMMAND BIGINT OUTPUT
	 , @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT
	 , @VOICE_TEXT NVARCHAR(1024) OUTPUT 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ROOM_NAME NVARCHAR(50)
	DECLARE @ORDER_NAME NVARCHAR(50)
	DECLARE @ORDER_COUNT BIGINT
	DECLARE @NAME_COUNT  BIGINT

	SET @ROOM_NAME = NULL	

	DECLARE @NOW_HOUR AS BIGINT
	SET @NOW_HOUR = DATEPART(HOUR, GETDATE())

	SET @VOICE_TEXT = ''
	--SELECT @ORDER_COUNT = COUNT ([ROOM_NAME])
	--FROM  [VIEW_ORDER_ROOM]
	--WHERE    (  [ORDER_NAME] = @keyword 
	--	    OR [MOBILE_PHONE] = @keyword
	--		OR DBO.FUNC_GET_PINYIN([ORDER_NAME]) like '%' +  DBO.FUNC_GET_PINYIN(@keyword) + '%'
	--		OR DBO.FUNC_GET_PINYIN(@keyword) like '%' +  DBO.FUNC_GET_PINYIN([ORDER_NAME]) + '%')
	--		AND DATEDIFF(DAY, GETDATE(), CAST(ORDER_DATE AS DATETIME)) = 0 -- 今天
	--		AND 
	--		(
	--			   ((@NOW_HOUR BETWEEN 9 AND 13) AND NIGHT = 0)	   -- 指定时间段
	--			OR ((@NOW_HOUR BETWEEN 15 AND 19) AND NIGHT = 1)   -- 指定时间段
	--		)

	SELECT @NAME_COUNT = COUNT (DISTINCT [MOBILE_PHONE])
	FROM  [VIEW_ORDER_ROOM]
	WHERE    (  [ORDER_NAME] = @keyword 
		    OR [MOBILE_PHONE] = @keyword
			OR DBO.FUNC_GET_PINYIN([ORDER_NAME]) like '%' +  DBO.FUNC_GET_PINYIN(@keyword) + '%'
			OR DBO.FUNC_GET_PINYIN(@keyword) like '%' +  DBO.FUNC_GET_PINYIN([ORDER_NAME]) + '%')
			AND DATEDIFF(DAY, GETDATE(), CAST(ORDER_DATE AS DATETIME)) = 0 -- 今天
			AND 
			(
				   ((@NOW_HOUR BETWEEN 9 AND 13) AND NIGHT = 0)	   -- 指定时间段
				OR ((@NOW_HOUR BETWEEN 15 AND 19) AND NIGHT = 1)   -- 指定时间段
			)

	IF @NAME_COUNT = 1
	BEGIN
		DECLARE C CURSOR  FOR
		SELECT   
			 --	@ROOM_NAME = 
				-- [ROOM_NAME]
			  --  @VOICE_COMMAND = 
			   1003 -- 巡游命令
			  -- , @VOICE_COMMAND_PARAM = 
			  , [ROOM_POSITION] -- 巡游位置
			  -- , @VOICE_TEXT = 
			  , [ORDER_NAME] -- + '您好，$nick_name$找到了您的预定，今天' 
			  , '今天' + PERIOD + '的' + ROOM_NAME  + '包间' -- 请随$nick_name$来，我这就带您过去。'

		FROM  [VIEW_ORDER_ROOM]
		WHERE    (  [ORDER_NAME] = @keyword 
				OR [MOBILE_PHONE] = @keyword
				OR DBO.FUNC_GET_PINYIN([ORDER_NAME]) like '%' +  DBO.FUNC_GET_PINYIN(@keyword) + '%'
				OR DBO.FUNC_GET_PINYIN(@keyword) like '%' +  DBO.FUNC_GET_PINYIN([ORDER_NAME]) + '%')
				AND DATEDIFF(DAY, GETDATE(), CAST(ORDER_DATE AS DATETIME)) = 0
				AND 
				(
				   ((@NOW_HOUR BETWEEN 9 AND 12) AND NIGHT = 0)  -- 指定时间段
				OR ((@NOW_HOUR BETWEEN 15 AND 18) AND NIGHT = 1) -- 指定时间段
				)
				ORDER BY [ORDER_DATE] ASC

		OPEN C
		
		FETCH NEXT FROM C INTO  @VOICE_COMMAND , @VOICE_COMMAND_PARAM, @ORDER_NAME, @ROOM_NAME
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			 SET @VOICE_TEXT = @VOICE_TEXT +   @ROOM_NAME + ','
			 FETCH NEXT FROM C INTO @VOICE_COMMAND , @VOICE_COMMAND_PARAM, @ORDER_NAME, @ROOM_NAME
		END
		CLOSE C
		DEALLOCATE C		

		SET @VOICE_TEXT = @ORDER_NAME  + '您好，$nick_name$找到了您的预定，' + @VOICE_TEXT + ' 请随$nick_name$来，我这就带您过去。'

	END
	ELSE 
	BEGIN
		IF @NAME_COUNT > 1
		BEGIN
			SET @ROOM_NAME = '多个'
			SET @VOICE_TEXT = '找到多个' + @keyword + '的预约，请您告诉$nick_name$手机号码吧'		
		END
		ELSE
			SET @VOICE_TEXT = '对不起，没有找到' + @keyword + '的预约, 请检查你的手机号和预约名字是否正确，另外$nick_name$只会处理距离预约时间前三小时的预约哦'
	END	


END






GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOM_GET_AVALIABLE_ROOM_LIST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSTOM_GET_AVALIABLE_ROOM_LIST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSTOM_GET_AVALIABLE_ROOM_LIST] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-31
-- Description:	获取指定天日期可用的房间
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSTOM_GET_AVALIABLE_ROOM_LIST]
	@ORDER_DATE DATETIME
	,@NIGHT BIT
AS
BEGIN
	SET NOCOUNT ON;
 

	SELECT * FROM ENT_ROOM WHERE ID NOT IN 
	(	
		SELECT [ROOM_ID] FROM  [VIEW_ORDER_ROOM] WHERE [ORDER_DATE] = @ORDER_DATE AND NIGHT = @NIGHT
	)
END



GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOM_GET_NO]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSTOM_GET_NO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSTOM_GET_NO] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-4-11
-- Description:	取号并打印
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSTOM_GET_NO]
	   @ROBOT_ID BIGINT
	 , @VOICE_COMMAND BIGINT OUTPUT
	 , @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT
	 , @VOICE_TEXT NVARCHAR(1024) OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @NO as bigint

	SET  @no = 
	cast (
	DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'no', '1') as bigint)

	

	SET @NO = @NO + 1			
		EXEC SP_SAVE_SESSION_CONTEXT 
			  @ROBOT_ID
			, 'no'
			, @NO
			, 36000
			, ''

	PRINT CAST(@NO AS NVARCHAR(20))
	SET @VOICE_COMMAND = 1009
	SET @VOICE_COMMAND_PARAM = '$print_template$'
 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOM_GET_ORDER_LIST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSTOM_GET_ORDER_LIST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSTOM_GET_ORDER_LIST] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-31
-- Description:	获取预约列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSTOM_GET_ORDER_LIST]
	@keyword NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	SET @keyword =  (case @keyword when 'null' then '' else @keyword  end )
	SET @keyword = '%' + ISNULL(@keyword, '') + '%'

	
	SELECT [ROOM_ID]
		  ,[ROOM_NAME]
		  ,[ORDER_DATE]
		  ,[ROOM_POSITION]
		  ,[PERIOD]
		  ,[ORDER_NAME]
		  ,[MOBILE_PHONE]
		  ,[SUBMIT_DATETIME]
		  ,[NIGHT]
	  FROM  [VIEW_ORDER_ROOM]
	WHERE  ([ORDER_NAME] LIKE @keyword OR  [MOBILE_PHONE] LIKE @keyword)
	AND DATEDIFF(DAY, GETDATE(), CAST(ORDER_DATE AS DATETIME)) >= 0
	ORDER BY [ORDER_DATE] ASC
END




GO
/****** Object:  StoredProcedure [dbo].[SP_CUSTOM_ORDER_ROOM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CUSTOM_ORDER_ROOM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CUSTOM_ORDER_ROOM] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-31
-- Description:	生态园的客户预约系统
-- =============================================
ALTER PROCEDURE [dbo].[SP_CUSTOM_ORDER_ROOM]
	 @ROOM_ID BIGINT
	,@ORDER_DATE NVARCHAR(50)
	,@NIGHT BIT
	,@ORDER_NAME NVARCHAR(50)
	,@MOBILE_PHONE NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;


	-- 提前一小时预约
	

	IF DATEDIFF(HOUR, GETDATE(), 
	
	(@ORDER_DATE + 
	(CASE @NIGHT WHEN 1 THEN ' 18:00:00' ELSE ' 12:00:00' END))) > 1 AND

	NOT EXISTS
	(	
		SELECT [ROOM_ID] 
		FROM   [VIEW_ORDER_ROOM] 
		WHERE  [ORDER_DATE] = @ORDER_DATE AND NIGHT = @NIGHT AND [ROOM_ID] = @ROOM_ID
	)		
		INSERT INTO [TBL_ORDER_ROOM]
			   ([ROOM_ID]
			   ,[ORDER_DATE]
			   ,[NIGHT]
			   ,[ORDER_NAME]
			   ,[MOBILE_PHONE])
		 VALUES
			   (@ROOM_ID
			   ,@ORDER_DATE
			   ,@NIGHT
			   ,@ORDER_NAME
			   ,@MOBILE_PHONE)	

		ELSE
			 RAISERROR ('预约失败！可能的原因：请确保提前一小时预约，已经被预约的房间无法被二次预约',  15,  5) 

		SELECT *
		FROM   [VIEW_ORDER_ROOM] 
		WHERE  [ORDER_DATE] = @ORDER_DATE AND NIGHT = @NIGHT AND [ROOM_ID] = @ROOM_ID
END




GO
/****** Object:  StoredProcedure [dbo].[SP_DEACTIVATE_ROBOT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DEACTIVATE_ROBOT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DEACTIVATE_ROBOT] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-14
-- Description:	机器人取消激活
-- =============================================
ALTER PROCEDURE [dbo].[SP_DEACTIVATE_ROBOT]
			  @USER_NAME   AS NVARCHAR(400)
			, @PASSWORD    AS NVARCHAR(400)
			, @DIG    AS NVARCHAR(400)
			, @ROBOT_IMEI  AS NVARCHAR(400)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- 验证身份
	DECLARE @ROBOT_ID AS BIGINT

	SET @ROBOT_ID = NULL

	SELECT @ROBOT_ID = [ROBOT_ID]
	FROM [VIEW_USER_ROBOT_BIND_LIST]
	WHERE [USER_NAME]   =  @USER_NAME  
	AND ([USER_PASSWORD] =  @PASSWORD OR @DIG =  [USER_PASSWORD])
	AND [ROBOT_IMEI]    =  @ROBOT_IMEI

	IF @ROBOT_ID IS NOT NULL
	BEGIN	 
		DELETE  TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID
		DELETE  TBL_CUSTOMIZED_CONFIG_FOR_ROBOT  WHERE ROBOT_ID = @ROBOT_ID
		DELETE FROM  [TBL_ROBOT_SESSION_CONTEXT]  WHERE ROBOT_ID = @ROBOT_ID
		DELETE  [ENT_ROBOT] WHERE ID = @ROBOT_ID


	END
	ELSE
	BEGIN
			RAISERROR (N'用户名或密码错误！',   15,  1)  
	END

end





GO
/****** Object:  StoredProcedure [dbo].[SP_DEBUG_LASTEST_DIALOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DEBUG_LASTEST_DIALOG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DEBUG_LASTEST_DIALOG] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-4-15
-- Description:	语音会话DEBUG
-- =============================================
ALTER PROCEDURE [dbo].[SP_DEBUG_LASTEST_DIALOG]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE ENT_SYSTEM_META_SETTINGS SET  VALUE = 1 WHERE NAME = 'RECORD_REQUEST_PROPERTY'

	DECLARE @ID AS NVARCHAR(120)

	SELECT @ID = ID FROM ENT_REQUEST WHERE 
	start = (SELECT MAX(START) FROM ENT_REQUEST)
	
	IF @ID IS NOT NULL
	EXEC	[SP_SMART_DIALOG]
			@REQUEST_ID = @ID,
			@DEBUG = 1

END

GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_APP_VERSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_APP_VERSION]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_APP_VERSION] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-25
-- Description:	删除版本
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_APP_VERSION]
		@ROBOT_APP_ID bigint
	   ,@VERSION_CODE bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DELETE FROM  [TBL_ROBOT_APP_VERSION]
      WHERE  @ROBOT_APP_ID = ROBOT_APP_ID AND @VERSION_CODE = VERSION_CODE
END

GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_CONFIG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_CONFIG] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-19
-- Description:	删除配置
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_CONFIG](
	-- Add the parameters for the stored procedure here
	@uid as bigint,
	@gid as bigint,
	@rid as bigint,
	@ck  as nvarchar(256)
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @gid is not null 
		  DELETE FROM  [TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]
		  WHERE  USER_GROUP_ID = @gid AND [NAME] = @ck

	IF @rid is not null 
		  DELETE FROM  [TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]
			WHERE [NAME] = @ck AND   robot_id = @rid

	IF @GID is null and @RID is null
		  DELETE FROM  ENT_CONFIG
			WHERE [NAME] = @ck 


   
END




GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_CUSROMER_ENROLL_INFO]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_CUSROMER_ENROLL_INFO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_CUSROMER_ENROLL_INFO] AS' 
END
GO


-- =============================================
-- Author:		洪江力
-- Create date: 2017-04-07
-- Description:	删除顾客注册的人脸相关联信息
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_CUSROMER_ENROLL_INFO]
			@ID					NVARCHAR(400) 
		  , @CUSTOMER_GROUP_ID  NVARCHAR(400)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @ID IS NOT NULL AND @CUSTOMER_GROUP_ID IS NOT NULL
		BEGIN
			DELETE FROM ENT_CUSTOMER WHERE ID = @ID AND CUSTOMER_GROUP_ID = @CUSTOMER_GROUP_ID
		END
	--ELSE
	--	 BEGIN
	--		RAISERROR ('信息不全无法删除！',  15,  5) 
	--		RETURN
	--	 END
	
END



GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_CUSTOMIZED_CONFIG_WITH_OWNER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_CUSTOMIZED_CONFIG_WITH_OWNER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_CUSTOMIZED_CONFIG_WITH_OWNER] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-16
-- Description:	删除配置
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_CUSTOMIZED_CONFIG_WITH_OWNER](
	-- Add the parameters for the stored procedure here
	@uid as bigint,
	@owner_id as bigint,
	@priority as bigint,
	@ck  as nvarchar(256)
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @priority = 1 
		  DELETE FROM  TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY
		  WHERE  INDUSTRY_ID = @owner_id AND [NAME] = @ck

	IF @priority = 3 
		  DELETE FROM  [TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]
		  WHERE  USER_GROUP_ID = @owner_id AND [NAME] = @ck

	IF @priority = 5
		  DELETE FROM  TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE
			WHERE [NAME] = @ck AND   USER_GROUP_SCENE_ID = @owner_id

	IF @priority = 7  
		  DELETE FROM  [TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]
			WHERE [NAME] = @ck AND   robot_id = @owner_id


   
END



GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_MANUAL_MODE_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_MANUAL_MODE_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_MANUAL_MODE_VOICE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-27
-- Description:	删除人工模式的应答
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_MANUAL_MODE_VOICE]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ID AS BIGINT

	DECLARE  CUR_DELETE_MANUAL_MODE_VOICE CURSOR FOR SELECT ID FROM ENT_VOICE WHERE CAT = '5'

	OPEN CUR_DELETE_MANUAL_MODE_VOICE 

	FETCH NEXT FROM CUR_DELETE_MANUAL_MODE_VOICE INTO  @ID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC SP_DELETE_VOICE @ID
		FETCH NEXT FROM CUR_DELETE_MANUAL_MODE_VOICE INTO  @ID
	END

	CLOSE CUR_DELETE_MANUAL_MODE_VOICE
	DEALLOCATE CUR_DELETE_MANUAL_MODE_VOICE		

END

GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_RULE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_RULE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_RULE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	删除单词
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_RULE]
		@ID AS BIGINT
AS
BEGIN
	DELETE TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE WHERE ID = @ID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_RULE_ORIGNAL]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_RULE_ORIGNAL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_RULE_ORIGNAL] AS' 
END
GO







-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	删除原始句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_RULE_ORIGNAL]
		@ID AS BIGINT
		,@VOICE_ID AS BIGINT
AS
BEGIN

	DECLARE @RESPONSE_VOICE_GROUP_ID BIGINT
	DECLARE @GEN_WORD_GROUP_FLOW_ID BIGINT

	PRINT @ID
	PRINT @VOICE_ID

	SELECT    @RESPONSE_VOICE_GROUP_ID = RESPONSE_VOICE_GROUP_ID
			, @GEN_WORD_GROUP_FLOW_ID = GEN_WORD_GROUP_FLOW_ID
	FROM    TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL 
	WHERE   ID = @ID

	PRINT '原始rule， flowid ，voice id'
	PRINT @GEN_WORD_GROUP_FLOW_ID
	PRINT @RESPONSE_VOICE_GROUP_ID

	IF @GEN_WORD_GROUP_FLOW_ID IS NOT NULL AND
		@RESPONSE_VOICE_GROUP_ID IS NOT NULL
	BEGIN
		PRINT 'DELETE RULE, 删除已经扩展的语义'
		-- DELETE FROM [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]
		-- WHERE   
		--	VOICE_GROUP_ID =      @RESPONSE_VOICE_GROUP_ID
		-- AND	WORD_GROUP_FLOW_ID =  @GEN_WORD_GROUP_FLOW_ID
	END


	PRINT '解除挂靠'
	PRINT @RESPONSE_VOICE_GROUP_ID
	PRINT @VOICE_ID

	-- 解除挂靠
	EXEC SP_SET_VOICE_TO_GROUP @RESPONSE_VOICE_GROUP_ID, @VOICE_ID, 0

	-- 
	-- 删除 voice
	PRINT '删除 voice'
	PRINT @VOICE_ID

	EXEC SP_DELETE_VOICE @VOICE_ID

	PRINT '删除 原始rule '
	PRINT @ID
	DELETE TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL WHERE ID = @ID
END








GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_RULE_ORIGNAL_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_RULE_ORIGNAL_V2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_RULE_ORIGNAL_V2] AS' 
END
GO








-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	删除原始句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_RULE_ORIGNAL_V2]
		@ID AS BIGINT
		,@VOICE_ID AS BIGINT
AS
BEGIN
	-- PRINT '只能删除未扩展的'
	DELETE TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL WHERE ID = @ID -- AND GEN_DATETIME IS NULL
	-- DELETE TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL WHERE ID = @ID -- AND GEN_DATETIME IS NULL
	EXEC SP_DELETE_VOICE @VOICE_ID
END









GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_SESSION_CONTEXT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_SESSION_CONTEXT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_SESSION_CONTEXT] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-30
-- Description:	删除上下文信息
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_SESSION_CONTEXT]
			@ROBOT_ID  bigint
           ,@CTX_NAME  nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DELETE FROM [TBL_ROBOT_SESSION_CONTEXT]
    WHERE  @ROBOT_ID  =  ROBOT_ID AND @CTX_NAME = CTX_NAME
END



GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_SESSION_CONTEXT_LOOKUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_SESSION_CONTEXT_LOOKUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_SESSION_CONTEXT_LOOKUP] AS' 
END
GO





-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-26
-- Description:	删除 LOOKUP
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_SESSION_CONTEXT_LOOKUP]
			@ROBOT_ID  bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC SP_DELETE_SESSION_CONTEXT @ROBOT_ID, 'LOOKUP'
END






GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_THIRD_PARTY_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_THIRD_PARTY_API] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-6
-- Description:	删除第三方API
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_THIRD_PARTY_API]
		@ID AS BIGINT
AS
BEGIN
	-- DELETE TBL_VOICE_TAG WHERE VOICE_ID = @ID
	DELETE TBL_THIRD_PARTY_API_PARAM WHERE THIRD_PARTY_API_ID = @ID

	DELETE ENT_THIRD_PARTY_API WHERE ID = @ID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_THIRD_PARTY_API_PARAM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-6
-- Description:	删除第三方API params
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM]
		@ID AS BIGINT
AS
BEGIN
	-- DELETE TBL_VOICE_TAG WHERE VOICE_ID = @ID
	DELETE ENT_THIRD_PARTY_API_PARAM WHERE ID = @ID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_THIRD_PARTY_API_PARAM_VALUE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM_VALUE] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-12
-- Description:	删除第三方API值
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM_VALUE]
		@ID AS BIGINT
AS
BEGIN
	-- DELETE TBL_VOICE_TAG WHERE VOICE_ID = @ID
	DELETE TBL_THIRD_PARTY_API_PARAM_VALUE WHERE THIRD_PARTY_API_PARAM_VALUE_ID = @ID

	DELETE ENT_THIRD_PARTY_API_PARAM_VALUE WHERE ID = @ID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM_VALUE_ITEM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_THIRD_PARTY_API_PARAM_VALUE_ITEM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM_VALUE_ITEM] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-6
-- Description:	删除第三方API params 参数值
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_THIRD_PARTY_API_PARAM_VALUE_ITEM]
		@ID AS BIGINT
		, @PARAM_ID AS BIGINT
AS
BEGIN
	DELETE TBL_THIRD_PARTY_API_PARAM_VALUE WHERE THIRD_PARTY_API_PARAM_VALUE_ID = @ID
	AND THIRD_PARTY_API_PARAM_ID = @PARAM_ID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_USER_GROUP_SCENE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_USER_GROUP_SCENE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_USER_GROUP_SCENE] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-16
-- Description:	删除用户场景
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_USER_GROUP_SCENE]
		@SCENE_ID AS BIGINT
AS
BEGIN
	DELETE TBL_USER_GROUP_SCENE WHERE ID = @SCENE_ID
END



GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_VOICE] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	删除单词
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_VOICE]
		@ID AS BIGINT
AS
BEGIN
	DELETE TBL_VOICE_TAG WHERE VOICE_ID = @ID
	DELETE ENT_VOICE WHERE ID = @ID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_VOICE_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_VOICE_GROUP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	删除应答组
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_VOICE_GROUP]
		@ID AS BIGINT
AS
BEGIN

	-- 先删除GROUP 下的关系
	DELETE TBL_VOICE_GROUP WHERE ID = @ID

	DELETE ENT_VOICE_GROUP WHERE ID = @ID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_WORD]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_WORD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_WORD] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	删除单词
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_WORD]
		@WORD_ID AS BIGINT
AS
BEGIN
	DELETE ENT_KEY_WORDS WHERE ID = @WORD_ID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_WORD_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_WORD_GROUP] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	删除词组
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_WORD_GROUP]
		@ID AS BIGINT
AS
BEGIN

	-- 先删除词组的词关系

	DELETE TBL_WORD_GROUP WHERE GROUP_ID = @ID

	DELETE ENT_WORD_GROUP WHERE ID = @ID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_WORD_GROUP_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_DELETE_WORD_GROUP_FLOW] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	删除句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_DELETE_WORD_GROUP_FLOW]
		@ID AS BIGINT
AS
BEGIN
	-- 先删除句法下所有关联的词组关系
	DELETE TBL_WORD_GROUP_FLOW WHERE ID = @ID

	-- 再删除此句法
	DELETE ENT_WORD_GROUP_FLOW WHERE ID = @ID
END


GO
/****** Object:  StoredProcedure [dbo].[SP_GEN_REQUEST_PROPERTY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GEN_REQUEST_PROPERTY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GEN_REQUEST_PROPERTY] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROC [dbo].[SP_GEN_REQUEST_PROPERTY]
	@REQUEST_ID AS NVARCHAR(256)
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @PROPERTY_NAME AS NVARCHAR(200)
	DECLARE @PROPERTY_VALUE AS NVARCHAR(4000)
	DECLARE @SQL AS NVARCHAR(4000)
	
	DECLARE C
	CURSOR FOR
	SELECT NAME FROM SYSCOLUMNS WHERE ID=OBJECT_ID('ENT_REQUEST') AND NAME NOT IN('ID','DATETIME')  

	OPEN C
	FETCH NEXT FROM c INTO @PROPERTY_NAME
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL =  'SELECT @PROPERTY_VALUE = [' + @PROPERTY_NAME + '] FROM  ENT_REQUEST WHERE	ID =   @REQUEST_ID '

		EXEC SP_EXECUTESQL 
			   @SQL
			, N'@REQUEST_ID NVARCHAR(120), @PROPERTY_VALUE NVARCHAR(4000) OUTPUT'
			, @REQUEST_ID, @PROPERTY_VALUE OUTPUT 
		
		IF @PROPERTY_VALUE IS NOT NULL
			INSERT INTO [TBL_REQUEST_PROPERTY]
					   ([REQUEST_ID]
					   ,[PROPERTY_NAME]
					   ,[PROPERTY_VALUE]
					   ,[IS_NUMERIC])
				 VALUES
				 (
						@REQUEST_ID 
					   ,@PROPERTY_NAME
					   ,@PROPERTY_VALUE
					   ,ISNUMERIC(@PROPERTY_VALUE)
				 )

		FETCH NEXT FROM C INTO @PROPERTY_NAME
	END
	CLOSE C
	DEALLOCATE C

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GEN_VOICE_BY_MANUAL]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GEN_VOICE_BY_MANUAL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GEN_VOICE_BY_MANUAL] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-23
-- Description:	人工模式生成一个 voice
-- =============================================
ALTER PROCEDURE [dbo].[SP_GEN_VOICE_BY_MANUAL]
@PATH NVARCHAR(1024)
,@TEXT NVARCHAR(4000)
,@EMOTION NVARCHAR(1024)
,@COMMAND BIGINT
,@COMMAND_PARAM NVARCHAR(MAX)
,@THIRD_PARTY_API_ID BIGINT
,@THIRD_PARTY_API_PARAMS_VALUE_ID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT      0 AS ID
		  , 0 AS VOICE_GROUP_ID
		  , '人工模式'AS VOICE_NAME
		  , @PATH AS VOICE_PATH
		  , @TEXT AS VOICE_TEXT
		  , '5' AS VOICE_CAT
		  , '人工模式' AS VOICE_DESCRIPTION
          , @COMMAND as VOICE_COMMAND
		  , @COMMAND_PARAM AS VOICE_COMMAND_PARAM
		  , VIEW_VALID_THIRD_PARTY_API.NAME AS VOICE_THIRD_PARTY_API_NAME
          , VIEW_VALID_THIRD_PARTY_API.METHOD AS VOICE_THIRD_PARTY_API_METHOD
, DBO.FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2(@THIRD_PARTY_API_ID, 0, @THIRD_PARTY_API_PARAMS_VALUE_ID) AS VOICE_THIRD_PARTY_API_HEADER_PARAMS
, VIEW_VALID_THIRD_PARTY_API.URL + N'?' + DBO.FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2(@THIRD_PARTY_API_ID, 1, @THIRD_PARTY_API_PARAMS_VALUE_ID) AS VOICE_THIRD_PARTY_API_URL
, VIEW_VALID_THIRD_PARTY_API.RESULT_TYPE AS VOICE_THIRD_PARTY_API_RESULT_TYPE
, VIEW_VALID_THIRD_PARTY_API.RUN_AT_SERVER AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER
, '' as VOICE_INC_PROP
, '' as VOICE_EXC_PROP
, @EMOTION AS VOICE_EMOTION
, 1 AS VOICE_ENABLED
FROM VIEW_VALID_THIRD_PARTY_API 
WHERE dbo.VIEW_VALID_THIRD_PARTY_API.ID = @THIRD_PARTY_API_ID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GEN_VOICE_TAG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GEN_VOICE_TAG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GEN_VOICE_TAG] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-11
-- Description:	生成VOICE TAG
-- =============================================
ALTER PROCEDURE [dbo].[SP_GEN_VOICE_TAG]
	   @VOICE_ID AS BIGINT
	 , @TAGS AS NVARCHAR(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE [TBL_VOICE_TAG] WHERE VOICE_ID = @VOICE_ID

	INSERT INTO [TBL_VOICE_TAG] 
	SELECT @VOICE_ID AS VOICE_ID, TAG FROM  [dbo].[FUNC_GET_TAGS_TABLE](@TAGS)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ACTIVIATED_INFO]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ACTIVIATED_INFO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ACTIVIATED_INFO] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-09
-- Description:	查找激活的公司名和机器名
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ACTIVIATED_INFO]
		  @ROBOT_IMEI  AS NVARCHAR(400)
AS
BEGIN
		--SELECT [ROBOT_ID]
  --    ,[ROBOT_NAME]
  --    ,[ROBOT_IMEI]
  --    ,[ROBOT_ACTIVATE_DATETIME]
	 -- ,[ROBOT_MANUAL_MODE]
  --    ,ISNULL([ROBOT_LATEST_STATUS_UPDATE_DATETIME], '') AS ROBOT_LATEST_STATUS_UPDATE_DATETIME
  --    ,ISNULL([ROBOT_LATEST_STATUS_WSS_SESSION_ID], '') AS ROBOT_LATEST_STATUS_WSS_SESSION_ID
  --    ,ISNULL([ROBOT_LATEST_STATUS_ONLINE], '') AS ROBOT_LATEST_STATUS_ONLINE
  --    ,ISNULL([ROBOT_LATEST_STATUS_EXTRA_INFO], '') AS ROBOT_LATEST_STATUS_EXTRA_INFO
  --    ,[USER_ID]
  --    ,[IS_ACTIVATE_USER]
  --    ,[USER_NAME]
  --    ,[USER_PASSWORD]
  --    ,[USER_GROUP_ID]
  --    ,[USER_GROUP_NAME]
  --    ,ISNULL([USER_LASTEST_STATUS_UPDATE_DATETIME], '') AS USER_LASTEST_STATUS_UPDATE_DATETIME
  --    ,ISNULL([USER_LASTEST_STATUS_WSS_SESSION_ID], '') AS USER_LASTEST_STATUS_WSS_SESSION_ID
  --    ,[UPDATE_DATETIME]
  --    ,ISNULL([USER_LASTEST_STATUS_ONLINE], '')  AS USER_LASTEST_STATUS_ONLINE
  --    ,ISNULL([USER_LASTEST_STATUS_EXTRA_INFO], '')  AS USER_LASTEST_STATUS_EXTRA_INFO
  --    ,[USER_EMAIL]
  SELECT *   
  FROM [G2Robot].[dbo].[VIEW_USER_ROBOT_BIND_LIST]
	WHERE ROBOT_IMEI = @ROBOT_IMEI
END




GO
/****** Object:  StoredProcedure [dbo].[SP_GET_BIND_LIST_BY_SESSION_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_BIND_LIST_BY_SESSION_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_BIND_LIST_BY_SESSION_ID] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-4-6
-- Description:	根据 Session id 获取绑定终端列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_BIND_LIST_BY_SESSION_ID]
	@SESSION_ID AS NVARCHAR(400)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	 SELECT *
    FROM  [VIEW_ENDPOINT_LATEST_STATUS]
	WHERE  [END_POINT_ID] IN 
    (
		SELECT USER_ID
		FROM [VIEW_USER_ROBOT_BIND_LIST]
		WHERE [ROBOT_LATEST_STATUS_WSS_SESSION_ID] = @SESSION_ID
		-- and VIEW_USER_ROBOT_BIND_LIST.ROBOT_LATEST_STATUS_ONLINE = 1
	)
	UNION
	 SELECT *
    FROM  [VIEW_ENDPOINT_LATEST_STATUS]
	WHERE  [END_POINT_ID] IN 
    (
		SELECT  [ROBOT_ID]
		FROM [VIEW_USER_ROBOT_BIND_LIST]
		WHERE USER_LASTEST_STATUS_WSS_SESSION_ID = @SESSION_ID
		-- and VIEW_USER_ROBOT_BIND_LIST.USER_LASTEST_STATUS_ONLINE = 1
	)
END



GO
/****** Object:  StoredProcedure [dbo].[SP_GET_BIZ_MENUTREE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_BIZ_MENUTREE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_BIZ_MENUTREE] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-6-24
-- Description:	根据业务入口名查找菜单树
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_BIZ_MENUTREE]
		@ENTRY_NAME  AS NVARCHAR(200)
AS
BEGIN
	
SELECT [MENU_ENTRY_NAME]
      ,[MENU_ID]
      ,[MENU_LABEL]
      ,[MENU_EXTRA]
      ,[PARENT_MENU_ID]
      ,[MENU_SEQ]
      ,[ACTION]
      ,[ACTION_URI]
      ,[ACTION_TYPE]
      ,[ACTION_PACKAGE_NAME]
      ,[ACTION_CLASS_NAME]
      ,[ACTION_EXTRA]
  FROM [VIEW_BIZ_MENUTREE]
  WHERE 
	[MENU_ENTRY_NAME] = @ENTRY_NAME

END



GO
/****** Object:  StoredProcedure [dbo].[SP_GET_CHAT_TIMELINE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_CHAT_TIMELINE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_CHAT_TIMELINE] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-03
-- Description:	聊天 timeline
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_CHAT_TIMELINE]
	  @GROUP_ID BIGINT  -- 公司ID
	, @SN  NVARCHAR(50) -- 机器人SN号
	, @time NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(4000)

	DECLARE @SN_LIST NVARCHAR(MAX)

	IF @SN IS NOT NULL
		SET @SN_LIST = '(''' + @SN + ''')'
	IF @GROUP_ID IS NOT NULL
		SET @SN_LIST =  DBO.FUNC_GET_ROBOT_SN_LIST(@GROUP_ID)
 
  

SET @SQL = 
'SELECT  *
   FROM [VIEW_TODAY_CHAT_TIMELINE]
   WHERE DATE_TIME > ''' + @time + '''' + 
 ' AND REQUEST_EP_SN IN ' + @SN_LIST + 
 ' ORDER BY DATE_TIME ASC'

	EXEC SP_EXECUTESQL @SQL
	
	PRINT @SQL
END



GO
/****** Object:  StoredProcedure [dbo].[SP_GET_CLASSIC_NLP_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_CLASSIC_NLP_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_CLASSIC_NLP_API] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-4-19
-- Description:	获取机器的典型第三方语义接口描述
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_CLASSIC_NLP_API]
	  @IMEI AS NVARCHAR(20)
	, @REQEUST_ID nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ID AS BIGINT
	DECLARE @P_ID AS BIGINT
	DECLARE @RET AS NVARCHAR(4000)
	DECLARE @REC AS NVARCHAR(4000)

	SELECT @ID   = DBO.FUNC_GET_CONFIG_VALUE(@IMEI, 'classic_third_party_nlp_api_id', 0)
	SELECT @P_ID = DBO.FUNC_GET_CONFIG_VALUE(@IMEI, 'classic_third_party_nlp_api_params_id', 0)
	SELECT @RET  = DBO.FUNC_GET_CONFIG_VALUE(@IMEI, 'classic_third_party_nlp_api_res', '')
	SELECT @REC  = DBO.FUNC_GET_CONFIG_VALUE(@IMEI, 'classic_third_party_nlp_api_recommend', '')

    -- Insert statements for procedure here
	SELECT     

	  0                  AS ID
	, 0                  AS VOICE_GROUP_ID
	, 'CLASSIC_NLP'      AS VOICE_NAME
	, ''                 AS VOICE_PATH
	, @RET               AS VOICE_TEXT
	, '3'                AS VOICE_CAT
	, API.DESCRIPTION    AS VOICE_DESCRIPTION 
	, 0                  AS VOICE_COMMAND
	, @REC               AS VOICE_COMMAND_PARAM
	, API.NAME           AS VOICE_THIRD_PARTY_API_NAME 
	, API.METHOD         AS VOICE_THIRD_PARTY_API_METHOD
	, DBO.FUNC_FILLED_REQUEST_VALUE(DBO.FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2(API.ID , 0,    @P_ID) , @REQEUST_ID)
	                     AS VOICE_THIRD_PARTY_API_HEADER_PARAMS
	, DBO.FUNC_FILLED_REQUEST_VALUE( API.URL + N'?' + DBO.FUNC_GET_THIRD_PARTY_API_PARAMS_STRING_V2(API.ID, 1, @P_ID), @REQEUST_ID) 
	                     AS VOICE_THIRD_PARTY_API_URL
	, API.RESULT_TYPE    AS VOICE_THIRD_PARTY_API_RESULT_TYPE
	, API.RUN_AT_SERVER  AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER
	, ''                 AS VOICE_INC_PROP 
	, ''                 AS VOICE_EXC_PROP
	, ''                 AS VOICE_EMOTION
	, 1                  AS VOICE_ENABLED

	FROM VIEW_VALID_THIRD_PARTY_API AS API
	WHERE API.ID = @ID



END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_CONFIG_DEFINED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_CONFIG_DEFINED]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_CONFIG_DEFINED] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-22
-- Description:	配置项管理
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_CONFIG_DEFINED]
	-- Add the parameters for the stored procedure here
	@key_word AS NVARCHAR(200)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'

	SELECT * FROM VIEW_CONFIG WHERE  NAME LIKE @key_word OR  DESCRIPTION LIKE @key_word
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_CUSROMER_ENROLL_INFO]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_CUSROMER_ENROLL_INFO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_CUSROMER_ENROLL_INFO] AS' 
END
GO


-- =============================================
-- Author:		洪江力
-- Create date: 2017-03-08
-- Description:	获取顾客注册的人脸相关联信息
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_CUSROMER_ENROLL_INFO]

			@ID					NVARCHAR(400)
		  , @CUSTOMER_GROUP_ID  NVARCHAR(400)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT ID, NAME, NICK_NAME, ENGLISH_NAME, SEX, CUSTOMER_GROUP_ID FROM ENT_CUSTOMER WHERE ID = @ID AND CUSTOMER_GROUP_ID = @CUSTOMER_GROUP_ID

	
END



GO
/****** Object:  StoredProcedure [dbo].[SP_GET_CUSROMER_ENROLL_LIST_BY_CUSTOMER_GROUP_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_CUSROMER_ENROLL_LIST_BY_CUSTOMER_GROUP_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_CUSROMER_ENROLL_LIST_BY_CUSTOMER_GROUP_ID] AS' 
END
GO


-- =============================================
-- Author:		洪江力
-- Create date: 2017-04-07
-- Description:	根据用户组获取注册用户
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_CUSROMER_ENROLL_LIST_BY_CUSTOMER_GROUP_ID]

		   @CUSTOMER_GROUP_ID  NVARCHAR(400)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT ID, NAME, NICK_NAME, ENGLISH_NAME, SEX, CUSTOMER_GROUP_ID FROM ENT_CUSTOMER WHERE CUSTOMER_GROUP_ID = @CUSTOMER_GROUP_ID

	
END



GO
/****** Object:  StoredProcedure [dbo].[SP_GET_DIALOG_HISTORY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_DIALOG_HISTORY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_DIALOG_HISTORY] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-21
-- Description:	获取以往会话记录
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_DIALOG_HISTORY]
	  @GROUP_ID BIGINT  -- 公司ID
	, @SN  NVARCHAR(50) -- 机器人SN号
	, @FROM NVARCHAR(50) -- 起始日期
	, @TO NVARCHAR(50) -- 起始日期
	, @CAT NVARCHAR(50) -- 响应类别
	, @KEY_WORDS NVARCHAR(50) -- 关键字
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @KEY_WORDS = [dbo].[FUNC_KEYWORD_MODIFIER](@KEY_WORDS)

	DECLARE @SQL NVARCHAR(4000)

	DECLARE @SN_LIST NVARCHAR(MAX)

	IF ISNULL(@SN, 'null') <> 'null'
		SET @SN_LIST = '(''' + @SN + ''')'

	IF @GROUP_ID IS NOT NULL
		SET @SN_LIST =  DBO.FUNC_GET_ROBOT_SN_LIST(@GROUP_ID)
 
		SET @SQL = 
	'SELECT *
		FROM [VIEW_CHAT_HISTORY] WHERE 1 = 1'

	IF ISNULL(@CAT, 'null') <> 'null'
		SET @SQL = @SQL +  ' AND RESPONSE_1 LIKE ''%' + @CAT + ''''


	IF @SN_LIST IS NOT NULL	
		 SET @SQL = @SQL + ' AND REQUEST_EP_SN IN ' + @SN_LIST 
	
	SET @SQL = @SQL +  ' AND (REQUEST LIKE ''' + @KEY_WORDS + ''' OR [TEXT] LIKE '''  + @KEY_WORDS + ''')'
	
	SET @SQL = @SQL +  ' AND DATE_TIME BETWEEN ''' + @FROM + ''' AND ''' + isnull( @TO, getdate()) + ''''

	SET @SQL = @SQL +  ' ORDER BY DATE_TIME DESC'

	EXEC SP_EXECUTESQL @SQL
	
	PRINT @SQL	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_DIALOG_TODAY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_DIALOG_TODAY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_DIALOG_TODAY] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-21
-- Description:	获取今日会话记录
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_DIALOG_TODAY]
	  @GROUP_ID BIGINT  -- 公司ID
	, @SN  NVARCHAR(50) -- 机器人SN号
	, @CAT NVARCHAR(50) -- 响应类别
	, @KEY_WORDS NVARCHAR(50) -- 关键字
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @KEY_WORDS = [dbo].[FUNC_KEYWORD_MODIFIER](@KEY_WORDS)

	DECLARE @SQL NVARCHAR(4000)

	DECLARE @SN_LIST NVARCHAR(MAX)

	IF ISNULL(@SN, 'null') <> 'null'
		SET @SN_LIST = '(''' + @SN + ''')'

	IF @GROUP_ID IS NOT NULL
		SET @SN_LIST =  DBO.FUNC_GET_ROBOT_SN_LIST(@GROUP_ID)
 
		SET @SQL = 
	'SELECT *
		FROM [VIEW_TODAY_CHAT_TIMELINE] WHERE 1 = 1'

	IF ISNULL(@CAT, 'null') <> 'null'
		SET @SQL = @SQL +  ' AND RESPONSE_1 LIKE ''%' + @CAT + ''''

	IF @SN_LIST IS NOT NULL	
		 SET @SQL = @SQL + ' AND REQUEST_EP_SN IN ' + @SN_LIST 
		

	SET @SQL = @SQL +  ' AND (REQUEST LIKE ''' + @KEY_WORDS + ''' OR [TEXT] LIKE '''  + @KEY_WORDS + ''')'
	SET @SQL = @SQL +  ' ORDER BY DATE_TIME DESC'

	EXEC SP_EXECUTESQL @SQL
	
	PRINT @SQL	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EMAIL]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMAIL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_EMAIL] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-6-21
-- Description:	根据用户名，绑定机器获取用户EMAIL
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_EMAIL]
	@USER_NAME AS NVARCHAR(200)
	,@ROBOT_IMEI AS NVARCHAR(200)
	,@USER_EMAIL AS NVARCHAR(200) OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT TOP 1
      @USER_EMAIL = [USER_EMAIL]
  FROM [VIEW_USER_ROBOT_BIND_LIST]  
	WHERE @ROBOT_IMEI = ROBOT_IMEI AND @USER_NAME = USER_NAME
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EMPTY_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPTY_THIRD_PARTY_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_EMPTY_THIRD_PARTY_API] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-8
-- Description:	找空API，无参数API
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_EMPTY_THIRD_PARTY_API]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
-- 空应答组
SELECT '空API', * FROM ENT_THIRD_PARTY_API WHERE ENT_THIRD_PARTY_API.ID NOT IN
(
	SELECT TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_ID FROM TBL_THIRD_PARTY_API_PARAM
)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EMPTY_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPTY_THIRD_PARTY_API_PARAM_VALUE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_EMPTY_THIRD_PARTY_API_PARAM_VALUE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-22
-- Description:	找空参数组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_EMPTY_THIRD_PARTY_API_PARAM_VALUE]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
-- 空应答组
SELECT '空参数组', * FROM VIEW_THIRD_PARTY_API_PARAM_VALUE WHERE VIEW_THIRD_PARTY_API_PARAM_VALUE.ID NOT IN
(
	SELECT TBL_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_PARAM_VALUE_ID FROM TBL_THIRD_PARTY_API_PARAM_VALUE
)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EMPTY_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPTY_VOICE_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_EMPTY_VOICE_GROUP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-23
-- Description:	找空应答组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_EMPTY_VOICE_GROUP]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
-- 空应答组
SELECT '空应答组', * FROM VIEW_VOICE_GROUP_SIMPLE WHERE VIEW_VOICE_GROUP_SIMPLE.ID NOT IN
(
	SELECT TBL_VOICE_GROUP.ID FROM TBL_VOICE_GROUP
)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EMPTY_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPTY_WORD_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_EMPTY_WORD_GROUP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-23
-- Description:	找空词组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_EMPTY_WORD_GROUP]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- 空词组
SELECT '空词组', * FROM ENT_WORD_GROUP WHERE ENT_WORD_GROUP.ID NOT IN
(
	SELECT TBL_WORD_GROUP.GROUP_ID FROM TBL_WORD_GROUP
)


END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_EMPTY_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPTY_WORD_GROUP_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_EMPTY_WORD_GROUP_FLOW] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-23
-- Description:	找空句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_EMPTY_WORD_GROUP_FLOW]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 空句法
SELECT '空句法', * FROM ENT_WORD_GROUP_FLOW WHERE ENT_WORD_GROUP_FLOW.ID NOT IN
(
	SELECT TBL_WORD_GROUP_FLOW.ID FROM TBL_WORD_GROUP_FLOW
)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ENDPOINT_STATUS_BY_ENDPOINT_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ENDPOINT_STATUS_BY_ENDPOINT_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ENDPOINT_STATUS_BY_ENDPOINT_ID] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-4-4
-- Description:	获取机器人状态
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ENDPOINT_STATUS_BY_ENDPOINT_ID]
	-- Add the parameters for the stored procedure here
	@END_POINT_ID AS NVARCHAR(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 SELECT *
  FROM  [VIEW_ENDPOINT_LATEST_STATUS]
	WHERE  [END_POINT_ID] = @END_POINT_ID
	order by [VIEW_ENDPOINT_LATEST_STATUS].ONLINE desc

END




GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ENDPOINT_STATUS_BY_SESSION_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ENDPOINT_STATUS_BY_SESSION_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ENDPOINT_STATUS_BY_SESSION_ID] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-4-4
-- Description:	获取机器人状态
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ENDPOINT_STATUS_BY_SESSION_ID]
	-- Add the parameters for the stored procedure here
	@SESSION_ID AS NVARCHAR(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 SELECT  *
  FROM  [VIEW_ENDPOINT_LATEST_STATUS]
	WHERE  [WSS_SESSION_ID] = @SESSION_ID
	order by [VIEW_ENDPOINT_LATEST_STATUS].ONLINE desc

END




GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ENTITY_FOR_THIRD_PARTY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ENTITY_FOR_THIRD_PARTY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ENTITY_FOR_THIRD_PARTY] AS' 
END
GO




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-1
-- Description:	获取第三方API, ENTITY 输出
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ENTITY_FOR_THIRD_PARTY]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT 
			 ID
			,DESCRIPTION AS NAME
			,DESCRIPTION
	FROM VIEW_VALID_THIRD_PARTY_API 
	ORDER BY name
END





GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ENTITY_FOR_THIRD_PARTY_PARAMS_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ENTITY_FOR_THIRD_PARTY_PARAMS_VALUE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ENTITY_FOR_THIRD_PARTY_PARAMS_VALUE] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-1
-- Description:	获取第三方API参数列表, ENTITY 输出
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ENTITY_FOR_THIRD_PARTY_PARAMS_VALUE]
	@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT 
			ID
			,DESCRIPTION AS NAME
			,DESCRIPTION
	FROM VIEW_THIRD_PARTY_PARAMS_VALUE WHERE @ID = THIRD_PARTY_API_ID	
	ORDER BY NAME
END




GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ENTITY_FOR_VOICE_COMMAND]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ENTITY_FOR_VOICE_COMMAND]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ENTITY_FOR_VOICE_COMMAND] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-1
-- Description:	获取机器人命令列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ENTITY_FOR_VOICE_COMMAND]
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT 
			ID
			,NAME
			,DESCRIPTION
	FROM ENT_VOICE_COMMAND 
	ORDER BY name
END




GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ENTITY_ID_BY_NAME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ENTITY_ID_BY_NAME]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ENTITY_ID_BY_NAME] AS' 
END
GO




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-08
-- Description:	根据实体名字获取实体 ID
-- =============================================
ALTER PROC [dbo].[SP_GET_ENTITY_ID_BY_NAME]
(
	  @TABLE_NAME AS NVARCHAR(100)
	, @NAME AS NVARCHAR(50)
	, @ID AS BIGINT OUTPUT
)

AS
BEGIN

	DECLARE @SQL AS NVARCHAR(4000)
	SET @SQL = 'SELECT @ID = ID FROM ' + @TABLE_NAME + ' WHERE NAME = ''' + @NAME + ''''

	EXECUTE sp_executesql @SQL, N'@ID BIGINT OUTPUT', @ID OUTPUT 
END





GO
/****** Object:  StoredProcedure [dbo].[SP_GET_INDUSTRIES]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_INDUSTRIES]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_INDUSTRIES] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-28
-- Description:	获取行业列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_INDUSTRIES]
	@key_word AS NVARCHAR(200) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'

	SELECT ID AS VALUE, NAME FROM ENT_INDUSTRY WHERE NAME LIKE @key_word AND ENABLED = 1
	 ORDER BY NAME
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_KEY_WORD]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_KEY_WORD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_KEY_WORD] AS' 
END
GO





-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索单词
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_KEY_WORD](
    @kw as nvarchar(8)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @kw IS NULL
			SELECT TOP 10 [ID]
				  ,[KW]
				  ,[CAT]
				  ,[SOUND]
			  FROM  [ENT_KEY_WORDS]	
	ELSE
			SELECT [ID]
				  ,[KW]
				  ,[CAT]
				  ,[SOUND]
			  FROM  [ENT_KEY_WORDS]	
			WHERE  [KW]   LIKE '%' + @KW + '%'
					OR CAST(ID AS NVARCHAR(20)) like @kw
			ORDER BY KW 
END






GO
/****** Object:  StoredProcedure [dbo].[SP_GET_KEY_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_KEY_WORD_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_KEY_WORD_GROUP] AS' 
END
GO







-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索词组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_KEY_WORD_GROUP](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT ENT_WORD_GROUP.[ID]
		  ,ENT_WORD_GROUP.[NAME]
		  ,ENT_WORD_GROUP.[DESCRIPTION]
	  FROM ENT_WORD_GROUP	
    WHERE [NAME] LIKE @KW
			OR DESCRIPTION LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) like @kw
END








GO
/****** Object:  StoredProcedure [dbo].[SP_GET_KEY_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_KEY_WORD_GROUP_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_KEY_WORD_GROUP_FLOW] AS' 
END
GO





-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_KEY_WORD_GROUP_FLOW](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT [ID]
		  ,[NAME]
		  ,[DESCRIPTION]		 
	  FROM ENT_WORD_GROUP_FLOW	
    WHERE [DESCRIPTION] LIKE @KW
			OR [NAME] LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) like @kw
	ORDER BY len(NAME) ASC  -- 按相似度
END






GO
/****** Object:  StoredProcedure [dbo].[SP_GET_LOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_LOG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_LOG] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-03
-- Description:	搜索LOG
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_LOG]
	  @GROUP_ID BIGINT  -- 公司ID
	, @SN  NVARCHAR(50) -- 机器人SN号
	, @PACKAGE_NAME  NVARCHAR(2000) -- 包名
	, @END  NVARCHAR(20) -- 截至时间
	, @RANGE BIGINT -- 范围
	, @UNIT  NVARCHAR(10) -- 单位
	, @keyword NVARCHAR(120) -- 关键字 
	, @MAX_COUNT BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(4000)

	DECLARE @SN_LIST NVARCHAR(MAX)
	SET @SN_LIST = NULL

	IF @SN IS NOT NULL
		SET @SN_LIST = '(''' + @SN + ''')'
	IF @GROUP_ID IS NOT NULL
		SET @SN_LIST =  DBO.FUNC_GET_ROBOT_SN_LIST(@GROUP_ID)
 
	SET @END = CASE WHEN @END IS  NULL THEN 'GETDATE()' ELSE ('''' + @END + '''') END

 	SET @keyword = '''%' + ISNULL(@keyword, '') + '%'''
 

	SET @SQL = 
	 'SELECT TOP ' + CAST(ISNULL(@MAX_COUNT, 100) AS NVARCHAR(10)) + '[ID]
      ,[ROBOT_ID]
      ,[APP]
      ,[TYPE]
      ,[MSG]
      ,[DETAILS]
      ,[DATE_TIME]
	  FROM [TBL_RUNTIME_DATA] WHERE 1 = 1 ' 
	  
	  IF @SN_LIST IS NOT NULL

		SET @SQL = @SQL + ' AND [ROBOT_ID] IN'	  + @SN_LIST 

	SET @SQL = @SQL + 
	' AND DATEDIFF (' + @UNIT + ', DATE_TIME, ' + @END + ') <= ' + CAST(@RANGE AS NVARCHAR(20)) + 
	' AND DATEDIFF (' + @UNIT + ', DATE_TIME, ' + @END + ') >= 0 ' + 
	' AND (TYPE LIKE ' + @keyword + ' OR MSG LIKE ' + @keyword + ' OR [DETAILS] LIKE ' + @keyword + ')' +
	(CASE WHEN @PACKAGE_NAME IS NULL THEN '' ELSE  ' AND [APP] = ''' + @PACKAGE_NAME + '''' END ) +
	' ORDER BY DATE_TIME DESC '

	print @sql
	EXEC SP_EXECUTESQL @SQL
	
END



GO
/****** Object:  StoredProcedure [dbo].[SP_GET_MAX_MATCHED_FLOW_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_MAX_MATCHED_FLOW_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_MAX_MATCHED_FLOW_ID] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-24
-- Description:	判断给定语料是否存在匹配
-- =============================================
ALTER PROC [dbo].[SP_GET_MAX_MATCHED_FLOW_ID]
(
	  @INPUT_STRING AS NVARCHAR(1024)
	, @MAX_MATCHED_KEY_WORD_GROUP_FLOW_ID AS BIGINT OUTPUT
	, @MAX_MATCHED_VOICE_GROUP_ID AS BIGINT OUTPUT
)
AS
BEGIN
	DECLARE @VOICE_GROUP_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
	DECLARE @ACT_CNT AS BIGINT
	DECLARE @USE_FULLY_MATCH BIT
	DECLARE @MAX_ACT_CNT AS BIGINT

	SET @MAX_ACT_CNT = 0
 
	DECLARE CUR_CHECK_KW_ENTIRELY
	CURSOR FOR 

	SELECT KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT
	FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
	WHERE 
	(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0) AND ENABLE = 1
	GROUP BY KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID
	ORDER BY USE_FULLY_MATCH DESC, CNT DESC

	OPEN CUR_CHECK_KW_ENTIRELY

	FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
	@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
		WHERE ID = @KEY_WORD_GROUP_FLOW_ID AND INC_1_EXC_0 = 1

--		PRINT 'contain '
--		PRINT @KEY_WORD_GROUP_FLOW_ID
--		PRINT @VOICE_GROUP_ID
--		PRINT @KEY_WORD_GROUP_ID_COUNT
--		PRINT @ACT_CNT

		IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT 
		BEGIN
--			PRINT 'matched.'
--			PRINT @KEY_WORD_GROUP_FLOW_ID
--			PRINT @VOICE_GROUP_ID
--			PRINT @KEY_WORD_GROUP_ID_COUNT
--			PRINT @ACT_CNT

			-- 先严格匹配
			IF  @USE_FULLY_MATCH = 1
				IF DBO.FUNC_IS_FULLY_MATCHED(@INPUT_STRING, @KEY_WORD_GROUP_FLOW_ID) = 1 
				BEGIN
--					PRINT 'fully matched.'
					SET @MAX_MATCHED_KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID
					SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
					BREAK		
				END	
				ELSE
				BEGIN
					GOTO NEXT_ITEM
				END
			IF @MAX_ACT_CNT < @ACT_CNT
			BEGIN
--				PRINT 'new max matched.'
--				PRINT @MAX_MATCHED_KEY_WORD_GROUP_FLOW_ID
				SET @MAX_ACT_CNT = @ACT_CNT
				SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
				SET @MAX_MATCHED_KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID
			END
		END

		NEXT_ITEM:
		FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
		@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
	END
	CLOSE CUR_CHECK_KW_ENTIRELY
	DEALLOCATE CUR_CHECK_KW_ENTIRELY		 
END 

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_NO_REF_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_NO_REF_THIRD_PARTY_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_NO_REF_THIRD_PARTY_API] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-8
-- Description:	找未被任何应答引用的API
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_NO_REF_THIRD_PARTY_API]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 没人用的API
	SELECT '无用的API', * FROM ENT_THIRD_PARTY_API WHERE ENT_THIRD_PARTY_API.ID NOT IN
	(
		SELECT DISTINCT ENT_VOICE.THIRD_PARTY_API_ID FROM ENT_VOICE WHERE THIRD_PARTY_API_ID IS NOT NULL
	)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_NO_REF_THIRD_PARTY_API_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_NO_REF_THIRD_PARTY_API_PARAM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_NO_REF_THIRD_PARTY_API_PARAM] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-8
-- Description:	找未被任何API引用的参数
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_NO_REF_THIRD_PARTY_API_PARAM]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	-- 没人用api参数 
	SELECT '无用的API参数', * FROM ENT_THIRD_PARTY_API_PARAM WHERE ENT_THIRD_PARTY_API_PARAM.ID NOT IN
	(
		SELECT TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID FROM TBL_THIRD_PARTY_API_PARAM
	)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_NO_REF_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_NO_REF_THIRD_PARTY_API_PARAM_VALUE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_NO_REF_THIRD_PARTY_API_PARAM_VALUE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-22
-- Description:	找未被任何API引用的I参数组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_NO_REF_THIRD_PARTY_API_PARAM_VALUE]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	
	-- 没人用的API
	SELECT '无用的API参数组', * FROM VIEW_THIRD_PARTY_API_PARAM_VALUE WHERE VIEW_THIRD_PARTY_API_PARAM_VALUE.ID NOT IN
	(
		SELECT ENT_VOICE.THIRD_PARTY_API_PARAMS_VALUE_ID FROM ENT_VOICE WHERE THIRD_PARTY_API_PARAMS_VALUE_ID IS NOT NULL
	)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_NO_REF_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_NO_REF_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_NO_REF_VOICE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-23
-- Description:	找未被任何应答组/客户自助提交引用的应答
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_NO_REF_VOICE]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- 没人用的应答
	SELECT '无用的应答', * FROM VIEW_VOICE_SIMPLE WHERE CAT <> '2' AND VIEW_VOICE_SIMPLE.ID NOT IN
	(
		SELECT TBL_VOICE_GROUP.VOICE_ID FROM TBL_VOICE_GROUP
		UNION
		SELECT TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID 
		FROM TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL

	) 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_NO_REF_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_NO_REF_VOICE_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_NO_REF_VOICE_GROUP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-23
-- Description:	找未被任何规则引用的应答组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_NO_REF_VOICE_GROUP]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- 没人用的应答组
SELECT '无用的应答组', * FROM ENT_VOICE_GROUP WHERE ENT_VOICE_GROUP.ID NOT IN
(
	SELECT TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE .VOICE_GROUP_ID
	FROM TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_NO_REF_WORD]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_NO_REF_WORD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_NO_REF_WORD] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-23
-- Description:	找未被任何词组引用的单词
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_NO_REF_WORD]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
-- 没人用单词
SELECT '无用的单词', * FROM ENT_KEY_WORDS WHERE ENT_KEY_WORDS.ID NOT IN
(
	SELECT TBL_WORD_GROUP.KEY_WORD_ID FROM TBL_WORD_GROUP
)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_NO_REF_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_NO_REF_WORD_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_NO_REF_WORD_GROUP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-23
-- Description:	找未被任何句法引用的词组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_NO_REF_WORD_GROUP]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- 没人用的词组
SELECT '无用的词组', * FROM ENT_WORD_GROUP WHERE ENT_WORD_GROUP.ID NOT IN
(
	SELECT TBL_WORD_GROUP_FLOW.WORD_GROUP_ID FROM TBL_WORD_GROUP_FLOW
)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_NO_REF_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_NO_REF_WORD_GROUP_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_NO_REF_WORD_GROUP_FLOW] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-5-23
-- Description:	找未被任何规则引用的句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_NO_REF_WORD_GROUP_FLOW]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 SELECT '无用的句法', * FROM ENT_WORD_GROUP_FLOW WHERE ENT_WORD_GROUP_FLOW.ID NOT IN
(
	SELECT TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE .WORD_GROUP_FLOW_ID
	FROM TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE
	UNION
	SELECT TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.GEN_WORD_GROUP_FLOW_ID
	FROM TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL WHERE GEN_WORD_GROUP_FLOW_ID IS NOT NULL
	 
)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_PINYIN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_PINYIN]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_PINYIN] AS' 
END
GO
-- Batch submitted through debugger: SQLQuery7.sql|7|0|C:\Users\ADMINI~1\AppData\Local\Temp\1\~vsC4BA.sql


ALTER PROC [dbo].[SP_GET_PINYIN](@str varchar(1024),  @re varchar(8000) output)
as
begin
 declare @crs varchar(10)
 declare @strlen int 
 select @strlen=len(@str),@re=''
 while @strlen>0
 begin  
  set @crs= substring(@str,@strlen,1)
      SET @re=
        (case
        when @crs<'吖' then @crs
        when @crs<='厑' then 'a'
        when @crs<='靉' then 'ai'
        when @crs<='黯' then 'an'
        when @crs<='醠' then 'ang'
        when @crs<='驁' then 'ao'
        when @crs<='欛' then 'ba'
        when @crs<='瓸' then 'bai'
        when @crs<='瓣' then 'ban'
        when @crs<='鎊' then 'bang'
        when @crs<='鑤' then 'bao'
        when @crs<='鐾' then 'bei'
        when @crs<='輽' then 'ben'
        when @crs<='鏰' then 'beng'
        when @crs<='鼊' then 'bi'
        when @crs<='變' then 'bian'
        when @crs<='鰾' then 'biao'
        when @crs<='彆' then 'bie'
        when @crs<='鬢' then 'bin'
        when @crs<='靐' then 'bing'
        when @crs<='蔔' then 'bo'
        when @crs<='簿' then 'bu'
        when @crs<='囃' then 'ca'
        when @crs<='乲' then 'cai'
        when @crs<='爘' then 'can'
        when @crs<='賶' then 'cang'
        when @crs<='鼜' then 'cao'
        when @crs<='簎' then 'ce'
        when @crs<='笒' then 'cen'
        when @crs<='乽' then 'ceng'
        when @crs<='詫' then 'cha'
        when @crs<='囆' then 'chai'
        when @crs<='顫' then 'chan'
        when @crs<='韔' then 'chang'
        when @crs<='觘' then 'chao'
        when @crs<='爡' then 'che'
        when @crs<='讖' then 'chen'
        when @crs<='秤' then 'cheng'
        when @crs<='鷘' then 'chi'
        when @crs<='銃' then 'chong'
        when @crs<='殠' then 'chou'
        when @crs<='矗' then 'chu'
        when @crs<='踹' then 'chuai'
        when @crs<='鶨' then 'chuan'
        when @crs<='愴' then 'chuang'
        when @crs<='顀' then 'chui'
        when @crs<='蠢' then 'chun'
        when @crs<='縒' then 'chuo'
        when @crs<='嗭' then 'ci'
        when @crs<='謥' then 'cong'
        when @crs<='輳' then 'cou'
        when @crs<='顣' then 'cu'
        when @crs<='爨' then 'cuan'
        when @crs<='臎' then 'cui'
        when @crs<='籿' then 'cun'
        when @crs<='錯' then 'cuo'
        when @crs<='橽' then 'da'
        when @crs<='靆' then 'dai'
        when @crs<='饏' then 'dan'
        when @crs<='闣' then 'dang'
        when @crs<='纛' then 'dao'
        when @crs<='的' then 'de'
        when @crs<='扽' then 'den'
        when @crs<='鐙' then 'deng'
        when @crs<='螮' then 'di'
        when @crs<='嗲' then 'dia'
        when @crs<='驔' then 'dian'
        when @crs<='鑃' then 'diao'
        when @crs<='嚸' then 'die'
        when @crs<='顁' then 'ding'
        when @crs<='銩' then 'diu'
        when @crs<='霘' then 'dong'
        when @crs<='鬭' then 'dou'
        when @crs<='蠹' then 'du'
        when @crs<='叾' then 'duan'
        when @crs<='譵' then 'dui'
        when @crs<='踲' then 'dun'
        when @crs<='鵽' then 'duo'
        when @crs<='鱷' then 'e'
        when @crs<='摁' then 'en'
        when @crs<='鞥' then 'eng'
        when @crs<='樲' then 'er'
        when @crs<='髮' then 'fa'
        when @crs<='瀪' then 'fan'
        when @crs<='放' then 'fang'
        when @crs<='靅' then 'fei'
        when @crs<='鱝' then 'fen'
        when @crs<='覅' then 'feng'
        when @crs<='梻' then 'fo'
        when @crs<='鴀' then 'fou'
        when @crs<='猤' then 'fu'
        when @crs<='魀' then 'ga'
        when @crs<='瓂' then 'gai'
        when @crs<='灨' then 'gan'
        when @crs<='戇' then 'gang'
        when @crs<='鋯' then 'gao'
        when @crs<='獦' then 'ge'
        when @crs<='給' then 'gei'
        when @crs<='搄' then 'gen'
        when @crs<='堩' then 'geng'
        when @crs<='兣' then 'gong'
        when @crs<='購' then 'gou'
        when @crs<='顧' then 'gu'
        when @crs<='詿' then 'gua'
        when @crs<='恠' then 'guai'
        when @crs<='鱹' then 'guan'
        when @crs<='撗' then 'guang'
        when @crs<='鱥' then 'gui'
        when @crs<='謴' then 'gun'
        when @crs<='腂' then 'guo'
        when @crs<='哈' then 'ha'
        when @crs<='饚' then 'hai'
        when @crs<='鶾' then 'han'
        when @crs<='沆' then 'hang'
        when @crs<='兞' then 'hao'
        when @crs<='靏' then 'he'
        when @crs<='嬒' then 'hei'
        when @crs<='恨' then 'hen'
        when @crs<='堼' then 'heng'
        when @crs<='鬨' then 'hong'
        when @crs<='鱟' then 'hou'
        when @crs<='鸌' then 'hu'
        when @crs<='蘳' then 'hua'
        when @crs<='蘾' then 'huai'
        when @crs<='鰀' then 'huan'
        when @crs<='鎤' then 'huang'
        when @crs<='顪' then 'hui'
        when @crs<='諢' then 'hun'
        when @crs<='夻' then 'huo'
        when @crs<='驥' then 'ji'
        when @crs<='嗧' then 'jia'
        when @crs<='鑳' then 'jian'
        when @crs<='謽' then 'jiang'
        when @crs<='釂' then 'jiao'
        when @crs<='繲' then 'jie'
        when @crs<='齽' then 'jin'
        when @crs<='竸' then 'jing'
        when @crs<='蘔' then 'jiong'
        when @crs<='欍' then 'jiu'
        when @crs<='爠' then 'ju'
        when @crs<='羂' then 'juan'
        when @crs<='钁' then 'jue'
        when @crs<='攈' then 'jun'
        when @crs<='鉲' then 'ka'
        when @crs<='乫' then 'kai'
        when @crs<='矙' then 'kan'
        when @crs<='閌' then 'kang'
        when @crs<='鯌' then 'kao'
        when @crs<='騍' then 'ke'
        when @crs<='褃' then 'ken'
        when @crs<='鏗' then 'keng'
        when @crs<='廤' then 'kong'
        when @crs<='鷇' then 'kou'
        when @crs<='嚳' then 'ku'
        when @crs<='骻' then 'kua'
        when @crs<='鱠' then 'kuai'
        when @crs<='窾' then 'kuan'
        when @crs<='鑛' then 'kuang'
        when @crs<='鑎' then 'kui'
        when @crs<='睏' then 'kun'
        when @crs<='穒' then 'kuo'
        when @crs<='鞡' then 'la'
        when @crs<='籟' then 'lai'
        when @crs<='糷' then 'lan'
        when @crs<='唥' then 'lang'
        when @crs<='軂' then 'lao'
        when @crs<='餎' then 'le'
        when @crs<='脷' then 'lei'
        when @crs<='睖' then 'leng'
        when @crs<='瓈' then 'li'
        when @crs<='倆' then 'lia'
        when @crs<='纞' then 'lian'
        when @crs<='鍄' then 'liang'
        when @crs<='瞭' then 'liao'
        when @crs<='鱲' then 'lie'
        when @crs<='轥' then 'lin'
        when @crs<='炩' then 'ling'
        when @crs<='咯' then 'liu'
        when @crs<='贚' then 'long'
        when @crs<='鏤' then 'lou'
        when @crs<='氇' then 'lu'
        when @crs<='鑢' then 'lv'
        when @crs<='亂' then 'luan'
        when @crs<='擽' then 'lue'
        when @crs<='論' then 'lun'
        when @crs<='鱳' then 'luo'
        when @crs<='嘛' then 'ma'
        when @crs<='霢' then 'mai'
        when @crs<='蘰' then 'man'
        when @crs<='蠎' then 'mang'
        when @crs<='唜' then 'mao'
        when @crs<='癦' then 'me'
        when @crs<='嚜' then 'mei'
        when @crs<='們' then 'men'
        when @crs<='霥' then 'meng'
        when @crs<='羃' then 'mi'
        when @crs<='麵' then 'mian'
        when @crs<='廟' then 'miao'
        when @crs<='鱴' then 'mie'
        when @crs<='鰵' then 'min'
        when @crs<='詺' then 'ming'
        when @crs<='謬' then 'miu'
        when @crs<='耱' then 'mo'
        when @crs<='麰' then 'mou'
        when @crs<='旀' then 'mu'
        when @crs<='魶' then 'na'
        when @crs<='錼' then 'nai'
        when @crs<='婻' then 'nan'
        when @crs<='齉' then 'nang'
        when @crs<='臑' then 'nao'
        when @crs<='呢' then 'ne'
        when @crs<='焾' then 'nei'
        when @crs<='嫩' then 'nen'
        when @crs<='能' then 'neng'
        when @crs<='嬺' then 'ni'
        when @crs<='艌' then 'nian'
        when @crs<='釀' then 'niang'
        when @crs<='脲' then 'niao'
        when @crs<='钀' then 'nie'
        when @crs<='拰' then 'nin'
        when @crs<='濘' then 'ning'
        when @crs<='靵' then 'niu'
        when @crs<='齈' then 'nong'
        when @crs<='譳' then 'nou'
        when @crs<='搙' then 'nu'
        when @crs<='衄' then 'nv'
        when @crs<='瘧' then 'nue'
        when @crs<='燶' then 'nuan'
        when @crs<='桛' then 'nuo'
        when @crs<='鞰' then 'o'
        when @crs<='漚' then 'ou'
        when @crs<='袙' then 'pa'
        when @crs<='磗' then 'pai'
        when @crs<='鑻' then 'pan'
        when @crs<='胖' then 'pang'
        when @crs<='礮' then 'pao'
        when @crs<='轡' then 'pei'
        when @crs<='喯' then 'pen'
        when @crs<='喸' then 'peng'
        when @crs<='鸊' then 'pi'
        when @crs<='騙' then 'pian'
        when @crs<='慓' then 'piao'
        when @crs<='嫳' then 'pie'
        when @crs<='聘' then 'pin'
        when @crs<='蘋' then 'ping'
        when @crs<='魄' then 'po'
        when @crs<='哛' then 'pou'
        when @crs<='曝' then 'pu'
        when @crs<='蟿' then 'qi'
        when @crs<='髂' then 'qia'
        when @crs<='縴' then 'qian'
        when @crs<='瓩' then 'qiang'
        when @crs<='躈' then 'qiao'
        when @crs<='籡' then 'qie'
        when @crs<='藽' then 'qin'
        when @crs<='櫦' then 'qing'
        when @crs<='瓗' then 'qiong'
        when @crs<='糗' then 'qiu'
        when @crs<='覻' then 'qu'
        when @crs<='勸' then 'quan'
        when @crs<='礭' then 'que'
        when @crs<='囕' then 'qun'
        when @crs<='橪' then 'ran'
        when @crs<='讓' then 'rang'
        when @crs<='繞' then 'rao'
        when @crs<='熱' then 're'
        when @crs<='餁' then 'ren'
        when @crs<='陾' then 'reng'
        when @crs<='馹' then 'ri'
        when @crs<='穃' then 'rong'
        when @crs<='嶿' then 'rou'
        when @crs<='擩' then 'ru'
        when @crs<='礝' then 'ruan'
        when @crs<='壡' then 'rui'
        when @crs<='橍' then 'run'
        when @crs<='鶸' then 'ruo'
        when @crs<='栍' then 'sa'
        when @crs<='虄' then 'sai'
        when @crs<='閐' then 'san'
        when @crs<='喪' then 'sang'
        when @crs<='髞' then 'sao'
        when @crs<='飋' then 'se'
        when @crs<='篸' then 'sen'
        when @crs<='縇' then 'seng'
        when @crs<='霎' then 'sha'
        when @crs<='曬' then 'shai'
        when @crs<='鱔' then 'shan'
        when @crs<='緔' then 'shang'
        when @crs<='潲' then 'shao'
        when @crs<='欇' then 'she'
        when @crs<='瘮' then 'shen'
        when @crs<='賸' then 'sheng'
        when @crs<='瓧' then 'shi'
        when @crs<='鏉' then 'shou'
        when @crs<='虪' then 'shu'
        when @crs<='誜' then 'shua'
        when @crs<='卛' then 'shuai'
        when @crs<='腨' then 'shuan'
        when @crs<='灀' then 'shuang'
        when @crs<='睡' then 'shui'
        when @crs<='鬊' then 'shun'
        when @crs<='鑠' then 'shuo'
        when @crs<='乺' then 'si'
        when @crs<='鎹' then 'song'
        when @crs<='瘶' then 'sou'
        when @crs<='鷫' then 'su'
        when @crs<='算' then 'suan'
        when @crs<='鐩' then 'sui'
        when @crs<='潠' then 'sun'
        when @crs<='蜶' then 'suo'
       when @crs<='襨' then 'ta'
        when @crs<='燤' then 'tai'
        when @crs<='賧' then 'tan'
        when @crs<='燙' then 'tang'
        when @crs<='畓' then 'tao'
        when @crs<='蟘' then 'te'
        when @crs<='朰' then 'teng'
        when @crs<='趯' then 'ti'
        when @crs<='舚' then 'tian'
        when @crs<='糶' then 'tiao'
        when @crs<='餮' then 'tie'
        when @crs<='乭' then 'ting'
        when @crs<='憅' then 'tong'
        when @crs<='透' then 'tou'
        when @crs<='鵵' then 'tu'
        when @crs<='褖' then 'tuan'
        when @crs<='駾' then 'tui'
        when @crs<='坉' then 'tun'
        when @crs<='籜' then 'tuo'
        when @crs<='韤' then 'wa'
        when @crs<='顡' then 'wai'
        when @crs<='贎' then 'wan'
        when @crs<='朢' then 'wang'
        when @crs<='躛' then 'wei'
        when @crs<='璺' then 'wen'
        when @crs<='齆' then 'weng'
        when @crs<='齷' then 'wo'
        when @crs<='鶩' then 'wu'
        when @crs<='衋' then 'xi'
        when @crs<='鏬' then 'xia'
        when @crs<='鼸' then 'xian'
        when @crs<='鱌' then 'xiang'
        when @crs<='斆' then 'xiao'
        when @crs<='躞' then 'xie'
        when @crs<='釁' then 'xin'
        when @crs<='臖' then 'xing'
        when @crs<='敻' then 'xiong'
        when @crs<='齅' then 'xiu'
        when @crs<='蓿' then 'xu'
        when @crs<='贙' then 'xuan'
        when @crs<='瀥' then 'xue'
        when @crs<='鑂' then 'xun'
        when @crs<='齾' then 'ya'
        when @crs<='灩' then 'yan'
        when @crs<='樣' then 'yang'
        when @crs<='鑰' then 'yao'
        when @crs<='岃' then 'ye'
        when @crs<='齸' then 'yi'
        when @crs<='檼' then 'yin'
        when @crs<='譍' then 'ying'
        when @crs<='喲' then 'yo'
        when @crs<='醟' then 'yong'
        when @crs<='鼬' then 'you'
        when @crs<='爩' then 'yu'
        when @crs<='願' then 'yuan'
        when @crs<='鸙' then 'yue'
        when @crs<='韻' then 'yun'
        when @crs<='雥' then 'za'
        when @crs<='縡' then 'zai'
        when @crs<='饡' then 'zan'
        when @crs<='臟' then 'zang'
        when @crs<='竈' then 'zao'
        when @crs<='稄' then 'ze'
        when @crs<='鱡' then 'zei'
        when @crs<='囎' then 'zen'
        when @crs<='贈' then 'zeng'
        when @crs<='醡' then 'zha'
        when @crs<='瘵' then 'zhai'
        when @crs<='驏' then 'zhan'
        when @crs<='瞕' then 'zhang'
        when @crs<='羄' then 'zhao'
        when @crs<='鷓' then 'zhe'
        when @crs<='黮' then 'zhen'
        when @crs<='證' then 'zheng'
        when @crs<='豒' then 'zhi'
        when @crs<='諥' then 'zhong'
        when @crs<='驟' then 'zhou'
        when @crs<='鑄' then 'zhu'
        when @crs<='爪' then 'zhua'
        when @crs<='跩' then 'zhuai'
        when @crs<='籑' then 'zhuan'
        when @crs<='戅' then 'zhuang'
        when @crs<='鑆' then 'zhui'
        when @crs<='稕' then 'zhun'
        when @crs<='籱' then 'zhuo'
        when @crs<='漬' then 'zi'
        when @crs<='縱' then 'zong'
        when @crs<='媰' then 'zou'
        when @crs<='謯' then 'zu'
        when @crs<='攥' then 'zuan'
        when @crs<='欈' then 'zui'
        when @crs<='銌' then 'zun'
        when @crs<='咗' then 'zuo'
        else  @crs end) +''+@re
		SET @strlen=@strlen-1 

   end
 

end


GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RECOMMENDS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_RECOMMENDS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_RECOMMENDS] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-4-6
-- Description:	获取推荐
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_RECOMMENDS]
	-- Add the parameters for the stored procedure here
	@IMEI NVARCHAR(20),
	@KW   NVARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT -- TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.ID as name,
	  TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.REQUEST as value
	FROM      VIEW_USER_ROBOT_BIND_LIST
	, TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL
	, VIEW_VOICE
	WHERE   
	TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID = VIEW_VOICE.ID
	AND VIEW_USER_ROBOT_BIND_LIST.USER_ID = TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID  	
	AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI = @IMEI --'SG85O7KNDQSCH69S'  
	AND VIEW_VOICE.ENABLED = 1
	AND VIEW_VOICE.CAT = '4'
	AND REQUEST LIKE '%' + @KW + '%' 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RECOMMENDS_ADVANCE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_RECOMMENDS_ADVANCE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_RECOMMENDS_ADVANCE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-4
-- Description:	获取推荐 高级版
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_RECOMMENDS_ADVANCE]
	-- Add the parameters for the stored procedure here
	@REQUEST_ID NVARCHAR(120)
	,@IMEI NVARCHAR(20)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF CAST(DBO.FUNC_GET_CONFIG_VALUE(@IMEI, 'recommend_enabled', '0') AS BIT) = 1

		SELECT TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.REQUEST AS VALUE
		FROM
		TBL_REQUEST_RECOMMEND
		, TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL
		,      VIEW_USER_ROBOT_BIND_LIST
		, VIEW_VOICE

		WHERE
		TBL_REQUEST_RECOMMEND.REQUEST_ID = @REQUEST_ID
		AND TBL_REQUEST_RECOMMEND.MATCHED_DEGREE * TBL_REQUEST_RECOMMEND.GRANULARITY > 1
		AND TBL_REQUEST_RECOMMEND.RECOMMEND_FLOW_ID = TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.GEN_WORD_GROUP_FLOW_ID
		AND TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID = VIEW_VOICE.ID
		AND VIEW_USER_ROBOT_BIND_LIST.USER_ID = TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID  	
		AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_IMEI = @IMEI --'SG85O7KNDQSCH69S'  
		AND VIEW_VOICE.ENABLED = 1
		AND VIEW_VOICE.CAT = '4'

		ORDER BY TBL_REQUEST_RECOMMEND.MATCHED_DEGREE * TBL_REQUEST_RECOMMEND.GRANULARITY DESC
	ELSE
		SELECT NULL AS VALUE WHERE 1 = 0
	-- DELETE  TBL_REQUEST_RECOMMEND WHERE REQUEST_ID = @REQUEST_ID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_REQUEST_PROPERTY_VALUE_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_REQUEST_PROPERTY_VALUE_V2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_REQUEST_PROPERTY_VALUE_V2] AS' 
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_REQUEST_PROPERTY_VALUE_V2]
	  @REQUEST_ID NVARCHAR(120)
	, @PROPERTY_NAME NVARCHAR(120)
	, @PROPERTY_VALUE NVARCHAR(4000) OUTPUT
AS
BEGIN
	DECLARE @SQL AS NVARCHAR(4000)
    SET @SQL =  'SELECT @PROPERTY_VALUE = ' + @PROPERTY_NAME + ' FROM  ENT_REQUEST WHERE	ID =   @REQUEST_ID '

	EXEC SP_EXECUTESQL 
		   @SQL
		, N'@REQUEST_ID NVARCHAR(120), @PROPERTY_VALUE NVARCHAR(4000) OUTPUT'
	    , @REQUEST_ID, @PROPERTY_VALUE OUTPUT 
	RETURN @PROPERTY_VALUE

END


GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOT_APP_LASTEST_VERSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOT_APP_LASTEST_VERSION]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOT_APP_LASTEST_VERSION] AS' 
END
GO









-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-06-14
-- Description:	获取应用列表最新版本
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOT_APP_LASTEST_VERSION]
	  @ROBOT_IMEI  AS NVARCHAR(400)
	, @keyword  AS NVARCHAR(400)
	, @ENABLE_ONLY bit
AS
BEGIN

	SET @keyword =  (case @keyword when 'null' then '' else @keyword  end )
	SET @keyword = '%' + ISNULL(@keyword, '') + '%'

	SELECT *
	  FROM [G2Robot].[dbo].[VIEW_ROBOT_APP_BIND_LIST]
	WHERE ROBOT_IMEI = @ROBOT_IMEI	
		AND   [LASTEST_VERSION_CODE] IS NOT NULL
		AND   [ENABLE] IN (@ENABLE_ONLY, 1)
		AND   ([APP_PACKAGE_NAME] LIKE @keyword OR [APP_NAME]  LIKE @keyword OR [RELEASE_NOTE] LIKE @keyword or [DESCRIPTION] LIKE @keyword)
	ORDER BY 
		  ENABLE DESC 
		, APP_OWNER DESC
		, PUBLISH_DATETIME DESC
		, APP_ID DESC
END










GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOT_APP_VERSION_HISTORY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOT_APP_VERSION_HISTORY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOT_APP_VERSION_HISTORY] AS' 
END
GO




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-25
-- Description:	搜索版本历史
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOT_APP_VERSION_HISTORY]
		@ROBOT_APP_ID bigint
	  , @keyword  AS NVARCHAR(400)
	  , @FROM AS DATETIME
	  , @TO AS DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @keyword =  (case @keyword when 'null' then '' else @keyword  end )
	SET @keyword = '%' + ISNULL(@keyword, '') + '%'
	
	PRINT @keyword

	SET @FROM = ISNULL(@FROM, '1970-1-1 0:0:0')
	SET @TO = ISNULL(@TO, GETDATE())
	 
	SET @TO = DATEADD(HOUR, 23, @TO)
	SET @TO = DATEADD(minute, 59, @TO)
	SET @TO = DATEADD(SECOND, 59, @TO)

	SELECT [APP_NAME]
		,[VERSION_CODE]
		,[VERSION_NAME]
		,[DOWNLOAD_URL]
		,[RELEASE_NOTE]
		,[PUBLISH_DATETIME]
		,[ENABLED]
		,[ROBOT_APP_ID]
	FROM [VIEW_ROBOT_APP_VERSION]
	WHERE
			@ROBOT_APP_ID = [ROBOT_APP_ID]
		AND ([VERSION_NAME] LIKE @keyword 
		OR  [RELEASE_NOTE] LIKE @keyword )
		AND [PUBLISH_DATETIME] BETWEEN @FROM AND @TO
	ORDER BY PUBLISH_DATETIME DESC
	 
END





GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOT_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOT_CONFIG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOT_CONFIG] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-6-23
-- Description:	根据IMEI获取配置
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOT_CONFIG]
	@ROBOT_IMEI AS NVARCHAR(200),
	@key_word AS NVARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;

IF @key_word = '%all%' 
	SELECT 
		  [NAME]
		  ,[VALUE]
		  ,[DESCRIPTION]
	  FROM [G2Robot].[dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG]
		 where [ROBOT_IMEI] = @ROBOT_IMEI
else

	
	SELECT 
		  [NAME]
		  ,[VALUE]
		  ,[DESCRIPTION]
	  FROM [G2Robot].[dbo].[VIEW_ROBOT_MAX_PRIORITY_CONFIG]
		 where [ROBOT_IMEI] = @ROBOT_IMEI
		and ([NAME] like @key_word OR [DESCRIPTION] LIKE  @key_word )

END




GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOT_CONFIG_FOR_APP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOT_CONFIG_FOR_APP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOT_CONFIG_FOR_APP] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-14
-- Description:	根据IMEI获取客户端配置
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOT_CONFIG_FOR_APP]
	@ROBOT_IMEI AS NVARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;	
	SELECT 
		  [NAME]
		  ,[VALUE]
 
	  FROM VIEW_ROBOT_CONFIG_FOR_APP
		WHERE VIEW_ROBOT_CONFIG_FOR_APP.ROBOT_IMEI = @ROBOT_IMEI
END





GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOT_CONFIG_FOR_EDITOR]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOT_CONFIG_FOR_EDITOR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOT_CONFIG_FOR_EDITOR] AS' 
END
GO








-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-14
-- Description:	根据 owner id 和级别获取配置， 可编辑
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOT_CONFIG_FOR_EDITOR]
	@OWNER_ID  AS  bigint,
	@PRIORITY  AS BIGINT,
	@key_word AS NVARCHAR(200),
	@BIT_MASK      AS bigint = 1
AS
BEGIN
	SET NOCOUNT ON;
		
	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'

	DECLARE @SQL AS NVARCHAR(4000)



	SET @SQL = 
	'SELECT  distinct
				 VIEW_ROBOT_CONFIG_WITH_OWNER.PRIORITY
			   , ENT_CONFIG.NAME
			   , VIEW_ROBOT_CONFIG_WITH_OWNER.VALUE
			   , ENT_CONFIG.DESCRIPTION
			   , VIEW_ROBOT_CONFIG_WITH_OWNER.OWNER_NAME
			   , VIEW_ROBOT_CONFIG_WITH_OWNER.OWNER_ID
			   , '''' AS ROBOT_IMEI
			   , 0 AS ROBOT_ID
				, ISNULL(ENT_CONFIG.CANDIDATE, '''') AS CANDIDATE
				, ENT_CONFIG.DESCRIPTION
				, ENT_CONFIG.LEVEL
				, ISNULL(ENT_CONFIG.LIMIT_H, '''') AS LIMIT_H
				, ISNULL(ENT_CONFIG.LIMIT_L, '''') AS LIMIT_L
				, ISNULL(ENT_CONFIG.PATTERN, '''') AS PATTERN
			   ,  ENT_CONFIG.TYPE
			   ,  ENT_CONFIG.UI_ORDER
	FROM         
				VIEW_ROBOT_CONFIG_WITH_OWNER 


				INNER JOIN 
				(
							SELECT     MAX(PRIORITY) AS PRIORITY, NAME, ROBOT_IMEI
                            FROM          dbo.VIEW_ROBOT_CONFIG_WITH_OWNER AS T_PRIORITY
							WHERE T_PRIORITY.PRIORITY <= ' + CAST (@PRIORITY AS  VARCHAR(20)) + '
                            GROUP BY NAME, ROBOT_IMEI

				) AS MAX_PRIORITY_CONFIG_WITH_OWNER				  
				ON   
				(
                      VIEW_ROBOT_CONFIG_WITH_OWNER.PRIORITY = MAX_PRIORITY_CONFIG_WITH_OWNER.PRIORITY AND 
                      VIEW_ROBOT_CONFIG_WITH_OWNER.NAME = MAX_PRIORITY_CONFIG_WITH_OWNER.NAME AND 
                      VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_IMEI = MAX_PRIORITY_CONFIG_WITH_OWNER.ROBOT_IMEI
				)  
				INNER JOIN ENT_CONFIG
				ON 
				(
					VIEW_ROBOT_CONFIG_WITH_OWNER.NAME = ENT_CONFIG.NAME
				)				
WHERE 
				(   
					 ENT_CONFIG.NAME LIKE ''' +  @key_word + '''
				  OR ENT_CONFIG.DESCRIPTION LIKE ''' +  @key_word + '''
				)
				AND  VIEW_ROBOT_CONFIG_WITH_OWNER.ROBOT_ID IN  ('

	
	IF  @PRIORITY = 0
		SET @SQL = @SQL + 'SELECT ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST )'

	IF  @PRIORITY = 1
		SET @SQL = @SQL + 'SELECT ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST WHERE VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_ID = ' + CAST(@OWNER_ID AS VARCHAR(20))  + ')'

	IF  @PRIORITY = 3
		SET @SQL = @SQL + 'SELECT ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST WHERE VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID = ' + CAST(@OWNER_ID AS VARCHAR(20)) + ')'

	IF  @PRIORITY = 5
		SET @SQL = @SQL + 'SELECT ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST WHERE VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_SCENE_ID = ' + CAST(@OWNER_ID AS VARCHAR(20)) + ')'

	IF  @PRIORITY >= 7
		SET @SQL = @SQL + 'SELECT ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST WHERE VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = ' + CAST(@OWNER_ID AS VARCHAR(20)) + ')'
	

--	IF @MAIN = 1
--	BEGIN
		SET @SQL = @SQL + ' AND LEVEL & ' + CAST(@BIT_MASK AS VARCHAR(20)) + ' <> 0 '
--		SET @SQL = @SQL + '	ORDER BY PRIORITY DESC, OWNER_ID , [NAME] ASC'
--		SET @SQL = @SQL + '	ORDER BY [NAME] ASC'
		SET @SQL = @SQL + '	ORDER BY ENT_CONFIG.UI_ORDER ASC'

--	END
--	ELSE
--		SET @SQL = @SQL + '	ORDER BY PRIORITY DESC, OWNER_ID , [NAME] ASC'

	PRINT @SQL
	
	EXEC SP_EXECUTESQL @SQL

END










GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOT_CONFIG_WITH_OWNER]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOT_CONFIG_WITH_OWNER]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOT_CONFIG_WITH_OWNER] AS' 
END
GO








-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-19
-- Description:	根据IMEI获取配置, 带使用者
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOT_CONFIG_WITH_OWNER]
	@ROBOT_IMEI AS NVARCHAR(200),
	@GROUP_ID  AS  bigint,
	@key_word AS NVARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;
		
	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'

	IF @ROBOT_IMEI IS NOT NULL
		SELECT 
			 VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER.*
		  FROM [G2Robot].[dbo].VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER
			 where [ROBOT_IMEI] = @ROBOT_IMEI
			and ([NAME] like @key_word OR [DESCRIPTION] LIKE  @key_word )
		ORDER BY PRIORITY DESC, OWNER_ID , [NAME] ASC

	IF @GROUP_ID IS NOT NULL

		SELECT 
		DISTINCT
		'0' AS ROBOT_ID
	   ,'combiled' AS ROBOT_IMEI
	   ,[PRIORITY]
      ,[NAME]
      ,[VALUE]
      ,[DESCRIPTION]
      ,[OWNER_ID]
      ,[OWNER_NAME]
		  FROM VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER
			 where  [ROBOT_IMEI] IN (SELECT ROBOT_IMEI FROM VIEW_USER_ROBOT_BIND_LIST WHERE USER_GROUP_ID = @GROUP_ID)
			and ([NAME] like @key_word OR [DESCRIPTION] LIKE  @key_word )
		ORDER BY PRIORITY DESC, OWNER_ID , [NAME] ASC

END









GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOT_EXCEPTION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOT_EXCEPTION]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOT_EXCEPTION] AS' 
END
GO











-- =============================================
-- Author:		洪江力
-- Create date: 2017-01-05
-- Description:	搜索机器人异常信息
-- =============================================


ALTER PROCEDURE [dbo].[SP_GET_ROBOT_EXCEPTION]
	 @GROUP_ID BIGINT        --公司ID
	,@SN NVARCHAR(50)        --机器人SN号
	,@END NVARCHAR(20)       --截至时间
	,@RANGE BIGINT           --范围
	,@UNIT NVARCHAR(10)      --单位
	,@keyword NVARCHAR(120)  --关键字
	
	--,@MAX_COUNT BIGINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(4000)

	DECLARE @SN_LIST NVARCHAR(MAX)

	IF @SN IS NOT NULL 
		SET @SN_LIST = '(''' + @SN + ''')'

	IF @GROUP_ID IS NOT NULL
		SET @SN_LIST = dbo.FUNC_GET_ROBOT_SN_LIST(@GROUP_ID)


	SET @END =  CASE WHEN @END IS NULL THEN 'GETDATE()' ELSE ('''' + @END + '''') END

	SET @keyword = '''%' + ISNULL(@keyword, '') + '%'''

	SET @SQL = 
	'SELECT [ID]
		, [ROBOT_IMEI]
		, [MESSAGE]
		, [DESCRIPTION]
		, [NOTE]
		, [DATE_TIME]
		FROM [TBL_RUNTIME] WHERE ROBOT_IMEI IN ' + @SN_LIST + 
	' AND DATEDIFF (' + @UNIT + ', DATE_TIME, ' + @END + ') <= ' + CAST(@RANGE AS NVARCHAR(20)) + 
	' AND DATEDIFF (' + @UNIT + ', DATE_TIME, ' + @END + ') >= 0 ' + 
	' AND (NOTE LIKE ' + @keyword + ' OR MESSAGE LIKE ' + @keyword + ' OR [DESCRIPTION] LIKE ' + @keyword + ')' +
	' ORDER BY DATE_TIME DESC '

	print @sql
	EXEC SP_EXECUTESQL @SQL

END










GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOTS_NVP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOTS_NVP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOTS_NVP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-28
-- Description:	获取机器列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOTS_NVP]
	@SCENE_ID BIGINT = 0,
	@key_word AS NVARCHAR(200) = NULL
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SET @SCENE_ID = ISNULL(@SCENE_ID, 0)

	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'

	SELECT ENT_ROBOT.ID AS VALUE
	, ISNULL(TBL_USER_GROUP_SCENE.NAME, '(未归属场景)') + ' - '+   ENT_ROBOT.NAME AS NAME
	FROM ENT_ROBOT
	
	LEFT JOIN TBL_USER_GROUP_SCENE ON (ENT_ROBOT.USER_GROUP_SCENE_ID = TBL_USER_GROUP_SCENE.ID)
	
	WHERE 
	
	(ENT_ROBOT.NAME LIKE @key_word  OR TBL_USER_GROUP_SCENE.NAME LIKE @key_word)
	
	 AND ISNULL(ENT_ROBOT.USER_GROUP_SCENE_ID, 0) = ( CASE  @SCENE_ID WHEN 0 THEN ISNULL(USER_GROUP_SCENE_ID, 0) ELSE @SCENE_ID END)

	 ORDER BY NAME

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOTS_NVP_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOTS_NVP_V2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOTS_NVP_V2] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-28
-- Description:	获取机器列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOTS_NVP_V2]
	@INDUSTRY_ID BIGINT = 0,
	@USER_GROUP_ID BIGINT = 0,
	@SCENE_ID BIGINT = 0,
	@key_word AS NVARCHAR(200) = NULL
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SET @INDUSTRY_ID = ISNULL(@INDUSTRY_ID, 0)
	SET @USER_GROUP_ID = ISNULL(@USER_GROUP_ID, 0)
	SET @SCENE_ID = ISNULL(@SCENE_ID, 0)

	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'
	 
	DECLARE @SQL AS NVARCHAR(4000)



	SET @SQL = 
	'	SELECT [ROBOT_ID] AS VALUE
		,[ROBOT_NAME] AS NAME
	FROM [VIEW_USER_ROBOT_BIND_LIST] WHERE 1 = 1 '

	
	IF  @INDUSTRY_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_INDUSTRY_ID] =  ' + CAST(@INDUSTRY_ID AS VARCHAR(20))

	IF  @USER_GROUP_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_ID] = ' + CAST(@USER_GROUP_ID AS VARCHAR(20))

	IF  @SCENE_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_SCENE_ID] = ' + CAST(@SCENE_ID AS VARCHAR(20))
	
	 
	SET @SQL = @SQL + '	ORDER BY [NAME] ASC'

	PRINT @SQL
	
	EXEC SP_EXECUTESQL @SQL
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOTS_SN_NVP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOTS_SN_NVP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOTS_SN_NVP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-04-14
-- Description:	获取机器列表，输出SN
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOTS_SN_NVP]
	@INDUSTRY_ID BIGINT = 0,
	@USER_GROUP_ID BIGINT = 0,
	@SCENE_ID BIGINT = 0,
	@key_word AS NVARCHAR(200) = NULL
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SET @INDUSTRY_ID = ISNULL(@INDUSTRY_ID, 0)
	SET @USER_GROUP_ID = ISNULL(@USER_GROUP_ID, 0)
	SET @SCENE_ID = ISNULL(@SCENE_ID, 0)

	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'
	 
	DECLARE @SQL AS NVARCHAR(4000)



	SET @SQL = 
	'	SELECT ROBOT_IMEI AS VALUE
		,[ROBOT_NAME] AS NAME
	FROM [VIEW_USER_ROBOT_BIND_LIST] WHERE 1 = 1 '

	
	IF  @INDUSTRY_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_INDUSTRY_ID] =  ' + CAST(@INDUSTRY_ID AS VARCHAR(20))

	IF  @USER_GROUP_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_ID] = ' + CAST(@USER_GROUP_ID AS VARCHAR(20))

	IF  @SCENE_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_SCENE_ID] = ' + CAST(@SCENE_ID AS VARCHAR(20))
	
	 
	SET @SQL = @SQL + '	ORDER BY [NAME] ASC'

	PRINT @SQL
	
	EXEC SP_EXECUTESQL @SQL
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_ROBOTS_SN_NVP_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ROBOTS_SN_NVP_V2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_ROBOTS_SN_NVP_V2] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-28
-- Description:	获取机器列表，输出SN
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_ROBOTS_SN_NVP_V2]
	@INDUSTRY_ID BIGINT = 0,
	@USER_GROUP_ID BIGINT = 0,
	@SCENE_ID BIGINT = 0,
	@key_word AS NVARCHAR(200) = NULL
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SET @INDUSTRY_ID = ISNULL(@INDUSTRY_ID, 0)
	SET @USER_GROUP_ID = ISNULL(@USER_GROUP_ID, 0)
	SET @SCENE_ID = ISNULL(@SCENE_ID, 0)

	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'
	 
	DECLARE @SQL AS NVARCHAR(4000)



	SET @SQL = 
	'	SELECT ROBOT_IMEI AS VALUE
		,[ROBOT_NAME] AS NAME
	FROM [VIEW_USER_ROBOT_BIND_LIST] WHERE 1 = 1 '

	
	IF  @INDUSTRY_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_INDUSTRY_ID] =  ' + CAST(@INDUSTRY_ID AS VARCHAR(20))

	IF  @USER_GROUP_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_ID] = ' + CAST(@USER_GROUP_ID AS VARCHAR(20))

	IF  @SCENE_ID <> 0
		SET @SQL = @SQL + ' AND   [USER_GROUP_SCENE_ID] = ' + CAST(@SCENE_ID AS VARCHAR(20))
	
	 
	SET @SQL = @SQL + '	ORDER BY [NAME] ASC'

	PRINT @SQL
	
	EXEC SP_EXECUTESQL @SQL
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RULE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_RULE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_RULE] AS' 
END
GO







-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索规则
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_RULE](
    @kw as nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

SELECT [ID]
      ,[FLOW_ID]
      ,[FLOW_NAME]
      ,[VOICE_ID]
      ,[VOICE_NAME]
      ,[ENABLE]
	  ,[USE_FULLY_MATCH]
      ,[DESCRIPTION]
  FROM  [VIEW_FLOW_VOICE_RULE]	
    WHERE [DESCRIPTION] LIKE @KW
			OR [FLOW_NAME] LIKE @KW
			OR [VOICE_NAME] LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) like @kw

END








GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RULE_ORIGNAL]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_RULE_ORIGNAL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_RULE_ORIGNAL] AS' 
END
GO














-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索原始规则
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_RULE_ORIGNAL](
    @USER_ID as BIGINT
    , @kw as nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW =  DBO.FUNC_KEYWORD_MODIFIER(@KW)

	SELECT  distinct  VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.*		    
	FROM    VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL	
    WHERE   VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID = @USER_ID
			AND DBO.FUNC_AUTHENTICATE_PASSPORT_BY_USER_ID(VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID, @USER_ID) > 0
			-- AND VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CAT = '4' 已经过滤了
			AND (
					[DESCRIPTION] LIKE @KW
				OR  [NAME] LIKE @KW
				OR  [TEXT] LIKE @KW
				OR  [REQUEST] LIKE @KW
			)
	ORDER BY VOICE_ENABLED DESC , UPDATE_DATETIME DESC
END















GO
/****** Object:  StoredProcedure [dbo].[SP_GET_RULE_ORIGNAL_V2]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_RULE_ORIGNAL_V2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_RULE_ORIGNAL_V2] AS' 
END
GO















-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索原始规则
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_RULE_ORIGNAL_V2](
      @USER_ID as BIGINT
    , @kw as nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW =  DBO.FUNC_KEYWORD_MODIFIER(@KW)

	SELECT     VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2.*		    
	FROM    VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2	
    WHERE   VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2.CREATE_USER_ID = @USER_ID
			-- AND DBO.FUNC_AUTHENTICATE_PASSPORT_BY_USER_ID(VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2.VOICE_ID, @USER_ID) > 0
			AND (
					[DESCRIPTION] LIKE @KW
				OR  [NAME] LIKE @KW
				OR  [TEXT] LIKE @KW
				OR  [REQUEST] LIKE @KW
			)
	ORDER BY VOICE_ENABLED DESC , UPDATE_DATETIME DESC
END
















GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	搜索API
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT * 
	  FROM ENT_THIRD_PARTY_API	
    WHERE [NAME] LIKE @KW
			OR [DESCRIPTION] LIKE @KW
			OR URL LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) = @kw
END












GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_API_BY_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_API_BY_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_BY_ID] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	获取API
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_BY_ID](
    @ID BIGINT = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM ENT_THIRD_PARTY_API
    WHERE  ID = @ID
END












GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_API_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_API_PARAM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	搜索API PARAM
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT * 
	  FROM ENT_THIRD_PARTY_API_PARAM	
    WHERE [NAME] LIKE @KW
			OR [DESCRIPTION] LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) like @kw
END












GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_API_PARAM_BY_API_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_API_PARAM_BY_API_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM_BY_API_ID] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-12
-- Description:	通过 API ID 搜索API PARAM
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM_BY_API_ID](
	@API_ID AS BIGINT,
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT ENT_THIRD_PARTY_API_PARAM.* 
	  FROM TBL_THIRD_PARTY_API_PARAM INNER JOIN
	  ENT_THIRD_PARTY_API_PARAM
	   ON (TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID = ENT_THIRD_PARTY_API_PARAM.ID
	   AND TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_ID = @API_ID
	   )	
    WHERE ENT_THIRD_PARTY_API_PARAM.[NAME] LIKE @KW
			OR ENT_THIRD_PARTY_API_PARAM.[DESCRIPTION] LIKE @KW
			ORDER BY ENT_THIRD_PARTY_API_PARAM.NAME
					-- OR CAST(ENT_THIRD_PARTY_API_PARAM.ID AS NVARCHAR(20)) like @kw
END












GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_API_PARAM_BY_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_API_PARAM_BY_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM_BY_ID] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	获取API
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM_BY_ID](
    @ID BIGINT = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM ENT_THIRD_PARTY_API_PARAM
    WHERE  ID = @ID
END












GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_API_PARAM_VALUE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM_VALUE] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-11
-- Description:	搜索API PARAM 值组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM_VALUE](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT * 
	  FROM VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE
           
    WHERE [NAME] LIKE @KW
			OR API_NAME LIKE @KW
			OR [DESCRIPTION] LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) like @kw
END












GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_API_PARAM_VALUE_BY_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_API_PARAM_VALUE_BY_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM_VALUE_BY_ID] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-13
-- Description:	搜索API PARAM 值组， 按ID
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_API_PARAM_VALUE_BY_ID](
	@ID AS BIGINT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT * 
	  FROM VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE
           
    WHERE 
		     VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE.ID = @ID
END












GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_PARAMS_LIST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_PARAMS_LIST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_PARAMS_LIST] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-30
-- Description:	根据第三方API ID 获取参数列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_PARAMS_LIST]
		@API_ID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT [ID]
		  ,[THIRD_PARTY_API_ID]
		  ,[ENABLED]
		  ,[DESCIRPTION]
	  FROM [ENT_THIRD_PARTY_API_PARAMS_VALUE]
	WHERE [THIRD_PARTY_API_ID] = @API_ID
	AND [ENABLED] = 1
	ORDER BY [DESCIRPTION]
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_THIRD_PARTY_PARAMS_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_THIRD_PARTY_PARAMS_VALUE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_THIRD_PARTY_PARAMS_VALUE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-1
-- Description:	获取第三方API参数列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_THIRD_PARTY_PARAMS_VALUE]
	@TRD_ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT VIEW_THIRD_PARTY_PARAMS_VALUE.*
	FROM VIEW_THIRD_PARTY_PARAMS_VALUE WHERE @TRD_ID = THIRD_PARTY_API_ID
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_USER_EMAIL_FROM_ROBOT_EP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_USER_EMAIL_FROM_ROBOT_EP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_USER_EMAIL_FROM_ROBOT_EP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-6-21
-- Description:	根据用户名，绑定机器获取用户EMAIL
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_USER_EMAIL_FROM_ROBOT_EP]
	 @USER_NAME AS NVARCHAR(200)
	,@ROBOT_IMEI AS NVARCHAR(200)
	,@USER_EMAIL AS NVARCHAR(200) OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT TOP 1
      @USER_EMAIL = [USER_EMAIL]
  FROM [VIEW_USER_ROBOT_BIND_LIST]  
	WHERE @ROBOT_IMEI = ROBOT_IMEI AND @USER_NAME = USER_NAME
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_USER_GROUP_SCENES]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_USER_GROUP_SCENES]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_USER_GROUP_SCENES] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-16
-- Description:	获取指定企业下所有的组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_USER_GROUP_SCENES](
	  @group_id as bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 
	SELECT [ID]
		  ,[NAME]
		  ,[USER_GROUP_ID]
		  ,[USER_GROUP_NAME]
	  FROM  [VIEW_USER_GROUP_SCENE]
	WHERE [USER_GROUP_ID] = @group_id 


 
 
END





GO
/****** Object:  StoredProcedure [dbo].[SP_GET_USER_GROUP_SCENES_NVP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_USER_GROUP_SCENES_NVP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_USER_GROUP_SCENES_NVP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-28
-- Description:	获取场景列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_USER_GROUP_SCENES_NVP]
	@GROUP_ID BIGINT = 0,
	@key_word AS NVARCHAR(200) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SET @GROUP_ID = ISNULL(@GROUP_ID, 0)

	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'

	SELECT TBL_USER_GROUP_SCENE.ID AS VALUE
	, ENT_USER_GROUP.NAME + ' - ' +   TBL_USER_GROUP_SCENE.NAME AS NAME

	FROM TBL_USER_GROUP_SCENE
	
	INNER  JOIN ENT_USER_GROUP ON (ENT_USER_GROUP.ID = TBL_USER_GROUP_SCENE.USER_GROUP_ID)
	
	WHERE 
	
	(ENT_USER_GROUP.NAME LIKE @key_word  OR TBL_USER_GROUP_SCENE.NAME LIKE @key_word)
	
	 AND TBL_USER_GROUP_SCENE.USER_GROUP_ID  = ( CASE  @GROUP_ID WHEN 0 THEN TBL_USER_GROUP_SCENE.USER_GROUP_ID ELSE @GROUP_ID END)

	 ORDER BY NAME
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_USER_GROUPS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_USER_GROUPS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_USER_GROUPS] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-03-28
-- Description:	获取企业列表
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_USER_GROUPS]
	@INDUTRY_ID BIGINT = 0,
	@key_word AS NVARCHAR(200) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	SET @INDUTRY_ID = ISNULL(@INDUTRY_ID, 0)

	SET @key_word =  (case @key_word when 'null' then '' else @key_word  end )
	SET @key_word = '%' + ISNULL(@key_word, '') + '%'

	SELECT ENT_USER_GROUP.ID AS VALUE
	, ISNULL(ENT_INDUSTRY.NAME, '(未归属行业)') + ' - '+   ENT_USER_GROUP.NAME AS NAME
	FROM ENT_USER_GROUP
	
	LEFT JOIN ENT_INDUSTRY ON (ENT_USER_GROUP.INDUSTRY_ID = ENT_INDUSTRY.ID)
	
	WHERE 
	
	(ENT_USER_GROUP.NAME LIKE @key_word  OR ENT_INDUSTRY.NAME LIKE @key_word)
	
	 AND ISNULL(INDUSTRY_ID, 0) = ( CASE  @INDUTRY_ID WHEN 0 THEN ISNULL(INDUSTRY_ID, 0) ELSE @INDUTRY_ID END)

	 ORDER BY NAME

END

GO
/****** Object:  StoredProcedure [dbo].[SP_GET_USER_ROBOT_BIND_LIST_BY_SESSION_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_USER_ROBOT_BIND_LIST_BY_SESSION_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_USER_ROBOT_BIND_LIST_BY_SESSION_ID] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-3-31
-- Description:	根据 Session id 获取绑定终端列表详细
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_USER_ROBOT_BIND_LIST_BY_SESSION_ID]
	@SESSION_ID AS NVARCHAR(400)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	 SELECT *
    FROM  VIEW_USER_ROBOT_BIND_LIST
	WHERE  
	(
		    VIEW_USER_ROBOT_BIND_LIST.USER_LASTEST_STATUS_WSS_SESSION_ID = @SESSION_ID
		and VIEW_USER_ROBOT_BIND_LIST.USER_LASTEST_STATUS_ONLINE = 1
	)
	OR
	(
			VIEW_USER_ROBOT_BIND_LIST.ROBOT_LATEST_STATUS_WSS_SESSION_ID = @SESSION_ID
		and VIEW_USER_ROBOT_BIND_LIST.ROBOT_LATEST_STATUS_ONLINE = 1
	)

	order by  VIEW_USER_ROBOT_BIND_LIST.ROBOT_LATEST_STATUS_ONLINE desc,
	VIEW_USER_ROBOT_BIND_LIST.USER_LASTEST_STATUS_ONLINE desc,
	VIEW_USER_ROBOT_BIND_LIST.ROBOT_NAME ASC

END



GO
/****** Object:  StoredProcedure [dbo].[SP_GET_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_VOICE] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索回答
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_VOICE](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ORI AS nvarchar(30)
	SET @ORI = ISNULL(@KW, '')


	SET @KW = '%' + @ORI + '%'

	SELECT  ENT_VOICE.*
	  FROM ENT_VOICE	
    WHERE [NAME] LIKE @KW
		OR [DESCRIPTION] LIKE @KW
		OR COMMAND_PARAM LIKE @KW
		OR [TEXT] LIKE @KW
	    OR INC_PROP LIKE @KW
		OR EXC_PROP LIKE @KW	    
					OR CAST(ID AS NVARCHAR(20)) like @kw
		ORDER BY NAME
END













GO
/****** Object:  StoredProcedure [dbo].[SP_GET_VOICE_BY_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_VOICE_BY_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_VOICE_BY_ID] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	获取回答
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_VOICE_BY_ID](
    @ID BIGINT = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT  VIEW_VOICE_SIMPLE.*
	FROM VIEW_VOICE_SIMPLE	
    WHERE  ID = @ID
END












GO
/****** Object:  StoredProcedure [dbo].[SP_GET_VOICE_COUNT_BY_ROBOT_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_VOICE_COUNT_BY_ROBOT_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_VOICE_COUNT_BY_ROBOT_ID] AS' 
END
GO







-- =============================================
-- AUTHOR:		殷圣鸽
-- CREATE DATE: 2016-11-09
-- DESCRIPTION:	获得应答组总数以ROBOT_ID
-- 2017-03-22  自动关联行业TAG, 企业TAG
-- =============================================
ALTER PROC [dbo].[SP_GET_VOICE_COUNT_BY_ROBOT_ID]
(
	  @VOICE_GROUP_ID AS BIGINT
	, @ROBOT_ID AS BIGINT
	, @VOICE_COUNT AS BIGINT OUTPUT
	, @MAX_MATCHED_DEGREE AS BIGINT OUTPUT

)
 
AS
BEGIN
	-- DECLARE THE RETURN VARIABLE HERE
	-- DECLARE  @TAGS AS NVARCHAR(4000)

	IF @VOICE_GROUP_ID = -1
	BEGIN
		SELECT TOP 1 @MAX_MATCHED_DEGREE = 
				MAX(DBO.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID))
		FROM VIEW_VOICE_GROUP
		WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
			AND [VOICE_ENABLED] = 1
 			AND VOICE_CAT = '2'

		IF @MAX_MATCHED_DEGREE > 0
		BEGIN
			SELECT  @VOICE_COUNT = COUNT(VIEW_VOICE_GROUP.ID)
			FROM VIEW_VOICE_GROUP
			WHERE 
				(VOICE_GROUP_ID = @VOICE_GROUP_ID)
			AND [VOICE_ENABLED] = 1
 			AND DBO.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID) = @MAX_MATCHED_DEGREE
 			AND VOICE_CAT = '2'
		END

 	END
	ELSE
	BEGIN
		SELECT TOP 1 @MAX_MATCHED_DEGREE = 
				MAX(DBO.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID))
		FROM VIEW_VOICE_GROUP
		WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)

		IF @MAX_MATCHED_DEGREE > 0
		BEGIN
			SELECT  @VOICE_COUNT = COUNT(VIEW_VOICE_GROUP.ID)
			FROM VIEW_VOICE_GROUP
			WHERE 
				(VOICE_GROUP_ID = @VOICE_GROUP_ID)
			AND [VOICE_ENABLED] = 1
 			AND DBO.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID) = @MAX_MATCHED_DEGREE
		END
	END

END








GO
/****** Object:  StoredProcedure [dbo].[SP_GET_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_VOICE_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_VOICE_GROUP] AS' 
END
GO





-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索回答组
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_VOICE_GROUP](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT [ID]
		  ,[NAME]
		  ,[DESCRIPTION]	 
	  FROM ENT_VOICE_GROUP	
    WHERE [NAME] LIKE @KW
			OR [DESCRIPTION] LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) like @kw
END






GO
/****** Object:  StoredProcedure [dbo].[SP_GET_VOICE_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_VOICE_SIMPLE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_GET_VOICE_SIMPLE] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	搜索回答
-- =============================================
ALTER PROCEDURE [dbo].[SP_GET_VOICE_SIMPLE](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ORI AS nvarchar(30)
	SET @ORI = ISNULL(@KW, '')


	SET @KW = '%' + @ORI + '%'

	SELECT  VIEW_VOICE_SIMPLE.*
	  FROM VIEW_VOICE_SIMPLE	
    WHERE [NAME] LIKE @KW
		OR [DESCRIPTION] LIKE @KW
		OR COMMAND_PARAM LIKE @KW
		OR [TEXT] LIKE @KW
	    OR INC_PROP LIKE @KW
		OR EXC_PROP LIKE @KW	    
					OR CAST(ID AS NVARCHAR(20)) like @kw
		ORDER BY NAME
END













GO
/****** Object:  StoredProcedure [dbo].[SP_IS_ROBOT_ACTIVATED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_IS_ROBOT_ACTIVATED]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_IS_ROBOT_ACTIVATED] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-6-14
-- Description:	判断终端是否激活
-- =============================================
ALTER PROCEDURE [dbo].[SP_IS_ROBOT_ACTIVATED]
		  @ROBOT_IMEI  AS NVARCHAR(400)
		, @IS_ACTIVATED AS BIT OUTPUT
AS
BEGIN
	

	SELECT @IS_ACTIVATED = (CASE WHEN ID IS NOT NULL THEN 1 ELSE 0 END) FROM ENT_ROBOT WHERE  @ROBOT_IMEI = IMEI
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_LIST_KEY_WORD]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_LIST_KEY_WORD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_LIST_KEY_WORD] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	根据group_id获得关键词
-- =============================================
ALTER PROCEDURE [dbo].[SP_LIST_KEY_WORD](
    @groud_id as bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT 
	 ENT_KEY_WORDS.*
	 FROM
	 ENT_KEY_WORDS INNER JOIN TBL_WORD_GROUP
	 ON (TBL_WORD_GROUP.KEY_WORD_ID = ENT_KEY_WORDS.ID)
	WHERE TBL_WORD_GROUP.GROUP_ID = @groud_id
	ORDER BY ENT_KEY_WORDS.id;

END







GO
/****** Object:  StoredProcedure [dbo].[SP_LIST_KEY_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_LIST_KEY_WORD_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_LIST_KEY_WORD_GROUP] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	根据flow_id获得词组
-- =============================================
ALTER PROCEDURE [dbo].[SP_LIST_KEY_WORD_GROUP](
    @flow_id as bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT 
	 ENT_WORD_GROUP.*
	 FROM
	 ENT_WORD_GROUP INNER JOIN TBL_WORD_GROUP_FLOW
	 ON (TBL_WORD_GROUP_FLOW.WORD_GROUP_ID = ENT_WORD_GROUP.ID)
	WHERE TBL_WORD_GROUP_FLOW.ID = @FLOW_ID
	ORDER BY GROUP_FLOW_ORDER;

END







GO
/****** Object:  StoredProcedure [dbo].[SP_LIST_THIRD_PARTY_API_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_LIST_THIRD_PARTY_API_PARAM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_LIST_THIRD_PARTY_API_PARAM] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-8
-- Description:	根据API获得param id
-- =============================================
ALTER PROCEDURE [dbo].[SP_LIST_THIRD_PARTY_API_PARAM](
    @id as bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT 
	 ENT_THIRD_PARTY_API_PARAM.*
	 FROM
	 ENT_THIRD_PARTY_API_PARAM INNER JOIN TBL_THIRD_PARTY_API_PARAM
	 ON (TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID = ENT_THIRD_PARTY_API_PARAM.ID)
	WHERE TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_ID = @id
	ORDER BY ENT_THIRD_PARTY_API_PARAM.id;

END







GO
/****** Object:  StoredProcedure [dbo].[SP_LIST_THIRD_PARTY_API_PARAM_VALUE_ITEM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_LIST_THIRD_PARTY_API_PARAM_VALUE_ITEM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_LIST_THIRD_PARTY_API_PARAM_VALUE_ITEM] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-11
-- Description:	根据VALUE ID获得 value item
-- =============================================
ALTER PROCEDURE [dbo].[SP_LIST_THIRD_PARTY_API_PARAM_VALUE_ITEM](
    @id as bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT 
	 VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM.*
	 FROM
	 VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM
	WHERE VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM.VALUE_ID = @id
	ORDER BY VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM.PARAM_NAME ;

END







GO
/****** Object:  StoredProcedure [dbo].[SP_LIST_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_LIST_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_LIST_VOICE] AS' 
END
GO







-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	根据group_id获得关键词
-- =============================================
ALTER PROCEDURE [dbo].[SP_LIST_VOICE](
    @groud_id as bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT 
	 ENT_VOICE.*
	 FROM
	 ENT_VOICE INNER JOIN TBL_VOICE_GROUP
	 ON (TBL_VOICE_GROUP.VOICE_ID = ENT_VOICE.ID)
	WHERE TBL_VOICE_GROUP.ID = @groud_id
	ORDER BY ENT_VOICE.NAME;

END








GO
/****** Object:  StoredProcedure [dbo].[SP_LIST_VOICE_SIMPLE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_LIST_VOICE_SIMPLE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_LIST_VOICE_SIMPLE] AS' 
END
GO








-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-30
-- Description:	根据group_id获得关键词
-- =============================================
ALTER PROCEDURE [dbo].[SP_LIST_VOICE_SIMPLE](
    @groud_id as bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT 
	 VIEW_VOICE_SIMPLE.*
	 FROM
	 VIEW_VOICE_SIMPLE INNER JOIN TBL_VOICE_GROUP
	 ON (TBL_VOICE_GROUP.VOICE_ID = VIEW_VOICE_SIMPLE.ID)
	WHERE TBL_VOICE_GROUP.ID = @groud_id
	ORDER BY VIEW_VOICE_SIMPLE.NAME;

END









GO
/****** Object:  StoredProcedure [dbo].[SP_LOGOUT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_LOGOUT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_LOGOUT] AS' 
END
GO


-- =============================================
-- Author:		yinshengge
-- Create date: 2016-3-31
-- Description:	登出 注销
-- =============================================
ALTER PROCEDURE [dbo].[SP_LOGOUT]
		@SESSION_ID AS NVARCHAR(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ID AS BIGINT
	DECLARE @RTC_SESSION_ID AS BIGINT

	SET @ID = -1
	SET @RTC_SESSION_ID = -1

	SELECT @ID = USER_ID FROM VIEW_USER_ROBOT_BIND_LIST 
	WHERE USER_LASTEST_STATUS_WSS_SESSION_ID = @SESSION_ID
	AND   USER_LASTEST_STATUS_ONLINE = 1

	IF @ID <> -1
	BEGIN
		INSERT INTO [TBL_USER_STATUS]
			   ([USER_ID]
			   ,[UPDATE_DATETIME]
			   ,[ONLINE]
			   ,[EXTRA_INFO]
			   ,[WSS_SESSION_ID])
		 VALUES
			   (@ID
			   , GETDATE()
			   , 0
			   , NULL
			   , @SESSION_ID)	

		-- 结束掉它相关的 rtc_session
		SELECT  @RTC_SESSION_ID = [RTC_SESSION_ID]
		FROM [VIEW_RTC_SESSION_STATUS]
		WHERE [USER_ID] = @ID AND [STATUS] <> 'closed'
		ORDER BY [CREATE_DATETIME] DESC 

		IF	@RTC_SESSION_ID <> -1
			INSERT INTO [TBL_RTC_SESSION_STATUS]
					   ([RTC_SESSION_ID]
					   ,[UPDATE_DATETIME]
					   ,[STATUS])
				 VALUES
					   (@RTC_SESSION_ID
					   ,GETDATE()
					   ,'closed')				
	
		RETURN
	END

	SET @ID = -1

	SELECT @ID = ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST 
	WHERE ROBOT_LATEST_STATUS_WSS_SESSION_ID = @SESSION_ID
	AND   ROBOT_LATEST_STATUS_ONLINE = 1

	IF  @ID <> -1
		INSERT INTO [TBL_ROBOT_STATUS]
			   ([ROBOT_ID]
			   ,[UPDATE_DATETIME]
			   ,[ONLINE]
			   ,[EXTRA_INFO]
			   ,[WSS_SESSION_ID])
		 VALUES
			   (@ID
			   , GETDATE()
			   , 0
			   , NULL
			   , @SESSION_ID)		
 
		-- 结束掉它相关的 rtc_session
		SELECT  @RTC_SESSION_ID = [RTC_SESSION_ID]
		FROM [VIEW_RTC_SESSION_STATUS]
		WHERE ROBOT_ID = @ID AND [STATUS] <> 'closed'
		ORDER BY [CREATE_DATETIME] DESC 

		IF	@RTC_SESSION_ID <> -1
			INSERT INTO [TBL_RTC_SESSION_STATUS]
					   ([RTC_SESSION_ID]
					   ,[UPDATE_DATETIME]
					   ,[STATUS])
				 VALUES
					   (@RTC_SESSION_ID
					   ,GETDATE()
					   ,'closed')	
END



GO
/****** Object:  StoredProcedure [dbo].[SP_ML_NO]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ML_NO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_ML_NO] AS' 
END
GO

ALTER PROC [dbo].[SP_ML_NO]
(
	@ROBOT_ID BIGINT
	, @VOICE_COMMAND BIGINT OUTPUT
	,@VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT
	,@VOICE_TEXT NVARCHAR(1024) OUTPUT
)
AS
BEGIN

	IF DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_input', 'null') <> 'null' OR
	(
		DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_q', 'null') <> 'null' 
		AND DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_a', 'null') <> 'null' 
	)
	BEGIN
		EXEC SP_DELETE_SESSION_CONTEXT @ROBOT_ID,'ml_input'
		EXEC SP_DELETE_SESSION_CONTEXT @ROBOT_ID,'ml_q'
		EXEC SP_DELETE_SESSION_CONTEXT @ROBOT_ID,'ml_a'

		SET @VOICE_COMMAND = 0
		SET @VOICE_COMMAND_PARAM = ''
		SET @VOICE_TEXT ='已取消'	
	END
	ELSE
	BEGIN
		SET @VOICE_COMMAND = 0
		SET @VOICE_COMMAND_PARAM = NULL
		SET @VOICE_TEXT = '哦'
	END	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_ML_SBS_MAKE_SURE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ML_SBS_MAKE_SURE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_ML_SBS_MAKE_SURE] AS' 
END
GO

-- 殷圣鸽， 2016-11-26 教机器人说话
ALTER PROC [dbo].[SP_ML_SBS_MAKE_SURE] 
(
	  @ROBOT_ID BIGINT
	, @ml_a NVARCHAR(1024)
	, @VOICE_COMMAND BIGINT OUTPUT
	, @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT
	, @VOICE_TEXT NVARCHAR(1024) OUTPUT
)
AS
BEGIN

	EXEC SP_SAVE_SESSION_CONTEXT @ROBOT_ID, 'ml_a', @ml_a

	IF  DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_q', '') <> '' 
		AND DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_a', '') <> '' 
	BEGIN
		SET @VOICE_TEXT = '如果有人跟$nick_name$说: ' +  DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_q', '')
			+ ', $nick_name$就回复他: '
			+  DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_a', '')
			+ '。确定吗？'
	END
 
	EXEC SP_DELETE_SESSION_CONTEXT_LOOKUP @ROBOT_ID

END


GO
/****** Object:  StoredProcedure [dbo].[SP_ML_YES]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ML_YES]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_ML_YES] AS' 
END
GO





ALTER PROC [dbo].[SP_ML_YES] 
(
	 @ROBOT_ID BIGINT
	,@VOICE_COMMAND BIGINT OUTPUT
	,@VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT
	,@VOICE_TEXT NVARCHAR(1024) OUTPUT
)
AS
BEGIN

	DECLARE @ML_INPUT NVARCHAR(1024) 
	DECLARE @ML_Q NVARCHAR(1024) 
	DECLARE @ML_A NVARCHAR(1024) 

	SET  @ML_INPUT = DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_input', '')
	SET  @ML_Q = DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_q', '')
	SET  @ML_A = DBO.FUNC_GET_CONTEXT_VALUE (@ROBOT_ID,'ml_a', '')

	IF @ML_INPUT  <> '' OR (@ML_Q <> '' AND @ML_A <> '')
	BEGIN

		DECLARE @ACTIVED_USER_ID BIGINT
		SELECT @ACTIVED_USER_ID = ACTIVATE_USER_ID FROM ENT_ROBOT WHERE ID = @ROBOT_ID

		IF dbo.FUNC_GET_META_SETTINGS ('ML_RULE_AUTO_GEN', 0) = 1 AND (@ML_Q <> '' AND @ML_A <> '')
		BEGIN

			DECLARE @VOICE_NAME NVARCHAR(50)
			SET @VOICE_NAME = '机器学习：应答' + @ML_Q

			EXECUTE [SP_CUSOMER_SAVE_ORIGNAL_VOICE_V2] 
			 NULL
			,NULL
			,@VOICE_NAME
			,NULL
			,NULL
			,@ML_A
			,NULL
			,NULL
			,NULL
			,NULL
			,'ml'
			,'4'
			,@ML_Q
			,@ACTIVED_USER_ID
			,'机器学习'	
			,0	

			SET @VOICE_COMMAND = 0
			SET @VOICE_COMMAND_PARAM = NULL
			SET @VOICE_TEXT = '$ml_success_tip$'

			EXEC SP_DELETE_SESSION_CONTEXT @ROBOT_ID,'ml_input'
			EXEC SP_DELETE_SESSION_CONTEXT @ROBOT_ID,'ml_q'
			EXEC SP_DELETE_SESSION_CONTEXT @ROBOT_ID,'ml_a'
			 
		END
		ELSE
		BEGIN
			SET @VOICE_COMMAND = 1988
			SET @VOICE_COMMAND_PARAM = 
				  'MachineLearning' 
				+ ',' + CAST (@ACTIVED_USER_ID	AS NVARCHAR(20)) 
				+ ',' + CAST (@ROBOT_ID	AS NVARCHAR(20)) 
			
			IF  @ML_INPUT <> ''
				SET @VOICE_COMMAND_PARAM = @VOICE_COMMAND_PARAM + ',ml_input'

			IF  @ML_Q  <> ''
				SET @VOICE_COMMAND_PARAM = @VOICE_COMMAND_PARAM+ ',ml_q'

			IF  @ML_A <> ''
				SET @VOICE_COMMAND_PARAM = @VOICE_COMMAND_PARAM+ ',ml_a'

			SET @VOICE_TEXT = '1988 executor'
		END
	END
	ELSE
	BEGIN
		SET @VOICE_COMMAND = 0
		SET @VOICE_COMMAND_PARAM = NULL
		SET @VOICE_TEXT = '啥'
	END	
END





GO
/****** Object:  StoredProcedure [dbo].[SP_POST_ROUTINE_TEST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_POST_ROUTINE_TEST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_POST_ROUTINE_TEST] AS' 
END
GO





-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-1-4
-- Description:	后置例程
-- =============================================
ALTER PROCEDURE [dbo].[SP_POST_ROUTINE_TEST]
	   @REQUEST_ID NVARCHAR(120)
	 , @INPUT NVARCHAR(1024)
	 , @DEBUG BIT = 0
	 , @VOICE_COMMAND BIGINT OUTPUT
	 , @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT
	 , @VOICE_TEXT NVARCHAR(1024) OUTPUT 
AS
BEGIN
	SET NOCOUNT ON;
 
	IF @DEBUG = 1
		PRINT '后置例程实例,无实际功能'

END






GO
/****** Object:  StoredProcedure [dbo].[SP_RECORD_3RD_SMART_DIALOG_RESULT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RECORD_3RD_SMART_DIALOG_RESULT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_RECORD_3RD_SMART_DIALOG_RESULT] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-21
-- Description:	第三方会话结果写入
-- =============================================
ALTER PROCEDURE [dbo].[SP_RECORD_3RD_SMART_DIALOG_RESULT]
	 @INPUT_STRING AS NVARCHAR(1024)
	,@MODLE AS NVARCHAR(1024)
    ,@IMEI  AS NVARCHAR(1024)
	,@RESPONSE AS NVARCHAR(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  UPDATE [ENT_DIALOG]
   SET 
       [RESPONSE_1] = '3'
      ,[RESPONSE_2] = @RESPONSE
 WHERE ID in
(
	SELECT TOP 1 ID FROM ENT_DIALOG WHERE 
	request = @INPUT_STRING
	and request_ep_sn = @IMEI
	and request_model = @MODLE
	order by datetime desc
)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_RECORD_SMART_DIALOG_RESULT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RECORD_SMART_DIALOG_RESULT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_RECORD_SMART_DIALOG_RESULT] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-29
-- Description:	记录会话结果
-- =============================================
ALTER PROCEDURE [dbo].[SP_RECORD_SMART_DIALOG_RESULT]
	  @REQUEST_ID NVARCHAR(120)
	 ,@RESPONSE_1 AS NVARCHAR(4000) 
	 ,@RESPONSE_2 AS NVARCHAR(4000) 
	 ,@RESPONSE_3 AS NVARCHAR(4000) 
	 ,@RESPONSE_4 AS NVARCHAR(4000) 
	 ,@RESPONSE_5 AS NVARCHAR(4000) 
	 ,@RESPONSE_6 AS NVARCHAR(4000) 
	 ,@RESPONSE_7 AS NVARCHAR(4000) 
	 ,@RESPONSE_8 AS NVARCHAR(4000) 
	 ,@RESPONSE_9 AS NVARCHAR(4000) 
	 ,@RESPONSE_10 AS NVARCHAR(4000) 
	 ,@RESPONSE_11 AS NVARCHAR(4000) 
	 ,@RESPONSE_12 AS NVARCHAR(4000) 
	 ,@RESPONSE_13 AS NVARCHAR(4000) 
	 ,@RESPONSE_14 AS NVARCHAR(4000) 
	 ,@RESPONSE_15 AS NVARCHAR(4000) 
	 ,@RESPONSE_16 AS NVARCHAR(4000) 


AS
BEGIN
		DECLARE @TAGS AS NVARCHAR(1024)
		DECLARE @INPUT AS NVARCHAR(4000)
		DECLARE @SN  AS NVARCHAR(1024)
		DECLARE @h_version  AS NVARCHAR(120)
		DECLARE @client_ip  AS NVARCHAR(50)
		DECLARE @h_addr  AS NVARCHAR(500)
		-- DECLARE @start  AS NVARCHAR(120)
		DECLARE @start_datetime  AS datetime

		SELECT 
			 @INPUT = [input]
			,@SN = [sn]
			,@TAGS = [tag]
			,@start_datetime = exec_start_datetime
			,@client_ip = [client_ip]
			,@h_version = [h_version]
			,@h_addr = [h_addr]
		FROM  [ENT_REQUEST]
		WHERE [ID] = @REQUEST_ID

		INSERT INTO [ENT_DIALOG]
           ([REQUEST]
           ,[REQUEST_EP_SN]
           ,[REQUEST_MODEL]
           ,[REQUEST_CLIENT_IP]
           ,[REQUEST_CLIENT_VERSION]
           ,[REQUEST_ADDR]
           ,[RESPONSE_1]
           ,[RESPONSE_2]
           ,[RESPONSE_3]
           ,[RESPONSE_4]
           ,[RESPONSE_5]
           ,[RESPONSE_6]
           ,[RESPONSE_7]
           ,[RESPONSE_8]
           ,[RESPONSE_9]
           ,[RESPONSE_10]
           ,[RESPONSE_11]
           ,[RESPONSE_12]
           ,[RESPONSE_13]
           ,[RESPONSE_14]
           ,[RESPONSE_15]
           ,[RESPONSE_16]
           ,[EXEC_MILLSECS])
 		VALUES ( 
			 @INPUT
		   , @SN
		   , @TAGS
           , @client_ip
           , @h_version
		   , @h_addr
		   , @RESPONSE_1
		   , @RESPONSE_2
		   , @RESPONSE_3
		   , @RESPONSE_4
		   , @RESPONSE_5
		   , @RESPONSE_6
		   , @RESPONSE_7
		   , @RESPONSE_8
		   , @RESPONSE_9
		   , @RESPONSE_10 
		   , @RESPONSE_11  
		   , @RESPONSE_12 
		   , @RESPONSE_13 
		   , @RESPONSE_14 
		   , @RESPONSE_15 
		   , @RESPONSE_16
	       , (
				datediff(ms, @start_datetime, getdate())
			 )
		  )

	DECLARE @ROBOT_ID AS BIGINT
	DECLARE @UNKNOW_COUNT AS BIGINT

	SELECT @ROBOT_ID = ID FROM ENT_ROBOT WHERE @SN = IMEI
	IF @RESPONSE_1 = '2'
	BEGIN	
		SELECT  @UNKNOW_COUNT = (1 + CAST(ISNULL(CTX_VALUE, '0') AS BIGINT)) FROM TBL_ROBOT_SESSION_CONTEXT 
		WHERE @ROBOT_ID = ROBOT_ID AND CTX_NAME = 'UNKONW_COUNT'

		
		EXEC SP_SAVE_SESSION_CONTEXT 
			  @ROBOT_ID
			, 'UNKONW_COUNT'
			, @UNKNOW_COUNT 
			, 30
			, ''
	END			
	ELSE
		EXEC SP_SAVE_SESSION_CONTEXT 
			  @ROBOT_ID
			, 'UNKONW_COUNT'
			, '0' 
			, 30
			, ''	

	IF DBO.FUNC_GET_META_SETTINGS('RECORD_REQUEST_PROPERTY', '0')  = '0'
		EXEC SP_REMOVE_REQUEST @REQUEST_ID

END












GO
/****** Object:  StoredProcedure [dbo].[SP_REF_RULE_BY_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REF_RULE_BY_VOICE_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REF_RULE_BY_VOICE_GROUP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-07
-- Description:	根据 VOICE_GROUP ID 获得引用它的 RULE
-- =============================================
ALTER PROCEDURE [dbo].[SP_REF_RULE_BY_VOICE_GROUP]
		@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT VIEW_FLOW_VOICE_RULE.*
	FROM  VIEW_FLOW_VOICE_RULE 
	 
	WHERE VOICE_ID = @ID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_REF_RULE_BY_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REF_RULE_BY_WORD_GROUP_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REF_RULE_BY_WORD_GROUP_FLOW] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-07
-- Description:	根据 WORD_GROUP_FLOW 获得引用它的 RULE
-- =============================================
ALTER PROCEDURE [dbo].[SP_REF_RULE_BY_WORD_GROUP_FLOW]
		@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT VIEW_FLOW_VOICE_RULE.*
	FROM  VIEW_FLOW_VOICE_RULE 
	 
	WHERE FLOW_ID = @ID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_REF_THIRD_PARTY_API_BY_PARAM_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REF_THIRD_PARTY_API_BY_PARAM_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REF_THIRD_PARTY_API_BY_PARAM_ID] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-22
-- Description:	根据第三方参数ID 获得引用它的 第三方
-- =============================================
ALTER PROCEDURE [dbo].[SP_REF_THIRD_PARTY_API_BY_PARAM_ID]
		@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT ENT_THIRD_PARTY_API.*
	  FROM ENT_THIRD_PARTY_API
	  inner join TBL_THIRD_PARTY_API_PARAM ON 
	  (
		ENT_THIRD_PARTY_API.ID = TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_ID
		AND TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID = @ID
	  )
	

END

GO
/****** Object:  StoredProcedure [dbo].[SP_REF_VOICE_BY_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REF_VOICE_BY_THIRD_PARTY_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REF_VOICE_BY_THIRD_PARTY_API] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-22
-- Description:	根据第三方ID 获得引用它的 VOICE
-- =============================================
ALTER PROCEDURE [dbo].[SP_REF_VOICE_BY_THIRD_PARTY_API]
		@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT VIEW_VOICE_SIMPLE.*
	  FROM VIEW_VOICE_SIMPLE
	WHERE VIEW_VOICE_SIMPLE.THIRD_PARTY_API_ID = @ID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_REF_VOICE_BY_THIRD_PARTY_API_PARAM_VALUE_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REF_VOICE_BY_THIRD_PARTY_API_PARAM_VALUE_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REF_VOICE_BY_THIRD_PARTY_API_PARAM_VALUE_ID] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-22
-- Description:	根据第三方参数值ID 获得引用它的 VOICE
-- =============================================
ALTER PROCEDURE [dbo].[SP_REF_VOICE_BY_THIRD_PARTY_API_PARAM_VALUE_ID]
		@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT VIEW_VOICE_SIMPLE.*
	  FROM VIEW_VOICE_SIMPLE
	WHERE VIEW_VOICE_SIMPLE.THIRD_PARTY_API_PARAMS_VALUE_ID = @ID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_REF_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REF_VOICE_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REF_VOICE_GROUP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-07
-- Description:	根据VOICE ID 获得引用它的 VOICE_GROUP
-- =============================================
ALTER PROCEDURE [dbo].[SP_REF_VOICE_GROUP]
		@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT ENT_VOICE_GROUP.[ID]
		  ,ENT_VOICE_GROUP.NAME
		  ,ENT_VOICE_GROUP.[DESCRIPTION]
	  FROM  ENT_VOICE_GROUP 
	INNER JOIN [TBL_VOICE_GROUP] ON (ENT_VOICE_GROUP.ID = [TBL_VOICE_GROUP].ID )
	WHERE [TBL_VOICE_GROUP].VOICE_ID = @ID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_REF_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REF_WORD_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REF_WORD_GROUP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-07
-- Description:	根据WORD ID 获得引用它的 WORD_GROUP
-- =============================================
ALTER PROCEDURE [dbo].[SP_REF_WORD_GROUP]
		@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT ENT_WORD_GROUP.[ID]
		  ,ENT_WORD_GROUP.NAME
		  ,ENT_WORD_GROUP.[DESCRIPTION]
	  FROM  ENT_WORD_GROUP 
	INNER JOIN TBL_WORD_GROUP ON (ENT_WORD_GROUP.ID = TBL_WORD_GROUP.GROUP_ID )
	WHERE TBL_WORD_GROUP.KEY_WORD_ID = @ID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_REF_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REF_WORD_GROUP_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REF_WORD_GROUP_FLOW] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-07
-- Description:	根据WORD_GROUP_ID 获得引用它的 WORD_GROUP_FLOW
-- =============================================
ALTER PROCEDURE [dbo].[SP_REF_WORD_GROUP_FLOW]
		@ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT ENT_WORD_GROUP_FLOW.[ID]
		  ,ENT_WORD_GROUP_FLOW.NAME
		  ,ENT_WORD_GROUP_FLOW.[DESCRIPTION]
	  FROM  ENT_WORD_GROUP_FLOW 
	INNER JOIN TBL_WORD_GROUP_FLOW ON (ENT_WORD_GROUP_FLOW.ID = TBL_WORD_GROUP_FLOW.ID )
	WHERE TBL_WORD_GROUP_FLOW.WORD_GROUP_ID = @ID

END


GO
/****** Object:  StoredProcedure [dbo].[SP_REFRESH_ROBOT_TAGS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REFRESH_ROBOT_TAGS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REFRESH_ROBOT_TAGS] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-28
-- Description:	刷新TAG
-- =============================================
ALTER PROCEDURE [dbo].[SP_REFRESH_ROBOT_TAGS]
	@ROBOT_ID BIGINT
	,@TAGS AS NVARCHAR(1024) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- 刷新TAGS
	IF NOT EXISTS(SELECT TOP 1 TAG FROM TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID AND TAG_STR = @TAGS)
	BEGIN			
		DELETE 	TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID
		INSERT INTO TBL_ROBOT_TAGS
		SELECT @ROBOT_ID AS ROBOT_ID, TAG, @TAGS AS TAG_STR FROM FUNC_GET_TAGS_TABLE(@TAGS)
	
		DECLARE @USRE_GROUP_TAG NVARCHAR(50)
		DECLARE @ROBOT_TAG NVARCHAR(50)

		-- 获取企业TAG
		SELECT @USRE_GROUP_TAG = ENT_USER_GROUP.TAG 
		FROM   VIEW_USER_ROBOT_BIND_LIST INNER JOIN ENT_USER_GROUP ON (VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID = ENT_USER_GROUP.ID)
		WHERE  VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = @ROBOT_ID

		IF EXISTS(SELECT TAG FROM TBL_ROBOT_TAGS WHERE TAG = @USRE_GROUP_TAG)
			-- 企业TAG
			INSERT INTO TBL_ROBOT_TAGS(ROBOT_ID, TAG, TAG_STR) VALUES (@ROBOT_ID, @USRE_GROUP_TAG, @USRE_GROUP_TAG)

		SET @ROBOT_TAG = CAST(@ROBOT_ID AS NVARCHAR(50))

		IF EXISTS(SELECT TAG FROM TBL_ROBOT_TAGS WHERE TAG = @ROBOT_TAG)
			-- 机器人自身 TAG
			INSERT INTO TBL_ROBOT_TAGS(ROBOT_ID, TAG, TAG_STR) VALUES (@ROBOT_ID, @ROBOT_TAG, @ROBOT_TAG)
		
	END
END


GO
/****** Object:  StoredProcedure [dbo].[SP_REGISTER_VISITOR]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REGISTER_VISITOR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REGISTER_VISITOR] AS' 
END
GO

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-6-1
-- Description:	登记用户

			
--			call.setString(argCount++, name);
--			call.setString(argCount++, phone);
--			call.setString(argCount++, event);
--			call.setString(argCount++, company);
--			call.setString(argCount++, target);

-- =============================================
ALTER PROCEDURE [dbo].[SP_REGISTER_VISITOR]
		 @NAME AS NVARCHAR(50)
		,@PHONE AS NVARCHAR(50)
		,@EVENT AS NVARCHAR(50)
		,@COMPANY AS NVARCHAR(50)
		,@TARGET AS NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO [ENT_VISITORS]
           ([NAME]
           ,[PHONE]
           ,[COMPANY]
           ,[EVENT]
           ,[TAREGET])
     VALUES
           (@NAME
           ,@PHONE
           ,@COMPANY
           ,@EVENT
           ,@TARGET)
 
END


GO
/****** Object:  StoredProcedure [dbo].[SP_REMOVE_REQUEST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REMOVE_REQUEST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REMOVE_REQUEST] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	删除request
-- =============================================
ALTER PROCEDURE [dbo].[SP_REMOVE_REQUEST]
	@REQUEST_ID NVARCHAR(120)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM  [TBL_REQUEST_PROPERTY]
      WHERE  REQUEST_ID = @REQUEST_ID

	DELETE FROM  [ENT_REQUEST]
      WHERE ID = @REQUEST_ID

	DELETE  TBL_REQUEST_RECOMMEND WHERE REQUEST_ID = @REQUEST_ID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_EXCEPTION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REPORT_EXCEPTION]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REPORT_EXCEPTION] AS' 
END
GO


-- =============================================
-- Author:		yinshengge
-- Create date: 2015/12/01
-- Description:	存储错误
-- =============================================
ALTER PROCEDURE [dbo].[SP_REPORT_EXCEPTION]
	-- Add the parameters for the stored procedure here
	  @robotId as nvarchar(50)
	, @app as nvarchar(2000)
	, @type   as nvarchar(50)
	, @msg    as nvarchar(4000)
	, @details as varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [TBL_RUNTIME_DATA]
			   ([ROBOT_ID]
			   ,[APP]
			   ,[TYPE]
			   ,[MSG]
			   ,[DETAILS] )
		 VALUES
			   (@robotId
			   ,@app
			   ,@type
			   ,@msg
			   ,@details)
		 
END



GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_RUNTIME]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_REPORT_RUNTIME]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_REPORT_RUNTIME] AS' 
END
GO





-- =============================================
-- Author:		yinshengge
-- Create date: 2015/12/01
-- Description:	存储错误
-- =============================================
ALTER PROCEDURE [dbo].[SP_REPORT_RUNTIME]
	-- Add the parameters for the stored procedure here
	  @robotId as nvarchar(50)
	, @app as nvarchar(2000)
	, @type   as nvarchar(50)
	, @msg    as nvarchar(4000)
	, @details as varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [TBL_RUNTIME_DATA]
			   ([ROBOT_ID]
			   ,[APP]
			   ,[TYPE]
			   ,[MSG]
			   ,[DETAILS] )
		 VALUES
			   (@robotId
			   ,@app
			   ,@type
			   ,@msg
			   ,@details)

END






GO
/****** Object:  StoredProcedure [dbo].[SP_RESET_USER_PASSWORD]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_RESET_USER_PASSWORD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_RESET_USER_PASSWORD] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-29
-- Description:	修改密码
-- =============================================
ALTER PROCEDURE [dbo].[SP_RESET_USER_PASSWORD]
	 @USER_NAME  AS NVARCHAR(4000)  -- IN
	,@PASSWORD   AS NVARCHAR(4000)  -- IN
	,@NEW_PASSWORD   AS NVARCHAR(4000)  -- IN
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF EXISTS(SELECT ID FROM ENT_USER  WHERE @USER_NAME = [NAME]
	 AND @PASSWORD = [PASSWORD] )
	BEGIN
		UPDATE [ENT_USER]
		SET 		  
			   [PASSWORD] = @NEW_PASSWORD
		 WHERE @USER_NAME = [NAME]
		 AND @PASSWORD = [PASSWORD]
	END
	ELSE
	BEGIN
			 RAISERROR ('用户名或密码错误！',  15,  5) 
	END	

END

GO
/****** Object:  StoredProcedure [dbo].[SP_ROBOT_LOGIN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_ROBOT_LOGIN]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_ROBOT_LOGIN] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-3-30
-- Description: 机器人登录
/*

1. 根据 IMEI, USERNAME, PASSWORD 找出机器人的资料， 验证用户， 

输入：
UserAgent
UserName  
password
IMEI

输出：
code	
message	
id	
name	
activateDatetime	
lastestLoginDatetime	
loginCount	
user[+d].id	
user[+d].status	
user[+d].name	
user[+d].groupName	


*/

-- =============================================
ALTER PROCEDURE [dbo].[SP_ROBOT_LOGIN] 
	-- Add the parameters for the stored procedure here
	 @USER_AGENT AS NVARCHAR(4000)  -- IN
	,@USER_NAME  AS NVARCHAR(4000)  -- IN
	,@PASSWORD   AS NVARCHAR(4000)  -- IN
	,@DIG   AS NVARCHAR(4000)  -- IN
	,@IMEI       AS NVARCHAR(50)    -- IN
	,@SESSION_ID AS NVARCHAR(4000)  -- IN
	,@LOGIN_COUNT   AS BIGINT OUTPUT -- 登录次数

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @ROBOT_ID AS BIGINT 

	SET @ROBOT_ID = NULL

	
	SELECT @ROBOT_ID = [ROBOT_ID]
	FROM [VIEW_USER_ROBOT_BIND_LIST]
	WHERE [USER_NAME]   =  @USER_NAME  
	AND 
	(
		USER_PASSWORD = @PASSWORD 
		OR USER_PASSWORD = @DIG
	)  
	AND [ROBOT_IMEI]    =  @IMEI

	IF @ROBOT_ID IS NOT NULL 
	BEGIN
		SELECT @LOGIN_COUNT = COUNT([WSS_SESSION_ID])
		FROM [TBL_ROBOT_STATUS]
		WHERE [ROBOT_ID] = @ROBOT_ID AND [ONLINE] = 1

		INSERT INTO [TBL_ROBOT_STATUS]
			   ([ROBOT_ID]
			   ,[UPDATE_DATETIME]
			   ,[WSS_SESSION_ID]
			   ,[ONLINE]
			   ,[EXTRA_INFO])
		 VALUES
			   (@ROBOT_ID
			   , GETDATE()
			   , @SESSION_ID
			   , 1
			   , @USER_AGENT)

		 SELECT *
			  FROM [G2Robot].[dbo].[VIEW_USER_ROBOT_BIND_LIST]
		  WHERE [ROBOT_ID]   =  @ROBOT_ID 
	END
	ELSE
	BEGIN
			RAISERROR (N'用户名或密码有误！',  
           15,  
           1)  
	END
END







GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_APP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_APP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_APP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-25
-- Description:	发布应用
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_APP]
	 @ID AS BIGINT
	,@PAKCAGE_NAME AS NVARCHAR(100)
	,@APP_NAME AS NVARCHAR(50)
	,@GROUP_ID AS BIGINT
	,@ENABLE AS BIT
	,@DESCRIPTION AS NVARCHAR(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	IF @ID IS NULL 
	BEGIN
		INSERT INTO [ENT_ROBOT_APP]
				   (
				    [PACKAGE_NAME]
				   ,[APP_NAME]
				   ,[EXCLUSIVE]
				   ,[ENABLE]
				   ,[DESCRIPTION])
			 VALUES
				   (
				    @PAKCAGE_NAME
				   ,@APP_NAME
				   ,(CASE @GROUP_ID WHEN NULL THEN 0 ELSE 1 END)
				   ,@ENABLE
				   ,@DESCRIPTION)
		
		 SELECT @ID = ID FROM [ENT_ROBOT_APP] WHERE [APP_NAME] = @APP_NAME

		IF @GROUP_ID IS NOT NULL
			INSERT INTO [TBL_ROBOT_APP_EXCLUSIVE]
				(ROBOT_APP_ID
				,USER_GROUP_ID)
			 VALUES
				   (@ID
				   ,@GROUP_ID)

	END
	ELSE
		UPDATE [G2Robot].[dbo].[ENT_ROBOT_APP]
		SET 
		   [PACKAGE_NAME] = @PAKCAGE_NAME
		  ,[APP_NAME] = @APP_NAME
		  ,[ENABLE] = @ENABLE
		  ,[DESCRIPTION] = @DESCRIPTION
		 WHERE [ID] = @ID
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_APP_VERSION]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_APP_VERSION]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_APP_VERSION] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-25
-- Description:	发布版本
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_APP_VERSION]
		@ROBOT_APP_ID bigint
	   ,@VERSION_CODE bigint
	   ,@VERSION_NAME nvarchar(500)
	   ,@DOWNLOAD_URL nvarchar(500)
	   ,@RELEASE_NOTE nvarchar(500)
	   ,@ENABLED bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT * FROM TBL_ROBOT_APP_VERSION WHERE [ROBOT_APP_ID] = @ROBOT_APP_ID  AND [VERSION_CODE] = @VERSION_CODE)
		INSERT INTO  [TBL_ROBOT_APP_VERSION]
				   ([ROBOT_APP_ID]
				   ,[VERSION_CODE]
				   ,[VERSION_NAME]
				   ,[DOWNLOAD_URL]
				   ,[RELEASE_NOTE]
				   ,[PUBLISH_DATETIME]
				   ,[ENABLED])
			 VALUES
				   (@ROBOT_APP_ID
				   ,@VERSION_CODE
				   ,@VERSION_NAME
				   ,@DOWNLOAD_URL
				   ,@RELEASE_NOTE
				   ,getdate()
				   ,@ENABLED)
	ELSE
		UPDATE  [TBL_ROBOT_APP_VERSION]
		   SET
			   [VERSION_NAME] = @VERSION_NAME
			  ,[RELEASE_NOTE] = @RELEASE_NOTE
			  ,[ENABLED] = @ENABLED
		 WHERE [ROBOT_APP_ID] = @ROBOT_APP_ID  AND [VERSION_CODE] = @VERSION_CODE
	 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_CONFIG_DEFINE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_CONFIG_DEFINE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_CONFIG_DEFINE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-3-22
-- Description:	保存配置设置
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_CONFIG_DEFINE]
	 @NAME nvarchar(256)
	,@OWNER_ID bigint
	,@OWNER_TYPE bigint
	,@TYPE varchar(50)
	,@VALUE nvarchar(max)
	,@LEVEL bigint
	,@LIMIT_L varchar(50)
	,@LIMIT_H varchar(50)
	,@CANDIDATE nvarchar(4000)
	,@PATTERN varchar(50)
	,@DESCRIPTION nvarchar(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT  NAME FROM ENT_CONFIG WHERE NAME = @NAME)

		INSERT INTO [ENT_CONFIG]
				   ([NAME]
				   ,[OWNER_ID]
				   ,[OWNER_TYPE]
				   ,[TYPE]
				   ,[VALUE]
				   ,[LEVEL]
				   ,[LIMIT_L]
				   ,[LIMIT_H]
				   ,[CANDIDATE]
				   ,[PATTERN]
				   ,[DESCRIPTION])
			 VALUES
				   (@NAME
				   ,@OWNER_ID
				   ,@OWNER_TYPE
				   ,@TYPE
				   ,@VALUE
				   ,@LEVEL
				   ,@LIMIT_L
				   ,@LIMIT_H
				   ,@CANDIDATE
				   ,@PATTERN
				   ,@DESCRIPTION)
	 ELSE
 

		UPDATE [ENT_CONFIG]
		   SET [NAME] = @NAME
			  ,[OWNER_ID] = @OWNER_ID 
			  ,[OWNER_TYPE] = @OWNER_TYPE 
			  ,[TYPE] = @TYPE 
			  ,[VALUE] = @VALUE 
			  ,[LEVEL] = @LEVEL 
			  ,[LIMIT_L] = @LIMIT_L 
			  ,[LIMIT_H] = @LIMIT_H 
			  ,[CANDIDATE] = @CANDIDATE 
			  ,[PATTERN] = @PATTERN 
			  ,[DESCRIPTION] = @DESCRIPTION 
		WHERE NAME = @NAME




END

GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_CURR_TIMESTAMP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_CURR_TIMESTAMP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_CURR_TIMESTAMP] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-29
-- Description:	存储请求的时间点毫秒
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_CURR_TIMESTAMP] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select convert(varchar(23),getdate(),121)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_CUSROMER_ENROLL_INFO]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_CUSROMER_ENROLL_INFO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_CUSROMER_ENROLL_INFO] AS' 
END
GO


-- =============================================
-- Author:		洪江力
-- Create date: 2017-03-08
-- Description:	保存顾客注册的人脸相关联信息
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_CUSROMER_ENROLL_INFO]
			@ID					NVARCHAR(400) 
		  , @NAME				NVARCHAR(100) 
		  , @NICK_NAME			NVARCHAR(100) 
		  , @ENGLISH_NAME		NVARCHAR(100)
		  , @SEX				BIT
		  , @CUSTOMER_GROUP_ID  NVARCHAR(400)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	INSERT INTO ENT_CUSTOMER
		(ID
		, NAME
		, NICK_NAME
		, ENGLISH_NAME
		, SEX
		, CUSTOMER_GROUP_ID)
		VALUES(@ID
			, @NAME
			, @NICK_NAME
			, @ENGLISH_NAME
			, @SEX
			, @CUSTOMER_GROUP_ID)


	SELECT ID, NAME, NICK_NAME, ENGLISH_NAME, SEX, CUSTOMER_GROUP_ID FROM ENT_CUSTOMER WHERE ID = @ID
	
END



GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_KEY_WORD]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_KEY_WORD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_KEY_WORD] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	创建单词
-- 增加cat 的输入 2016-11-29
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_KEY_WORD](
	  @id as bigint
	, @kw as nvarchar(8)
	, @CAT AS BIGINT = 1
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @ID IS NULL OR @ID = 0
	BEGIN
		IF NOT EXISTS(SELECT * FROM [ENT_KEY_WORDS] where KW = @kw)
		BEGIN	
			INSERT INTO [ENT_KEY_WORDS]
			   ( 
				[KW]
			   ,[CAT])
			VALUES
			   ( 
				 @kw
			   , @cat)
		END
		SELECT [ID]
			  ,[KW]
			  ,[CAT]
			  ,SOUND
		  FROM [ENT_KEY_WORDS]	
		WHERE  [KW] = @KW
	END
	ELSE
	BEGIN
		UPDATE [ENT_KEY_WORDS] SET KW = @KW, CAT=@CAT WHERE ID = @ID	 

		SELECT [ID]
			  ,[KW]
			  ,[CAT]
			  ,SOUND
		  FROM  [ENT_KEY_WORDS]	
		WHERE  [ID] = @ID

	END
END




GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_REQUEST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_REQUEST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_REQUEST] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	保存请求
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_REQUEST]
	-- Add the parameters for the stored procedure here
	 @ID  nvarchar(120)
	,@PATH  nvarchar(2000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [ENT_REQUEST]
			   ([ID]
			   ,[PATH])
		 VALUES
			   (@ID
			   ,@PATH)	 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_REQUEST_PROPERTY]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_REQUEST_PROPERTY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_REQUEST_PROPERTY] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	保存请求属性
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_REQUEST_PROPERTY]
	-- Add the parameters for the stored procedure here
	@REQUEST_ID nvarchar(120)
	,@PROPERTY_NAME nvarchar(120)
	,@PROPERTY_VALUE nvarchar(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [TBL_REQUEST_PROPERTY]
			   ([REQUEST_ID]
			   ,[PROPERTY_NAME]
			   ,[PROPERTY_VALUE]
			   ,[IS_NUMERIC])
		 VALUES
			   (@REQUEST_ID 
			   ,@PROPERTY_NAME 
			   ,@PROPERTY_VALUE 
			   ,ISNUMERIC(@PROPERTY_VALUE))  
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_SESSION_CONTEXT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_SESSION_CONTEXT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_SESSION_CONTEXT] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-30
-- Description:	保存上下文信息
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_SESSION_CONTEXT]
			@ROBOT_ID  bigint
           ,@CTX_NAME  nvarchar(50)
           ,@CTX_VALUE  nvarchar(max)
           ,@EXPR_SECS  bigint = 30
           ,@DESCRIPTION  nvarchar(50) = 'N/A'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(SELECT [CTX_VALUE] FROM [TBL_ROBOT_SESSION_CONTEXT] WHERE [ROBOT_ID] = @ROBOT_ID AND [CTX_NAME] = @CTX_NAME)
		UPDATE  [TBL_ROBOT_SESSION_CONTEXT]
		   SET
			   [CTX_VALUE] = @CTX_VALUE
			  ,[EXPR_SECS] = @EXPR_SECS
			  ,[DESCRIPTION] = @DESCRIPTION
			  ,[CREATE_DATETIME] = GETDATE()
		 WHERE  [ROBOT_ID] = @ROBOT_ID AND [CTX_NAME] = @CTX_NAME	
	ELSE
		INSERT INTO [TBL_ROBOT_SESSION_CONTEXT]
			   ([ROBOT_ID]
			   ,[CTX_NAME]
			   ,[CTX_VALUE]
			   ,[EXPR_SECS]
			   ,[DESCRIPTION])
		 VALUES
			   (@ROBOT_ID
			   ,@CTX_NAME
			   ,@CTX_VALUE
			   ,@EXPR_SECS
			   ,@DESCRIPTION )
END




GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_SESSION_CONTEXT_SET_LOOKUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_SESSION_CONTEXT_SET_LOOKUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_SESSION_CONTEXT_SET_LOOKUP] AS' 
END
GO




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-1
-- Description:	设置 LOOKUP
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_SESSION_CONTEXT_SET_LOOKUP]
			@ROBOT_ID  bigint
           ,@LOOKUP_VOICE_GROUP_ID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC SP_SAVE_SESSION_CONTEXT @ROBOT_ID, 'LOOKUP', @LOOKUP_VOICE_GROUP_ID, 30, '启发下次会话'
END





GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_THIRD_PARTY_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_THIRD_PARTY_API] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	保存API
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_THIRD_PARTY_API]
	    @ID   BIGINT
	   ,@NAME NVARCHAR(50)
	   ,@URL NVARCHAR(1024)
	   ,@METHOD NVARCHAR(50)
	   ,@RESULT_TYPE NVARCHAR(50)
	   ,@RUN_AT_SERVER BIT
	   ,@ENABLED BIT
	   ,@DESCRIPTION NVARCHAR(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF @ID IS NULL OR @ID = 0
	BEGIN
 
		INSERT INTO [dbo].[ENT_THIRD_PARTY_API]
				   ([NAME]
				   ,[ENABLE]
				   ,[URL]
				   ,[METHOD]
				   ,[RUN_AT_SERVER]
				   ,[RESULT_TYPE]
				   ,[DESCRIPTION])
			 VALUES
				   (@NAME
				   ,@ENABLED
				   ,@URL
				   ,@METHOD
				   ,@RUN_AT_SERVER
				   ,@RESULT_TYPE
				   ,@DESCRIPTION)
 


			SELECT @ID = MAX(ID) FROM [ENT_THIRD_PARTY_API]
	END
	ELSE
 
		UPDATE [dbo].[ENT_THIRD_PARTY_API]
		   SET  
			   [NAME] = @NAME 
			  ,[ENABLE] = @ENABLED 
			  ,[URL] = @URL 
			  ,[METHOD] = @METHOD 
			  ,[RUN_AT_SERVER] = @RUN_AT_SERVER 
			  ,[RESULT_TYPE] = @RESULT_TYPE 
			  ,[DESCRIPTION] = @DESCRIPTION 
		 WHERE ID = @ID

		EXEC SP_GET_THIRD_PARTY_API_BY_ID @ID
END













GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_THIRD_PARTY_API_PARAM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	保存API PARAM
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM]
	    @ID   BIGINT
	   ,@NAME NVARCHAR(50)
	   ,@HEADER_0_BODY_1 BIT
	   ,@OPTIONAL BIT
	   ,@DEFAULT_VALUE NVARCHAR(500)
	   ,@DESCRIPTION NVARCHAR(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF @ID IS NULL OR @ID = 0
	BEGIN
 

		INSERT INTO [ENT_THIRD_PARTY_API_PARAM]
			   ([ID]
			   ,[NAME]
			   ,[HEADER_0_BODY_1]
			   ,[OPTIONAL]
			   ,[DEFAULT_VALUE]
			   ,[DESCRIPTION])
		 VALUES
			   (@ID
			   ,@NAME
			   ,@HEADER_0_BODY_1
			   ,@OPTIONAL
			   ,@DEFAULT_VALUE
			   ,@DESCRIPTION)

 


			SELECT @ID = MAX(ID) FROM [ENT_THIRD_PARTY_API_PARAM]
	END
	ELSE
 

		UPDATE [ENT_THIRD_PARTY_API_PARAM]
		   SET [ID] = @ID
			  ,[NAME] = @NAME
			  ,[HEADER_0_BODY_1] = @HEADER_0_BODY_1
			  ,[OPTIONAL] = @OPTIONAL
			  ,[DEFAULT_VALUE] = @DEFAULT_VALUE
			  ,[DESCRIPTION] = @DESCRIPTION
		WHERE ID = @ID

	
	EXEC SP_GET_THIRD_PARTY_API_PARAM_BY_ID @ID
END













GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_THIRD_PARTY_API_PARAM_VALUE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM_VALUE] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-11
-- Description:	保存API PARAM VALUE
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM_VALUE]
	    @ID   BIGINT
	   ,@NAME NVARCHAR(50)
	   ,@THIRD_PARTY_API_ID BIGINT
	   ,@ENABLED BIT
	   ,@DESCRIPTION NVARCHAR(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF @ID IS NULL OR @ID = 0
	BEGIN
  

	INSERT INTO [ENT_THIRD_PARTY_API_PARAM_VALUE]
			   (
			    NAME
			   ,[THIRD_PARTY_API_ID]
			   ,[ENABLED]
			   ,[DESCRIPTION])
		 VALUES
			   (
			    @NAME
			   ,@THIRD_PARTY_API_ID
			   ,@ENABLED
			   ,@DESCRIPTION)
 


 


			SELECT @ID = MAX(ID) FROM [ENT_THIRD_PARTY_API_PARAM_VALUE]
	END
	ELSE
 

		UPDATE [ENT_THIRD_PARTY_API_PARAM_VALUE]
		   SET [ID] = @ID
			  ,[NAME] = @NAME
			  ,[THIRD_PARTY_API_ID] = @THIRD_PARTY_API_ID
			  ,[ENABLED] = @ENABLED
			  ,[DESCRIPTION] = @DESCRIPTION
		WHERE ID = @ID

	
	SELECT VIEW_THIRD_PARTY_API_PARAM_VALUE.*from VIEW_THIRD_PARTY_API_PARAM_VALUE where VIEW_THIRD_PARTY_API_PARAM_VALUE.ID = @id
END













GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM_VALUE_ITEM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_THIRD_PARTY_API_PARAM_VALUE_ITEM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM_VALUE_ITEM] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-12
-- Description:	保存API PARAM VALUE ITEM
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_THIRD_PARTY_API_PARAM_VALUE_ITEM]
	    @THIRD_PARTY_API_PARAM_VALUE_ID   BIGINT
	   ,@THIRD_PARTY_API_PARAM_ID BIGINT
	   ,@PARAM_VALUE NVARCHAR(2000)
	   ,@DESCRIPTION NVARCHAR(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF NOT EXISTS(SELECT PARAM_VALUE FROM TBL_THIRD_PARTY_API_PARAM_VALUE WHERE
		THIRD_PARTY_API_PARAM_VALUE_ID = @THIRD_PARTY_API_PARAM_VALUE_ID
		AND THIRD_PARTY_API_PARAM_ID   = @THIRD_PARTY_API_PARAM_ID)
	BEGIN

		INSERT INTO [TBL_THIRD_PARTY_API_PARAM_VALUE]
				   ([THIRD_PARTY_API_PARAM_VALUE_ID]
				   ,[THIRD_PARTY_API_PARAM_ID]
				   ,[PARAM_VALUE]
				   ,[DESCRIPTION])
			 VALUES
				   (@THIRD_PARTY_API_PARAM_VALUE_ID
				   ,@THIRD_PARTY_API_PARAM_ID
				   ,@PARAM_VALUE
				   ,@DESCRIPTION)
	END
	ELSE
 

		UPDATE [TBL_THIRD_PARTY_API_PARAM_VALUE]
		   SET [PARAM_VALUE] = @PARAM_VALUE
			  ,[DESCRIPTION] = @DESCRIPTION
		 WHERE
		THIRD_PARTY_API_PARAM_VALUE_ID = @THIRD_PARTY_API_PARAM_VALUE_ID
		AND THIRD_PARTY_API_PARAM_ID   = @THIRD_PARTY_API_PARAM_ID

	
	SELECT VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM.*from VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM 
	where VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM.VALUE_ID = @THIRD_PARTY_API_PARAM_VALUE_ID
	AND   VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM.PARAM_ID = @THIRD_PARTY_API_PARAM_ID
END













GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_USER_FEEDBACK]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_USER_FEEDBACK]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_USER_FEEDBACK] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-5-24
-- Description:	保存主页用户意见反馈

--    	  name
--       email
--      subject
--      content
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_USER_FEEDBACK]
		@USER AS NVARCHAR(50)
		,@EMAIL AS NVARCHAR(128)
		,@TITLE AS NVARCHAR(256)
		,@CONTENT AS NVARCHAR(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [ENT_FEEDBACK]
           ([USER]
           ,[E_MAIL]
		   ,TITLE
           ,[CONTENT] )
     VALUES
           (@USER
           ,@EMAIL
		   ,@TITLE
           ,@CONTENT)

END

GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_USER_GROUP_SCENE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_USER_GROUP_SCENE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_USER_GROUP_SCENE] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-16
-- Description:	创建/更新用户场景
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_USER_GROUP_SCENE](
	  @id as bigint
	,  @group_id as bigint
	, @name as nvarchar(1024)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @ID IS NULL OR @ID = 0
	BEGIN
		IF NOT EXISTS(SELECT * FROM TBL_USER_GROUP_SCENE where id = @id)
		BEGIN
			INSERT INTO TBL_USER_GROUP_SCENE
			   ( 
				NAME
				,USER_GROUP_ID
				,DESCRIPTION)
			VALUES
			   ( 
				 @name
				 , @group_id
			   , '')

			   SELECT @ID = MAX(ID) FROM TBL_USER_GROUP_SCENE
		END 
	END
	ELSE
 
		UPDATE TBL_USER_GROUP_SCENE SET NAME = @name, USER_GROUP_ID=@group_id WHERE ID = @ID	 


 
	SELECT [ID]
		  ,[NAME]
		  ,[USER_GROUP_ID]
		  ,[USER_GROUP_NAME]
	  FROM  [VIEW_USER_GROUP_SCENE]
	WHERE ID = @ID 


 
 
END





GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_VOICE] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-22
-- Description:	语料编辑器提交语料
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_VOICE]
	    @ID   BIGINT
	   ,@NAME NVARCHAR(50)
	   ,@PATH NVARCHAR(1024)
	   ,@EMOTION NVARCHAR(1024)
	   ,@TEXT NVARCHAR(4000)
	   ,@COMMAND BIGINT
	   ,@COMMAND_PARAM NVARCHAR(MAX)
	   ,@THIRD_PARTY_API_ID BIGINT
	   ,@THIRD_PARTY_API_PARAMS_VALUE_ID BIGINT
	   ,@INC_PROP NVARCHAR(4000)
	   ,@EXC_PROP NVARCHAR(4000)
	   ,@CAT NVARCHAR(50)
	   ,@ENABLED BIT
	   ,@DESCRIPTION NVARCHAR(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	IF @ID IS NULL OR @ID = 0
	BEGIN
		INSERT INTO [ENT_VOICE]
				   ( 
				    [NAME]
				   ,[PATH]
				   ,[EMOTION]
				   ,[TEXT]
				   ,[COMMAND]
				   ,[COMMAND_PARAM]
				   ,[THIRD_PARTY_API_ID]
				   ,[THIRD_PARTY_API_PARAMS_VALUE_ID]
				   ,[INC_PROP]
				   ,[EXC_PROP]
				   ,[CAT]
				   ,[ENABLED]
				   ,[DESCRIPTION])
			 VALUES
				   ( 
				    @NAME
				   ,@PATH
				   ,@EMOTION
				   ,@TEXT
				   ,@COMMAND
				   ,@COMMAND_PARAM
				   ,@THIRD_PARTY_API_ID
				   ,@THIRD_PARTY_API_PARAMS_VALUE_ID
				   ,@INC_PROP
				   ,@EXC_PROP
				   ,@CAT
				   ,@ENABLED
				   ,@DESCRIPTION)
		SELECT @ID = MAX(ID) FROM ENT_VOICE
	END
	ELSE
		UPDATE  [ENT_VOICE]
		   SET  
			   [NAME] = @NAME
			  ,[PATH] = @PATH
			  ,[EMOTION] = @EMOTION
			  ,[TEXT] = @TEXT
			  ,[COMMAND] = @COMMAND
			  ,[COMMAND_PARAM] = @COMMAND_PARAM
			  ,[THIRD_PARTY_API_ID] = @THIRD_PARTY_API_ID
			  ,[THIRD_PARTY_API_PARAMS_VALUE_ID] = @THIRD_PARTY_API_PARAMS_VALUE_ID
			  ,[INC_PROP] = @INC_PROP
			  ,[EXC_PROP] = @EXC_PROP
			  ,[CAT] = @CAT
			  ,[ENABLED] = @ENABLED
			  ,[DESCRIPTION] = @DESCRIPTION
		 WHERE ID = @ID

	EXEC SP_GET_VOICE_BY_ID @ID
END













GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_VOICE_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_VOICE_GROUP] AS' 
END
GO




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-29
-- Description:	创建回答集
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_VOICE_GROUP](
	  @id   as bigint
	, @name as nvarchar(50)
	, @description as nvarchar(200)
	, @QUERY BIT = 1
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @ID IS NULL  OR @ID = 0
	BEGIN

		IF NOT EXISTS(SELECT * FROM [ENT_VOICE_GROUP] where [NAME] = @name)
		BEGIN
			INSERT INTO [ENT_VOICE_GROUP]
				   ([NAME]
				   ,[DESCRIPTION])
			 VALUES
				   (
				    @name
				   ,@description)
		END

		IF @QUERY = 1
			SELECT [ID]
					,[NAME]
					,[DESCRIPTION]
			FROM [ENT_VOICE_GROUP]	
			WHERE  [NAME] = @name
	END
	ELSE
	BEGIN
		UPDATE  [dbo].[ENT_VOICE_GROUP]
		SET
			   [NAME] = @NAME
			  ,[DESCRIPTION] = @description
		WHERE  [ID] = @ID

		IF @QUERY = 1
			SELECT   [ID]
					,[NAME]
					,[DESCRIPTION]
			FROM [ENT_VOICE_GROUP]	
			WHERE  [ID] = @ID

	END
	 
END





GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_VOICE_MANUAL]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_VOICE_MANUAL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_VOICE_MANUAL] AS' 
END
GO












-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-1-6
-- Description:	语料编辑器提交语料
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_VOICE_MANUAL]
		@ROBOT_ID BIGINT
	   ,@PATH NVARCHAR(1024)
	   ,@EMOTION NVARCHAR(1024)
	   ,@TEXT NVARCHAR(1024)
	   ,@COMMAND BIGINT
	   ,@COMMAND_PARAM NVARCHAR(MAX)
	   ,@THIRD_PARTY_API_ID BIGINT
	   ,@THIRD_PARTY_API_PARAMS_VALUE_ID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE @VOICE_ID BIGINT

	IF '.' = @TEXT
		SET @VOICE_ID = -1
	ELSE
	BEGIN
		INSERT INTO [ENT_VOICE]
					( 
					[NAME]
					,[PATH]
					,[EMOTION]
					,[TEXT]
					,[COMMAND]
					,[COMMAND_PARAM]
					,[THIRD_PARTY_API_ID]
					,[THIRD_PARTY_API_PARAMS_VALUE_ID]
					,[INC_PROP]
					,[EXC_PROP]
					,[CAT]
					,[ENABLED]
					,[DESCRIPTION])
				VALUES
					( 
					'人工模式'
					,@PATH
					,@EMOTION
					,@TEXT
					,@COMMAND
					,@COMMAND_PARAM
					,@THIRD_PARTY_API_ID
					,@THIRD_PARTY_API_PARAMS_VALUE_ID
					,''
					,''
					,'5'
					,1
					,'人工模式')
			SELECT @VOICE_ID = MAX(ID) FROM ENT_VOICE
		END

		IF EXISTS(SELECT VOICE_ID FROM [TBL_ROBOT_MANUAL_TALK_CACHE] WHERE ROBOT_ID = @ROBOT_ID)
			UPDATE [TBL_ROBOT_MANUAL_TALK_CACHE]
				SET VOICE_ID =	@VOICE_ID, CREATE_DATETIME = GETDATE()
			 WHERE ROBOT_ID = @ROBOT_ID
		ELSE
			INSERT INTO [TBL_ROBOT_MANUAL_TALK_CACHE]
					   ([ROBOT_ID]
					   ,[VOICE_ID])
				 VALUES
					   (@ROBOT_ID
					   ,@VOICE_ID)
	 
END













GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_WORD_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_WORD_GROUP] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	创建词组
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_WORD_GROUP](
	  @id   as bigint
	, @name as nvarchar(50)
	, @description as nvarchar(200)
	, @QUERY bit = 1
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @ID IS NULL  OR @ID = 0

	BEGIN

		IF NOT EXISTS(SELECT * FROM [ENT_WORD_GROUP] where [NAME] = @name)
		BEGIN
			INSERT INTO [ENT_WORD_GROUP]
				   ([NAME]
				   ,[DESCRIPTION])
			 VALUES
				   (
				    @name
				   ,@description)
		END

		IF @QUERY = 1
			SELECT [ID]
					,[NAME]
					,[DESCRIPTION]
			FROM [ENT_WORD_GROUP]	
			WHERE  [NAME] = @name
	END
	ELSE
	BEGIN
		UPDATE  [dbo].[ENT_WORD_GROUP]
		SET
			   [NAME] = @NAME
			  ,[DESCRIPTION] = @description
		WHERE  [ID] = @ID

		IF @QUERY = 1
			SELECT   [ID]
					,[NAME]
					,[DESCRIPTION]
			FROM [ENT_WORD_GROUP]	
			WHERE  [ID] = @ID

	END
	 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_WORD_GROUP_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_WORD_GROUP_FLOW] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-27
-- Description:	创建句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_WORD_GROUP_FLOW](
	  @id   as bigint
	, @name as nvarchar(50)
	, @description as nvarchar(200)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @ID IS NULL  OR @ID = 0
	BEGIN

		IF NOT EXISTS(SELECT * FROM [ENT_WORD_GROUP_FLOW] where [NAME] = @name)
		BEGIN
			INSERT INTO [ENT_WORD_GROUP_FLOW]
				   ([NAME]
				   ,[DESCRIPTION])
			 VALUES
				   (
				    @name
				   ,@description)
		END

		SELECT [ID]
				,[NAME]
				,[DESCRIPTION]
		FROM [ENT_WORD_GROUP_FLOW]	
		WHERE  [NAME] = @name
	END
	ELSE
	BEGIN
		UPDATE  [dbo].[ENT_WORD_GROUP_FLOW]
		SET
			   [NAME] = @NAME
			  ,[DESCRIPTION] = @description
		WHERE  [ID] = @ID

		SELECT   [ID]
				,[NAME]
				,[DESCRIPTION]
		FROM [ENT_WORD_GROUP_FLOW]	
		WHERE  [ID] = @ID

	END
	 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_SAVE_WORDS_OPERATION_LOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SAVE_WORDS_OPERATION_LOG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SAVE_WORDS_OPERATION_LOG] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-4-30
-- Description:	保存语料操作日志
-- =============================================
ALTER PROCEDURE [dbo].[SP_SAVE_WORDS_OPERATION_LOG]
	-- Add the parameters for the stored procedure here
	@ADMIN_NAME nvarchar(50)
	,@VERSION  nvarchar(20)
    ,@ACTION nvarchar(50)
    ,@OBJECT_NAME nvarchar(50)
    ,@VALUE_SET nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	IF DBO.FUNC_VERIFY_CLIENT_WORDS_VERSION(@VERSION) = 0
	BEGIN
			RAISERROR ('该客户端版本已不受支持',  15,  5) 
			RETURN
	END

	
	IF NOT EXISTS(SELECT * FROM ENT_ADMIN WHERE NAME = @ADMIN_NAME)
	BEGIN
			RAISERROR ('此用户无此操作权限！',  15,  5) 
			RETURN
	END

	 INSERT INTO  [TBL_OPERATION_LOG]
			   ([ADMIN_NAME]
			   ,[ACTION]
			   ,[OBJECT_NAME]
			   ,[VALUE_SET]
			   ,[DATE_TIME])
		 VALUES
			   (@ADMIN_NAME
			   ,@ACTION
			   ,isnull(@OBJECT_NAME, 0)
			   ,@VALUE_SET
			   ,GETDATE())
 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SELECT_THIRD_PARTY_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	SELECT API
-- =============================================
ALTER PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	IF @KW = '%<null>%'
		SELECT * 
		  FROM ENT_THIRD_PARTY_API	
		ORDER BY NAME
	ELSE

		SELECT * 
		  FROM ENT_THIRD_PARTY_API	
		WHERE [NAME] LIKE @KW
						OR CAST(ID AS NVARCHAR(20)) like @kw
		ORDER BY NAME
END












GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_BY_API_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_BY_API_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_BY_API_ID] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-12
-- Description:	通过 API ID 搜索API PARAM
-- =============================================
ALTER PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_BY_API_ID](
	@API_ID AS BIGINT,
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

    IF @KW = '%<null>%'

		SELECT ENT_THIRD_PARTY_API_PARAM.* 
		  FROM TBL_THIRD_PARTY_API_PARAM INNER JOIN
		  ENT_THIRD_PARTY_API_PARAM
		   ON (TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID = ENT_THIRD_PARTY_API_PARAM.ID
		   AND TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_ID = @API_ID
		   )	 
				ORDER BY ENT_THIRD_PARTY_API_PARAM.NAME
	ELSE
		SELECT ENT_THIRD_PARTY_API_PARAM.* 
		  FROM TBL_THIRD_PARTY_API_PARAM INNER JOIN
		  ENT_THIRD_PARTY_API_PARAM
		   ON (TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID = ENT_THIRD_PARTY_API_PARAM.ID
		   AND TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_ID = @API_ID
		   )	
		WHERE ENT_THIRD_PARTY_API_PARAM.[NAME] LIKE @KW
				OR ENT_THIRD_PARTY_API_PARAM.[DESCRIPTION] LIKE @KW
				ORDER BY ENT_THIRD_PARTY_API_PARAM.NAME

END












GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-11
-- Description:	搜索API PARAM 值组
-- =============================================
ALTER PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE](
    @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT * 
	  FROM VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE
           
    WHERE [NAME] LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) like @kw
			order by VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE.NAME
END












GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_API_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_API_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_API_ID] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-13
-- Description:	搜索API PARAM 值组， 按API_ID
-- =============================================
ALTER PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_API_ID](
	@API_ID AS BIGINT
    , @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

    IF @KW = '%<null>%'

		SELECT * 
		  FROM VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE
           
		WHERE 
				 VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE.API_ID = @API_ID
				 order by VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE.NAME
	ELSE
		SELECT * 
		  FROM VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE
           
		WHERE ([NAME] LIKE @KW
				--OR API_NAME LIKE @KW
				--OR [DESCRIPTION] LIKE @KW
						OR CAST(ID AS NVARCHAR(20)) like @kw)
			   AND VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE.API_ID = @API_ID
				 order by VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE.NAME

END












GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_ID] AS' 
END
GO











-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-13
-- Description:	搜索API PARAM 值组， 按API_ID
-- =============================================
ALTER PROCEDURE [dbo].[SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_ID](
	@API_ID AS BIGINT
    , @kw as nvarchar(30)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @KW = '%' + ISNULL(@KW, '') + '%'

	SELECT * 
	  FROM VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE
           
    WHERE ([NAME] LIKE @KW
			--OR API_NAME LIKE @KW
			--OR [DESCRIPTION] LIKE @KW
					OR CAST(ID AS NVARCHAR(20)) like @kw)
		   AND VIEW_THIRD_PARTY_PARAM_VALUE_SIMPLE.API_ID = @API_ID
END












GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SELECT_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SELECT_VOICE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2015-9-23
-- Description:	智能会话
-- =============================================
ALTER PROCEDURE [dbo].[SP_SELECT_VOICE]
(
	 @VOICE_GROUP_ID AS BIGINT
	,@MODEL AS NVARCHAR(1024) output
	,@VOICE_NAME AS NVARCHAR(50) output
	,@VOICE_PATH AS NVARCHAR(4000) output
	,@VOICE_TEXT AS NVARCHAR(max) output
	,@VOICE_EMOTION AS NVARCHAR(4000) output
	,@VOICE_COMMAND AS BIGINT output
	,@VOICE_COMMAND_PARAM AS NVARCHAR(max) output
    ,@VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  output
    ,@VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  output
    ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  output
    ,@VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  output
    ,@VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  output
    ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT OUTPUT
	,@VOICE_CAT  AS NVARCHAR(50) output
	,@VOICE_DESCRIPTION  AS NVARCHAR(1024) output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	DECLARE @VOICE_COUNT AS BIGINT
	DECLARE @VOICE_AMOUNT_COUNT AS BIGINT

	DECLARE @INDEX AS BIGINT 
	DECLARE @SQL AS NVARCHAR(4000)

	DECLARE @VOICE_INC_PROP AS NVARCHAR(4000)
	DECLARE @VOICE_EXC_PROP AS NVARCHAR(4000)
	
	PRINT 'SP_SELECT_VOICE'
	PRINT @VOICE_GROUP_ID
	
	SET @VOICE_COUNT = DBO.FUNC_GET_VOICE_COUNT(@VOICE_GROUP_ID, @MODEL)
 
	PRINT '@VOICE_COUNTT=' 
	PRINT @VOICE_COUNT

	SET @VOICE_COUNT = @VOICE_COUNT * RAND()
	PRINT 'SELECTED RAND INDEX =' 
	PRINT @VOICE_COUNT

	SET @INDEX = 0

	IF @VOICE_GROUP_ID = -1
		--- 遍历所有
		DECLARE WORD_GROUP_TO_VOICE_GROUP_CUSOR  
	 
		CURSOR FOR SELECT 
		   [VOICE_NAME]
		  ,[VOICE_PATH]
		  ,[VOICE_TEXT]
		  ,[VOICE_EMOTION]
		  ,[VOICE_CAT]
		  ,[VOICE_DESCRIPTION]
		  ,[VOICE_COMMAND]
		  ,[VOICE_COMMAND_PARAM]
		  ,[VOICE_THIRD_PARTY_API_NAME]
		  ,[VOICE_THIRD_PARTY_API_METHOD]
		  ,[VOICE_THIRD_PARTY_API_HEADER_PARAMS]
		  ,[VOICE_THIRD_PARTY_API_URL]
		  ,[VOICE_THIRD_PARTY_API_RESULT_TYPE]
		  ,[VOICE_THIRD_PARTY_API_RUN_AT_SERVER]
		  ,[VOICE_INC_PROP]
		  ,[VOICE_EXC_PROP]
  		 FROM VIEW_VOICE_GROUP
		 WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
		AND (CHARINDEX(@MODEL, ISNULL(VOICE_INC_PROP, @MODEL))>0)
		AND (CHARINDEX(@MODEL, ISNULL(VOICE_EXC_PROP, REVERSE(@MODEL))) = 0)
		AND [VOICE_CAT] = '2'
	ELSE
		DECLARE WORD_GROUP_TO_VOICE_GROUP_CUSOR  
	 
		CURSOR FOR SELECT 
		   [VOICE_NAME]
		  ,[VOICE_PATH]
		  ,[VOICE_TEXT]
		  ,[VOICE_EMOTION]
		  ,[VOICE_CAT]
		  ,[VOICE_DESCRIPTION]
		  ,[VOICE_COMMAND]
		  ,[VOICE_COMMAND_PARAM]
		  ,[VOICE_THIRD_PARTY_API_NAME]
		  ,[VOICE_THIRD_PARTY_API_METHOD]
		  ,[VOICE_THIRD_PARTY_API_HEADER_PARAMS]
		  ,[VOICE_THIRD_PARTY_API_URL]
		  ,[VOICE_THIRD_PARTY_API_RESULT_TYPE]
		  ,[VOICE_THIRD_PARTY_API_RUN_AT_SERVER]
		  ,[VOICE_INC_PROP]
		  ,[VOICE_EXC_PROP]
  		 FROM VIEW_VOICE_GROUP
		 WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
		AND (CHARINDEX(@MODEL, ISNULL(VOICE_INC_PROP, @MODEL))>0)
		AND (CHARINDEX(@MODEL, ISNULL(VOICE_EXC_PROP, REVERSE(@MODEL))) = 0)

	OPEN WORD_GROUP_TO_VOICE_GROUP_CUSOR
	FETCH NEXT FROM WORD_GROUP_TO_VOICE_GROUP_CUSOR INTO 
			   @VOICE_NAME
			  ,@VOICE_PATH
			  ,@VOICE_TEXT
              ,@VOICE_EMOTION
			  ,@VOICE_CAT
			  ,@VOICE_DESCRIPTION
			  ,@VOICE_COMMAND
			  ,@VOICE_COMMAND_PARAM
			  ,@VOICE_THIRD_PARTY_API_NAME
			  ,@VOICE_THIRD_PARTY_API_METHOD
			  ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS
			  ,@VOICE_THIRD_PARTY_API_URL
		      ,@VOICE_THIRD_PARTY_API_RESULT_TYPE
			  ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER
			  ,@VOICE_INC_PROP
			  ,@VOICE_EXC_PROP

	BEGIN 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			 IF @INDEX = @VOICE_COUNT 
			 BREAK

			 FETCH NEXT FROM WORD_GROUP_TO_VOICE_GROUP_CUSOR INTO 
			   @VOICE_NAME
			  ,@VOICE_PATH
			  ,@VOICE_TEXT
              ,@VOICE_EMOTION
			  ,@VOICE_CAT
			  ,@VOICE_DESCRIPTION
			  ,@VOICE_COMMAND
			  ,@VOICE_COMMAND_PARAM
			  ,@VOICE_THIRD_PARTY_API_NAME
			  ,@VOICE_THIRD_PARTY_API_METHOD
			  ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS
			  ,@VOICE_THIRD_PARTY_API_URL
		      ,@VOICE_THIRD_PARTY_API_RESULT_TYPE
			  ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER
			  ,@VOICE_INC_PROP
			  ,@VOICE_EXC_PROP

			 SET @INDEX = @INDEX + 1

		END
	END

	PRINT  @VOICE_NAME 

	CLOSE WORD_GROUP_TO_VOICE_GROUP_CUSOR
	DEALLOCATE WORD_GROUP_TO_VOICE_GROUP_CUSOR

	RETURN 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_VOICE_BY_ROBOT_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SELECT_VOICE_BY_ROBOT_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SELECT_VOICE_BY_ROBOT_ID] AS' 
END
GO









-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-22
-- Description:	智能会话 - 使用机器人ID选择
-- =============================================
ALTER PROCEDURE [dbo].[SP_SELECT_VOICE_BY_ROBOT_ID]
(
	 @VOICE_GROUP_ID AS BIGINT
	,@ROBOT_ID AS BIGINT OUTPUT
	,@VOICE_NAME AS NVARCHAR(50) output
	,@VOICE_PATH AS NVARCHAR(4000) output
	,@VOICE_TEXT AS NVARCHAR(max) output
	,@VOICE_EMOTION AS NVARCHAR(4000) output
	,@VOICE_COMMAND AS BIGINT output
	,@VOICE_COMMAND_PARAM AS NVARCHAR(max) output
    ,@VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  output
    ,@VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  output
    ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  output
    ,@VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  output
    ,@VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  output
    ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT OUTPUT
	,@VOICE_CAT  AS NVARCHAR(50) output
	,@VOICE_DESCRIPTION  AS NVARCHAR(1024) output
	,@VOICE_COUNT BIGINT
	,@MATCHED_DEGREE BIGINT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- DECLARE @VOICE_COUNT AS BIGINT
	-- DECLARE @MATCHED_DEGREE AS BIGINT
	DECLARE @VOICE_AMOUNT_COUNT AS BIGINT

	DECLARE @INDEX AS BIGINT 
	DECLARE @SQL AS NVARCHAR(4000)

	DECLARE @VOICE_INC_PROP AS NVARCHAR(4000)
	DECLARE @VOICE_EXC_PROP AS NVARCHAR(4000)
	
	PRINT 'SP_SELECT_VOICE'
	PRINT @VOICE_GROUP_ID

	IF ISNULL(@MATCHED_DEGREE, 0) = 0 
	BEGIN
		PRINT '没有匹配度，按无法回答重新查找'
		SET @VOICE_GROUP_ID = -1
		EXEC SP_GET_VOICE_COUNT_BY_ROBOT_ID  
			  @VOICE_GROUP_ID
			, @ROBOT_ID
			, @VOICE_COUNT OUTPUT
			, @MATCHED_DEGREE OUTPUT
	END
 
	PRINT '@VOICE_GROUP_ID=' 
	PRINT @VOICE_GROUP_ID
	PRINT '@ROBOT_ID=' 
	PRINT @VOICE_GROUP_ID
	PRINT '@VOICE_COUNTT=' 
	PRINT @VOICE_COUNT
	PRINT '@MATCHED_DEGREE=' 
	PRINT @MATCHED_DEGREE

	IF @VOICE_COUNT = 0
	BEGIN
		PRINT '噪声'

		SET @VOICE_NAME = '噪音'
		SET @VOICE_CAT = '2'
		SET @VOICE_COMMAND = 0
		SET @VOICE_TEXT = ''
		RETURN
	END

	SET @VOICE_COUNT = @VOICE_COUNT * RAND()

	PRINT 'SELECTED RAND INDEX =' 
	PRINT @VOICE_COUNT

	SET @INDEX = 0

	IF @VOICE_GROUP_ID = -1
	BEGIN
		PRINT '无法应答中获取' 

		--- 遍历所有
		DECLARE WORD_GROUP_TO_VOICE_GROUP_CUSOR  
	 
		CURSOR FOR SELECT 
		   [VOICE_NAME]
		  ,[VOICE_PATH]
		  ,[VOICE_TEXT]
		  ,[VOICE_EMOTION]
		  ,[VOICE_CAT]
		  ,[VOICE_DESCRIPTION]
		  ,[VOICE_COMMAND]
		  ,[VOICE_COMMAND_PARAM]
		  ,[VOICE_THIRD_PARTY_API_NAME]
		  ,[VOICE_THIRD_PARTY_API_METHOD]
		  ,[VOICE_THIRD_PARTY_API_HEADER_PARAMS]
		  ,[VOICE_THIRD_PARTY_API_URL]
		  ,[VOICE_THIRD_PARTY_API_RESULT_TYPE]
		  ,[VOICE_THIRD_PARTY_API_RUN_AT_SERVER]
		  ,[VOICE_INC_PROP]
		  ,[VOICE_EXC_PROP]
  		 FROM VIEW_VOICE_GROUP
		 WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
		AND [VOICE_CAT] = '2'
		AND [VOICE_ENABLED] = 1
 	    AND DBO.FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4(ID, @ROBOT_ID) = @MATCHED_DEGREE
	END
	ELSE
	BEGIN
		PRINT '指定组中获取, 组，匹配度'
		PRINT @VOICE_GROUP_ID
		PRINT @MATCHED_DEGREE

		DECLARE WORD_GROUP_TO_VOICE_GROUP_CUSOR  
	 
		CURSOR FOR SELECT 
		   [VOICE_NAME]
		  ,[VOICE_PATH]
		  ,[VOICE_TEXT]
		  ,[VOICE_EMOTION]
		  ,[VOICE_CAT]
		  ,[VOICE_DESCRIPTION]
		  ,[VOICE_COMMAND]
		  ,[VOICE_COMMAND_PARAM]
		  ,[VOICE_THIRD_PARTY_API_NAME]
		  ,[VOICE_THIRD_PARTY_API_METHOD]
		  ,[VOICE_THIRD_PARTY_API_HEADER_PARAMS]
		  ,[VOICE_THIRD_PARTY_API_URL]
		  ,[VOICE_THIRD_PARTY_API_RESULT_TYPE]
		  ,[VOICE_THIRD_PARTY_API_RUN_AT_SERVER]
		  ,[VOICE_INC_PROP]
		  ,[VOICE_EXC_PROP]
  		 FROM VIEW_VOICE_GROUP
		 WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
		AND [VOICE_ENABLED] = 1
 	    AND DBO.FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4(ID, @ROBOT_ID) = @MATCHED_DEGREE
	END
	OPEN WORD_GROUP_TO_VOICE_GROUP_CUSOR
	FETCH NEXT FROM WORD_GROUP_TO_VOICE_GROUP_CUSOR INTO 
			   @VOICE_NAME
			  ,@VOICE_PATH
			  ,@VOICE_TEXT
              ,@VOICE_EMOTION
			  ,@VOICE_CAT
			  ,@VOICE_DESCRIPTION
			  ,@VOICE_COMMAND
			  ,@VOICE_COMMAND_PARAM
			  ,@VOICE_THIRD_PARTY_API_NAME
			  ,@VOICE_THIRD_PARTY_API_METHOD
			  ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS
			  ,@VOICE_THIRD_PARTY_API_URL
		      ,@VOICE_THIRD_PARTY_API_RESULT_TYPE
			  ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER
			  ,@VOICE_INC_PROP
			  ,@VOICE_EXC_PROP

	BEGIN 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			 IF @INDEX = @VOICE_COUNT 
			 BEGIN
				PRINT '找到，游标完成'
				BREAK
			 END

			 FETCH NEXT FROM WORD_GROUP_TO_VOICE_GROUP_CUSOR INTO 
			   @VOICE_NAME
			  ,@VOICE_PATH
			  ,@VOICE_TEXT
              ,@VOICE_EMOTION
			  ,@VOICE_CAT
			  ,@VOICE_DESCRIPTION
			  ,@VOICE_COMMAND
			  ,@VOICE_COMMAND_PARAM
			  ,@VOICE_THIRD_PARTY_API_NAME
			  ,@VOICE_THIRD_PARTY_API_METHOD
			  ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS
			  ,@VOICE_THIRD_PARTY_API_URL
		      ,@VOICE_THIRD_PARTY_API_RESULT_TYPE
			  ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER
			  ,@VOICE_INC_PROP
			  ,@VOICE_EXC_PROP

 			 SET @INDEX = @INDEX + 1
		END
	END

	PRINT  '关闭游标'

	CLOSE WORD_GROUP_TO_VOICE_GROUP_CUSOR
	DEALLOCATE WORD_GROUP_TO_VOICE_GROUP_CUSOR

	PRINT  @VOICE_NAME 

	RETURN 
END









GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_VOICE_BY_TAGS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SELECT_VOICE_BY_TAGS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SELECT_VOICE_BY_TAGS] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-22
-- Description:	智能会话
-- =============================================
ALTER PROCEDURE [dbo].[SP_SELECT_VOICE_BY_TAGS]
(
	 @VOICE_GROUP_ID AS BIGINT
	,@TAGS AS NVARCHAR(1024) output
	,@VOICE_NAME AS NVARCHAR(50) output
	,@VOICE_PATH AS NVARCHAR(4000) output
	,@VOICE_TEXT AS NVARCHAR(max) output
	,@VOICE_EMOTION AS NVARCHAR(4000) output
	,@VOICE_COMMAND AS BIGINT output
	,@VOICE_COMMAND_PARAM AS NVARCHAR(max) output
    ,@VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  output
    ,@VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  output
    ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  output
    ,@VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  output
    ,@VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  output
    ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT OUTPUT
	,@VOICE_CAT  AS NVARCHAR(50) output
	,@VOICE_DESCRIPTION  AS NVARCHAR(1024) output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	DECLARE @VOICE_COUNT AS BIGINT
	DECLARE @VOICE_AMOUNT_COUNT AS BIGINT

	DECLARE @INDEX AS BIGINT 
	DECLARE @SQL AS NVARCHAR(4000)

	DECLARE @VOICE_INC_PROP AS NVARCHAR(4000)
	DECLARE @VOICE_EXC_PROP AS NVARCHAR(4000)
	
	PRINT 'SP_SELECT_VOICE'
	PRINT @VOICE_GROUP_ID

 	SET @VOICE_COUNT = DBO.FUNC_GET_VOICE_COUNT_BY_TAGS(@VOICE_GROUP_ID, @TAGS)
 
	PRINT '@VOICE_COUNTT=' 
	PRINT @VOICE_COUNT

	SET @VOICE_COUNT = @VOICE_COUNT * RAND()
	PRINT 'SELECTED RAND INDEX =' 
	PRINT @VOICE_COUNT

	SET @INDEX = 0

	IF @VOICE_GROUP_ID = -1
		--- 遍历所有
		DECLARE WORD_GROUP_TO_VOICE_GROUP_CUSOR  
	 
		CURSOR FOR SELECT 
		   [VOICE_NAME]
		  ,[VOICE_PATH]
		  ,[VOICE_TEXT]
		  ,[VOICE_EMOTION]
		  ,[VOICE_CAT]
		  ,[VOICE_DESCRIPTION]
		  ,[VOICE_COMMAND]
		  ,[VOICE_COMMAND_PARAM]
		  ,[VOICE_THIRD_PARTY_API_NAME]
		  ,[VOICE_THIRD_PARTY_API_METHOD]
		  ,[VOICE_THIRD_PARTY_API_HEADER_PARAMS]
		  ,[VOICE_THIRD_PARTY_API_URL]
		  ,[VOICE_THIRD_PARTY_API_RESULT_TYPE]
		  ,[VOICE_THIRD_PARTY_API_RUN_AT_SERVER]
		  ,[VOICE_INC_PROP]
		  ,[VOICE_EXC_PROP]
  		 FROM VIEW_VOICE_GROUP
		 WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
 	    AND DBO.FUNC_AUTHENTICATE_PASSPORT(@TAGS, VOICE_INC_PROP) = 1
		AND [VOICE_CAT] = '2'
	ELSE
		DECLARE WORD_GROUP_TO_VOICE_GROUP_CUSOR  
	 
		CURSOR FOR SELECT 
		   [VOICE_NAME]
		  ,[VOICE_PATH]
		  ,[VOICE_TEXT]
		  ,[VOICE_EMOTION]
		  ,[VOICE_CAT]
		  ,[VOICE_DESCRIPTION]
		  ,[VOICE_COMMAND]
		  ,[VOICE_COMMAND_PARAM]
		  ,[VOICE_THIRD_PARTY_API_NAME]
		  ,[VOICE_THIRD_PARTY_API_METHOD]
		  ,[VOICE_THIRD_PARTY_API_HEADER_PARAMS]
		  ,[VOICE_THIRD_PARTY_API_URL]
		  ,[VOICE_THIRD_PARTY_API_RESULT_TYPE]
		  ,[VOICE_THIRD_PARTY_API_RUN_AT_SERVER]
		  ,[VOICE_INC_PROP]
		  ,[VOICE_EXC_PROP]
  		 FROM VIEW_VOICE_GROUP
		 WHERE 
			(VOICE_GROUP_ID = @VOICE_GROUP_ID)
 	     AND DBO.FUNC_AUTHENTICATE_PASSPORT(@TAGS, VOICE_INC_PROP) = 1
 
	OPEN WORD_GROUP_TO_VOICE_GROUP_CUSOR
	FETCH NEXT FROM WORD_GROUP_TO_VOICE_GROUP_CUSOR INTO 
			   @VOICE_NAME
			  ,@VOICE_PATH
			  ,@VOICE_TEXT
              ,@VOICE_EMOTION
			  ,@VOICE_CAT
			  ,@VOICE_DESCRIPTION
			  ,@VOICE_COMMAND
			  ,@VOICE_COMMAND_PARAM
			  ,@VOICE_THIRD_PARTY_API_NAME
			  ,@VOICE_THIRD_PARTY_API_METHOD
			  ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS
			  ,@VOICE_THIRD_PARTY_API_URL
		      ,@VOICE_THIRD_PARTY_API_RESULT_TYPE
			  ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER
			  ,@VOICE_INC_PROP
			  ,@VOICE_EXC_PROP

	BEGIN 
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			 IF @INDEX = @VOICE_COUNT 
			 BREAK

			 FETCH NEXT FROM WORD_GROUP_TO_VOICE_GROUP_CUSOR INTO 
			   @VOICE_NAME
			  ,@VOICE_PATH
			  ,@VOICE_TEXT
              ,@VOICE_EMOTION
			  ,@VOICE_CAT
			  ,@VOICE_DESCRIPTION
			  ,@VOICE_COMMAND
			  ,@VOICE_COMMAND_PARAM
			  ,@VOICE_THIRD_PARTY_API_NAME
			  ,@VOICE_THIRD_PARTY_API_METHOD
			  ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS
			  ,@VOICE_THIRD_PARTY_API_URL
		      ,@VOICE_THIRD_PARTY_API_RESULT_TYPE
			  ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER
			  ,@VOICE_INC_PROP
			  ,@VOICE_EXC_PROP

 			 SET @INDEX = @INDEX + 1
		END
	END

	PRINT  @VOICE_NAME 

	CLOSE WORD_GROUP_TO_VOICE_GROUP_CUSOR
	DEALLOCATE WORD_GROUP_TO_VOICE_GROUP_CUSOR

	RETURN 
END



GO
/****** Object:  StoredProcedure [dbo].[SP_SET_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_CONFIG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_CONFIG] AS' 
END
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_CONFIG](
	-- Add the parameters for the stored procedure here
	@uid as bigint,
	@gid as bigint,
	@rid as bigint,
	@ck  as nvarchar(256),
	@cv  as nvarchar(max),
	@des  as nvarchar(128)
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF @gid is not null 
	IF EXISTS(
		SELECT [NAME] FROM TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP 
		WHERE [NAME] = @ck AND   USER_GROUP_ID = @gid
    )

		UPDATE  TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP
		   SET  
			   [NAME] = @ck
			  ,[VALUE] = @cv
			  ,[DESCRIPTION] = @des
		 WHERE  [NAME] = @ck AND  USER_GROUP_ID = @gid
	ELSE
		INSERT INTO TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP
				   ([USER_GROUP_ID]
				   ,[NAME]
				   ,[VALUE]
				   ,[DESCRIPTION])
			 VALUES
				   (@gid
				   ,@ck
				   ,@cv
				   ,@des)


IF @rid is not null 
	IF EXISTS(
		SELECT [NAME] FROM [TBL_CUSTOMIZED_CONFIG_FOR_ROBOT] 
		WHERE [NAME] = @ck AND   robot_id = @rid
		)

		UPDATE  [TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]
		   SET  
			   [NAME] = @ck
			  ,[VALUE] = @cv
			  ,[DESCRIPTION] = @des
		 WHERE  [NAME] = @ck AND  robot_id = @rid
	ELSE
		INSERT INTO  [TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]
			   ([ROBOT_ID]
			   ,[NAME]
			   ,[VALUE]
			   ,[DESCRIPTION])
		 VALUES
			   (@rid
			   ,@ck
			   ,@cv
			   ,@des)

IF @GID is null and @RID is null
	IF EXISTS(
		SELECT [NAME] FROM ENT_CONFIG 
		WHERE [NAME] = @ck  )

		UPDATE  ENT_CONFIG
		   SET  
			   [NAME] = @ck
			  ,[VALUE] = @cv
			  ,[DESCRIPTION] = @des
		 WHERE  [NAME] = @ck 
	ELSE
		INSERT INTO  ENT_CONFIG
			    ([NAME]
			   ,[VALUE]
			   ,[DESCRIPTION])
		 VALUES
			   ( 
			    @ck
			   ,@cv
			   ,@des)


   
END




GO
/****** Object:  StoredProcedure [dbo].[SP_SET_CUSTOMIZED_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_CUSTOMIZED_CONFIG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_CUSTOMIZED_CONFIG] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-16
-- Description:	增加客制化配置
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_CUSTOMIZED_CONFIG](
	-- Add the parameters for the stored procedure here
	@uid as bigint,
	@owner_id as bigint,
	@priority as bigint,
	@ck  as nvarchar(256),
	@cv  as nvarchar(max)
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF @priority = 1
	IF EXISTS(
		SELECT [NAME] FROM TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY 
		WHERE [NAME] = @ck AND   TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY.INDUSTRY_ID  = @owner_id
    )

		UPDATE  TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY
		   SET  
			   [NAME] = @ck
			  ,[VALUE] = @cv 
		 WHERE  [NAME] = @ck AND  INDUSTRY_ID = @owner_id
	ELSE
		INSERT INTO TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY
				   (INDUSTRY_ID
				   ,[NAME]
				   ,[VALUE]
				   ,[DESCRIPTION])
			 VALUES
				   (@owner_id
				   ,@ck
				   ,@cv
				   ,'')

IF @priority = 3 
	IF EXISTS(
		SELECT [NAME] FROM TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP 
		WHERE [NAME] = @ck AND   USER_GROUP_ID = @owner_id
    )

		UPDATE  TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP
		   SET  
			   [NAME] = @ck
			  ,[VALUE] = @cv 
		 WHERE  [NAME] = @ck AND  USER_GROUP_ID = @owner_id
	ELSE
		INSERT INTO TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP
				   ([USER_GROUP_ID]
				   ,[NAME]
				   ,[VALUE]
				   ,[DESCRIPTION])
			 VALUES
				   (@owner_id
				   ,@ck
				   ,@cv
				   ,'')


	IF @priority = 5
		IF EXISTS(
			SELECT [NAME] FROM TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE 
			WHERE [NAME] = @ck AND   USER_GROUP_SCENE_ID = @owner_id
			)

			UPDATE  TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE
			   SET  
				   [NAME] = @ck
				  ,[VALUE] = @cv
			 WHERE  [NAME] = @ck AND  USER_GROUP_SCENE_ID = @owner_id
		ELSE
			INSERT INTO  TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE
				   (USER_GROUP_SCENE_ID
				   ,[NAME]
				   ,[VALUE]
				   ,[DESCRIPTION])
			 VALUES
				   (@owner_id
				   ,@ck
				   ,@cv
				   ,'')

	IF @priority = 7
		IF EXISTS(
			SELECT [NAME] FROM [TBL_CUSTOMIZED_CONFIG_FOR_ROBOT] 
			WHERE [NAME] = @ck AND   robot_id = @owner_id
			)

			UPDATE  [TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]
			   SET  
				   [NAME] = @ck
				  ,[VALUE] = @cv
			 WHERE  [NAME] = @ck AND  robot_id = @owner_id
		ELSE
			INSERT INTO  [TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]
				   ([ROBOT_ID]
				   ,[NAME]
				   ,[VALUE]
				   ,[DESCRIPTION])
			 VALUES
				   (@owner_id
				   ,@ck
				   ,@cv
				   ,'')

  -- 机器硬件配置，优先级无比高
 	IF @priority = 255
		IF EXISTS(
			SELECT [NAME] FROM TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC 
			WHERE [NAME] = @ck AND   HW_SPEC_ID = @owner_id
			)

			UPDATE  TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC
			   SET  
				   [NAME] = @ck
				  ,[VALUE] = @cv
			 WHERE  [NAME] = @ck AND  HW_SPEC_ID = @owner_id
		ELSE
			INSERT INTO  TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC
				   (HW_SPEC_ID
				   ,[NAME]
				   ,[VALUE]
				   ,[DESCRIPTION])
			 VALUES
				   (@owner_id
				   ,@ck
				   ,@cv
				   ,'')
   
END





GO
/****** Object:  StoredProcedure [dbo].[SP_SET_KEY_WORD_TO_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_KEY_WORD_TO_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_KEY_WORD_TO_GROUP] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-28
-- Description:	将关键词加入词组
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_KEY_WORD_TO_GROUP]
		    @GROUP_ID AS BIGINT
		  , @KEY_WORD_ID AS BIGINT
		--  , @DESCRIPTION AS NVARCHAR(1024)
		  , @CREATE BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @CREATE = 1 
	BEGIN
		IF NOT EXISTS(SELECT * FROM [TBL_WORD_GROUP] WHERE 
			GROUP_ID = @GROUP_ID AND KEY_WORD_ID = @KEY_WORD_ID)
			INSERT INTO [TBL_WORD_GROUP]
					   ([GROUP_ID]
					   ,[KEY_WORD_ID]
					  -- ,[DESCRIPTION]
				)
				 VALUES
					   (@GROUP_ID
					   ,@KEY_WORD_ID
					  -- ,@DESCRIPTION
				)    
	END
	ELSE
		DELETE [TBL_WORD_GROUP] WHERE 
			GROUP_ID = @GROUP_ID AND KEY_WORD_ID = @KEY_WORD_ID
	
END




GO
/****** Object:  StoredProcedure [dbo].[SP_SET_ONLINE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_ONLINE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_ONLINE] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-3-30
-- Description: 机器人登录
/*

1. 根据 IMEI, USERNAME, PASSWORD 找出机器人的资料， 验证用户， 

输入：
UserAgent
UserName  
password
IMEI

输出：
code	
message	
id	
name	
activateDatetime	
lastestLoginDatetime	
loginCount	
user[+d].id	
user[+d].status	
user[+d].name	
user[+d].groupName	


*/

-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_ONLINE] 
	-- Add the parameters for the stored procedure here
	@EP_ID  AS BIGINT,
	@SESSION_ID AS NVARCHAR(4000)  -- IN

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
 	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ID AS BIGINT
	DECLARE @RTC_SESSION_ID AS BIGINT

	SET @ID = -1
	
	SELECT @ID = USER_ID FROM VIEW_USER_ROBOT_BIND_LIST 
	WHERE USER_LASTEST_STATUS_WSS_SESSION_ID = @SESSION_ID
	AND   USER_LASTEST_STATUS_ONLINE = 0 

	IF @ID <> -1
	BEGIN
		
		INSERT INTO [TBL_USER_STATUS]
			   ([USER_ID]
			   ,[UPDATE_DATETIME]
			   ,[ONLINE]
			   ,[EXTRA_INFO]
			   ,[WSS_SESSION_ID])
		 VALUES
			   (@ID
			   , GETDATE()
			   , 1
			   , NULL
			   , @SESSION_ID)	
		RETURN
	END

	SET @ID = -1

	SELECT @ID = ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST 
	WHERE ROBOT_LATEST_STATUS_WSS_SESSION_ID = @SESSION_ID
--	AND   ROBOT_LATEST_STATUS_ONLINE = 0

	IF  @ID = -1
		INSERT INTO [TBL_ROBOT_STATUS]
			   ([ROBOT_ID]
			   ,[UPDATE_DATETIME]
			   ,[ONLINE]
			   ,[EXTRA_INFO]
			   ,[WSS_SESSION_ID])
		 VALUES
			   (@EP_ID
			   , GETDATE()
			   , 1
			   , NULL
			   , @SESSION_ID)		
	 
END







GO
/****** Object:  StoredProcedure [dbo].[SP_SET_RECORD_REQ_OFF]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_RECORD_REQ_OFF]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_RECORD_REQ_OFF] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-4-15
-- Description:	关闭记录属性
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_RECORD_REQ_OFF]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE ENT_SYSTEM_META_SETTINGS SET  VALUE = 0 WHERE NAME = 'RECORD_REQUEST_PROPERTY'
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SET_ROBOT_ONLINE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_ROBOT_ONLINE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_ROBOT_ONLINE] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-3-30
-- Description: 机器人登录
/*

1. 根据 IMEI, USERNAME, PASSWORD 找出机器人的资料， 验证用户， 

输入：
UserAgent
UserName  
password
IMEI

输出：
code	
message	
id	
name	
activateDatetime	
lastestLoginDatetime	
loginCount	
user[+d].id	
user[+d].status	
user[+d].name	
user[+d].groupName	


*/

-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_ROBOT_ONLINE] 
	-- Add the parameters for the stored procedure here
	@SN  AS NVARCHAR(20),
	@SESSION_ID AS NVARCHAR(4000)  -- IN

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
 	-- interfering with SELECT statements.

	IF NOT EXISTS(
	SELECT  ROBOT_ID FROM VIEW_USER_ROBOT_BIND_LIST 
	WHERE ROBOT_LATEST_STATUS_WSS_SESSION_ID = @SESSION_ID
    AND ROBOT_IMEI = @SN)


		INSERT INTO [TBL_ROBOT_STATUS]
			   ([ROBOT_ID]
			   ,[UPDATE_DATETIME]
			   ,[ONLINE]
			   ,[EXTRA_INFO]
			   ,[WSS_SESSION_ID])
		 VALUES
			   (DBO.FUNC_GET_ROBOT_ID_BY_SN(@SN)
			   , GETDATE()
			   , 1
			   , NULL
			   , @SESSION_ID)		
	 
END







GO
/****** Object:  StoredProcedure [dbo].[SP_SET_ROBOT_TO_USER_GROUP_SCENE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_ROBOT_TO_USER_GROUP_SCENE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_ROBOT_TO_USER_GROUP_SCENE] AS' 
END
GO



-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-16
-- Description:	将机器人加入场景
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_ROBOT_TO_USER_GROUP_SCENE]
		    @SCENE_ID AS BIGINT
		  , @ROBOT_ID AS BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 
	update ENT_ROBOT SET USER_GROUP_SCENE_ID = @SCENE_ID WHERE ID = @ROBOT_ID
	
END





GO
/****** Object:  StoredProcedure [dbo].[SP_SET_THIRD_PARTY_API_PARAM_TO_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_THIRD_PARTY_API_PARAM_TO_API]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_THIRD_PARTY_API_PARAM_TO_API] AS' 
END
GO




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-8
-- Description:	将API PARAM加入API
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_THIRD_PARTY_API_PARAM_TO_API]
		    @API_ID AS BIGINT
		  , @PARAM_ID AS BIGINT
		  , @CREATE BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @CREATE = 1 
	BEGIN
		IF NOT EXISTS(SELECT * FROM TBL_THIRD_PARTY_API_PARAM WHERE 
			THIRD_PARTY_API_ID = @API_ID AND THIRD_PARTY_API_PARAM_ID = @PARAM_ID)
			INSERT INTO TBL_THIRD_PARTY_API_PARAM
					   (THIRD_PARTY_API_ID
					   ,THIRD_PARTY_API_PARAM_ID
					  -- ,[DESCRIPTION]
				)
				 VALUES
					   (@API_ID
					   ,@PARAM_ID
					  -- ,@DESCRIPTION
				)    
	END
	ELSE
		DELETE TBL_THIRD_PARTY_API_PARAM WHERE 
			THIRD_PARTY_API_ID = @API_ID AND THIRD_PARTY_API_PARAM_ID = @PARAM_ID
	
END





GO
/****** Object:  StoredProcedure [dbo].[SP_SET_VOICE_ENABLED]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_VOICE_ENABLED]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_VOICE_ENABLED] AS' 
END
GO


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-03
-- Description:	应答有效性设定
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_VOICE_ENABLED]
		@ID AS BIGINT
		,@ENABLED AS BIT
AS
BEGIN
	UPDATE ENT_VOICE SET ENABLED = @ENABLED WHERE ID = @ID
END



GO
/****** Object:  StoredProcedure [dbo].[SP_SET_VOICE_TO_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_VOICE_TO_GROUP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_VOICE_TO_GROUP] AS' 
END
GO




-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-04
-- Description:	将应答加入应答组
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_VOICE_TO_GROUP]
		    @GROUP_ID AS BIGINT
		  , @VOICE_ID AS BIGINT
		--  , @DESCRIPTION AS NVARCHAR(1024)
		  , @CREATE BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @CREATE = 1 
	BEGIN
		IF NOT EXISTS(SELECT * FROM TBL_VOICE_GROUP WHERE 
			ID = @GROUP_ID AND VOICE_ID = @VOICE_ID)
			INSERT INTO TBL_VOICE_GROUP
					   (ID
					   ,VOICE_ID
					  -- ,[DESCRIPTION]
				)
				 VALUES
					   (@GROUP_ID
					   ,@VOICE_ID
					  -- ,@DESCRIPTION
				)    
	END
	ELSE
		DELETE TBL_VOICE_GROUP WHERE 
			ID = @GROUP_ID AND VOICE_ID = @VOICE_ID
	
END





GO
/****** Object:  StoredProcedure [dbo].[SP_SET_WORD_GROUP_FLOW_TO_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_WORD_GROUP_FLOW_TO_VOICE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_WORD_GROUP_FLOW_TO_VOICE] AS' 
END
GO







-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-28
-- Description:	将句法匹配回答集
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_WORD_GROUP_FLOW_TO_VOICE]
			@ID AS BIGINT
		  , @WORD_GROUP_FLOW_ID AS BIGINT
		  , @VOICE_GROUP_ID AS BIGINT
		  , @DESCRIPTION AS NVARCHAR(1024)
		  , @ENABLE BIT
		  , @USE_FULLY_MATCH BIT
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	IF @ID = 0  OR @ID IS NULL 
	BEGIN
		IF NOT EXISTS(SELECT * FROM TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE WHERE 
			@WORD_GROUP_FLOW_ID = WORD_GROUP_FLOW_ID AND @VOICE_GROUP_ID = VOICE_GROUP_ID)

		INSERT INTO [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]
				   ( 
				    [WORD_GROUP_FLOW_ID]
				   ,[VOICE_GROUP_ID]
				   ,[DESCRIPTION]
				   ,[ENABLE]
				   ,[USE_FULLY_MATCH])
			 VALUES
				   ( 
				     @WORD_GROUP_FLOW_ID
				   , @VOICE_GROUP_ID
				   , @DESCRIPTION
				   , @ENABLE
				   , @USE_FULLY_MATCH)
	END
	ELSE	
	BEGIN
		
				UPDATE [TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE] 
				SET   [USE_FULLY_MATCH] = @USE_FULLY_MATCH
				    , [ENABLE] = @ENABLE 
					, WORD_GROUP_FLOW_ID = @WORD_GROUP_FLOW_ID 
					, VOICE_GROUP_ID = @VOICE_GROUP_ID
					, DESCRIPTION = @DESCRIPTION
				WHERE ID = @ID

	END
	
	IF @ID = 0  OR @ID IS NULL 

		SELECT [ID]
			  ,[FLOW_ID]
			  ,[FLOW_NAME]
			  ,[VOICE_ID]
			  ,[VOICE_NAME]
			  ,[ENABLE]
			  ,[USE_FULLY_MATCH]
			  ,[DESCRIPTION]			  
		  FROM  [VIEW_FLOW_VOICE_RULE]	
			WHERE @WORD_GROUP_FLOW_ID = [FLOW_ID] AND @VOICE_GROUP_ID = [VOICE_ID]				
	else
		SELECT [ID]
			  ,[FLOW_ID]
			  ,[FLOW_NAME]
			  ,[VOICE_ID]
			  ,[VOICE_NAME]
			  ,[ENABLE]
			  ,[USE_FULLY_MATCH]
			  ,[DESCRIPTION]
		  FROM  [VIEW_FLOW_VOICE_RULE]	
			  
			WHERE  ID = @ID	
	
		-- EXEC SP_GET_RULE @DESCRIPTION
END






GO
/****** Object:  StoredProcedure [dbo].[SP_SET_WORD_GROUP_TO_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SET_WORD_GROUP_TO_FLOW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SET_WORD_GROUP_TO_FLOW] AS' 
END
GO






-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-28
-- Description:	将词组设置到句法
-- =============================================
ALTER PROCEDURE [dbo].[SP_SET_WORD_GROUP_TO_FLOW]
		    @ID AS BIGINT
		  , @WORD_GROUP_ID AS BIGINT
		  , @CREATE BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @CREATE = 1 
	BEGIN
		IF NOT EXISTS(SELECT * FROM [TBL_WORD_GROUP_FLOW] WHERE 
			ID = @ID 
			AND @WORD_GROUP_ID = WORD_GROUP_ID)
		INSERT INTO [TBL_WORD_GROUP_FLOW]
				   ([ID]
				   ,[WORD_GROUP_ID]
					)
			 VALUES
				   (@ID
				   ,@WORD_GROUP_ID
					) 
	END
	ELSE
		DELETE [TBL_WORD_GROUP_FLOW] WHERE 
			ID = @ID 
			AND @WORD_GROUP_ID = WORD_GROUP_ID
END





GO
/****** Object:  StoredProcedure [dbo].[SP_SMART_DIALOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SMART_DIALOG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SMART_DIALOG] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-29
-- Description: 加入音匹配，可选全匹配
-- 2016-12-09   手工模式在业务端判断
-- 2016-12-15   不嵌套调用存储过程
-- =============================================
ALTER PROCEDURE [dbo].[SP_SMART_DIALOG]
(
	@REQUEST_ID NVARCHAR(120)
	,@DEBUG BIT = 0
)
AS

	DECLARE @VOICE_NAME AS NVARCHAR(50) 
	DECLARE @VOICE_PATH AS NVARCHAR(4000) 
	DECLARE @VOICE_TEXT AS NVARCHAR(4000) 
	DECLARE @VOICE_EMOTION AS NVARCHAR(4000) 
	DECLARE @VOICE_COMMAND AS BIGINT 
	DECLARE @VOICE_COMMAND_PARAM AS NVARCHAR(max) 
    DECLARE @VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  
    DECLARE @VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT 
	DECLARE @VOICE_CAT  AS NVARCHAR(50) 
	DECLARE @VOICE_DESCRIPTION  AS NVARCHAR(1024) 

	DECLARE @VOICE_ID AS BIGINT
	DECLARE @GRANULARITY AS BIGINT
	DECLARE @VOICE_GROUP_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
	DECLARE @ACT_CNT AS BIGINT

	DECLARE @MAX_ACT_CNT AS BIGINT
	DECLARE @MAX_MATCHED_VOICE_GROUP_ID AS BIGINT

	DECLARE @VOICE_COUNT AS BIGINT 
	DECLARE @USE_FULLY_MATCH AS BIT
	DECLARE @TAGS AS NVARCHAR(1024)
	DECLARE @INPUT_STRING AS NVARCHAR(4000)
	DECLARE @LEXER AS NVARCHAR(MAX)
    DECLARE @IMEI  AS NVARCHAR(1024)

	DECLARE @ROBOT_ID AS BIGINT
	DECLARE @MATCHED_DEGREE AS BIGINT
	DECLARE @MANUAL_MODE AS BIT
 
	DECLARE @UA NVARCHAR(4000)
	DECLARE @VER NVARCHAR(120)
	DECLARE @ENABLED_CHAT BIT

    SET NOCOUNT ON;

	SET @MAX_ACT_CNT = 0
	SET @VOICE_COUNT = 0
	SET @ROBOT_ID = NULL
	SET @MAX_MATCHED_VOICE_GROUP_ID = -1
	SET @MATCHED_DEGREE = 0

	-- 获取 input
	-- 获取 sn 
	-- 获取 robotid
	SELECT 
	  @INPUT_STRING = INPUT
    , @LEXER = ENT_REQUEST.lexer
	, @IMEI = SN
	, @VER  = ENT_REQUEST.h_version
	, @UA   = ENT_REQUEST.user_agent
	FROM ENT_REQUEST WHERE ID = @REQUEST_ID

	IF @UA IS NOT NULL AND
		DBO.FUNC_CHECK_ROBOT_APP_VERSION_REQUIRED(@IMEI, 1469460853347, @VER) = 0 
		SET @MAX_MATCHED_VOICE_GROUP_ID = 1692

	SET @ENABLED_CHAT = CAST(DBO.FUNC_GET_CONFIG_VALUE(@IMEI, 'enable_chat', '1') AS BIT)

	IF @ENABLED_CHAT = 0 
		SET @MAX_MATCHED_VOICE_GROUP_ID = 1734


	SELECT @ROBOT_ID = ID , @MANUAL_MODE = MANUAL_MODE  FROM ENT_ROBOT WHERE IMEI = @IMEI	

	IF @DEBUG = 1 
	BEGIN
		PRINT '输入字串：' + @INPUT_STRING + ' SN :' + @IMEI
		PRINT 'LEXER：' + @LEXER
		PRINT 'ROBOT_ID：' 
		PRINT @ROBOT_ID
	END

	-- 获取 tags
	SELECT @TAGS = [VALUE] FROM  VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER WHERE [ROBOT_IMEI] = @IMEI AND [NAME] = 'chat_mode'
	-- 刷新TAGS, robotId
	UPDATE ENT_REQUEST SET TAG = @TAGS WHERE ID = @REQUEST_ID
	UPDATE ENT_REQUEST SET ROBOT_ID = @ROBOT_ID WHERE ID = @REQUEST_ID
		

	IF @DEBUG = 1 
	BEGIN
		PRINT '清空请求属性组'
		DELETE TBL_REQUEST_PROPERTY
		PRINT '生成请求属性'
	END

	EXEC SP_GEN_REQUEST_PROPERTY @REQUEST_ID


	IF NOT EXISTS(SELECT TAG FROM TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID AND TAG_STR = @TAGS)
	BEGIN			

		IF @DEBUG = 1 
		BEGIN
			PRINT 'TAG字符串：' + @TAGS
			PRINT '重新生成机器人TAG'
		END

		DELETE 	TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID
		INSERT INTO TBL_ROBOT_TAGS
		SELECT @ROBOT_ID AS ROBOT_ID, TAG, @TAGS AS TAG_STR FROM FUNC_GET_TAGS_TABLE(@TAGS)
	END

	-- 回收过期的上下文信息
	EXEC SP_COLLECT_SESSION_CONTEXT

	DECLARE @PINYIN VARCHAR(8000)

	-- 加入拼音
	SELECT  @PINYIN  =  DBO.FUNC_GET_PINYIN(  @INPUT_STRING)

	IF @DEBUG = 1 
	BEGIN
		PRINT '拼音：' + @PINYIN
	END

	-- 0. 人工模式
	IF @MANUAL_MODE = 1 OR @INPUT_STRING = '^'
	BEGIN
		SET @VOICE_ID = dbo.FUNC_GET_MANUAL_VOICE(@ROBOT_ID)
		-- 取完就删， MANUAL_CACHE
		DELETE TBL_ROBOT_MANUAL_TALK_CACHE WHERE ROBOT_ID = @ROBOT_ID

		-- 人工voice 已定义
		IF ISNULL(@VOICE_ID, -1) <> -1
		BEGIN
			GOTO VOICE_ID_READY
		END
	END

	-- 上下文动态 LOOK UP 第一优先级
	IF @MAX_MATCHED_VOICE_GROUP_ID = -1  
		SET @MAX_MATCHED_VOICE_GROUP_ID 
			= CAST(DBO.FUNC_GET_CONTEXT_VALUE(@ROBOT_ID, 'LOOKUP', '-1') AS BIGINT)

	-- 预置 LOOK UP 第二优先级 
	IF @MAX_MATCHED_VOICE_GROUP_ID = -1  
		SET @MAX_MATCHED_VOICE_GROUP_ID =
		CAST
		(
			(
				SELECT ISNULL([VALUE], '-1') FROM [VIEW_ROBOT_MAX_PRIORITY_CONFIG] 
				WHERE [ROBOT_IMEI] = @IMEI AND NAME = 'LOOKUP_VOICE_GROUP'
			) AS BIGINT
		)

	IF @DEBUG = 1 
	BEGIN
		PRINT '期望应答组'
		PRINT @MAX_MATCHED_VOICE_GROUP_ID
	END

	IF @MAX_MATCHED_VOICE_GROUP_ID = -1 
	BEGIN
		-- 客户自定义资料第三优先级
		SET @VOICE_ID =
		(  
			SELECT TOP 1 TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID
			FROM      VIEW_USER_ROBOT_BIND_LIST
				   , TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL
				   , VIEW_VOICE
			WHERE   
				   TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID = VIEW_VOICE.ID
				AND TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.GEN_DATETIME IS NULL
				AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = @ROBOT_ID  
				AND VIEW_USER_ROBOT_BIND_LIST.USER_ID = TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID  	
				AND VIEW_VOICE.ENABLED = 1
				AND @INPUT_STRING LIKE '%' + REQUEST + '%'   
		)

		IF @DEBUG = 1 
		BEGIN
			PRINT '客户原始规则应答'
			PRINT ISNULL(@VOICE_ID, -1)
		END

	END

	IF @VOICE_ID IS NULL AND @MAX_MATCHED_VOICE_GROUP_ID = -1
		-- 扩展语义第四优先级
	BEGIN

		IF @DEBUG = 1 
		BEGIN
			PRINT '扩展语义'
		END

		DECLARE CUR_CHECK_KW_ENTIRELY
		CURSOR FOR 

		SELECT KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT,  MIN(LEN(KEY_WORD)) AS GRANULARITY
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
		WHERE 		 
		(
			CHARINDEX(KEY_WORD, @INPUT_STRING) > 0   
			OR 
			(
				(
					KEY_WORD_CATEGORY = 0 
					OR GROUP_FLOW_USE_SOUND = 1
				) 
				AND  
				CHARINDEX(KEY_WORD_SOUND, @PINYIN) > 0     
			)
		)
		GROUP BY KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID
		ORDER BY USE_FULLY_MATCH DESC, CNT DESC

		OPEN CUR_CHECK_KW_ENTIRELY

		FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
		@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT, @GRANULARITY
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
			WHERE ID = @KEY_WORD_GROUP_FLOW_ID

			-- 放入推荐列表
			INSERT INTO [TBL_REQUEST_RECOMMEND]
					   ([REQUEST_ID]
					   ,[RECOMMEND_FLOW_ID]
					   ,[MATCHED_DEGREE]
					   ,[GRANULARITY])
				 VALUES
					   (@REQUEST_ID
					   ,@KEY_WORD_GROUP_FLOW_ID
					   ,@KEY_WORD_GROUP_ID_COUNT
					   ,@GRANULARITY)

			IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT
			-- 输入分词数多于规则包含词，则为匹配规则
			BEGIN

				IF @DEBUG = 1 
				BEGIN
					PRINT '找到匹配'
					PRINT '  @KEY_WORD_GROUP_FLOW_ID = ' + CAST (@KEY_WORD_GROUP_FLOW_ID AS VARCHAR(20))
						+ '  @VOICE_GROUP_ID = ' + CAST (@VOICE_GROUP_ID AS VARCHAR(20))
						+ '  @KEY_WORD_GROUP_ID_COUNT = ' + CAST (@KEY_WORD_GROUP_ID_COUNT AS VARCHAR(20))
				END

				-- 先严格匹配
				-- 规则是否为严格匹配，严格匹配走严格匹配规则
				IF  @USE_FULLY_MATCH = 1
				BEGIN
					IF DBO.FUNC_IS_FULLY_MATCHED(@INPUT_STRING, @KEY_WORD_GROUP_FLOW_ID) = 1 
					BEGIN
					-- 严格匹配成功
						IF @DEBUG = 1 
						BEGIN
							PRINT '使用严格匹配'
						END

						SELECT TOP 1 @MATCHED_DEGREE = 
								MAX(DBO.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID))
						FROM VIEW_VOICE_GROUP
						WHERE 
							(VOICE_GROUP_ID = @VOICE_GROUP_ID)

						IF @DEBUG = 1 
						BEGIN
							PRINT '最大 TAG 匹配度'  + CAST (@MATCHED_DEGREE AS VARCHAR(20))
						END

						IF @MATCHED_DEGREE > 0
						BEGIN
							SELECT  @VOICE_COUNT = COUNT(ID)
							FROM
							(
								SELECT ID, dbo.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID) AS DEGREE
								FROM VIEW_VOICE_GROUP
								WHERE (VOICE_GROUP_ID = @VOICE_GROUP_ID)
							) SUB
							WHERE DEGREE = @MATCHED_DEGREE

						END

						-- 应答数
						IF @VOICE_COUNT > 0 
						BEGIN
							IF @DEBUG = 1 
							BEGIN
								PRINT '严格匹配应答数:'
								PRINT ' @VOICE_COUNT = ' + CAST (@VOICE_COUNT AS VARCHAR(20))
							END

							SET @MAX_ACT_CNT = @ACT_CNT
							SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
							BREAK
						END
						ELSE
						BEGIN
							PRINT '严格匹配应答数为0, 放弃'
							GOTO NEXT_ITEM
						END
					END	
					ELSE
					BEGIN
						PRINT '使用严格失败！'
						GOTO NEXT_ITEM
					END
				END

				IF @MAX_ACT_CNT < @ACT_CNT
				BEGIN


					IF @DEBUG = 1 
					BEGIN
						PRINT '候选更优匹配，应答组='
						PRINT @VOICE_GROUP_ID
					END
				
					SELECT TOP 1 @MATCHED_DEGREE = 
							MAX(DBO.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID))
					FROM VIEW_VOICE_GROUP
					WHERE 
						(VOICE_GROUP_ID = @VOICE_GROUP_ID)

					PRINT '最大 TAG 匹配度 = '
					PRINT @MATCHED_DEGREE

					IF @MATCHED_DEGREE > 0
					BEGIN
							SELECT  @VOICE_COUNT = COUNT(ID)
							FROM
							(
								SELECT ID, dbo.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID) AS DEGREE
								FROM VIEW_VOICE_GROUP
								WHERE (VOICE_GROUP_ID = @VOICE_GROUP_ID)
							) SUB
							WHERE DEGREE = @MATCHED_DEGREE

					END
											 

					IF @DEBUG = 1 
					BEGIN
						PRINT '应答数:'
						PRINT ' @VOICE_COUNT = ' + CAST (@VOICE_COUNT AS VARCHAR(20))
					END

					IF @VOICE_COUNT > 0 
					BEGIN
						SET @MAX_ACT_CNT = @ACT_CNT
						SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID

						IF @DEBUG = 1 
						BEGIN
							PRINT '找到更优匹配:'
							PRINT ' NEW MAX MATCHED @MAX_MATCHED_VOICE_GROUP_ID = ' + CAST (@MAX_MATCHED_VOICE_GROUP_ID AS VARCHAR(20))
							+ ' @MAX_ACT_CNT = ' + CAST (@MAX_ACT_CNT AS VARCHAR(20))

						END
					END
				END
			END

			NEXT_ITEM:
			FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
			@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT, @GRANULARITY
		END
		CLOSE CUR_CHECK_KW_ENTIRELY
		DEALLOCATE CUR_CHECK_KW_ENTIRELY		
	END
	ELSE
	BEGIN
	-- 非扩展语义，匹配度1
		SET @MATCHED_DEGREE = 1

		IF @MAX_MATCHED_VOICE_GROUP_ID <> -1
			SELECT  @VOICE_COUNT = COUNT(ID)
			FROM
			(
				SELECT ID, dbo.[FUNC_AUTHENTICATE_PASSPORT_BY_ROBOT_ID_V4](ID, @ROBOT_ID) AS DEGREE
				FROM VIEW_VOICE_GROUP
				WHERE (VOICE_GROUP_ID = @MAX_MATCHED_VOICE_GROUP_ID)
			) SUB
			WHERE DEGREE = @MATCHED_DEGREE

	END

	IF @DEBUG = 1 
	BEGIN
		PRINT '扩展语义结果'
		PRINT ' @MAX_MATCHED_VOICE_GROUP_ID = ' + CAST (@MAX_MATCHED_VOICE_GROUP_ID AS VARCHAR(20))
		PRINT ' @VOICE_ID = ' + CAST (@VOICE_ID AS VARCHAR(20))

	END

	VOICE_ID_READY:
	IF @VOICE_ID IS NOT NULL
	BEGIN
		IF @DEBUG = 1 
		BEGIN
			PRINT '直接输出 voice_id' 
			PRINT @VOICE_ID
		END

		SELECT  
			   @VOICE_NAME = [NAME]
			  ,@VOICE_PATH = [PATH]
			  ,@VOICE_TEXT = [TEXT]
			  ,@VOICE_CAT = [CAT]
			  ,@VOICE_DESCRIPTION = [DESCRIPTION]
			  ,@VOICE_COMMAND = [COMMAND]
			  ,@VOICE_COMMAND_PARAM = [COMMAND_PARAM]
			  ,@VOICE_THIRD_PARTY_API_NAME =  [THIRD_PARTY_API_NAME]
			  ,@VOICE_THIRD_PARTY_API_METHOD =  [THIRD_PARTY_API_METHOD]
			  ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS = [THIRD_PARTY_API_HEADER_PARAMS]
			  ,@VOICE_THIRD_PARTY_API_URL = [THIRD_PARTY_API_URL]
			  ,@VOICE_THIRD_PARTY_API_RESULT_TYPE =  [THIRD_PARTY_API_RESULT_TYPE]
			  ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER =  [THIRD_PARTY_API_RUN_AT_SERVER]
			  ,@VOICE_EMOTION =  [EMOTION]
		  FROM [VIEW_VOICE] WHERE ID = @VOICE_ID
	END
	ELSE
	BEGIN
		IF @DEBUG = 1 
		BEGIN
			PRINT '选择 voice id，从group' 
			PRINT @MAX_MATCHED_VOICE_GROUP_ID
		END


		EXEC SP_SELECT_VOICE_BY_ROBOT_ID
			 @MAX_MATCHED_VOICE_GROUP_ID
			,@ROBOT_ID
			,@VOICE_NAME output
			,@VOICE_PATH output
			,@VOICE_TEXT output
			,@VOICE_EMOTION output
			,@VOICE_COMMAND    output
			,@VOICE_COMMAND_PARAM output
			,@VOICE_THIRD_PARTY_API_NAME OUTPUT
			,@VOICE_THIRD_PARTY_API_METHOD OUTPUT
			,@VOICE_THIRD_PARTY_API_HEADER_PARAMS OUTPUT
			,@VOICE_THIRD_PARTY_API_URL OUTPUT
			,@VOICE_THIRD_PARTY_API_RESULT_TYPE output
			,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER output
			,@VOICE_CAT  output
			,@VOICE_DESCRIPTION    output
			,@VOICE_COUNT
			,@MATCHED_DEGREE	
	END

	SET @VOICE_CAT = ISNULL(@VOICE_CAT, '2')

	IF @DEBUG = 1 
	BEGIN
		PRINT 'config 代入，第一轮'
	END

	-- 替换config参数
	SET @VOICE_PATH = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_PATH, @IMEI)
	SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_EMOTION, @IMEI)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)

	IF @DEBUG = 1 
	BEGIN
		PRINT 'request 代入，第一轮'
	END

	-- 替换request 参数
	SET @VOICE_TEXT = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_TEXT, @REQUEST_ID)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_EMOTION, @REQUEST_ID)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_COMMAND_PARAM, @REQUEST_ID)
	SET @VOICE_THIRD_PARTY_API_URL = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_THIRD_PARTY_API_URL, @REQUEST_ID)

	IF @DEBUG = 1 
	BEGIN
		PRINT 'context 代入，第一轮'
	END
	-- 替换 context 参数
	SET @VOICE_TEXT = dbo.FUNC_FILLED_SESSION_CONTEXT_VALUE(@VOICE_TEXT, @ROBOT_ID)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_SESSION_CONTEXT_VALUE(@VOICE_EMOTION, @ROBOT_ID)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_SESSION_CONTEXT_VALUE(@VOICE_COMMAND_PARAM, @ROBOT_ID)
	SET @VOICE_THIRD_PARTY_API_URL = dbo.FUNC_FILLED_SESSION_CONTEXT_VALUE(@VOICE_THIRD_PARTY_API_URL, @ROBOT_ID)

	IF @DEBUG = 1 
	BEGIN
		PRINT '数据库例程'
	END

	-- 数据库命令
	IF @VOICE_COMMAND = 1433
	BEGIN
		IF @DEBUG = 1 
		BEGIN
			PRINT '1433 数据库例程'
		END

		EXEC SP_EXECUTESQL @VOICE_COMMAND_PARAM
        , N'@VOICE_COMMAND BIGINT OUTPUT, @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT, @VOICE_TEXT NVARCHAR(1024) OUTPUT '
		, @VOICE_COMMAND OUTPUT
		, @VOICE_COMMAND_PARAM OUTPUT
		, @VOICE_TEXT OUTPUT 

		IF @DEBUG = 1 
		BEGIN
			PRINT 'config 代入，第二轮'
		END
		-- 对计算结果再做一轮config参数替换
		SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
		SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)

		IF @DEBUG = 1 
		BEGIN
			PRINT 'request 代入，第二轮'
		END
		-- 对计算结果再做一轮request参数替换
		SET @VOICE_TEXT = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_TEXT, @REQUEST_ID)
		SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_COMMAND_PARAM, @REQUEST_ID)

		IF @DEBUG = 1 
		BEGIN
			PRINT 'context 代入，第二轮'
		END
		-- 对计算结果再做一轮context参数替换
		SET @VOICE_TEXT = dbo.FUNC_FILLED_SESSION_CONTEXT_VALUE(@VOICE_TEXT, @ROBOT_ID)
		SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_SESSION_CONTEXT_VALUE(@VOICE_COMMAND_PARAM, @ROBOT_ID)

	END

	IF @DEBUG = 1 
	BEGIN
		PRINT '噪声判断'
	END

	IF  @VOICE_CAT = '2' AND 
		(
			CAST(DBO.FUNC_GET_CONTEXT_VALUE(@ROBOT_ID, 'UNKONW_COUNT', '0') AS BIGINT) >=
			CAST(DBO.FUNC_GET_CONFIG_VALUE(@IMEI, 'MAX_UNKONW_COUNT', '0') AS BIGINT)
		)
	BEGIN
		IF @DEBUG = 1 
		BEGIN
			PRINT '噪声'
		END

		SET @VOICE_NAME = '噪音'
		SET @VOICE_CAT = '2'
		SET @VOICE_COMMAND = 0
		SET @VOICE_TEXT = ''
	END


	IF  @VOICE_CAT = '5'  
	BEGIN
		IF @DEBUG = 1 
		BEGIN
			PRINT '人工模式，用完即删除'
		END

		DELETE ENT_VOICE WHERE ID = @VOICE_ID

	END


	LAST_STEP:

	IF @DEBUG = 1 
	BEGIN
		PRINT '最后一步，输出'
	END

	SELECT
		 0 AS ID
		,@MAX_MATCHED_VOICE_GROUP_ID VOICE_GROUP_ID
		,' ' AS VOICE_INC_PROP
		,' ' AS VOICE_EXC_PROP
		,ISNULL(@VOICE_NAME, '') AS VOICE_NAME
		,ISNULL(@VOICE_PATH , '') AS VOICE_PATH
		,ISNULL(@VOICE_TEXT, '') AS VOICE_TEXT
		,ISNULL(@VOICE_EMOTION, '') AS VOICE_EMOTION
		,ISNULL(@VOICE_COMMAND, 0)    AS VOICE_COMMAND
		,ISNULL(@VOICE_COMMAND_PARAM, '') AS VOICE_COMMAND_PARAM
		,ISNULL(@VOICE_THIRD_PARTY_API_NAME , '')AS VOICE_THIRD_PARTY_API_NAME
		,ISNULL(@VOICE_THIRD_PARTY_API_METHOD, '') AS VOICE_THIRD_PARTY_API_METHOD
		,ISNULL(@VOICE_THIRD_PARTY_API_HEADER_PARAMS, '') AS VOICE_THIRD_PARTY_API_HEADER_PARAMS
		,ISNULL(@VOICE_THIRD_PARTY_API_URL, '') AS VOICE_THIRD_PARTY_API_URL
		,ISNULL(@VOICE_THIRD_PARTY_API_RESULT_TYPE, '') AS VOICE_THIRD_PARTY_API_RESULT_TYPE
		,ISNULL(@VOICE_THIRD_PARTY_API_RUN_AT_SERVER, '') AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER
		,ISNULL(@VOICE_CAT, '')  AS VOICE_CAT
		,ISNULL(@VOICE_DESCRIPTION, '')    AS VOICE_DESCRIPTION	
		,1 AS VOICE_ENABLED
  
SET NOCOUNT OFF







GO
/****** Object:  StoredProcedure [dbo].[SP_SMART_DIALOG_1ST]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SMART_DIALOG_1ST]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SMART_DIALOG_1ST] AS' 
END
GO













-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-1
-- Description:	新的开放式自动问答
-- 输入词本身模糊匹配 2016-7-23
-- =============================================
ALTER PROCEDURE [dbo].[SP_SMART_DIALOG_1ST]
(
	 @INPUT_STRING AS NVARCHAR(1024)
	,@MODLE AS NVARCHAR(1024)
    ,@IMEI  AS NVARCHAR(1024)
	,@VOICE_NAME AS NVARCHAR(50) output
	,@VOICE_PATH AS NVARCHAR(4000) output
	,@VOICE_TEXT AS NVARCHAR(4000) output
	,@VOICE_EMOTION AS NVARCHAR(4000) output
	,@VOICE_COMMAND AS BIGINT output
	,@VOICE_COMMAND_PARAM AS NVARCHAR(max) output
    ,@VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  output
    ,@VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  output
    ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  output
    ,@VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  output
    ,@VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  output
    ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT OUTPUT
	,@VOICE_CAT  AS NVARCHAR(50) output
	,@VOICE_DESCRIPTION  AS NVARCHAR(1024) output
)
AS

DECLARE @VOICE_GROUP_ID AS BIGINT
DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
DECLARE @ACT_CNT AS BIGINT

DECLARE @MAX_ACT_CNT AS BIGINT
DECLARE @MAX_MATCHED_VOICE_GROUP_ID AS BIGINT
SET @MAX_ACT_CNT = 0

 
DECLARE CUR_CHECK_KW_ENTIRELY
CURSOR FOR 

SELECT KEY_WORD_GROUP_FLOW_ID, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT
FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
WHERE 
(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 1) AND ENABLE = 1
GROUP BY KEY_WORD_GROUP_FLOW_ID, VOICE_GROUP_ID
ORDER BY CNT DESC

OPEN CUR_CHECK_KW_ENTIRELY

FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
@KEY_WORD_GROUP_FLOW_ID, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
	WHERE ID = @KEY_WORD_GROUP_FLOW_ID AND INC_1_EXC_0 = 1

	PRINT 'FLOW_ID=' + CAST(@KEY_WORD_GROUP_FLOW_ID AS NVARCHAR(20))
		+ '; @VOICE_GROUP_ID=' + CAST(@VOICE_GROUP_ID AS NVARCHAR(20))
		+ '; WORD_GROUP_ID_CNT=' + CAST(@ACT_CNT AS NVARCHAR(20))
		+ '; FOUND=' + CAST(@KEY_WORD_GROUP_ID_COUNT AS NVARCHAR(20))

	-- @KEY_WORD_GROUP_FLOW_ID
	IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT AND -- 模式词组小于等于输入词组数，则取该模式
	   NOT EXISTS( -- exclue
		SELECT KEY_WORD_GROUP_ID AS EXC_CNT
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
		WHERE 
		(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 0) AND ENABLE = 1
		AND KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID)
	BEGIN
		PRINT 'MATCHED! VOICE_GROUP_ID=' +  CAST(@VOICE_GROUP_ID AS NVARCHAR(20))

		IF @MAX_ACT_CNT < @ACT_CNT
		BEGIN
			SET @MAX_ACT_CNT = @ACT_CNT
			SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
			PRINT 'NEW MAX MATCHED! VOICE_GROUP_ID=' +  CAST(@VOICE_GROUP_ID AS NVARCHAR(20))
		END

	END

	FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
	@KEY_WORD_GROUP_FLOW_ID, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
END

IF @MAX_ACT_CNT = 0
	PRINT 'not matched.'
ELSE
	EXEC SP_SELECT_VOICE 
		 @MAX_MATCHED_VOICE_GROUP_ID
		,@MODLE
		,@VOICE_NAME output
		,@VOICE_PATH output
		,@VOICE_TEXT output
		,@VOICE_EMOTION output
		,@VOICE_COMMAND    output
		,@VOICE_COMMAND_PARAM output
		,@VOICE_THIRD_PARTY_API_NAME OUTPUT
		,@VOICE_THIRD_PARTY_API_METHOD OUTPUT
		,@VOICE_THIRD_PARTY_API_HEADER_PARAMS OUTPUT
		,@VOICE_THIRD_PARTY_API_URL OUTPUT
        ,@VOICE_THIRD_PARTY_API_RESULT_TYPE output
	    ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER output
		,@VOICE_CAT  output
		,@VOICE_DESCRIPTION    output	

IF @VOICE_NAME IS NULL 
-- 没有匹配到回答
		EXEC SP_SELECT_VOICE 
			 -1
			,@MODLE
			,@VOICE_NAME output
			,@VOICE_PATH output
			,@VOICE_TEXT output
			,@VOICE_EMOTION output
			,@VOICE_COMMAND    output
			,@VOICE_COMMAND_PARAM output
		    ,@VOICE_THIRD_PARTY_API_NAME OUTPUT
		    ,@VOICE_THIRD_PARTY_API_METHOD OUTPUT
		    ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS OUTPUT
		    ,@VOICE_THIRD_PARTY_API_URL OUTPUT
		    ,@VOICE_THIRD_PARTY_API_RESULT_TYPE output
			,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER output
			,@VOICE_CAT  output
			,@VOICE_DESCRIPTION    output		

PRINT  @VOICE_NAME + '-' + @VOICE_PATH

DECLARE @RESPONSE_1 AS NVARCHAR(4000) 
DECLARE @RESPONSE_2 AS NVARCHAR(4000) 
DECLARE @RESPONSE_3 AS NVARCHAR(4000) 
DECLARE @RESPONSE_4 AS NVARCHAR(4000) 
DECLARE @RESPONSE_5 AS NVARCHAR(4000) 
DECLARE @RESPONSE_6 AS NVARCHAR(4000) 
DECLARE @RESPONSE_7 AS NVARCHAR(4000) 
DECLARE @RESPONSE_8 AS NVARCHAR(4000) 
DECLARE @RESPONSE_9 AS NVARCHAR(4000) 

EXEC SET_RESP_PARAMS 
	 @VOICE_CAT
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_PATH
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_TEXT
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_EMOTION
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_COMMAND
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_COMMAND_PARAM
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_THIRD_PARTY_API_NAME
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_THIRD_PARTY_API_METHOD
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_THIRD_PARTY_API_HEADER_PARAMS
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_THIRD_PARTY_API_URL
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

INSERT INTO [ENT_DIALOG]
           ( [REQUEST]
			,[REQUEST_EP_SN]
			,[REQUEST_MODEL]
            ,[RESPONSE_1]
            ,[RESPONSE_2]
            ,[RESPONSE_3]
            ,[RESPONSE_4]
            ,[RESPONSE_5]
            ,[RESPONSE_6]
            ,[RESPONSE_7]
            ,[RESPONSE_8]
            ,[RESPONSE_9]
            )
     VALUES
           ( @INPUT_STRING
           , @IMEI
           , @MODLE
		   , @RESPONSE_1
		   , @RESPONSE_2
		   , @RESPONSE_3
		   , @RESPONSE_4
		   , @RESPONSE_5
		   , @RESPONSE_6
		   , @RESPONSE_7
		   , @RESPONSE_8
		   , @RESPONSE_9
			)


CLOSE CUR_CHECK_KW_ENTIRELY
DEALLOCATE CUR_CHECK_KW_ENTIRELY













GO
/****** Object:  StoredProcedure [dbo].[SP_SMART_DIALOG_FOR_REQUEST_ID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SMART_DIALOG_FOR_REQUEST_ID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SMART_DIALOG_FOR_REQUEST_ID] AS' 
END
GO















































-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	无model会话
-- =============================================
ALTER PROCEDURE [dbo].[SP_SMART_DIALOG_FOR_REQUEST_ID]
(
	@REQUEST_ID NVARCHAR(120)
)
AS

	DECLARE @VOICE_NAME AS NVARCHAR(50) 
	DECLARE @VOICE_PATH AS NVARCHAR(4000) 
	DECLARE @VOICE_TEXT AS NVARCHAR(4000) 
	DECLARE @VOICE_EMOTION AS NVARCHAR(4000) 
	DECLARE @VOICE_COMMAND AS BIGINT 
	DECLARE @VOICE_COMMAND_PARAM AS NVARCHAR(max) 
    DECLARE @VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  
    DECLARE @VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT 
	DECLARE @VOICE_CAT  AS NVARCHAR(50) 
	DECLARE @VOICE_DESCRIPTION  AS NVARCHAR(1024) 

	DECLARE @VOICE_GROUP_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
	DECLARE @ACT_CNT AS BIGINT

	DECLARE @MAX_ACT_CNT AS BIGINT
	DECLARE @MAX_MATCHED_VOICE_GROUP_ID AS BIGINT

	DECLARE @VOICE_COUNT AS BIGINT 
	DECLARE @USE_FULLY_MATCH AS BIT
	DECLARE @TAGS AS NVARCHAR(1024)
	DECLARE @INPUT_STRING AS NVARCHAR(1024)
    DECLARE @IMEI  AS NVARCHAR(1024)

	DECLARE @ROBOT_ID AS BIGINT
	DECLARE @MATCHED_DEGREE AS BIGINT

    SET NOCOUNT ON;

	SET @MAX_ACT_CNT = 0
	SET @VOICE_COUNT = 0
	SET @ROBOT_ID = NULL
	SET @MAX_MATCHED_VOICE_GROUP_ID = -1

	-- 获取 input
	-- 获取 sn 
	-- 获取 robotid
	SELECT @INPUT_STRING = INPUT, @IMEI = SN FROM ENT_REQUEST WHERE ID = @REQUEST_ID
	SELECT @ROBOT_ID = ID FROM ENT_ROBOT WHERE IMEI = @IMEI	
	-- 获取 tags
	SELECT @TAGS = [VALUE] FROM  VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER WHERE [ROBOT_IMEI] = @IMEI AND [NAME] = 'chat_mode'
	-- 刷新TAGS, robotId
	UPDATE ENT_REQUEST SET TAG = @TAGS WHERE ID = @REQUEST_ID
	UPDATE ENT_REQUEST SET ROBOT_ID = @ROBOT_ID WHERE ID = @REQUEST_ID

	EXEC SP_GEN_REQUEST_PROPERTY @REQUEST_ID

	IF NOT EXISTS(SELECT TAG FROM TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID AND TAG_STR = @TAGS)
	BEGIN			
		DELETE 	TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID
		INSERT INTO TBL_ROBOT_TAGS
		SELECT @ROBOT_ID AS ROBOT_ID, TAG, @TAGS AS TAG_STR FROM FUNC_GET_TAGS_TABLE(@TAGS)
	END

	-- 回收过期的上下文信息
	EXEC SP_COLLECT_SESSION_CONTEXT

	-- LOOK UP 第一优先级
	SET @MAX_MATCHED_VOICE_GROUP_ID 
			= CAST(DBO.FUNC_GET_CONTEXT_VALUE(@ROBOT_ID, 'LOOKUP', '-1') AS BIGINT)

	IF @MAX_MATCHED_VOICE_GROUP_ID = -1 
	BEGIN
		-- 客户自定义资料第二优先级
		SET @VOICE_GROUP_ID =
		(  
			SELECT TOP 1 RESPONSE_VOICE_GROUP_ID
			FROM   TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL
				   , VIEW_USER_ROBOT_BIND_LIST
			WHERE   
				GEN_WORD_GROUP_FLOW_ID IS NULL 
				AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = @ROBOT_ID  
				AND VIEW_USER_ROBOT_BIND_LIST.USER_ID = TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID  	
				AND REQUEST LIKE '%' + @INPUT_STRING + '%'   
		)

		IF @VOICE_GROUP_ID IS NOT NULL		 
			SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
	END

	IF @MAX_MATCHED_VOICE_GROUP_ID = -1
		-- 扩展语义第三优先级
	BEGIN
		DECLARE CUR_CHECK_KW_ENTIRELY
		CURSOR FOR 

		SELECT KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
		WHERE 
		(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0) AND ENABLE = 1
		GROUP BY KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID
		ORDER BY USE_FULLY_MATCH DESC, CNT DESC

		OPEN CUR_CHECK_KW_ENTIRELY

		FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
		@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
			WHERE ID = @KEY_WORD_GROUP_FLOW_ID AND INC_1_EXC_0 = 1

			IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT AND -- 模式词组小于等于输入词组数，则取该模式
			   NOT EXISTS( -- exclue
				SELECT KEY_WORD_GROUP_ID AS EXC_CNT
				FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
				WHERE 
				(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 0) AND ENABLE = 1
				AND KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID)
			BEGIN

				-- 先严格匹配
				IF  @USE_FULLY_MATCH = 1
					IF DBO.FUNC_IS_FULLY_MATCHED(@INPUT_STRING, @KEY_WORD_GROUP_FLOW_ID) = 1 
					BEGIN
						-- SET @VOICE_COUNT = DBO.FUNC_GET_VOICE_COUNT_BY_ROBOT_ID(@VOICE_GROUP_ID, @ROBOT_ID)
						EXEC SP_GET_VOICE_COUNT_BY_ROBOT_ID  
							  @VOICE_GROUP_ID
							, @ROBOT_ID
							, @VOICE_COUNT OUTPUT
							, @MATCHED_DEGREE OUTPUT

						IF @VOICE_COUNT > 0 
						BEGIN
							SET @MAX_ACT_CNT = @ACT_CNT
							SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
						END
						BREAK		
					END	
					ELSE
					BEGIN
						GOTO NEXT_ITEM
					END
				IF @MAX_ACT_CNT < @ACT_CNT
				BEGIN

					-- 节省效率可以这么搞
					EXEC SP_GET_VOICE_COUNT_BY_ROBOT_ID  
						  @VOICE_GROUP_ID
						, @ROBOT_ID
						, @VOICE_COUNT OUTPUT
						, @MATCHED_DEGREE OUTPUT

					IF @VOICE_COUNT > 0 
					BEGIN
						SET @MAX_ACT_CNT = @ACT_CNT
						SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
					END
				END
			END

			NEXT_ITEM:
			FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
			@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
		END
		CLOSE CUR_CHECK_KW_ENTIRELY
		DEALLOCATE CUR_CHECK_KW_ENTIRELY		
	END

	EXEC SP_SELECT_VOICE_BY_ROBOT_ID
		 @MAX_MATCHED_VOICE_GROUP_ID
		,@ROBOT_ID
		,@VOICE_NAME output
		,@VOICE_PATH output
		,@VOICE_TEXT output
		,@VOICE_EMOTION output
		,@VOICE_COMMAND    output
		,@VOICE_COMMAND_PARAM output
		,@VOICE_THIRD_PARTY_API_NAME OUTPUT
		,@VOICE_THIRD_PARTY_API_METHOD OUTPUT
		,@VOICE_THIRD_PARTY_API_HEADER_PARAMS OUTPUT
		,@VOICE_THIRD_PARTY_API_URL OUTPUT
		,@VOICE_THIRD_PARTY_API_RESULT_TYPE output
		,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER output
		,@VOICE_CAT  output
		,@VOICE_DESCRIPTION    output	

	-- 替换config参数
	SET @VOICE_PATH = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_PATH, @IMEI)
	SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_EMOTION, @IMEI)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)

	-- 替换request 参数
	SET @VOICE_TEXT = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_TEXT, @REQUEST_ID)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_EMOTION, @REQUEST_ID)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_COMMAND_PARAM, @REQUEST_ID)
	SET @VOICE_THIRD_PARTY_API_URL = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_THIRD_PARTY_API_URL, @REQUEST_ID)

	-- 数据库命令
	IF @VOICE_COMMAND = 1433
	BEGIN
		EXEC SP_EXECUTESQL @VOICE_COMMAND_PARAM
        , N'@VOICE_COMMAND BIGINT OUTPUT, @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT, @VOICE_TEXT NVARCHAR(1024) OUTPUT '
		, @VOICE_COMMAND OUTPUT
		, @VOICE_COMMAND_PARAM OUTPUT
		, @VOICE_TEXT OUTPUT 

		-- 对计算结果再做一轮config参数替换
		SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
		SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)
		-- SET @VOICE_CAT = '5' -- 上下文相关
	END

	IF  @VOICE_CAT = '2' AND 
		(
			CAST(DBO.FUNC_GET_CONTEXT_VALUE(@ROBOT_ID, 'UNKONW_COUNT', '0') AS BIGINT) >=
			CAST(DBO.FUNC_GET_META_SETTINGS('MAX_UNKONW_COUNT', '3') AS BIGINT)
		)
	BEGIN
		SET @VOICE_NAME = '噪音'
		SET @VOICE_CAT = '1'
		SET @VOICE_COMMAND = 99
		SET @VOICE_TEXT = '.'
	END

	SELECT
		 0 AS ID
		,@MAX_MATCHED_VOICE_GROUP_ID VOICE_GROUP_ID
		,' ' AS VOICE_INC_PROP
		,' ' AS VOICE_EXC_PROP
		,ISNULL(@VOICE_NAME, '') AS VOICE_NAME
		,ISNULL(@VOICE_PATH , '') AS VOICE_PATH
		,ISNULL(@VOICE_TEXT, '') AS VOICE_TEXT
		,ISNULL(@VOICE_EMOTION, '') AS VOICE_EMOTION
		,ISNULL(@VOICE_COMMAND, 0)    AS VOICE_COMMAND
		,ISNULL(@VOICE_COMMAND_PARAM, '') AS VOICE_COMMAND_PARAM
		,ISNULL(@VOICE_THIRD_PARTY_API_NAME , '')AS VOICE_THIRD_PARTY_API_NAME
		,ISNULL(@VOICE_THIRD_PARTY_API_METHOD, '') AS VOICE_THIRD_PARTY_API_METHOD
		,ISNULL(@VOICE_THIRD_PARTY_API_HEADER_PARAMS, '') AS VOICE_THIRD_PARTY_API_HEADER_PARAMS
		,ISNULL(@VOICE_THIRD_PARTY_API_URL, '') AS VOICE_THIRD_PARTY_API_URL
		,ISNULL(@VOICE_THIRD_PARTY_API_RESULT_TYPE, '') AS VOICE_THIRD_PARTY_API_RESULT_TYPE
		,ISNULL(@VOICE_THIRD_PARTY_API_RUN_AT_SERVER, '') AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER
		,ISNULL(@VOICE_CAT, '')  AS VOICE_CAT
		,ISNULL(@VOICE_DESCRIPTION, '')    AS VOICE_DESCRIPTION	
		,1 AS VOICE_ENABLED
  
SET NOCOUNT OFF











































GO
/****** Object:  StoredProcedure [dbo].[SP_SMART_DIALOG_FOR_REQUEST_ID_WITH_LOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SMART_DIALOG_FOR_REQUEST_ID_WITH_LOG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SMART_DIALOG_FOR_REQUEST_ID_WITH_LOG] AS' 
END
GO










































-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-10-27
-- Description:	无model会话
-- =============================================
ALTER PROCEDURE [dbo].[SP_SMART_DIALOG_FOR_REQUEST_ID_WITH_LOG]
(
	@REQUEST_ID NVARCHAR(120)
)
AS

	DECLARE @VOICE_NAME AS NVARCHAR(50) 
	DECLARE @VOICE_PATH AS NVARCHAR(4000) 
	DECLARE @VOICE_TEXT AS NVARCHAR(4000) 
	DECLARE @VOICE_EMOTION AS NVARCHAR(4000) 
	DECLARE @VOICE_COMMAND AS BIGINT 
	DECLARE @VOICE_COMMAND_PARAM AS NVARCHAR(max) 
    DECLARE @VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  
    DECLARE @VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT 
	DECLARE @VOICE_CAT  AS NVARCHAR(50) 
	DECLARE @VOICE_DESCRIPTION  AS NVARCHAR(1024) 

	DECLARE @VOICE_GROUP_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
	DECLARE @ACT_CNT AS BIGINT

	DECLARE @MAX_ACT_CNT AS BIGINT
	DECLARE @MAX_MATCHED_VOICE_GROUP_ID AS BIGINT

	DECLARE @VOICE_COUNT AS BIGINT 
	DECLARE @USE_FULLY_MATCH AS BIT
	DECLARE @TAGS AS NVARCHAR(1024)
	DECLARE @INPUT_STRING AS NVARCHAR(1024)
    DECLARE @IMEI  AS NVARCHAR(1024)

	DECLARE @ROBOT_ID AS BIGINT
	DECLARE @MATCHED_DEGREE AS BIGINT

    SET NOCOUNT ON;

	SET @MAX_ACT_CNT = 0
	SET @VOICE_COUNT = 0
	SET @ROBOT_ID = NULL
	SET @MAX_MATCHED_VOICE_GROUP_ID = -1

	-- 获取 input
	-- 获取 sn 
	-- 获取 robotid
	SELECT @INPUT_STRING = INPUT, @IMEI = SN FROM ENT_REQUEST WHERE ID = @REQUEST_ID
	SELECT @ROBOT_ID = ID FROM ENT_ROBOT WHERE IMEI = @IMEI	
	-- 获取 tags
	SELECT @TAGS = [VALUE] FROM  VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER WHERE [ROBOT_IMEI] = @IMEI AND [NAME] = 'chat_mode'
	-- 刷新TAGS, robotId
	UPDATE ENT_REQUEST SET TAG = @TAGS WHERE ID = @REQUEST_ID
	UPDATE ENT_REQUEST SET ROBOT_ID = @ROBOT_ID WHERE ID = @REQUEST_ID

	DELETE TBL_REQUEST_PROPERTY
	EXEC SP_GEN_REQUEST_PROPERTY @REQUEST_ID

	IF NOT EXISTS(SELECT TAG FROM TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID AND TAG_STR = @TAGS)
	BEGIN			
		DELETE 	TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID
		INSERT INTO TBL_ROBOT_TAGS
		SELECT @ROBOT_ID AS ROBOT_ID, TAG, @TAGS AS TAG_STR FROM FUNC_GET_TAGS_TABLE(@TAGS)
	END

	-- 回收过期的上下文信息
	EXEC SP_COLLECT_SESSION_CONTEXT
	-- 获取LOOKUP启发
	SET @MAX_MATCHED_VOICE_GROUP_ID 
			= CAST(DBO.FUNC_GET_CONTEXT_VALUE(@ROBOT_ID, 'LOOKUP', '-1') AS BIGINT)

	PRINT @INPUT_STRING
	PRINT @ROBOT_ID
	PRINT @TAGS

	PRINT @MAX_MATCHED_VOICE_GROUP_ID
	SET @VOICE_GROUP_ID =
	(  
		SELECT TOP 1 RESPONSE_VOICE_GROUP_ID
		FROM   TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL
			   , VIEW_USER_ROBOT_BIND_LIST
		WHERE   
			GEN_WORD_GROUP_FLOW_ID IS NULL 
			AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = @ROBOT_ID  
			AND VIEW_USER_ROBOT_BIND_LIST.USER_ID = TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID  	
			AND REQUEST LIKE '%' + @INPUT_STRING + '%'   
	)

	IF @VOICE_GROUP_ID IS NOT NULL
	BEGIN
		PRINT 'ORGINAL FIND...'
		PRINT @VOICE_GROUP_ID
		SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
	END

	IF @MAX_MATCHED_VOICE_GROUP_ID = -1
	BEGIN

		DECLARE CUR_CHECK_KW_ENTIRELY
		CURSOR FOR 

		SELECT KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
		WHERE 
		(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0) AND ENABLE = 1
		GROUP BY KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID
		ORDER BY USE_FULLY_MATCH DESC, CNT DESC

		OPEN CUR_CHECK_KW_ENTIRELY

		FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
		@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
			WHERE ID = @KEY_WORD_GROUP_FLOW_ID AND INC_1_EXC_0 = 1

			IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT AND -- 模式词组小于等于输入词组数，则取该模式
			   NOT EXISTS( -- exclue
				SELECT KEY_WORD_GROUP_ID AS EXC_CNT
				FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
				WHERE 
				(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 0) AND ENABLE = 1
				AND KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID)
			BEGIN

				PRINT 'MATCHED @KEY_WORD_GROUP_FLOW_ID = ' + CAST (@KEY_WORD_GROUP_FLOW_ID AS VARCHAR(20))
					+ '  @VOICE_GROUP_ID = ' + CAST (@VOICE_GROUP_ID AS VARCHAR(20))
					+ '  @KEY_WORD_GROUP_ID_COUNT = ' + CAST (@KEY_WORD_GROUP_ID_COUNT AS VARCHAR(20))

				-- 先严格匹配
				IF  @USE_FULLY_MATCH = 1
					IF DBO.FUNC_IS_FULLY_MATCHED(@INPUT_STRING, @KEY_WORD_GROUP_FLOW_ID) = 1 
					BEGIN
						PRINT 'USE_FULLY_MATCH'
						EXEC SP_GET_VOICE_COUNT_BY_ROBOT_ID  
							  @VOICE_GROUP_ID
							, @ROBOT_ID
							, @VOICE_COUNT OUTPUT
							, @MATCHED_DEGREE OUTPUT

						IF @VOICE_COUNT > 0 
						BEGIN
							PRINT ' @VOICE_COUNT = ' + CAST (@VOICE_COUNT AS VARCHAR(20))
							SET @MAX_ACT_CNT = @ACT_CNT
							SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
						END
						BREAK		
					END	
					ELSE
					BEGIN
						GOTO NEXT_ITEM
					END

				IF @MAX_ACT_CNT < @ACT_CNT
				BEGIN

					EXEC SP_GET_VOICE_COUNT_BY_ROBOT_ID  
						  @VOICE_GROUP_ID
						, @ROBOT_ID
						, @VOICE_COUNT OUTPUT
						, @MATCHED_DEGREE OUTPUT

					PRINT ' @VOICE_COUNT = ' + CAST (@VOICE_COUNT AS VARCHAR(20))

					IF @VOICE_COUNT > 0 
					BEGIN

						SET @MAX_ACT_CNT = @ACT_CNT
						SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID

						PRINT ' NEW MAX MATCHED @MAX_MATCHED_VOICE_GROUP_ID = ' + CAST (@MAX_MATCHED_VOICE_GROUP_ID AS VARCHAR(20))
						+ ' @MAX_ACT_CNT = ' + CAST (@MAX_ACT_CNT AS VARCHAR(20))
					END
				END
			END

			NEXT_ITEM:
			FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
			@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
		END
		CLOSE CUR_CHECK_KW_ENTIRELY
		DEALLOCATE CUR_CHECK_KW_ENTIRELY
	END
	ELSE
		PRINT 'ORINAL MATCHED.'

	PRINT ' @MAX_MATCHED_VOICE_GROUP_ID = ' + CAST (@MAX_MATCHED_VOICE_GROUP_ID AS VARCHAR(20))
	PRINT ' @ROBOT_ID = ' + CAST (@ROBOT_ID AS VARCHAR(20))


	EXEC SP_SELECT_VOICE_BY_ROBOT_ID
		 @MAX_MATCHED_VOICE_GROUP_ID
		,@ROBOT_ID
		,@VOICE_NAME output
		,@VOICE_PATH output
		,@VOICE_TEXT output
		,@VOICE_EMOTION output
		,@VOICE_COMMAND    output
		,@VOICE_COMMAND_PARAM output
		,@VOICE_THIRD_PARTY_API_NAME OUTPUT
		,@VOICE_THIRD_PARTY_API_METHOD OUTPUT
		,@VOICE_THIRD_PARTY_API_HEADER_PARAMS OUTPUT
		,@VOICE_THIRD_PARTY_API_URL OUTPUT
		,@VOICE_THIRD_PARTY_API_RESULT_TYPE output
		,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER output
		,@VOICE_CAT  output
		,@VOICE_DESCRIPTION    output	

	-- 替换config参数
	SET @VOICE_PATH = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_PATH, @IMEI)
	SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_EMOTION, @IMEI)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)

	-- 替换request 参数
	SET @VOICE_TEXT = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_TEXT, @REQUEST_ID)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_EMOTION, @REQUEST_ID)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_COMMAND_PARAM, @REQUEST_ID)
	SET @VOICE_THIRD_PARTY_API_URL = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_THIRD_PARTY_API_URL, @REQUEST_ID)

	-- 数据库命令
	IF @VOICE_COMMAND = 1433
	BEGIN
		EXEC SP_EXECUTESQL @VOICE_COMMAND_PARAM
        , N'@VOICE_COMMAND BIGINT OUTPUT, @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT, @VOICE_TEXT NVARCHAR(1024) OUTPUT '
		, @VOICE_COMMAND OUTPUT
		, @VOICE_COMMAND_PARAM OUTPUT
		, @VOICE_TEXT OUTPUT 

		-- 对计算结果再做一轮config参数替换
		SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
		SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)
		-- SET @VOICE_CAT = '5' -- 上下文相关
	END

	IF  @VOICE_CAT = '2' AND 
		(
			CAST(DBO.FUNC_GET_CONTEXT_VALUE(@ROBOT_ID, 'UNKONW_COUNT', '0') AS BIGINT) >=
			CAST(DBO.FUNC_GET_META_SETTINGS('MAX_UNKONW_COUNT', '3') AS BIGINT)
		)
	BEGIN
		SET @VOICE_NAME = '噪音'
		SET @VOICE_CAT = '1'
		SET @VOICE_COMMAND = 99
		SET @VOICE_TEXT = '.'
	END

	SELECT
		 0 AS ID
		,@MAX_MATCHED_VOICE_GROUP_ID VOICE_GROUP_ID
		,' ' AS VOICE_INC_PROP
		,' ' AS VOICE_EXC_PROP
		,ISNULL(@VOICE_NAME, '') AS VOICE_NAME
		,ISNULL(@VOICE_PATH , '') AS VOICE_PATH
		,ISNULL(@VOICE_TEXT, '') AS VOICE_TEXT
		,ISNULL(@VOICE_EMOTION, '') AS VOICE_EMOTION
		,ISNULL(@VOICE_COMMAND, 0)    AS VOICE_COMMAND
		,ISNULL(@VOICE_COMMAND_PARAM, '') AS VOICE_COMMAND_PARAM
		,ISNULL(@VOICE_THIRD_PARTY_API_NAME , '')AS VOICE_THIRD_PARTY_API_NAME
		,ISNULL(@VOICE_THIRD_PARTY_API_METHOD, '') AS VOICE_THIRD_PARTY_API_METHOD
		,ISNULL(@VOICE_THIRD_PARTY_API_HEADER_PARAMS, '') AS VOICE_THIRD_PARTY_API_HEADER_PARAMS
		,ISNULL(@VOICE_THIRD_PARTY_API_URL, '') AS VOICE_THIRD_PARTY_API_URL
		,ISNULL(@VOICE_THIRD_PARTY_API_RESULT_TYPE, '') AS VOICE_THIRD_PARTY_API_RESULT_TYPE
		,ISNULL(@VOICE_THIRD_PARTY_API_RUN_AT_SERVER, '') AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER
		,ISNULL(@VOICE_CAT, '')  AS VOICE_CAT
		,ISNULL(@VOICE_DESCRIPTION, '')    AS VOICE_DESCRIPTION	
  
SET NOCOUNT OFF






































GO
/****** Object:  StoredProcedure [dbo].[SP_SMART_DIALOG_MUL_KW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SMART_DIALOG_MUL_KW]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SMART_DIALOG_MUL_KW] AS' 
END
GO













-- select * from VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE where key_word_group_flow_id = 95

ALTER PROCEDURE [dbo].[SP_SMART_DIALOG_MUL_KW]
(
	 @INPUT_STRING AS NVARCHAR(1024)
	,@MODLE AS NVARCHAR(1024)
	,@VOICE_NAME AS NVARCHAR(50) output
	,@VOICE_PATH AS NVARCHAR(4000) output
	,@VOICE_TEXT AS NVARCHAR(4000) output
	,@VOICE_EMOTION AS NVARCHAR(4000) output
	,@VOICE_COMMAND AS BIGINT output
	,@VOICE_COMMAND_PARAM AS NVARCHAR(4000) output
	,@VOICE_CAT  AS NVARCHAR(50) output
	,@VOICE_DESCRIPTION  AS NVARCHAR(1024) output
)
AS

DECLARE @VOICE_GROUP_ID AS BIGINT
DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
DECLARE @ACT_CNT AS BIGINT
 

DECLARE CUR_CHECK_KW_ENTIRELY
CURSOR FOR 

SELECT KEY_WORD_GROUP_FLOW_ID, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT
FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
WHERE 
(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 1)
GROUP BY KEY_WORD_GROUP_FLOW_ID, VOICE_GROUP_ID
ORDER BY CNT DESC

OPEN CUR_CHECK_KW_ENTIRELY

FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
@KEY_WORD_GROUP_FLOW_ID, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
	WHERE ID = @KEY_WORD_GROUP_FLOW_ID AND INC_1_EXC_0 = 1

	PRINT 'FLOW_ID=' + CAST(@KEY_WORD_GROUP_FLOW_ID AS NVARCHAR(20))
		+ '; @VOICE_GROUP_ID=' + CAST(@VOICE_GROUP_ID AS NVARCHAR(20))
		+ '; WORD_GROUP_ID_CNT=' + CAST(@ACT_CNT AS NVARCHAR(20))
		+ '; FOUND=' + CAST(@KEY_WORD_GROUP_ID_COUNT AS NVARCHAR(20))


	-- @KEY_WORD_GROUP_FLOW_ID
	IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT AND
	   NOT EXISTS(
		SELECT KEY_WORD_GROUP_ID AS EXC_CNT
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
		WHERE 
		(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 0)
		AND KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID)
	BEGIN
		EXEC SP_SELECT_VOICE 
			 @VOICE_GROUP_ID
			,@MODLE
			,@VOICE_NAME output
			,@VOICE_PATH output
			,@VOICE_TEXT output
			,@VOICE_EMOTION output
			,@VOICE_COMMAND    output
			,@VOICE_COMMAND_PARAM output
			,@VOICE_CAT  output
			,@VOICE_DESCRIPTION    output			
		BREAK
	END

	FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
	@KEY_WORD_GROUP_FLOW_ID, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
END

PRINT  @VOICE_NAME + '-' + @VOICE_PATH

DECLARE @RESPONSE_1 AS NVARCHAR(4000) 
DECLARE @RESPONSE_2 AS NVARCHAR(4000) 
DECLARE @RESPONSE_3 AS NVARCHAR(4000) 
DECLARE @RESPONSE_4 AS NVARCHAR(4000) 
DECLARE @RESPONSE_5 AS NVARCHAR(4000) 
DECLARE @RESPONSE_6 AS NVARCHAR(4000) 
DECLARE @RESPONSE_7 AS NVARCHAR(4000) 
DECLARE @RESPONSE_8 AS NVARCHAR(4000) 
DECLARE @RESPONSE_9 AS NVARCHAR(4000) 

EXEC SET_RESP_PARAMS 
	 @VOICE_PATH
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_TEXT
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_EMOTION
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_COMMAND
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_COMMAND_PARAM
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT


INSERT INTO [ENT_DIALOG]
           ( [REQUEST]
			,[REQUEST_MODEL]
            ,[RESPONSE_1]
            ,[RESPONSE_2]
            ,[RESPONSE_3]
            ,[RESPONSE_4]
            ,[RESPONSE_5]
            ,[RESPONSE_6]
            ,[RESPONSE_7]
            ,[RESPONSE_8]
            ,[RESPONSE_9]
            )
     VALUES
           ( @INPUT_STRING
           , @MODLE
		   , @RESPONSE_1
		   , @RESPONSE_2
		   , @RESPONSE_3
		   , @RESPONSE_4
		   , @RESPONSE_5
		   , @RESPONSE_6
		   , @RESPONSE_7
		   , @RESPONSE_8
		   , @RESPONSE_9
			)


CLOSE CUR_CHECK_KW_ENTIRELY
DEALLOCATE CUR_CHECK_KW_ENTIRELY













GO
/****** Object:  StoredProcedure [dbo].[SP_SMART_DIALOG_NO_OUTPUT]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SMART_DIALOG_NO_OUTPUT]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SMART_DIALOG_NO_OUTPUT] AS' 
END
GO





















-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-1
-- Description:	新的开放式自动问答
-- 输入词本身模糊匹配 2016-7-23
-- =============================================
ALTER PROCEDURE [dbo].[SP_SMART_DIALOG_NO_OUTPUT]
(
	 @INPUT_STRING AS NVARCHAR(1024)
	,@MODLE AS NVARCHAR(1024)
    ,@IMEI  AS NVARCHAR(1024)

)
AS

	DECLARE @VOICE_NAME AS NVARCHAR(50) 
	DECLARE @VOICE_PATH AS NVARCHAR(4000) 
	DECLARE @VOICE_TEXT AS NVARCHAR(4000) 
	DECLARE @VOICE_EMOTION AS NVARCHAR(4000) 
	DECLARE @VOICE_COMMAND AS BIGINT 
	DECLARE @VOICE_COMMAND_PARAM AS NVARCHAR(max) 
    DECLARE @VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  
    DECLARE @VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT 
	DECLARE @VOICE_CAT  AS NVARCHAR(50) 
	DECLARE @VOICE_DESCRIPTION  AS NVARCHAR(1024) 

	DECLARE @VOICE_GROUP_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
	DECLARE @ACT_CNT AS BIGINT

	DECLARE @MAX_ACT_CNT AS BIGINT
	DECLARE @MAX_MATCHED_VOICE_GROUP_ID AS BIGINT

	DECLARE @VOICE_COUNT AS BIGINT 
	DECLARE @USE_FULLY_MATCH AS BIT

    SET NOCOUNT ON;

	SET @MAX_ACT_CNT = 0
	SET @VOICE_COUNT = 0
 
DECLARE CUR_CHECK_KW_ENTIRELY
CURSOR FOR 

SELECT KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT
FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
WHERE 
(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 1) AND ENABLE = 1
GROUP BY KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID
ORDER BY USE_FULLY_MATCH DESC, CNT DESC

OPEN CUR_CHECK_KW_ENTIRELY

FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
	WHERE ID = @KEY_WORD_GROUP_FLOW_ID AND INC_1_EXC_0 = 1

	PRINT 'FLOW_ID=' + CAST(@KEY_WORD_GROUP_FLOW_ID AS NVARCHAR(20))
		+ '; @USE_FULLY_MATCH=' + CAST(@USE_FULLY_MATCH AS NVARCHAR(20))
		+ '; @VOICE_GROUP_ID=' + CAST(@VOICE_GROUP_ID AS NVARCHAR(20))
		+ '; WORD_GROUP_ID_CNT=' + CAST(@ACT_CNT AS NVARCHAR(20))
		+ '; FOUND=' + CAST(@KEY_WORD_GROUP_ID_COUNT AS NVARCHAR(20))
	

	-- @KEY_WORD_GROUP_FLOW_ID
	IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT AND -- 模式词组小于等于输入词组数，则取该模式
	   NOT EXISTS( -- exclue
		SELECT KEY_WORD_GROUP_ID AS EXC_CNT
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
		WHERE 
		(CHARINDEX([KEY_WORD], @INPUT_STRING) <> 0 AND KEY_WORD_GROUP_INC_1_EXC_0 = 0) AND ENABLE = 1
		AND KEY_WORD_GROUP_FLOW_ID = @KEY_WORD_GROUP_FLOW_ID)
	BEGIN

		-- 先严格匹配
		IF  @USE_FULLY_MATCH = 1
			IF DBO.FUNC_IS_FULLY_MATCHED(@INPUT_STRING, @KEY_WORD_GROUP_FLOW_ID) = 1 
			BEGIN
				PRINT 'FULLY MATCHED'
				SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
				SET @MAX_ACT_CNT = @ACT_CNT
				BREAK		
			END	
			ELSE
			BEGIN
				PRINT 'FULLY MATCH FAILED!'
				GOTO NEXT_ITEM
			END
		ELSE
			PRINT 'NO FULLY MATCH...'			
 
		PRINT 'MATCHED! VOICE_GROUP_ID=' +  CAST(@VOICE_GROUP_ID AS NVARCHAR(20))
		IF @MAX_ACT_CNT < @ACT_CNT
		BEGIN

			PRINT 'NEW CANDIDATE! @VOICE_GROUP_ID LOOKUP VOICE_COUNT=' 
			SET @VOICE_COUNT = DBO.FUNC_GET_VOICE_COUNT(@VOICE_GROUP_ID, @MODLE)
			PRINT @VOICE_COUNT

			IF @VOICE_COUNT = 0 
				PRINT 'IGNOR ZERO VOICE COUNT'
			ELSE
			BEGIN
				SET @MAX_ACT_CNT = @ACT_CNT
				SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
				PRINT 'NEW MAX MATCHED! VOICE_GROUP_ID=' +  CAST(@VOICE_GROUP_ID AS NVARCHAR(20))
			END

		END


	END

	NEXT_ITEM:
	FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
	@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
END

IF @MAX_ACT_CNT = 0
	PRINT 'not matched.'
ELSE
	EXEC SP_SELECT_VOICE 
		 @MAX_MATCHED_VOICE_GROUP_ID
		,@MODLE
		,@VOICE_NAME output
		,@VOICE_PATH output
		,@VOICE_TEXT output
		,@VOICE_EMOTION output
		,@VOICE_COMMAND    output
		,@VOICE_COMMAND_PARAM output
		,@VOICE_THIRD_PARTY_API_NAME OUTPUT
		,@VOICE_THIRD_PARTY_API_METHOD OUTPUT
		,@VOICE_THIRD_PARTY_API_HEADER_PARAMS OUTPUT
		,@VOICE_THIRD_PARTY_API_URL OUTPUT
        ,@VOICE_THIRD_PARTY_API_RESULT_TYPE output
	    ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER output
		,@VOICE_CAT  output
		,@VOICE_DESCRIPTION    output	

IF @VOICE_NAME IS NULL 
-- 没有匹配到回答
		EXEC SP_SELECT_VOICE 
			 -1
			,@MODLE
			,@VOICE_NAME output
			,@VOICE_PATH output
			,@VOICE_TEXT output
			,@VOICE_EMOTION output
			,@VOICE_COMMAND    output
			,@VOICE_COMMAND_PARAM output
		    ,@VOICE_THIRD_PARTY_API_NAME OUTPUT
		    ,@VOICE_THIRD_PARTY_API_METHOD OUTPUT
		    ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS OUTPUT
		    ,@VOICE_THIRD_PARTY_API_URL OUTPUT
		    ,@VOICE_THIRD_PARTY_API_RESULT_TYPE output
			,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER output
			,@VOICE_CAT  output
			,@VOICE_DESCRIPTION    output		


SET @VOICE_PATH = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_PATH, @IMEI)
SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
SET @VOICE_EMOTION = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_EMOTION, @IMEI)
SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)

PRINT  @VOICE_NAME + '-' + @VOICE_PATH

DECLARE @RESPONSE_1 AS NVARCHAR(4000) 
DECLARE @RESPONSE_2 AS NVARCHAR(4000) 
DECLARE @RESPONSE_3 AS NVARCHAR(4000) 
DECLARE @RESPONSE_4 AS NVARCHAR(4000) 
DECLARE @RESPONSE_5 AS NVARCHAR(4000) 
DECLARE @RESPONSE_6 AS NVARCHAR(4000) 
DECLARE @RESPONSE_7 AS NVARCHAR(4000) 
DECLARE @RESPONSE_8 AS NVARCHAR(4000) 
DECLARE @RESPONSE_9 AS NVARCHAR(4000) 

EXEC SET_RESP_PARAMS 
	 @VOICE_CAT
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_PATH
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_TEXT
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_EMOTION
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_COMMAND
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_COMMAND_PARAM
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_THIRD_PARTY_API_NAME
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_THIRD_PARTY_API_METHOD
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_THIRD_PARTY_API_HEADER_PARAMS
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

EXEC SET_RESP_PARAMS 
	 @VOICE_THIRD_PARTY_API_URL
	,@RESPONSE_1 OUTPUT
	,@RESPONSE_2 OUTPUT
	,@RESPONSE_3 OUTPUT
	,@RESPONSE_4 OUTPUT
	,@RESPONSE_5 OUTPUT
	,@RESPONSE_6 OUTPUT
	,@RESPONSE_7 OUTPUT
	,@RESPONSE_8 OUTPUT
	,@RESPONSE_9 OUTPUT

INSERT INTO [ENT_DIALOG]
           ( [REQUEST]
			,[REQUEST_EP_SN]
			,[REQUEST_MODEL]
            ,[RESPONSE_1]
            ,[RESPONSE_2]
            ,[RESPONSE_3]
            ,[RESPONSE_4]
            ,[RESPONSE_5]
            ,[RESPONSE_6]
            ,[RESPONSE_7]
            ,[RESPONSE_8]
            ,[RESPONSE_9]
            )
     VALUES
           ( @INPUT_STRING
           , @IMEI
           , @MODLE
		   , @RESPONSE_1
		   , @RESPONSE_2
		   , @RESPONSE_3
		   , @RESPONSE_4
		   , @RESPONSE_5
		   , @RESPONSE_6
		   , @RESPONSE_7
		   , @RESPONSE_8
		   , @RESPONSE_9
			)


CLOSE CUR_CHECK_KW_ENTIRELY
DEALLOCATE CUR_CHECK_KW_ENTIRELY

 

SELECT
			 0  AS ID
			, 0  AS VOICE_GROUP_ID
		    , ' ' AS VOICE_INC_PROP
            , ' ' AS VOICE_EXC_PROP
			, ISNULL(@VOICE_NAME, '') AS VOICE_NAME
			, ISNULL( @VOICE_PATH , '') AS VOICE_PATH
			,ISNULL(@VOICE_TEXT, '') AS VOICE_TEXT
			,ISNULL(@VOICE_EMOTION, '') AS VOICE_EMOTION
			,ISNULL(@VOICE_COMMAND, 0)    AS VOICE_COMMAND
			,ISNULL(@VOICE_COMMAND_PARAM, '') AS VOICE_COMMAND_PARAM
		    ,ISNULL(@VOICE_THIRD_PARTY_API_NAME , '')AS VOICE_THIRD_PARTY_API_NAME
		    ,ISNULL(@VOICE_THIRD_PARTY_API_METHOD, '') AS VOICE_THIRD_PARTY_API_METHOD
		    ,ISNULL(@VOICE_THIRD_PARTY_API_HEADER_PARAMS, '') AS VOICE_THIRD_PARTY_API_HEADER_PARAMS
		    ,ISNULL(@VOICE_THIRD_PARTY_API_URL, '') AS VOICE_THIRD_PARTY_API_URL
		    ,ISNULL(@VOICE_THIRD_PARTY_API_RESULT_TYPE, '') AS VOICE_THIRD_PARTY_API_RESULT_TYPE
			,ISNULL(@VOICE_THIRD_PARTY_API_RUN_AT_SERVER, '') AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER
			,ISNULL(@VOICE_CAT, '')  AS VOICE_CAT
			,ISNULL(@VOICE_DESCRIPTION, '')    AS VOICE_DESCRIPTION	

  set nocount off

















GO
/****** Object:  StoredProcedure [dbo].[SP_SMART_DIALOG_WITH_SOUND]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SMART_DIALOG_WITH_SOUND]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SMART_DIALOG_WITH_SOUND] AS' 
END
GO























































-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-11-29
-- Description: 加入音匹配，可选全匹配
-- 2016-12-09   手工模式在业务端判断
-- =============================================
ALTER PROCEDURE [dbo].[SP_SMART_DIALOG_WITH_SOUND]
(
	@REQUEST_ID NVARCHAR(120)
	,@DEBUG BIT = 0
)
AS

	DECLARE @VOICE_NAME AS NVARCHAR(50) 
	DECLARE @VOICE_PATH AS NVARCHAR(4000) 
	DECLARE @VOICE_TEXT AS NVARCHAR(4000) 
	DECLARE @VOICE_EMOTION AS NVARCHAR(4000) 
	DECLARE @VOICE_COMMAND AS BIGINT 
	DECLARE @VOICE_COMMAND_PARAM AS NVARCHAR(max) 
    DECLARE @VOICE_THIRD_PARTY_API_NAME AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_METHOD AS NVARCHAR(50)  
    DECLARE @VOICE_THIRD_PARTY_API_HEADER_PARAMS AS NVARCHAR(400)  
    DECLARE @VOICE_THIRD_PARTY_API_URL AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RESULT_TYPE AS NVARCHAR(4000)  
    DECLARE @VOICE_THIRD_PARTY_API_RUN_AT_SERVER  AS BIT 
	DECLARE @VOICE_CAT  AS NVARCHAR(50) 
	DECLARE @VOICE_DESCRIPTION  AS NVARCHAR(1024) 

	DECLARE @VOICE_ID AS BIGINT
	DECLARE @VOICE_GROUP_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_FLOW_ID AS BIGINT
	DECLARE @KEY_WORD_GROUP_ID_COUNT AS BIGINT
	DECLARE @ACT_CNT AS BIGINT

	DECLARE @MAX_ACT_CNT AS BIGINT
	DECLARE @MAX_MATCHED_VOICE_GROUP_ID AS BIGINT

	DECLARE @VOICE_COUNT AS BIGINT 
	DECLARE @USE_FULLY_MATCH AS BIT
	DECLARE @TAGS AS NVARCHAR(1024)
	DECLARE @INPUT_STRING AS NVARCHAR(1024)
    DECLARE @IMEI  AS NVARCHAR(1024)

	DECLARE @ROBOT_ID AS BIGINT
	DECLARE @MATCHED_DEGREE AS BIGINT
 
    SET NOCOUNT ON;

	SET @MAX_ACT_CNT = 0
	SET @VOICE_COUNT = 0
	SET @ROBOT_ID = NULL
	SET @MAX_MATCHED_VOICE_GROUP_ID = -1

	-- 获取 input
	-- 获取 sn 
	-- 获取 robotid
	SELECT @INPUT_STRING = INPUT, @IMEI = SN FROM ENT_REQUEST WHERE ID = @REQUEST_ID
	SELECT @ROBOT_ID = ID  FROM ENT_ROBOT WHERE IMEI = @IMEI	

	IF @DEBUG = 1 
	BEGIN
		PRINT '输入字串：' + @INPUT_STRING + ' SN :' + @IMEI
		PRINT 'ROBOT_ID：' 
		PRINT @ROBOT_ID
	END

	-- 获取 tags
	SELECT @TAGS = [VALUE] FROM  VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER WHERE [ROBOT_IMEI] = @IMEI AND [NAME] = 'chat_mode'
	-- 刷新TAGS, robotId
	UPDATE ENT_REQUEST SET TAG = @TAGS WHERE ID = @REQUEST_ID
	UPDATE ENT_REQUEST SET ROBOT_ID = @ROBOT_ID WHERE ID = @REQUEST_ID

	IF @DEBUG = 1 
	BEGIN
		PRINT '清空请求属性组'
		DELETE TBL_REQUEST_PROPERTY
		PRINT '生成请求属性'
	END

	EXEC SP_GEN_REQUEST_PROPERTY @REQUEST_ID

	IF NOT EXISTS(SELECT TAG FROM TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID AND TAG_STR = @TAGS)
	BEGIN			

		IF @DEBUG = 1 
		BEGIN
			PRINT 'TAG字符串：' + @TAGS
			PRINT '重新生成机器人TAG'
		END

		DELETE 	TBL_ROBOT_TAGS WHERE ROBOT_ID = @ROBOT_ID
		INSERT INTO TBL_ROBOT_TAGS
		SELECT @ROBOT_ID AS ROBOT_ID, TAG, @TAGS AS TAG_STR FROM FUNC_GET_TAGS_TABLE(@TAGS)
	END

	-- 回收过期的上下文信息
	EXEC SP_COLLECT_SESSION_CONTEXT

	DECLARE @PINYIN VARCHAR(8000)

	-- 加入拼音
	SELECT  @PINYIN  =  DBO.FUNC_GET_PINYIN(  @INPUT_STRING)

	IF @DEBUG = 1 
	BEGIN
		PRINT '拼音：' + @PINYIN
	END

	-- LOOK UP 第一优先级
	SET @MAX_MATCHED_VOICE_GROUP_ID 
			= CAST(DBO.FUNC_GET_CONTEXT_VALUE(@ROBOT_ID, 'LOOKUP', '-1') AS BIGINT)

	IF @DEBUG = 1 
	BEGIN
		PRINT '期望应答组'
		PRINT @MAX_MATCHED_VOICE_GROUP_ID
	END

	IF @MAX_MATCHED_VOICE_GROUP_ID = -1 
	BEGIN
		-- 客户自定义资料第二优先级
		SET @VOICE_ID =
		(  
			SELECT TOP 1 TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID
			FROM      VIEW_USER_ROBOT_BIND_LIST
				   , TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL
				   , VIEW_VOICE
			WHERE   
				   TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.VOICE_ID = VIEW_VOICE.ID
				AND TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.GEN_DATETIME IS NULL
				AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = @ROBOT_ID  
				AND VIEW_USER_ROBOT_BIND_LIST.USER_ID = TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.CREATE_USER_ID  	
				AND VIEW_VOICE.ENABLED = 1
				AND REQUEST LIKE '%' + @INPUT_STRING + '%'   
		)

		IF @DEBUG = 1 
		BEGIN
			PRINT '客户原始规则应答'
			PRINT ISNULL(@VOICE_ID, -1)
		END

	END

	IF @VOICE_ID IS NULL AND @MAX_MATCHED_VOICE_GROUP_ID = -1
		-- 扩展语义第三优先级
	BEGIN

		IF @DEBUG = 1 
		BEGIN
			PRINT '扩展语义'
		END

		DECLARE CUR_CHECK_KW_ENTIRELY
		CURSOR FOR 

		SELECT KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID, COUNT(DISTINCT KEY_WORD_GROUP_ID) AS CNT
		FROM VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE 
		WHERE 		 
		(
			CHARINDEX(KEY_WORD, @INPUT_STRING) > 0   
			OR 
			(
				(
					KEY_WORD_CATEGORY = 0 
					OR GROUP_FLOW_USE_SOUND = 1
				) 
				AND  
				CHARINDEX(KEY_WORD_SOUND, @PINYIN) > 0     
			)
		)
		GROUP BY KEY_WORD_GROUP_FLOW_ID, USE_FULLY_MATCH, VOICE_GROUP_ID
		ORDER BY USE_FULLY_MATCH DESC, CNT DESC

		OPEN CUR_CHECK_KW_ENTIRELY

		FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
		@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @ACT_CNT = COUNT(WORD_GROUP_ID) FROM TBL_WORD_GROUP_FLOW 
			WHERE ID = @KEY_WORD_GROUP_FLOW_ID

			IF @ACT_CNT <= @KEY_WORD_GROUP_ID_COUNT
			BEGIN

				IF @DEBUG = 1 
				BEGIN
					PRINT '找到匹配'
					PRINT '  @KEY_WORD_GROUP_FLOW_ID = ' + CAST (@KEY_WORD_GROUP_FLOW_ID AS VARCHAR(20))
						+ '  @VOICE_GROUP_ID = ' + CAST (@VOICE_GROUP_ID AS VARCHAR(20))
						+ '  @KEY_WORD_GROUP_ID_COUNT = ' + CAST (@KEY_WORD_GROUP_ID_COUNT AS VARCHAR(20))
				END

				-- 先严格匹配
				IF  @USE_FULLY_MATCH = 1
				BEGIN
					IF DBO.FUNC_IS_FULLY_MATCHED(@INPUT_STRING, @KEY_WORD_GROUP_FLOW_ID) = 1 
					BEGIN

						IF @DEBUG = 1 
						BEGIN
							PRINT '使用严格匹配'
						END

						EXEC SP_GET_VOICE_COUNT_BY_ROBOT_ID  
							  @VOICE_GROUP_ID
							, @ROBOT_ID
							, @VOICE_COUNT OUTPUT
							, @MATCHED_DEGREE OUTPUT

						IF @VOICE_COUNT > 0 
						BEGIN
							IF @DEBUG = 1 
							BEGIN
								PRINT '严格匹配应答数:'
								PRINT ' @VOICE_COUNT = ' + CAST (@VOICE_COUNT AS VARCHAR(20))
							END

							SET @MAX_ACT_CNT = @ACT_CNT
							SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID
							BREAK
						END
						ELSE
						BEGIN
							PRINT '严格匹配应答数为0, 放弃'
							GOTO NEXT_ITEM
						END
					END	
					ELSE
					BEGIN
						GOTO NEXT_ITEM
					END
				END

				IF @MAX_ACT_CNT < @ACT_CNT
				BEGIN

					EXEC SP_GET_VOICE_COUNT_BY_ROBOT_ID  
						  @VOICE_GROUP_ID
						, @ROBOT_ID
						, @VOICE_COUNT OUTPUT
						, @MATCHED_DEGREE OUTPUT

					IF @DEBUG = 1 
					BEGIN
						PRINT '应答数:'
						PRINT ' @VOICE_COUNT = ' + CAST (@VOICE_COUNT AS VARCHAR(20))
					END

					IF @VOICE_COUNT > 0 
					BEGIN
						SET @MAX_ACT_CNT = @ACT_CNT
						SET @MAX_MATCHED_VOICE_GROUP_ID = @VOICE_GROUP_ID

						IF @DEBUG = 1 
						BEGIN
							PRINT '发现更优匹配:'
							PRINT ' NEW MAX MATCHED @MAX_MATCHED_VOICE_GROUP_ID = ' + CAST (@MAX_MATCHED_VOICE_GROUP_ID AS VARCHAR(20))
							+ ' @MAX_ACT_CNT = ' + CAST (@MAX_ACT_CNT AS VARCHAR(20))

						END
					END
				END
			END

			NEXT_ITEM:
			FETCH NEXT FROM CUR_CHECK_KW_ENTIRELY INTO 
			@KEY_WORD_GROUP_FLOW_ID, @USE_FULLY_MATCH, @VOICE_GROUP_ID, @KEY_WORD_GROUP_ID_COUNT
		END
		CLOSE CUR_CHECK_KW_ENTIRELY
		DEALLOCATE CUR_CHECK_KW_ENTIRELY		
	END

	IF @DEBUG = 1 
	BEGIN
		PRINT '扩展语义结果'
		PRINT ' @MAX_MATCHED_VOICE_GROUP_ID = ' + CAST (@MAX_MATCHED_VOICE_GROUP_ID AS VARCHAR(20))
		PRINT ' @VOICE_ID = ' + CAST (@VOICE_ID AS VARCHAR(20))

	END

	IF @VOICE_ID IS NOT NULL
	BEGIN
		IF @DEBUG = 1 
		BEGIN
			PRINT '直接输出 voice_id' 
			PRINT @VOICE_ID
		END

		SELECT  
			   @VOICE_NAME = [NAME]
			  ,@VOICE_PATH = [PATH]
			  ,@VOICE_TEXT = [TEXT]
			  ,@VOICE_CAT = [CAT]
			  ,@VOICE_DESCRIPTION = [DESCRIPTION]
			  ,@VOICE_COMMAND = [COMMAND]
			  ,@VOICE_COMMAND_PARAM = [COMMAND_PARAM]
			  ,@VOICE_THIRD_PARTY_API_NAME =  [THIRD_PARTY_API_NAME]
			  ,@VOICE_THIRD_PARTY_API_METHOD =  [THIRD_PARTY_API_METHOD]
			  ,@VOICE_THIRD_PARTY_API_HEADER_PARAMS = [THIRD_PARTY_API_HEADER_PARAMS]
			  ,@VOICE_THIRD_PARTY_API_URL = [THIRD_PARTY_API_URL]
			  ,@VOICE_THIRD_PARTY_API_RESULT_TYPE =  [THIRD_PARTY_API_RESULT_TYPE]
			  ,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER =  [THIRD_PARTY_API_RUN_AT_SERVER]
			  ,@VOICE_EMOTION =  [EMOTION]
		  FROM [VIEW_VOICE] WHERE ID = @VOICE_ID
	END
	ELSE
	BEGIN
		IF @DEBUG = 1 
		BEGIN
			PRINT '选择 voice id，从group' 
			PRINT @MAX_MATCHED_VOICE_GROUP_ID
		END


		EXEC SP_SELECT_VOICE_BY_ROBOT_ID
			 @MAX_MATCHED_VOICE_GROUP_ID
			,@ROBOT_ID
			,@VOICE_NAME output
			,@VOICE_PATH output
			,@VOICE_TEXT output
			,@VOICE_EMOTION output
			,@VOICE_COMMAND    output
			,@VOICE_COMMAND_PARAM output
			,@VOICE_THIRD_PARTY_API_NAME OUTPUT
			,@VOICE_THIRD_PARTY_API_METHOD OUTPUT
			,@VOICE_THIRD_PARTY_API_HEADER_PARAMS OUTPUT
			,@VOICE_THIRD_PARTY_API_URL OUTPUT
			,@VOICE_THIRD_PARTY_API_RESULT_TYPE output
			,@VOICE_THIRD_PARTY_API_RUN_AT_SERVER output
			,@VOICE_CAT  output
			,@VOICE_DESCRIPTION    output
			,@VOICE_COUNT
			,@MATCHED_DEGREE	
	END

	IF @DEBUG = 1 
	BEGIN
		PRINT 'config 代入，第一轮'
	END

	-- 替换config参数
	SET @VOICE_PATH = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_PATH, @IMEI)
	SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_EMOTION, @IMEI)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)

	IF @DEBUG = 1 
	BEGIN
		PRINT 'request 代入，第一轮'
	END

	-- 替换request 参数
	SET @VOICE_TEXT = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_TEXT, @REQUEST_ID)
	SET @VOICE_EMOTION = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_EMOTION, @REQUEST_ID)
	SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_COMMAND_PARAM, @REQUEST_ID)
	SET @VOICE_THIRD_PARTY_API_URL = dbo.FUNC_FILLED_REQUEST_VALUE(@VOICE_THIRD_PARTY_API_URL, @REQUEST_ID)

	IF @DEBUG = 1 
	BEGIN
		PRINT '数据库例程'
	END

	-- 数据库命令
	IF @VOICE_COMMAND = 1433
	BEGIN
		IF @DEBUG = 1 
		BEGIN
			PRINT '1433 数据库例程'
		END

		EXEC SP_EXECUTESQL @VOICE_COMMAND_PARAM
        , N'@VOICE_COMMAND BIGINT OUTPUT, @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT, @VOICE_TEXT NVARCHAR(1024) OUTPUT '
		, @VOICE_COMMAND OUTPUT
		, @VOICE_COMMAND_PARAM OUTPUT
		, @VOICE_TEXT OUTPUT 

		IF @DEBUG = 1 
		BEGIN
			PRINT 'config 代入，第二轮'
		END
		-- 对计算结果再做一轮config参数替换
		SET @VOICE_TEXT = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_TEXT, @IMEI)
		SET @VOICE_COMMAND_PARAM = dbo.FUNC_FILLED_CONFIG_VALUE(@VOICE_COMMAND_PARAM, @IMEI)
		-- SET @VOICE_CAT = '5' -- 上下文相关
	END

	IF @DEBUG = 1 
	BEGIN
		PRINT '噪声判断'
	END

	IF  @VOICE_CAT = '2' AND 
		(
			CAST(DBO.FUNC_GET_CONTEXT_VALUE(@ROBOT_ID, 'UNKONW_COUNT', '0') AS BIGINT) >=
			CAST(DBO.FUNC_GET_META_SETTINGS('MAX_UNKONW_COUNT', '3') AS BIGINT)
		)
	BEGIN
		SET @VOICE_NAME = '噪音'
		SET @VOICE_CAT = '1'
		SET @VOICE_COMMAND = 99
		SET @VOICE_TEXT = '.'
	END

	LAST_STEP:

	IF @DEBUG = 1 
	BEGIN
		PRINT '最后一步，输出'
	END

	SELECT
		 0 AS ID
		,@MAX_MATCHED_VOICE_GROUP_ID VOICE_GROUP_ID
		,' ' AS VOICE_INC_PROP
		,' ' AS VOICE_EXC_PROP
		,ISNULL(@VOICE_NAME, '') AS VOICE_NAME
		,ISNULL(@VOICE_PATH , '') AS VOICE_PATH
		,ISNULL(@VOICE_TEXT, '') AS VOICE_TEXT
		,ISNULL(@VOICE_EMOTION, '') AS VOICE_EMOTION
		,ISNULL(@VOICE_COMMAND, 0)    AS VOICE_COMMAND
		,ISNULL(@VOICE_COMMAND_PARAM, '') AS VOICE_COMMAND_PARAM
		,ISNULL(@VOICE_THIRD_PARTY_API_NAME , '')AS VOICE_THIRD_PARTY_API_NAME
		,ISNULL(@VOICE_THIRD_PARTY_API_METHOD, '') AS VOICE_THIRD_PARTY_API_METHOD
		,ISNULL(@VOICE_THIRD_PARTY_API_HEADER_PARAMS, '') AS VOICE_THIRD_PARTY_API_HEADER_PARAMS
		,ISNULL(@VOICE_THIRD_PARTY_API_URL, '') AS VOICE_THIRD_PARTY_API_URL
		,ISNULL(@VOICE_THIRD_PARTY_API_RESULT_TYPE, '') AS VOICE_THIRD_PARTY_API_RESULT_TYPE
		,ISNULL(@VOICE_THIRD_PARTY_API_RUN_AT_SERVER, '') AS VOICE_THIRD_PARTY_API_RUN_AT_SERVER
		,ISNULL(@VOICE_CAT, '')  AS VOICE_CAT
		,ISNULL(@VOICE_DESCRIPTION, '')    AS VOICE_DESCRIPTION	
		,1 AS VOICE_ENABLED
  
SET NOCOUNT OFF



















































GO
/****** Object:  StoredProcedure [dbo].[SP_SWITCH_MANUAL_MODE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SWITCH_MANUAL_MODE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_SWITCH_MANUAL_MODE] AS' 
END
GO
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-12-7
-- Description:	手动模式切换
-- =============================================
ALTER PROCEDURE [dbo].[SP_SWITCH_MANUAL_MODE]
	 @USER_ID BIGINT
	,@ROBOT_ID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS(
		SELECT  ROBOT_ID FROM [VIEW_USER_ROBOT_BIND_LIST]
		WHERE  @USER_ID = USER_ID AND @ROBOT_ID = ROBOT_ID)
	 BEGIN
			 RAISERROR ('无权切换',  15,  5) 
			 RETURN
	 END

	UPDATE ENT_ROBOT SET MANUAL_MODE = ~MANUAL_MODE WHERE ID = @ROBOT_ID

END

GO
/****** Object:  StoredProcedure [dbo].[SP_USER_LOGIN]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_USER_LOGIN]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_USER_LOGIN] AS' 
END
GO








-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-3-31
-- Description: 用户登录
/*

1. 根据 IMEI, USERNAME, PASSWORD 找出机器人的资料， 验证用户， 

输入：
UserAgent
UserName  
password

输出：
code
message
id
name
groupName
lastestLoginDatetime
loginCount
robot[+d].id
robot[+d].status
robot[+d].name
robot[+d].activateDatetime


*/

-- =============================================
ALTER PROCEDURE [dbo].[SP_USER_LOGIN] 
	-- Add the parameters for the stored procedure here
	 @USER_AGENT AS NVARCHAR(4000)  -- IN
	,@USER_NAME  AS NVARCHAR(4000)  -- IN
	,@PASSWORD   AS NVARCHAR(4000)  -- IN
	,@DIG   AS NVARCHAR(4000)  -- IN
	,@SESSION_ID AS NVARCHAR(4000)  -- IN
	--,@USER_ID   AS BIGINT OUTPUT  -- 用户ID
	,@LOGIN_COUNT   AS BIGINT OUTPUT -- 登录次数
	,@HIJACK AS BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 	DECLARE @USER_ID AS BIGINT 
	DECLARE @ROBOT_COUNT  AS BIGINT
	DECLARE @LASTEST_SESSION_ID NVARCHAR(4000)
	
	SET @ROBOT_COUNT = 0
	SET @USER_ID = NULL
	SET @LASTEST_SESSION_ID = NULL
	SET @HIJACK = ISNULL(@HIJACK, 0)

	SELECT  @USER_ID = USER_ID, @ROBOT_COUNT = COUNT(ROBOT_ID) FROM [VIEW_USER_ROBOT_BIND_LIST]
	WHERE USER_NAME = @USER_NAME 
	AND 
	(
		USER_PASSWORD = @PASSWORD 
		OR USER_PASSWORD = @DIG
	)  GROUP BY USER_ID

	
	IF @ROBOT_COUNT > 0 
	BEGIN

		SELECT @LOGIN_COUNT = COUNT([WSS_SESSION_ID])
		FROM TBL_USER_STATUS
		WHERE USER_ID = @USER_ID AND [ONLINE] = 1

		
		SELECT @LASTEST_SESSION_ID = USER_LASTEST_STATUS_WSS_SESSION_ID  FROM [VIEW_USER_ROBOT_BIND_LIST]
		WHERE USER_NAME = @USER_NAME AND
		   (
				USER_PASSWORD = @PASSWORD 
				OR USER_PASSWORD = @DIG
			)  AND [USER_LASTEST_STATUS_ONLINE] = 1


		 IF @HIJACK = 0 AND  @LASTEST_SESSION_ID IS NOT NULL
		-- 已经登录
		 BEGIN
			RAISERROR ('该用户已在别处登录，请勿重复登录！',  15,  5) 
			RETURN
			-- print '该用户已在别处登录，请勿重复登录！'
		 END
	   

	 INSERT INTO TBL_USER_STATUS
           (USER_ID
           ,[UPDATE_DATETIME]
           ,[WSS_SESSION_ID]
           ,[ONLINE]
           ,[EXTRA_INFO])
     VALUES
           (@USER_ID
           , GETDATE()
           , @SESSION_ID
           , 1
           , @USER_AGENT)

		SELECT *
		  FROM [VIEW_USER_ROBOT_BIND_LIST]
	   WHERE USER_NAME = @USER_NAME AND 		  
	    (
				USER_PASSWORD = @PASSWORD 
				OR USER_PASSWORD = @DIG
		) 
		order by [VIEW_USER_ROBOT_BIND_LIST].ROBOT_LATEST_STATUS_ONLINE desc
		, [VIEW_USER_ROBOT_BIND_LIST].ROBOT_LATEST_STATUS_UPDATE_DATETIME desc
		, [VIEW_USER_ROBOT_BIND_LIST].ROBOT_ACTIVATE_DATETIME desc
	END
	ELSE
	BEGIN
			RAISERROR (N'用户名或密码有误！',  
           15,  
           1)  

	END
END









GO
/****** Object:  StoredProcedure [dbo].[TEST_DIALOG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEST_DIALOG]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TEST_DIALOG] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[TEST_DIALOG]
	-- Add the parameters for the stored procedure here
		@arg_input  AS NVARCHAR(512),
		@arg_model  as nvarchar(120)
	AS
BEGIN
	EXEC [SP_SMART_DIALOG_NO_OUTPUT]
		@INPUT_STRING = @arg_input,
		@MODLE = @arg_model,
		@IMEI = N'TEST_DILOG'
END

GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_ENT_KEY_WORDS]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_ENT_KEY_WORDS]'))
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-23
-- Description:	ID 生成器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_ENT_KEY_WORDS]
   ON  [dbo].[ENT_KEY_WORDS]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''ENT_KEY_WORDS'', @GEN_ID OUTPUT

	INSERT INTO ENT_KEY_WORDS  
	SELECT  @GEN_ID, KW, CAT, DBO.FUNC_GET_PINYIN(KW) AS SOUND FROM INSERTED

END

' 
GO
/****** Object:  Trigger [dbo].[TRG_CHECK_SCENE_ID_VALID]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRG_CHECK_SCENE_ID_VALID]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-14
-- Description:	检查场景ID是否与用户ID匹配
-- =============================================
CREATE TRIGGER [dbo].[TRG_CHECK_SCENE_ID_VALID]
   ON [dbo].[ENT_ROBOT] 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SCENE_ID  BIGINT
	DECLARE @ACTIVATED_USER_ID BIGINT
	DECLARE @ACTIVATED_USER_GROUP_ID BIGINT

	SELECT @SCENE_ID = USER_GROUP_SCENE_ID, @ACTIVATED_USER_ID = ACTIVATE_USER_ID  FROM inserted


	IF @SCENE_ID IS NOT NULL AND NOT EXISTS(
		SELECT * FROM 
		ENT_USER
		, ENT_USER_GROUP
		, TBL_USER_GROUP_SCENE
		WHERE
		ENT_USER.USER_GROUP_ID = ENT_USER_GROUP.ID
		AND ENT_USER_GROUP.ID = TBL_USER_GROUP_SCENE.USER_GROUP_ID  
		AND TBL_USER_GROUP_SCENE.ID = @SCENE_ID
		AND ENT_USER.ID = @ACTIVATED_USER_ID
	)

			RAISERROR (N''只能使用激活用户所在企业的场景！'',  
           15,  
           1)  
    -- Insert statements for trigger here

END

' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	自动ID触发器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API]
   ON  [dbo].[ENT_THIRD_PARTY_API]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''ENT_THIRD_PARTY_API'', @GEN_ID OUTPUT

	INSERT INTO ENT_THIRD_PARTY_API  
 

	SELECT @GEN_ID
		,[NAME]
		,[ENABLE]
		,[URL]
		,[METHOD]
		,[RUN_AT_SERVER]
		,[RESULT_TYPE]
		,[DESCRIPTION]
	FROM INSERTED

END
' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API_PARAM]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API_PARAM]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	自动ID触发器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API_PARAM]
   ON  [dbo].[ENT_THIRD_PARTY_API_PARAM]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''ENT_THIRD_PARTY_API_PARAM'', @GEN_ID OUTPUT


	INSERT INTO [ENT_THIRD_PARTY_API_PARAM]
	SELECT @GEN_ID
		,[NAME]
		,[HEADER_0_BODY_1]
		,[OPTIONAL]
		,[DEFAULT_VALUE]
		,[DESCRIPTION]
	FROM INSERTED

END
' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API_PARAM_VALUE]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-5
-- Description:	自动ID触发器
-- =============================================
create TRIGGER [dbo].[TG_AUTO_GEN_ID_ENT_THIRD_PARTY_API_PARAM_VALUE]
   ON  [dbo].[ENT_THIRD_PARTY_API_PARAM_VALUE]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''ENT_THIRD_PARTY_API_PARAM_VALUE'', @GEN_ID OUTPUT


	INSERT INTO [ENT_THIRD_PARTY_API_PARAM_VALUE]
	SELECT @GEN_ID
		,NAME
		,THIRD_PARTY_API_ID
		,ENABLED
		,DESCRIPTION
	FROM INSERTED

END
' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_ENT_VOICE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_ENT_VOICE]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-23
-- Description:	自动ID触发器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_ENT_VOICE]
   ON  [dbo].[ENT_VOICE]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''ENT_VOICE'', @GEN_ID OUTPUT

	INSERT INTO ENT_VOICE  
	SELECT    @GEN_ID
      ,[NAME]
      ,[PATH]
      ,[EMOTION]
      ,[TEXT]
      ,[COMMAND]
      ,[COMMAND_PARAM]
	  ,[THIRD_PARTY_API_ID]
	  ,[THIRD_PARTY_API_PARAMS_VALUE_ID]
      ,[INC_PROP]
      ,[EXC_PROP]
      ,[CAT]
      ,[FIXED_PARAM_1]
      ,[FIXED_PARAM_2]
      ,[FIXED_PARAM_3]
      ,[FIXED_PARAM_4]
      ,[FIXED_PARAM_5]
	  ,[ENABLED]
      ,[DESCRIPTION]
   FROM INSERTED

END
' 
GO
/****** Object:  Trigger [dbo].[TG_DEL_VOICE_TAG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_DEL_VOICE_TAG]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-23
-- Description:	删除tag
-- =============================================
CREATE TRIGGER [dbo].[TG_DEL_VOICE_TAG]
   ON  [dbo].[ENT_VOICE]
   FOR DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	DELETE TBL_VOICE_TAG WHERE VOICE_ID IN  (SELECT ID FROM DELETED)
 
END
' 
GO
/****** Object:  Trigger [dbo].[TG_GEN_VOICE_TAG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_GEN_VOICE_TAG]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-7-23
-- Description:	生成
-- =============================================
CREATE TRIGGER [dbo].[TG_GEN_VOICE_TAG]
   ON  [dbo].[ENT_VOICE]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ID AS BIGINT
	DECLARE @TAGS AS NVARCHAR(4000)

	IF UPDATE(INC_PROP)
	BEGIN
		SELECT    
			@ID = ID
		  , @TAGS = INC_PROP 
		FROM INSERTED
		
		EXEC SP_GEN_VOICE_TAG @ID, @TAGS
	END
END
' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_ENT_VOICE_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_ENT_VOICE_GROUP]'))
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-28
-- Description:	ID 生成器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_ENT_VOICE_GROUP]
   ON  [dbo].[ENT_VOICE_GROUP]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''ENT_VOICE_GROUP'', @GEN_ID OUTPUT

	INSERT INTO ENT_VOICE_GROUP  
	SELECT  @GEN_ID, [NAME], DESCRIPTION  FROM INSERTED

END


' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_ENT_WORD_GROUP]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_ENT_WORD_GROUP]'))
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-28
-- Description:	ID 生成器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_ENT_WORD_GROUP]
   ON  [dbo].[ENT_WORD_GROUP]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''ENT_WORD_GROUP'', @GEN_ID OUTPUT

	INSERT INTO ENT_WORD_GROUP  
	SELECT  @GEN_ID, [NAME], DESCRIPTION  FROM INSERTED

END

' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_ENT_WORD_GROUP_FLOW]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_ENT_WORD_GROUP_FLOW]'))
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-28
-- Description:	ID 生成器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_ENT_WORD_GROUP_FLOW]
   ON  [dbo].[ENT_WORD_GROUP_FLOW]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''ENT_WORD_GROUP_FLOW'', @GEN_ID OUTPUT

	INSERT INTO ENT_WORD_GROUP_FLOW  
	SELECT  @GEN_ID, [NAME], DESCRIPTION  FROM INSERTED

END

' 
GO
/****** Object:  Trigger [dbo].[TRIG_HW_SPEC_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_HW_SPEC_CONFIG]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-9
-- Description:	行业只能客制化通用的配置
-- =============================================
create TRIGGER [dbo].[TRIG_HW_SPEC_CONFIG] 
   ON   [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_HW_SPEC]
   AFTER  INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	IF NOT EXISTS(
		SELECT NAME FROM VIEW_CONFIG_COMMON 
		WHERE  NAME = (SELECT NAME FROM inserted)
	)
	
		RAISERROR (N''硬件配置只能客制化共同配置！'',  
           15,  
           1)  
END


 

' 
GO
/****** Object:  Trigger [dbo].[TRIG_INDUSTY_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_INDUSTY_CONFIG]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-9
-- Description:	行业只能客制化通用的配置
-- =============================================
CREATE TRIGGER [dbo].[TRIG_INDUSTY_CONFIG] 
   ON   [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_INDUSTRY]
   AFTER  INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	IF NOT EXISTS(
		SELECT NAME FROM VIEW_CONFIG_COMMON 
		WHERE  NAME = (SELECT NAME FROM inserted)
	)
	
		RAISERROR (N''行业只能客制化共同配置！'',  
           15,  
           1)  
END

' 
GO
/****** Object:  Trigger [dbo].[TRIG_ROBOT_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_ROBOT_CONFIG]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-9
-- Description:	机器人配置只能客制化通用配置，本行业配置，本企业配置，所属场景的配置
-- =============================================
CREATE TRIGGER [dbo].[TRIG_ROBOT_CONFIG] 
   ON   [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_ROBOT]
   AFTER  INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @CFG_NAME NVARCHAR(256)
	DECLARE @ROBOT_ID BIGINT

	SELECT @CFG_NAME = NAME, @ROBOT_ID = ROBOT_ID  FROM inserted
	
	IF NOT EXISTS(
		SELECT NAME FROM VIEW_CONFIG_COMMON WHERE NAME = @CFG_NAME

		UNION  	

		SELECT VIEW_CONFIG_INDUSTRY.NAME 
		FROM VIEW_CONFIG_INDUSTRY , VIEW_USER_ROBOT_BIND_LIST
		WHERE 
		    VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_ID = VIEW_CONFIG_INDUSTRY.OWNER_ID 
		AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = @ROBOT_ID
		AND VIEW_CONFIG_INDUSTRY.NAME = @CFG_NAME 

		UNION

		SELECT VIEW_CONFIG_USER_GROUP.NAME 
		FROM VIEW_CONFIG_USER_GROUP , VIEW_USER_ROBOT_BIND_LIST
		WHERE 
		VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID = VIEW_CONFIG_USER_GROUP.OWNER_ID 
		AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = @ROBOT_ID
		AND VIEW_CONFIG_USER_GROUP.NAME = @CFG_NAME 

		UNION

		SELECT VIEW_CONFIG_USER_GROUP_SCENE.NAME 
		FROM VIEW_CONFIG_USER_GROUP_SCENE , VIEW_USER_ROBOT_BIND_LIST
		WHERE 
		VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_SCENE_ID = VIEW_CONFIG_USER_GROUP_SCENE.OWNER_ID 
		AND VIEW_USER_ROBOT_BIND_LIST.ROBOT_ID = @ROBOT_ID
		AND VIEW_CONFIG_USER_GROUP_SCENE.NAME = @CFG_NAME 

 
	)
	RAISERROR (N''机器人配置只能客制化通用配置，本行业配置，本企业配置，所属场景的配置！'',  
           15,  
           1)  
END

' 
GO
/****** Object:  Trigger [dbo].[TRIG_USER_GROUP_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_USER_GROUP_CONFIG]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-9
-- Description:	企业只能客制化通用配置，本行业配置
-- =============================================
CREATE TRIGGER [dbo].[TRIG_USER_GROUP_CONFIG] 
   ON   [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP]
   AFTER  INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @CFG_NAME NVARCHAR(256)
	DECLARE @USER_GROUP_ID BIGINT

	SELECT @CFG_NAME = NAME, @USER_GROUP_ID = USER_GROUP_ID  FROM inserted
	
	IF NOT EXISTS(
		SELECT NAME FROM VIEW_CONFIG_COMMON WHERE NAME = @CFG_NAME
		UNION  	
		SELECT VIEW_CONFIG_INDUSTRY.NAME FROM VIEW_CONFIG_INDUSTRY , ENT_USER_GROUP	
		WHERE ENT_USER_GROUP.INDUSTRY_ID = VIEW_CONFIG_INDUSTRY.OWNER_ID AND	
		VIEW_CONFIG_INDUSTRY.NAME = @CFG_NAME AND ENT_USER_GROUP.ID = @USER_GROUP_ID
	)
	RAISERROR (N''企业只能客制化通用配置，本行业配置！'',  
           15,  
           1)  
END

' 
GO
/****** Object:  Trigger [dbo].[TRIG_USER_GROUP_SCENE_CONFIG]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_USER_GROUP_SCENE_CONFIG]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-9
-- Description:	场景只能客制化通用配置，本行业配置，本企业配置
-- =============================================
CREATE TRIGGER [dbo].[TRIG_USER_GROUP_SCENE_CONFIG] 
   ON   [dbo].[TBL_CUSTOMIZED_CONFIG_FOR_USER_GROUP_SCENE]
   AFTER  INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @CFG_NAME NVARCHAR(256)
	DECLARE @USER_GROUP_SCENE_ID BIGINT

	SELECT @CFG_NAME = NAME, @USER_GROUP_SCENE_ID = USER_GROUP_SCENE_ID  FROM inserted
	
	IF NOT EXISTS(
		SELECT NAME FROM VIEW_CONFIG_COMMON WHERE NAME = @CFG_NAME

		UNION  	

		SELECT VIEW_CONFIG_INDUSTRY.NAME 
		FROM VIEW_CONFIG_INDUSTRY , VIEW_USER_ROBOT_BIND_LIST, TBL_USER_GROUP_SCENE
		WHERE 
		    VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_INDUSTRY_ID = VIEW_CONFIG_INDUSTRY.OWNER_ID 
		AND VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID = TBL_USER_GROUP_SCENE.USER_GROUP_ID
		AND TBL_USER_GROUP_SCENE.ID = @USER_GROUP_SCENE_ID
		AND VIEW_CONFIG_INDUSTRY.NAME = @CFG_NAME 

		UNION

		SELECT VIEW_CONFIG_USER_GROUP.NAME 
		FROM VIEW_CONFIG_USER_GROUP , VIEW_USER_ROBOT_BIND_LIST, TBL_USER_GROUP_SCENE
		WHERE 
		VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID = VIEW_CONFIG_USER_GROUP.OWNER_ID 
		AND VIEW_USER_ROBOT_BIND_LIST.USER_GROUP_ID = TBL_USER_GROUP_SCENE.USER_GROUP_ID
		AND TBL_USER_GROUP_SCENE.ID = @USER_GROUP_SCENE_ID
		AND VIEW_CONFIG_USER_GROUP.NAME = @CFG_NAME 

 
	)
	RAISERROR (N''场景只能客制化通用配置，本行业配置，本企业配置！'',  
           15,  
           1)  
END

' 
GO
/****** Object:  Trigger [dbo].[TRIG_TBL_THIRD_PARTY_API_PARAM_VALUE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_TBL_THIRD_PARTY_API_PARAM_VALUE]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-6-11
-- Description:	check 第三方参数值合法性
-- =============================================
CREATE TRIGGER [dbo].[TRIG_TBL_THIRD_PARTY_API_PARAM_VALUE] 
   ON   [dbo].[TBL_THIRD_PARTY_API_PARAM_VALUE]
   AFTER  INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @VALUE_ID AS BIGINT
	DECLARE @PARAM_ID AS BIGINT
	DECLARE @API_NAME AS NVARCHAR(500)
	DECLARE @PARAM_DESCRIPTION AS NVARCHAR(500)

	SELECT @VALUE_ID = THIRD_PARTY_API_PARAM_VALUE_ID, @PARAM_ID = THIRD_PARTY_API_PARAM_ID  FROM inserted

	SELECT @API_NAME = ENT_THIRD_PARTY_API.NAME FROM ENT_THIRD_PARTY_API, ENT_THIRD_PARTY_API_PARAM_VALUE
	WHERE ENT_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_ID = ENT_THIRD_PARTY_API.ID
	AND   ENT_THIRD_PARTY_API_PARAM_VALUE.ID = @VALUE_ID

	SELECT @PARAM_DESCRIPTION = DESCRIPTION FROM ENT_THIRD_PARTY_API_PARAM WHERE ID = @PARAM_ID

	IF NOT EXISTS(
		SELECT *
		FROM
		ENT_THIRD_PARTY_API INNER JOIN 
		ENT_THIRD_PARTY_API_PARAM
		ON 
		(
			ENT_THIRD_PARTY_API_PARAM.ID = @PARAM_ID
		)
		INNER JOIN ENT_THIRD_PARTY_API_PARAM_VALUE
		ON
		(
			ENT_THIRD_PARTY_API.ID =  ENT_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_ID
		)
		INNER JOIN TBL_THIRD_PARTY_API_PARAM 
		ON 
		(
			ENT_THIRD_PARTY_API_PARAM_VALUE.THIRD_PARTY_API_ID  = TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_ID
			AND ENT_THIRD_PARTY_API_PARAM.ID = TBL_THIRD_PARTY_API_PARAM.THIRD_PARTY_API_PARAM_ID
			AND ENT_THIRD_PARTY_API_PARAM_VALUE.ID = @VALUE_ID
		))

	BEGIN
		DECLARE @ERROR AS NVARCHAR(4000)
		SET @ERROR  = ''第三方API ['' + @API_NAME + ''] 不包含参数 ['' + @PARAM_DESCRIPTION + '']''
		-- Insert statements for trigger here
		RAISERROR (@ERROR,  
			   15,  
			   1)  
	END
END
' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_TBL_USER_GROUP_SCENE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_TBL_USER_GROUP_SCENE]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		殷圣鸽
-- Create date: 2017-2-16
-- Description:	ID 生成器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_TBL_USER_GROUP_SCENE]
   ON  [dbo].[TBL_USER_GROUP_SCENE]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''TBL_USER_GROUP_SCENE'', @GEN_ID OUTPUT

 	INSERT INTO TBL_USER_GROUP_SCENE  
	SELECT    @GEN_ID
	  , USER_GROUP_ID
      ,[NAME]
	  ,[ENABLED]
      ,[DESCRIPTION]
	  ,TAG
   FROM INSERTED

END



' 
GO
/****** Object:  Trigger [dbo].[TG_AUTO_GEN_ID_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]    Script Date: 2017/8/15 15:16:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TG_AUTO_GEN_ID_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]'))
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		殷圣鸽
-- Create date: 2016-9-28
-- Description:	ID 生成器
-- =============================================
CREATE TRIGGER [dbo].[TG_AUTO_GEN_ID_TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]
   ON  [dbo].[TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @GEN_ID AS BIGINT

	EXEC SP_AUTO_GEN_ID ''TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE'', @GEN_ID OUTPUT

	INSERT INTO TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE  
SELECT @GEN_ID
      ,[WORD_GROUP_FLOW_ID]
      ,[VOICE_GROUP_ID]
      ,[USE_FLOW_ORDER]
	  ,[USE_FULLY_MATCH]
      ,[ENABLE]
      ,[DESCRIPTION]
 FROM INSERTED

END



' 
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_BIZ_MENUTREE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[33] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_BIZ_MENU_ENTRY"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 221
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_BIZ_MENUTREE"
            Begin Extent = 
               Top = 6
               Left = 225
               Bottom = 233
               Right = 420
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_BIZ_MENUITEM_ACTION"
            Begin Extent = 
               Top = 6
               Left = 458
               Bottom = 218
               Right = 607
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 3510
         Table = 3705
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_BIZ_MENUTREE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_BIZ_MENUTREE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_BIZ_MENUTREE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_CONFIG_MODULE_BIT_MASK', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_CONFIG_MODULE_BIT_MASK"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 127
               Right = 182
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_CONFIG_MODULE_BIT_MASK'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_CONFIG_MODULE_BIT_MASK', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_CONFIG_MODULE_BIT_MASK'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_DIALOG_UNKNOW', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_DIALOG"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 195
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_DIALOG_UNKNOW'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_DIALOG_UNKNOW', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_DIALOG_UNKNOW'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ENDPOINT_LATEST_STATUS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 5
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ENDPOINT_LATEST_STATUS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ENDPOINT_LATEST_STATUS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ENDPOINT_LATEST_STATUS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ENTITY', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ENTITY'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ENTITY', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ENTITY'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_FLOW_VOICE_RULE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 195
               Right = 244
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_VOICE_GROUP"
            Begin Extent = 
               Top = 6
               Left = 282
               Bottom = 106
               Right = 431
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_WORD_GROUP_FLOW"
            Begin Extent = 
               Top = 6
               Left = 469
               Bottom = 106
               Right = 618
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_FLOW_VOICE_RULE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_FLOW_VOICE_RULE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_FLOW_VOICE_RULE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_HUAQIN_2016_PROIVDER_CONFRENCE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[49] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_HUAQIN_2016_PROVIDER_CONFRENCE_COMPANY"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 196
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "TBL_HUAQIN_2016_PROVIDER_CONFRENCE_PATICIPANTS"
            Begin Extent = 
               Top = 6
               Left = 234
               Bottom = 146
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2340
         Alias = 3675
         Table = 5745
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_HUAQIN_2016_PROIVDER_CONFRENCE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_HUAQIN_2016_PROIVDER_CONFRENCE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_HUAQIN_2016_PROIVDER_CONFRENCE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_KEY_WORD_GROUP', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_KEY_WORDS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 214
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_WORD_GROUP"
            Begin Extent = 
               Top = 6
               Left = 279
               Bottom = 187
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_KEY_WORD_GROUP'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_KEY_WORD_GROUP', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_KEY_WORD_GROUP'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_KEY_WORDS_SIMPLE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_KEY_WORDS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 180
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_KEY_WORDS_SIMPLE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_KEY_WORDS_SIMPLE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_KEY_WORDS_SIMPLE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ORDER_ROOM', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBL_ORDER_ROOM"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 182
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_ROOM"
            Begin Extent = 
               Top = 6
               Left = 258
               Bottom = 189
               Right = 485
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3585
         Alias = 3150
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ORDER_ROOM'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ORDER_ROOM', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ORDER_ROOM'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_REQUEST_PROPERTY', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[31] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_REQUEST"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 204
               Right = 197
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_REQUEST_PROPERTY"
            Begin Extent = 
               Top = 6
               Left = 207
               Bottom = 270
               Right = 433
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2520
         Alias = 900
         Table = 2835
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_REQUEST_PROPERTY'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_REQUEST_PROPERTY', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_REQUEST_PROPERTY'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_BIND_LIST', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VERSION_MAIN_INFO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_ROBOT_APP_LASTEST_VERSION"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 273
               Right = 528
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_BIND_LIST'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_BIND_LIST', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_BIND_LIST'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_LASTEST_UPDATETIME', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_ROBOT_APP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_APP_VERSION"
            Begin Extent = 
               Top = 6
               Left = 253
               Bottom = 121
               Right = 447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_LASTEST_UPDATETIME'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_LASTEST_UPDATETIME', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_LASTEST_UPDATETIME'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_LASTEST_VERSION', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[37] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_ROBOT_APP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 210
               Right = 199
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_ROBOT_APP_LASTEST_VERSION_CODE"
            Begin Extent = 
               Top = 137
               Left = 225
               Bottom = 280
               Right = 426
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_APP_VERSION"
            Begin Extent = 
               Top = 6
               Left = 476
               Bottom = 191
               Right = 654
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4245
         Alias = 1695
         Table = 3195
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_LASTEST_VERSION'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_LASTEST_VERSION', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_LASTEST_VERSION'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_LASTEST_VERSION_CODE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_ROBOT_APP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 212
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_APP_VERSION"
            Begin Extent = 
               Top = 6
               Left = 253
               Bottom = 190
               Right = 447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 3060
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_LASTEST_VERSION_CODE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_LASTEST_VERSION_CODE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_LASTEST_VERSION_CODE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_VERSION', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_ROBOT_APP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 222
               Right = 199
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_APP_VERSION"
            Begin Extent = 
               Top = 6
               Left = 237
               Bottom = 224
               Right = 415
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_VERSION'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_VERSION', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_VERSION'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_VERSION_REQUIRED', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_DB_VERSION"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 217
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_APP_VERSION_REQUIRED"
            Begin Extent = 
               Top = 6
               Left = 255
               Bottom = 127
               Right = 437
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_ROBOT_APP_BIND_LIST"
            Begin Extent = 
               Top = 6
               Left = 475
               Bottom = 215
               Right = 714
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_APP_VERSION"
            Begin Extent = 
               Top = 132
               Left = 255
               Bottom = 272
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_VERSION_REQUIRED'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_APP_VERSION_REQUIRED', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_APP_VERSION_REQUIRED'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_BELONG', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_USER_ROBOT_BIND_LIST"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 341
            End
            DisplayFlags = 280
            TopColumn = 11
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1740
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1890
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_BELONG'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_BELONG', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_BELONG'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_CONFIG', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[38] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ALL_CONFIG"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_CONFIG'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_CONFIG', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_CONFIG'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_CONFIG_WITH_OWNER', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 5
         Column = 1440
         Alias = 2475
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_CONFIG_WITH_OWNER'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_CONFIG_WITH_OWNER', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_CONFIG_WITH_OWNER'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_LATEST_STATUS_drop', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[22] 2[23] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_ROBOT_STATUS_LASTEST_UPDATETIME"
            Begin Extent = 
               Top = 25
               Left = 396
               Bottom = 160
               Right = 614
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_STATUS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 179
               Right = 327
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_ROBOT"
            Begin Extent = 
               Top = 17
               Left = 641
               Bottom = 132
               Right = 827
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 3075
         Width = 1500
         Width = 3930
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_LATEST_STATUS_drop'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_LATEST_STATUS_drop', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_LATEST_STATUS_drop'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_MANUAL_TALK_CACHE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[55] 2[4] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBL_ROBOT_MANUAL_TALK_CACHE"
            Begin Extent = 
               Top = 6
               Left = 384
               Bottom = 92
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_ROBOT"
            Begin Extent = 
               Top = 132
               Left = 384
               Bottom = 272
               Right = 596
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_VOICE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 338
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3735
         Alias = 3330
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_MANUAL_TALK_CACHE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_MANUAL_TALK_CACHE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_MANUAL_TALK_CACHE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_MAX_PRIORITY_CONFIG', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_ROBOT_CONFIG"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "MAX_PRIORITY_CONFIG"
            Begin Extent = 
               Top = 6
               Left = 225
               Bottom = 106
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3810
         Alias = 900
         Table = 2715
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_MAX_PRIORITY_CONFIG'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_MAX_PRIORITY_CONFIG', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_MAX_PRIORITY_CONFIG'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[21] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_ROBOT_CONFIG_WITH_OWNER"
            Begin Extent = 
               Top = 46
               Left = 40
               Bottom = 268
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MAX_PRIORITY_CONFIG_WITH_OWNER"
            Begin Extent = 
               Top = 44
               Left = 435
               Bottom = 233
               Right = 579
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 3690
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_MAX_PRIORITY_CONFIG_WITH_OWNER'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_STATUS_LASTEST_UPDATETIME', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_ROBOT"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 121
               Right = 470
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_STATUS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_STATUS_LASTEST_UPDATETIME'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_STATUS_LASTEST_UPDATETIME', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_STATUS_LASTEST_UPDATETIME'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_TAGS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_ROBOT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_TAGS"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 91
               Right = 395
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_TAGS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_TAGS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_TAGS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_USER_BINDLIST', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[37] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_ROBOT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_USER"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 121
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_USER_GROUP"
            Begin Extent = 
               Top = 6
               Left = 465
               Bottom = 91
               Right = 596
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_ROBOT_STATUS_LASTEST_UPDATETIME"
            Begin Extent = 
               Top = 6
               Left = 634
               Bottom = 91
               Right = 852
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_ROBOT_STATUS"
            Begin Extent = 
               Top = 96
               Left = 465
               Bottom = 211
               Right = 641
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3045
         Width = 2505
      End
   End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_USER_BINDLIST'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_USER_BINDLIST', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1770
         Alias = 3060
         Table = 2760
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_USER_BINDLIST'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_ROBOT_USER_BINDLIST', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROBOT_USER_BINDLIST'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_RTC_SESSION_STATUS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBL_RTC_SESSION"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME"
            Begin Extent = 
               Top = 6
               Left = 252
               Bottom = 91
               Right = 470
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_RTC_SESSION_STATUS"
            Begin Extent = 
               Top = 6
               Left = 508
               Bottom = 106
               Right = 684
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_RTC_SESSION_STATUS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_RTC_SESSION_STATUS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_RTC_SESSION_STATUS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBL_RTC_SESSION"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_RTC_SESSION_STATUS"
            Begin Extent = 
               Top = 6
               Left = 258
               Bottom = 106
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_RTC_SESSION_STATUS_LASTEST_UPDATETIME'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[50] 4[15] 2[32] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBL_THIRD_PARTY_API_PARAM_VALUE"
            Begin Extent = 
               Top = 1
               Left = 318
               Bottom = 207
               Right = 619
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_THIRD_PARTY_API_PARAM"
            Begin Extent = 
               Top = 45
               Left = 663
               Bottom = 258
               Right = 863
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_THIRD_PARTY_API_PARAM_VALUE"
            Begin Extent = 
               Top = 164
               Left = 61
               Bottom = 304
               Right = 524
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_THIRD_PARTY_API"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 146
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2730
         Alias = 3315
         Table = 4680
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_THIRD_PARTY_API_PARAM_VALUE_ITEM'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_THIRD_PARTY_PARAMS_VALUE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[23] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_THIRD_PARTY_API_PARAMS_VALUE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 232
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_THIRD_PARTY_API"
            Begin Extent = 
               Top = 6
               Left = 266
               Bottom = 238
               Right = 665
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2175
         Alias = 1320
         Table = 3795
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_THIRD_PARTY_PARAMS_VALUE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_THIRD_PARTY_PARAMS_VALUE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_THIRD_PARTY_PARAMS_VALUE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_TODAY_CHAT_TIMELINE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[18] 4[24] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_DIALOG"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_TODAY_CHAT_TIMELINE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_TODAY_CHAT_TIMELINE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_TODAY_CHAT_TIMELINE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_USER_LASTEST_STATUS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[18] 2[33] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_USER_STATUS_LASTEST_UPDATETIME"
            Begin Extent = 
               Top = 6
               Left = 252
               Bottom = 91
               Right = 470
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_USER_STATUS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_USER"
            Begin Extent = 
               Top = 6
               Left = 508
               Bottom = 121
               Right = 673
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_USER_GROUP"
            Begin Extent = 
               Top = 6
               Left = 711
               Bottom = 91
               Right = 842
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USER_LASTEST_STATUS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_USER_LASTEST_STATUS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USER_LASTEST_STATUS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_USER_LASTEST_STATUS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USER_LASTEST_STATUS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_USER_ROBOT_BIND_LIST', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[50] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "U"
            Begin Extent = 
               Top = 6
               Left = 296
               Bottom = 227
               Right = 461
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_USER_LASTEST_STATUS"
            Begin Extent = 
               Top = 6
               Left = 499
               Bottom = 121
               Right = 681
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_ROBOT_LATEST_STATUS"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 19
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3300
         Alias = 3705
         Table = 37' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USER_ROBOT_BIND_LIST'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_USER_ROBOT_BIND_LIST', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'80
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USER_ROBOT_BIND_LIST'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_USER_ROBOT_BIND_LIST', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USER_ROBOT_BIND_LIST'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_USER_STATUS_LASTEST_UPDATETIME', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_USER"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 121
               Right = 449
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_USER_STATUS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2325
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USER_STATUS_LASTEST_UPDATETIME'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_USER_STATUS_LASTEST_UPDATETIME', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USER_STATUS_LASTEST_UPDATETIME'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VALID_THIRD_PARTY_API', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[38] 2[2] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_THIRD_PARTY_API"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 241
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VALID_THIRD_PARTY_API'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VALID_THIRD_PARTY_API', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VALID_THIRD_PARTY_API'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VALID_THIRD_PARTY_API_PARAMS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_VALID_THIRD_PARTY_API"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 194
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_THIRD_PARTY_API_PARAMS"
            Begin Extent = 
               Top = 7
               Left = 282
               Bottom = 233
               Right = 574
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VALID_THIRD_PARTY_API_PARAMS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VALID_THIRD_PARTY_API_PARAMS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VALID_THIRD_PARTY_API_PARAMS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VALID_THIRD_PARTY_API_PARAMS_VALUE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_THIRD_PARTY_API_PARAMS_VALUE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VALID_THIRD_PARTY_API_PARAMS_VALUE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VALID_THIRD_PARTY_API_PARAMS_VALUE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VALID_THIRD_PARTY_API_PARAMS_VALUE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VOICE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[30] 2[24] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_VOICE"
            Begin Extent = 
               Top = 98
               Left = 0
               Bottom = 355
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "R1"
            Begin Extent = 
               Top = 6
               Left = 239
               Bottom = 106
               Right = 388
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R2"
            Begin Extent = 
               Top = 6
               Left = 426
               Bottom = 106
               Right = 575
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R3"
            Begin Extent = 
               Top = 108
               Left = 239
               Bottom = 208
               Right = 388
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R4"
            Begin Extent = 
               Top = 108
               Left = 426
               Bottom = 208
               Right = 575
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R5"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 226
               Right = 187
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_VALID_THIRD_PARTY_API"
            Begin Extent = 
               Top = 6
               Left = 613
               Bottom = 211
               Right = 793
            End
            DisplayFlags = 280
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VOICE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VOICE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 12090
         Alias = 2940
         Table = 4230
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VOICE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VOICE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VOICE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VOICE_GROUP', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[57] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -1440
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_VOICE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "TBL_VOICE_GROUP"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 91
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5070
         Alias = 3315
         Table = 2340
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VOICE_GROUP'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VOICE_GROUP', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VOICE_GROUP'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VOICE_SIMPLE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[53] 4[17] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_VOICE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 363
               Right = 465
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VOICE_SIMPLE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_VOICE_SIMPLE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_VOICE_SIMPLE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBL_WORD_GROUP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 106
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_WORD_GROUP"
            Begin Extent = 
               Top = 6
               Left = 230
               Bottom = 106
               Right = 379
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_KEY_WORDS"
            Begin Extent = 
               Top = 6
               Left = 417
               Bottom = 106
               Right = 548
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 4920
         Table = 3510
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[34] 2[31] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_KEY_WORDS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 180
               Right = 165
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_WORD_GROUP"
            Begin Extent = 
               Top = 6
               Left = 207
               Bottom = 106
               Right = 361
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_WORD_GROUP_FLOW"
            Begin Extent = 
               Top = 6
               Left = 399
               Bottom = 184
               Right = 712
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2430
         Alias = 2475
         Table = 2445
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[44] 2[35] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -768
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_WORD_GROUP_FLOW"
            Begin Extent = 
               Top = 115
               Left = 598
               Bottom = 302
               Right = 840
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE"
            Begin Extent = 
               Top = 6
               Left = 273
               Bottom = 241
               Right = 479
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "TBL_VOICE_GROUP"
            Begin Extent = 
               Top = 6
               Left = 517
               Bottom = 192
               Right = 648
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_VOICE"
            Begin Extent = 
               Top = 45
               Left = 43
               Bottom = 246
               Right = 278
            End
            DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 19
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3645
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Alias = 4185
         Table = 2925
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[37] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ENT_VOICE"
            Begin Extent = 
               Top = 6
               Left = 308
               Bottom = 234
               Right = 582
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_VOICE_GROUP"
            Begin Extent = 
               Top = 6
               Left = 620
               Bottom = 217
               Right = 843
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 233
               Right = 270
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1710
         Table = 5760
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 270
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ENT_VOICE"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 312
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL_V2'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_SIMPLE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[24] 4[50] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 387
               Right = 495
            End
            DisplayFlags = 280
            TopColumn = 7
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_SIMPLE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_SIMPLE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_SIMPLE'
GO
USE [master]
GO
ALTER DATABASE [G2Robot] SET  READ_WRITE 
GO
