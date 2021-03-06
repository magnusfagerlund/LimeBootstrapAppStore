USE [limebootstrap_aas]
GO
/****** Object:  StoredProcedure [dbo].[csp_finddocuments]    Script Date: 2015-04-02 10:13:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Fredrik Danielsson
-- Create date: 2013-10-31
-- Description:	Demos the Full-Text index feature for documents
-- =============================================
ALTER PROCEDURE [dbo].[csp_finddocuments]	
	@@searchstring NVARCHAR(4000)
AS
BEGIN
	-- FLAG_EXTERNALACCESS --
	SET NOCOUNT ON;
	set @@searchstring = [dbo].cfn_editString(@@searchstring)

    SELECT TOP 1001 d.iddocument AS [id] FROM dbo.document AS d 
	INNER JOIN dbo.[file] AS f ON d.document = f.idfile
	WHERE CONTAINS(f.data, @@searchstring)
	FOR XML AUTO, ROOT('documents'), ELEMENTS
END

