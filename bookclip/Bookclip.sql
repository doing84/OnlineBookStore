USE [master]
GO
/****** Object:  Database [BookClip]    Script Date: 03/23/2012 12:51:38 ******/
CREATE DATABASE [BookClip] 
ALTER DATABASE [BookClip] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BookClip].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BookClip] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [BookClip] SET ANSI_NULLS OFF
GO
ALTER DATABASE [BookClip] SET ANSI_PADDING OFF
GO
ALTER DATABASE [BookClip] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [BookClip] SET ARITHABORT OFF
GO
ALTER DATABASE [BookClip] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [BookClip] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [BookClip] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [BookClip] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [BookClip] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [BookClip] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [BookClip] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [BookClip] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [BookClip] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [BookClip] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [BookClip] SET  ENABLE_BROKER
GO
ALTER DATABASE [BookClip] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [BookClip] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [BookClip] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [BookClip] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [BookClip] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [BookClip] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [BookClip] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [BookClip] SET  READ_WRITE
GO
ALTER DATABASE [BookClip] SET RECOVERY FULL
GO
ALTER DATABASE [BookClip] SET  MULTI_USER
GO
ALTER DATABASE [BookClip] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [BookClip] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'BookClip', N'ON'
GO
USE [BookClip]
GO
/****** Object:  StoredProcedure [dbo].[CatalogGetBookDetails]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[CatalogGetBookDetails]
(@BookID INT)
AS
SELECT ISBN, Title, Description, Price, Author, Thumbnail, Image, Year
FROM Books
WHERE BookID = @BookID





GO
/****** Object:  StoredProcedure [dbo].[CatalogGetBooksInCategory]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[CatalogGetBooksInCategory]
(@CategoryID INT,
@DescriptionLength INT,
@PageNumber INT,
@BooksPerPage INT,
@HowManyBooks INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @Books TABLE
(RowNumber INT,
 BookID INT,
 Title NVARCHAR(200),
 Description NVARCHAR(1000),
 Price MONEY,
 Thumbnail NVARCHAR(50),
 Image NVARCHAR(50))


-- populate the table variable with the complete list of products
INSERT INTO @Books
SELECT ROW_NUMBER() OVER (ORDER BY Books.BookID),
       Books.BookID, Title,
       CASE WHEN LEN(Books.Description) <= @DescriptionLength THEN Books.Description 
            ELSE SUBSTRING(Books.Description, 1, @DescriptionLength) + '...' END 
       AS Description, CONVERT(VARCHAR(12), Price,1) AS Price, Thumbnail, Image
FROM Books INNER JOIN BooksCategory
  ON Books.BookID = BooksCategory.BookID
WHERE BooksCategory.CategoryID = @CategoryID

-- return the total number of products using an OUTPUT variable
SELECT @HowManyBooks = COUNT(BookID) FROM @Books

-- extract the requested page of products
SELECT BookID, Title, Description, Price, Thumbnail,
       Image
FROM @Books
WHERE RowNumber > (@PageNumber - 1) * @BooksPerPage
  AND RowNumber <= @PageNumber * @BooksPerPage






GO
/****** Object:  StoredProcedure [dbo].[CatalogGetBooksWithoutCategory]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[CatalogGetBooksWithoutCategory]
(@DescriptionLength INT,
@PageNumber INT,
@BooksPerPage INT,
@HowManyBooks INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @Books TABLE
(
 BookID INT,
 RowNumber INT,
 Title NVARCHAR(200),
 Description NVARCHAR(1000),
 Price MONEY,
 Thumbnail NVARCHAR(50),
 Image NVARCHAR(50))


-- populate the table variable with the complete list of products
INSERT INTO @Books
SELECT Books.BookID,
	   ROW_NUMBER() OVER (ORDER BY Books.BookID),
       Title,
       CASE WHEN LEN(Books.Description) <= @DescriptionLength THEN Books.Description 
            ELSE SUBSTRING(Books.Description, 1, @DescriptionLength) + '...' END 
       AS Description, Price, Thumbnail, Image
FROM Books INNER JOIN 
					(SELECT DISTINCT BookID
					FROM BooksCategory
					) BooksCategory
	 ON Books.BookID = BooksCategory.BookID

ORDER BY Books.BookID

-- return the total number of products using an OUTPUT variable
SELECT @HowManyBooks = COUNT(BookID) FROM @Books

-- extract the requested page of products
SELECT BookID, Title, Description, Price, Thumbnail,
       Image
FROM @Books
WHERE RowNumber > (@PageNumber - 1) * @BooksPerPage
  AND RowNumber <= @PageNumber * @BooksPerPage







GO
/****** Object:  StoredProcedure [dbo].[CatalogGetCategoriesWithBooks]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CatalogGetCategoriesWithBooks]
(@BookID int)
AS
SELECT Category.CategoryID, Name
FROM Category INNER JOIN BooksCategory
ON Category.CategoryID = BooksCategory.CategoryID
WHERE BooksCategory.BookID = @BookID



GO
/****** Object:  StoredProcedure [dbo].[CatalogGetCategoriesWithoutBooks]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CatalogGetCategoriesWithoutBooks]
(@BookID int)
AS
SELECT CategoryID, Name
FROM Category
WHERE CategoryID NOT IN
   (SELECT Category.CategoryID
    FROM Category INNER JOIN BooksCategory
    ON Category.CategoryID = BooksCategory.CategoryID
    WHERE BooksCategory.BookID = @BookID)



GO
/****** Object:  StoredProcedure [dbo].[CatalogGetCategoryDetails]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CatalogGetCategoryDetails]
(@CategoryID INT)
AS
SELECT Name, Description
FROM Category
WHERE CategoryID = @CategoryID



GO
/****** Object:  StoredProcedure [dbo].[CheckAdmin]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[CheckAdmin]
(@UserID NVARCHAR(30))
AS

BEGIN

	SELECT Authority FROM Users WHERE UserID = @UserID
END







GO
/****** Object:  StoredProcedure [dbo].[CreateOrder]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateOrder] 
(@UserID nvarchar(30))
AS
/* Insert a new record INTo Orders */
DECLARE @OrderID INT
INSERT INTO Orders (UserID) VALUES (@UserID)
/* Save the new Order ID */
SET @OrderID = @@IDENTITY
/* Add the order details to OrderDetail */
INSERT INTO OrderDetail 
     (OrderID, BookID, Title, Quantity, UnitCost)
SELECT 
     @OrderID, Books.BookID, Books.Title, 
     ShoppingCart.Quantity, Books.Price
FROM Books JOIN ShoppingCart
ON Books.BookID = ShoppingCart.BookID
WHERE ShoppingCart.UserID = @UserID
/* Clear the shopping cart */
DELETE FROM ShoppingCart
WHERE UserID = @UserID
/* Return the Order ID */
SELECT @OrderID


GO
/****** Object:  StoredProcedure [dbo].[ReviewCreate]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[ReviewCreate]
(@UserID NVARCHAR(30),
 @BookID INT,
 @Title  NVARCHAR(200),
 @Description NVARCHAR(1000))
AS

BEGIN

		INSERT INTO Reviews(BookID, Title, Description, UserID) VALUES(@BookID, @Title, @Description, @UserID)
END








GO
/****** Object:  StoredProcedure [dbo].[ReviewDelete]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[ReviewDelete]
(@UserID NVARCHAR(30),
 @BookID INT)
AS

BEGIN

	IF EXISTS(SELECT BookID FROM Reviews WHERE BookID = @BookID and UserID = @UserID)
		DELETE Reviews WHERE BookID = @BookID and UserID = @UserID
END







GO
/****** Object:  StoredProcedure [dbo].[ReviewList]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[ReviewList]
(@BookID INT)
AS

-- declare a new TABLE variable
DECLARE @Review TABLE
(RowNumber INT,
 ReviewID INT,
 BookID INT,
 Title NVARCHAR(200),
 Description NVARCHAR(1000),
 DateAdded datetime,
 UserID NVARCHAR(30));


-- populate the table variable with the complete list of products
INSERT INTO @Review
SELECT ROW_NUMBER() OVER (ORDER BY Reviews.ReviewID),
       Reviews.ReviewID, Reviews.BookID, Title,Description, 
	   DateAdded, 
	   Users.UserID
FROM Reviews INNER JOIN Users
  ON Reviews.UserID = Users.UserID
WHERE Reviews.BookID = @BookID

-- extract the requested page of products
SELECT ReviewID, BookID, Title, Description, DateAdded, UserID
FROM @Review







GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartAddItem]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[ShoppingCartAddItem]
(@UserID NVARCHAR(30),
 @BookID int)
AS
IF EXISTS
        (SELECT CartID
         FROM ShoppingCart
         WHERE BookID = @BookID AND UserID = @UserID)
    UPDATE ShoppingCart
    SET Quantity = Quantity + 1
    WHERE BookID = @BookID AND UserID = @UserID
ELSE
    IF EXISTS (SELECT Title FROM Books WHERE BookID=@BookID)
        INSERT INTO ShoppingCart (BookID, Quantity, DateAdded, UserID)
        VALUES (@BookID, 1, GETDATE(), @UserID)






GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartCountOldCarts]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShoppingCartCountOldCarts]
(@Days smallint)
AS
SELECT COUNT(CartID)
FROM ShoppingCart
WHERE CartID IN
(SELECT CartID
FROM ShoppingCart
GROUP BY CartID
HAVING MIN(DATEDIFF(dd,DateAdded,GETDATE())) >= @Days)



GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartDeleteOldCarts]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShoppingCartDeleteOldCarts]
(@Days smallint)
AS
DELETE FROM ShoppingCart
WHERE CartID IN
(SELECT CartID
FROM ShoppingCart
GROUP BY CartID
HAVING MIN(DATEDIFF(dd,DateAdded,GETDATE())) >= @Days)



GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartGetItems]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ShoppingCartGetItems]
(@UserID NVARCHAR(30))
AS
SELECT ShoppingCart.CartID, Books.BookID, Books.Title, Books.Price, ShoppingCart.Quantity, Books.Price * ShoppingCart.Quantity AS Subtotal
FROM ShoppingCart INNER JOIN Books
ON ShoppingCart.BookID = Books.BookID
WHERE ShoppingCart.UserID = @UserID





GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartGetTotalAmount]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ShoppingCartGetTotalAmount]
(@UserID NVARCHAR(30))
AS
SELECT ISNULL(SUM(Books.Price * ShoppingCart.Quantity), 0)
FROM ShoppingCart INNER JOIN Books
ON ShoppingCart.BookID = Books.BookID
WHERE ShoppingCart.UserID = @UserID






GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartRemoveItem]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ShoppingCartRemoveItem]
(@UserID nvarchar(30),
 @BookID int)
AS
DELETE FROM ShoppingCart
WHERE UserID = @UserID and BookID = @BookID






GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartUpdateItem]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ShoppingCartUpdateItem]
(@UserID NVARCHAR(30),
 @BookID int,
 @Quantity int)
AS
IF @Quantity <= 0
  EXEC ShoppingCartRemoveItem @UserID, @BookID
ELSE
  UPDATE ShoppingCart
  SET Quantity = @Quantity, DateAdded = GETDATE()
  WHERE BookID = @BookID AND UserID = @UserID





GO
/****** Object:  StoredProcedure [dbo].[SlideGetBooksInCategory]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[SlideGetBooksInCategory]
(@CategoryID INT)
AS

-- declare a new TABLE variable
DECLARE @Books TABLE
( BookID INT,
 Price MONEY,
 Image NVARCHAR(50))


-- populate the table variable with the complete list of products
INSERT INTO @Books
SELECT top 5 Books.BookID,
       CONVERT(VARCHAR(12), Price,1) AS Price, Image
FROM Books INNER JOIN BooksCategory
  ON Books.BookID = BooksCategory.BookID
WHERE BooksCategory.CategoryID = @CategoryID

-- extract the requested page of products
SELECT BookID, Price, Image
FROM @Books







GO
/****** Object:  StoredProcedure [dbo].[UserCreate]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[UserCreate]
(@UserID NVARCHAR(30),
 @FirstName NVARCHAR(50),
 @LastName NVARCHAR(50),
 @Password NVARCHAR(50),
 @CellPhone CHAR(12),
 @Email NVARCHAR(50),
 @City NVARCHAR(20),
 @Address NVARCHAR(100),
 @Province NCHAR(20),
 @PostalCode NCHAR(6))
AS

INSERT INTO Users
	(UserID,
	FirstName,
	LastName,
	Password,
	CellPhone,
	Email,
	City,
	Address,
	Province,
	PostalCode,
	DateJoined,
	Authority)
VALUES 
    (@UserID,
	@FirstName,
	@LastName,
	@Password,
	@CellPhone,
	@Email,
	@City,
	@Address,
	@Province,
	@PostalCode,
	GETDATE(),
	0)





GO
/****** Object:  StoredProcedure [dbo].[UserDetails]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[UserDetails]
(@userID nvarchar(30))
AS
SELECT FirstName,
LastName,
Password,
CellPhone,
Email,
City,
Address,
Province,
PostalCode
FROM Users

WHERE UserID = @userID




GO
/****** Object:  StoredProcedure [dbo].[UserEdit]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[UserEdit]
(@UserID NVARCHAR(30),
 @FirstName NVARCHAR(50),
 @LastName NVARCHAR(50),
 @Password NVARCHAR(50),
 @CellPhone CHAR(12),
 @Email NVARCHAR(50),
 @City NVARCHAR(20),
 @Address NVARCHAR(100),
 @Province NCHAR(20),
 @PostalCode NCHAR(6))
AS

Update Users
Set
	FirstName = @FirstName,
	LastName = @LastName,
	Password = @Password,
	CellPhone = @CellPhone,
	Email = @Email,
	City = @City,
	Address = @Address,
	Province = @Province,
	PostalCode = @PostalCode
Where
	UserID = @UserID





GO
/****** Object:  StoredProcedure [dbo].[UserIDCheck]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[UserIDCheck]

(@UserID	NVARCHAR(30))


AS
Set NoCount On 

Begin

			SELECT top 1 @UserID	FROM Users WHERE UserID = @UserID

End




GO
/****** Object:  StoredProcedure [dbo].[UserLogin]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[UserLogin]

	@UserID		NVARCHAR(30),
	@pwd		NVARCHAR(50)

AS
	--DECLARE	@mem_Nick varchar(20)
	--SET @mem_Nick = '-1'
	
BEGIN


	IF EXISTS(SELECT Top 1 FirstName FROM Users WHERE UserID = @UserID)			-- when existing ID
		IF EXISTS(SELECT Top 1 FirstName FROM Users WHERE UserID = @UserID AND Password=@pwd)			-- check pwd

				SELECT COALESCE(FirstName,'  ') + COALESCE(LastName, '') FROM Users WHERE UserID = @UserID AND Password=@pwd
				
				--RETURN @mem_Nick --	correct ID and pwd

		ELSE

				SELECT '-1'
				--RETURN @mem_Nick -- wrong pwd


	ELSE		-- not exist ID

			SELECT '-1'
			--RETURN @mem_Nick


END








GO
/****** Object:  StoredProcedure [dbo].[WhishListSelect]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[WhishListSelect]
(@UserID NVARCHAR(30),
@DescriptionLength INT,
@PageNumber INT,
@BooksPerPage INT,
@HowManyBooks INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @WishList TABLE
(RowNumber INT,
 BookID INT,
 Title NVARCHAR(200),
 Price MONEY,
 Thumbnail NVARCHAR(50),
 Image NVARCHAR(50))


-- populate the table variable with the complete list of products
INSERT INTO @WishList
SELECT ROW_NUMBER() OVER (ORDER BY WishList.BookID),
       Books.BookID,
       CASE WHEN LEN(Books.Title) <= @DescriptionLength THEN Books.Title 
            ELSE SUBSTRING(Books.Title, 1, @DescriptionLength) + '...' END 
       AS Title, CONVERT(VARCHAR(12), Price,1) AS Price, Thumbnail, Image
FROM Books INNER JOIN WishList
  ON Books.BookID = WishList.BookID
WHERE WishList.UserID = @UserID

-- return the total number of products using an OUTPUT variable
SELECT @HowManyBooks = COUNT(BookID) FROM @WishList

-- extract the requested page of products
SELECT BookID, Title, Price, Thumbnail,
       Image
FROM @WishList
WHERE RowNumber > (@PageNumber - 1) * @BooksPerPage
  AND RowNumber <= @PageNumber * @BooksPerPage







GO
/****** Object:  StoredProcedure [dbo].[WishListCreate]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[WishListCreate]
(@UserID NVARCHAR(30),
 @BookID INT)
AS

BEGIN

	IF NOT EXISTS(SELECT BookID FROM WishList WHERE BookID = @BookID and UserID = @UserID)
		INSERT INTO WishList VALUES
		(@BookID, @UserID)
END






GO
/****** Object:  StoredProcedure [dbo].[WishListDelete]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[WishListDelete]
(@UserID NVARCHAR(30),
 @BookID INT)
AS

BEGIN

	IF EXISTS(SELECT BookID FROM WishList WHERE BookID = @BookID and UserID = @UserID)
		DELETE WishList WHERE BookID = @BookID and UserID = @UserID
END






GO
/****** Object:  Table [dbo].[Books]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Books](
	[BookID] [int] NOT NULL,
	[ISBN] [char](13) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[Price] [money] NOT NULL,
	[Author] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Thumbnail] [nvarchar](50) NULL,
	[Image] [nvarchar](50) NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_Books] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BooksCategory]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BooksCategory](
	[BookID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_BooksCategory] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC,
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[OrderID] [int] NOT NULL,
	[BookID] [int] NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitCost] [money] NOT NULL,
	[Subtotal]  AS ([Quantity]*[UnitCost]),
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](30) NOT NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[DateShipped] [smalldatetime] NULL,
	[Verified] [bit] NOT NULL,
	[Completed] [bit] NOT NULL,
	[Canceled] [bit] NOT NULL,
	[Comments] [nvarchar](1000) NULL,
	[CustomerName] [nvarchar](50) NULL,
	[CustomerEmail] [nvarchar](50) NULL,
	[ShippingAddress] [nvarchar](500) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[BookID] [int] NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[DateAdded] [smalldatetime] NOT NULL,
	[UserID] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShoppingCart]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCart](
	[CartID] [int] IDENTITY(1,1) NOT NULL,
	[BookID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[DateAdded] [smalldatetime] NOT NULL,
	[UserID] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_ShoppingCart] PRIMARY KEY CLUSTERED 
(
	[CartID] ASC,
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [nvarchar](30) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[CellPhone] [char](12) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[City] [nvarchar](20) NOT NULL,
	[Address] [nvarchar](100) NOT NULL,
	[DateJoined] [smalldatetime] NOT NULL,
	[Authority] [bit] NOT NULL,
	[Province] [nchar](20) NOT NULL,
	[PostalCode] [nchar](6) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WishList]    Script Date: 2014-12-08 오후 9:50:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WishList](
	[BookID] [int] NOT NULL,
	[UserID] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_WishList] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Verified]  DEFAULT ((0)) FOR [Verified]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Completed]  DEFAULT ((0)) FOR [Completed]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Canceled]  DEFAULT ((0)) FOR [Canceled]
GO
ALTER TABLE [dbo].[Reviews] ADD  CONSTRAINT [DF_Reviews_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[ShoppingCart] ADD  CONSTRAINT [DF_ShoppingCart_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_DateJoined]  DEFAULT (getdate()) FOR [DateJoined]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_Authority]  DEFAULT ((0)) FOR [Authority]
GO
ALTER TABLE [dbo].[BooksCategory]  WITH CHECK ADD  CONSTRAINT [FK_BooksCategory_Books1] FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([BookID])
GO
ALTER TABLE [dbo].[BooksCategory] CHECK CONSTRAINT [FK_BooksCategory_Books1]
GO
ALTER TABLE [dbo].[BooksCategory]  WITH CHECK ADD  CONSTRAINT [FK_BooksCategory_Category1] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[BooksCategory] CHECK CONSTRAINT [FK_BooksCategory_Category1]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Orders]
GO
ALTER TABLE [dbo].[ShoppingCart]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCart_Books] FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([BookID])
GO
ALTER TABLE [dbo].[ShoppingCart] CHECK CONSTRAINT [FK_ShoppingCart_Books]
GO
ALTER TABLE [dbo].[WishList]  WITH CHECK ADD  CONSTRAINT [FK_WishList_Books] FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([BookID])
GO
ALTER TABLE [dbo].[WishList] CHECK CONSTRAINT [FK_WishList_Books]
GO
ALTER TABLE [dbo].[WishList]  WITH CHECK ADD  CONSTRAINT [FK_WishList_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[WishList] CHECK CONSTRAINT [FK_WishList_Users]
GO
USE [master]
GO
ALTER DATABASE [BookClip] SET  READ_WRITE 
GO



USE [BookClip]
GO
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (1, N'1405192534   ', N'Architects'' Data
', N'Neufert''s Architects'' Data is an essential reference for the initial design and planning of a building project. It provides, in one concise volume, the core information needed to form the framework for the more detailed design and planning of any building project. Organised largely by building type, it covers the full range of preliminary considerations, and with over 6200 diagrams it provides a mass of data on spatial requirements.
', 79.1600, N'Ernst Neufert and Peter Neufert
', 5, N'ArchitectsData.jpg
', N'ArchitectsData(big).jpg
', 2012)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (2, N'470399112
  ', N'Architectural Graphic
', N'Since 1975, Architectural Graphics has been a bestselling classic that has introduced countless students of architecture and design to the fundamentals of graphic communication. Featuring Francis D.K. Ching''s signature graphic style, it illustrates how to use graphic tools and drafting conventions to translate architectural ideas into effective visual presentation. ThisFifth Edition has been updated to reflect the latest drawing techniques helping it remain the leading book on the topic.
', 40.0000, N'Francis D. K. Ching
', 4, N'ArchitecturalGraphic.jpg
', N'ArchitecturalGraphic(big).jpg
', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (3, N'3038212547
 ', N'Materiology- The Creatives Guide to Materials and Technologies
', N'Materiology is directed at all those who are interested in materials and in working with materials: from architects, production designers, and stylists to artists: a handbook for students and new professionals as well as for experienced professionals, written in a clear, understandable style.
', 46.0000, N'Daniel Kula and Elodie Ternaux
', 5, N'Materiology.jpg
', N'Materiology(big).jpg
', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (4, N'470641916
  ', N'The Architect''s Studio Companion
', N'The Architect''s Studio Companion is the labor-saving design resource that architects, engineers, and builders have relied on for years. Now in its Fifth Edition, this industry standard maintains its reputation as a reliable tool for the preliminary selecting, configuring, and sizing of the structural, environmental, and life safety systems of a building. Bestselling authors Edward Allen and Joseph Iano reduce complex engineering and building code information to simple approximations that enable designers to lay out the fundamental systems of a building in a matter of minutes—without getting hung up on complicated technical concepts.
', 87.2000, N'Edward Allen and Joseph Iano
', 6, N'TheArchitectStudio.jpg
', N'TheArchitectStudio(big).jpg
', 2012)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (5, N'1119941288
 ', N'The Eyes of the Skin: Architecture and the Senses
', N'First published in 1996, The Eyes of the Skin has become a classic of architectural theory. It asks the far-reaching question why, when there are five senses, has one single sense – sight – become so predominant in architectural culture and design? With the ascendancy of the digital and the all-pervasive use of the image electronically, it is a subject that has become all the more pressing and topical since the first edition’s publication in the mid-1990s. Juhani Pallasmaa argues that the suppression of the other four sensory realms has led to the overall impoverishment of our built environment, often diminishing the emphasis on the spatial experience of a building and architecture’s ability to inspire, engage and be wholly life enhancing.
', 40.0000, N'Juhani Pallasmaa
', 4, N'TheEyes.jpg
', N'TheEyes(big).jpg
', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (6, N'545433150
  ', N'Amulet Book Six: Escape From Lucien
', N'Emily, Navin, and their friends continue to battle the Elf King in hopes of destroying him forever, but one of his most loyal followers, Max, isn''t making it easy for them. The crew journeys to Lucien, a city that''s been ravaged by the war. Emily has more enemies there than she realizes — and it''ll take everything she''s got to get herself and her friends out of the city alive.
', 12.0900, N'Kazu Kibuishi
', 5, N'EscapeLucien.jpg
', N'EscapeLucien(big).jpg
', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (7, N'141971189
  ', N'Diary of a Wimpy Kid: The Long Haul
', N'A family road trip is supposed to be a lot of fun . . . unless, of course, you’re the Heffleys. The journey starts off full of promise, then quickly takes several wrong turns. Gas station bathrooms, crazed seagulls, a fender bender, and a runaway pig—not exactly Greg Heffley’s idea of a good time. But even the worst road trip can turn into an adventure—and this is one the Heffleys won’t soon forget.
', 12.2400, N'Jeff Kinney
', 8, N'DiaryKid.jpg
', N'DiaryKid(big).jpg
', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (8, N'1935179624
 ', N'Hansel and Gretel: Standard Edition (A Toon Graphic)
', N'Best-selling author Neil Gaiman and fine artist Lorenzo Mattotti join forces to create Hansel & Gretel, a stunning book that’s at once as familiar as a dream and as evocative as a nightmare. Mattotti’s sweeping ink illustrations capture the terror and longing found in the classic Brothers Grimm fairy tale. Neil Gaiman crafts an original text filled with his signature wit and pathos that is sure to become a favorite of readers everywhere, young and old.
', 12.4000, N'Neil Gaiman and Lorenzo Mattotti
', 10, N'HanselGretel.jpg
', N'HanselGretel(big).jpg
', 2011)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (9, N'142319957
  ', N'Waiting Is Not Easy!
', N'Gerald is careful. Piggie is not. Piggie cannot help smiling. Gerald can. Gerald worries so that Piggie does not have to. Gerald and Piggie are best friends.
', 8.9900, N'Mo Willems
', 9, N'WaitingEasy.jpg
', N'WaitingEasy(big).jpg
', 2012)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (10, N'375869026
  ', N'Wonder
', N'The extraordinary #1 New York Times bestseller that has captivated over 1 million readers now also includes the bestselling short story The Julian Chapter.
', 14.4300, N'R. J. Palacio
', 2, N'Wonder.jpg
', N'Wonder(big).jpg
', NULL)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (11, N'415389550
  ', N'Gender Trouble: Feminism and the Subversion of Identity
', N'Arguing that traditional feminism is wrong to look to a natural, ''essential'' notion of the female, or indeed of sex or gender, Butler starts by questioning the category ''woman'' and continues in this vein with examinations of ''the masculine'' and ''the feminine''. Best known however, but also most often misinterpreted, is Butler''s concept of gender as a reiterated social performancerather than the expression of a prior reality.
', 25.7200, N'Judith Butler
', 8, N'GenderTrouble.jpg
', N'GenderTrouble(big).jpg
', NULL)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (12, N'1609949811
 ', N'Humble Inquiry: The Gentle Art of Asking Instead of Telling
', N'Communication is essential in a healthy organization. But all too often when we interact with people—especially those who report to us—we simply tell them what we think they need to know. This shuts them down. To generate bold new ideas, to avoid disastrous mistakes, to develop agility and flexibility, we need to practice Humble Inquiry. 
', 9.9900, N'Edgar H. Schein
', 12, N'HumbleInquiry.jpg
', N'HumbleInquiry(big).jpg
', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (13, N'195444248
  ', N'Interplay: The Process of Interpersonal Communication, Third Canadian Edition
', N'The Process of Interpersonal Communication, provides students with a solid foundation for effective communication with an emphasis on Canadian cultures, values, and identities. Highlighting the practical application of communication skills, this fully updated edition integrates a wide range of examples and statistics throughout. Two brand new chapters - on family communication and communication at work - along with expanded coverage of technology and different forms of electronic communication, make this the most current and relevant resource available. By showing how to apply communication skills in a variety of situations and cultural settings, Interplay prepares students to become effective communicators in both their personal and professional lives.
', 88.8800, N'Ronald B. Adler and Lawrence B. Rosenfeld
', 7, N'Interplay.jpg
', N'Interplay(big).jpg
', 2011)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (14, N'199002304
  ', N'Practical Grammar: A Canadian Writer''s Resource
', N'A succinct and comprehensive overview of English grammar, this text serves as both a textbook and a reference. With straightforward information on everything from punctuation and parts of speech to research and documentation, this practical, up-to-date handbook is a must for Canadian writers in any field.
', 29.4000, N'Maxine Ruvinsky
', 12, N'PracticalGrammar.jpg
', N'PracticalGrammar(big).jpg
', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (15, N'415972558
  ', N'The Cultural Politics of Emotion
', N'First Published in 2004. Routledge is an imprint of Taylor & Francis, an informa company.
', 40.2900, N'Sara Ahmed
', 9, N'TheCultural Politics.jpg
', N'TheCultural Politics(big).jpg
', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (16, N'0132350882   ', N'Clean Code: A Handbook of Agile Software Craftsmanship', N'Even bad code can function. But if code isn’t clean, it can bring a development organization to its knees. Every year, countless hours and significant resources are lost because of poorly written code. But it doesn’t have to be that way.', 38.0400, N'Robert C. Martin', 10, N'CleanCode.jpg', N'CleanCode(big).jpg', 2008)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (17, N'0321965515   ', N'Don''t Make Me Think, Revisited: A Common Sense Approach to Web Usability (3rd Edition)', N'Since Don’t Make Me Think was first published in 2000, hundreds of thousands of Web designers and developers have relied on usability guru Steve Krug’s guide to help them understand the principles of intuitive navigation and information design. Witty, commonsensical, and eminently practical, it’s one of the best-loved and most recommended books on the subject.', 28.0200, N'Steve Krug', 5, N'DontMake.jpg', N'DontMake(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (18, N'1118549368   ', N'Exploring Arduino: Tools and Techniques for Engineering Wizardry', N'Learn to easily build gadgets, gizmos, robots, and more using Arduino Written by Arduino expert Jeremy Blum, this unique book uses the popular Arduino microcontroller platform as an instrument to teach you about topics in electrical engineering, programming, and human-computer interaction. Whether you''re a budding hobbyist or an engineer, you''ll benefit from the perfectly paced lessons that walk you through useful, artistic, and educational exercises that gradually get more advanced. In addition to specific projects, the book shares best practices in programming and design that you can apply to your own projects.', 22.1600, N'Jeremy Blum', 4, N'ExploringArduino.jpg', N'ExploringArduino(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (19, N'098276085    ', N'The PMP Exam: How to Pass on Your First Try, Fifth Edition', N'A study guide for the Project Management Professional (PMP) certification exam, this book provides all the information project managers need to thoroughly prepare for the test. Review materials cover all the processes, inputs, tools, and outputs that will be tested, and extra help is offered with insider secrets, test tricks and tips, hundreds of sample questions, and exercises designed to strengthen mastery of key concepts and help candidates pass the exam on the first attempt.', 62.8900, N'Andy Crowe', 6, N'ThePMP.jpg', N'ThePMP(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (20, N'0131177052   ', N'Working Effectively with Legacy Code', N'Preface Do you remember the first program you wrote? I remember mine. It was a little graphics program I wrote on an early PC. I started programming later than most of my friends. Sure, I d seen computers when I was a kid. I remember being really impressed by a minicomputer I once saw in an office, but for years I never had a chance to even sit at a computer. Later, when I was a teenager, some friends of mine bought a couple of the first TRS-80s. I was interested, but I was actually a bit apprehensive, too. I knew that if I started to play with computers, I d get sucked into it. It just looked too cool.', 47.6500, N'Michael Feathers', 7, N'WorkingEffectively.jpg', N'WorkingEffectively(big).jpg', 2004)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (21, N'0132785773   ', N'Adobe Illustrator for Fashion Design (2nd Edition)', N'This fully-updated text addresses industry’s need to train fashion students to draw fashion flats and illustrations, textile designs, and presentations using the latest versions of Adobe Illustrator. Emphasizing the creative process, ADOBE ILLUSTRATOR FOR FASHION DESIGN, 2/e  explores Illustrator’s powerful capabilities as related to drawings of clothing, fashion poses, and textile prints. It offers clear and illustrated instructions throughout, guiding students through learning all the electronic drawing techniques they will need to work successfully in fashion. In this second edition, new online videos show students how to perform many key techniques step-by-step, and online examples of previous student projects inspire new students.', 67.8400, N'Susan Lazear', 5, N'AdobeIllustrator.jpg', N'AdobeIllustrator(big).jpg', 2011)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (22, N'089236856    ', N'Holy Image, Hallowed Ground', N'Isolated in the remote Egyptian desert, at the base of Mount Sinai, sits the oldest continuously inhabited monastery in the Christian world. The Holy Monastery of Saint Catherine at Sinai holds the most important collection of Byzantine icons remaining today. This catalogue, published in conjuction with the exhibition Holy Image, Hallowed Ground: Icons from Sinai, on view at the J. Paul Getty Museum from November 14, 2006, to March 4, 2007, features forty-three of the monastery''s extremely rare--and rarely exhibited--icons and six manuscripts still little-known to the world at large.', 71.2500, N'Robert Nelson', 7, N'HolyImage.jpg', N'HolyImage(big).jpg', 2007)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (23, N'1409470164   ', N'Kierkegaard, Aesthetics, and Selfhood: The Art of Subjectivity', N'In the digital world, Kierkegaard''s thought is valuable in thinking about aesthetics as a component of human development, both including but moving beyond the religious context as its primary center of meaning. Seeing human formation as interrelated with aesthetics makes art a vital dimension of human existence.Contributing to the debate about Kierkegaard''s conception of the aesthetic, Kierkegaard, Aesthetics, and Selfhood argues that Kierkegaard''s primary concern is to provocatively explore how a self becomes Christian, with aesthetics being a vital dimension for such self-formation. At a broader level, Peder Jothen also focuses on the role, authority, and meaning of aesthetic expression within religious thought generally and Christianity in particular.', 104.4500, N'Peder Jothen', 6, N'Kierkegaard.jpg', N'Kierkegaard(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (24, N'0136069347   ', N'Patternmaking for Fashion Design (5th Edition)', N'Renowned for its comprehensive coverage, exceptional illustrations, and clear instructions, "Patternmaking for Fashion Design" offers detailed yet easy-to-understand explanations of the essence of patternmaking. Hinging on a recurring theme that all designs are based on one or more of the three major patternmaking and design principles-dart manipulation, added fullness, and contouring-it provides students with all the relevant information necessary to create design patterns with accuracy regardless of their complexity.', 101.8400, N'Helen Joseph Armstrong', 5, N'Patternmaking.jpg', N'Patternmaking(big).jpg', 2009)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (25, N'0195176677   ', N'The Oxford Handbook of Religion and the ArtsJ', N'Nearly every form of religion or spirituality has a vital connection with art. Religions across the world, from Hinduism and Buddhism to Eastern Orthodox Christianity, have been involved over the centuries with a rich array of artistic traditions, both sacred and secular. In its uniquely multi-dimensional consideration of the topic, The Oxford Handbook of Religion and the Arts provides expert guidance to artistry and aesthetic theory in religion.', 142.4000, N'Frank Burch Brown', 8, N'TheOxfordHandbook.jpg', N'TheOxfordHandbook(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (26, N'1107044073   ', N'Actuarial Mathematics for Life Contingent Risks', N'Actuarial Mathematics for Life Contingent Risks, 2nd edition, has been designated as the sole required text for the new Society of Actuaries Exam MLC April 2014 test format. Actuarial Mathematics for Life Contingent Risks covers the entire syllabus for the SOA Exam MLC (April 2014). It is ideal for university courses and for individuals preparing for professional actuarial examinations - especially the new, long-answer exam questions.', 70.6200, N'David C. M. Dickson and Mary R. Hardy', 10, N'ActuarialMathematics.jpg', N'ActuarialMathematics(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (27, N'1118783727   ', N'Code Red: How to Protect Your Savings From the Coming Crisis', N'Wall Street Journal Bestseller Valuable insights on monetary policies, their impact on your financial future, and how to protect against them Written by the New York Times bestselling author team of John Mauldin and Jonathan Tepper, Code Red spills the beans on the central banks in the U.S., U.K., E.U., and Japan and how they''ve rigged the game against the average saver and investor. More importantly, it shows you how to protect your hard-earned cash from the bankers'' disastrous monetary policies and how to come out a winner in the irresponsible game of chicken they''re playing with the global financial system.', 21.4300, N' John Mauldin and Jonathan Tepper', 5, N'CodeRed.jpg', N'CodeRed(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (28, N'1285453530   ', N'Economics: Private and Public Choice', N'ECONOMICS: PRIVATE AND PUBLIC CHOICE, Fifteenth Edition, reflects current economic conditions, enabling you to apply economic concepts to the real world. The up-to-date text includes analysis and explanation of measures of economic activity in today''s market. It also includes highlights of the recession of 2008-2009, and an in-depth look at the lives and contributions of notable economists. ECONOMICS: PRIVATE AND PUBLIC CHOICE dispels common economic myths. The text uses the "invisible hand" metaphor to explain economic theory, demonstrating how it works to stimulate the economy. The fifteenth edition includes online learning solutions to improve your learning outcomes. Graphing tutorials and videos embedded within the interactive reader support your classroom work and improve your performance.', 303.3500, N'James D. Gwartney and Richard L. Stroup', 7, N'Economics.jpg', N'Economics(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (29, N'0691120358   ', N'Mostly Harmless Econometrics: An Empiricist''s Companion', N'The core methods in today''s econometric toolkit are linear regression for statistical control, instrumental variables methods for the analysis of natural experiments, and differences-in-differences methods that exploit policy changes. In the modern experimentalist paradigm, these techniques address clear causal questions such as: Do smaller classes increase learning? Should wife batterers be arrested? How much does education raise wages?', 28.0900, N'Joshua D. Angrist and Jörn-Steffen Pischke', 9, N'MostlyHarmless.jpg', N'MostlyHarmless(big).jpg', 2009)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (30, N'0684840073   ', N'You Can Be a Stock Market Genius: Uncover the Secret Hiding Places of Stock Market Profits', N'A comprehensive and practical guide to the stock market from a successful fund manager—filled with case studies, important background information, and all the tools you’ll need to become a stock market genius.', 10.1900, N'Joel Greenblatt', 3, N'YouCanBe.jpg', N'YouCanBe(big).jpg', 1999)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (31, N'0132558920   ', N'Applied Fluid Mechanics (7th Edition)', N'The leading applications-oriented approach to engineering fluid mechanics is now in full color, with integrated software, new problems, and extensive new coverage.', 144.9200, N'Robert L. Mott and Joseph A. Untener', 5, N'AppliedFluid.jpg', N'AppliedFluid(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (32, N'0176509909   ', N'Canadian Professional Engineering and Geoscience: Practice and Ethics', N'Gordon C. Andrews, "Canadian Professional Engineering and Geoscience: Practice and Ethics", Fourth Edition, 2009, published by Nelson Education Ltd. ISBN: 0-17-644134-4', 199.9500, N'Gordon C Andrews', 7, N'CanadianProfessional.jpg', N'CanadianProfessional(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (33, N'1118012895   ', N'Fundamentals of Machine Component Design', N'The latest edition of Juvinall/Marshek''s Fundamentals of Machine Component Design focuses on sound problem solving strategies and skills needed to navigate through large amounts of information.  Revisions in the text include coverage of Fatigue in addition to a continued concentration on the fundamentals of component design.  Several other new features include new learning objectives added at the beginning of all chapters; updated end-of-chapter problems, the elimination of weak problems and addition of new problems; updated applications for currency and relevance and new ones where appropriate; new system analysis problems and examples; improved sections dealing with Fatigue; expanded coverage of failure theory; and updated references.', 154.0300, N'Robert C. Juvinall and Kurt M. Marshek', 9, N'FundamentalsofMachine.jpg', N'FundamentalsofMachine(big).jpg', 2011)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (34, N'0070985219   ', N'Law for Professional Engineers', N'The purpose of this text is twofold: to provide the Canadian engineering profession with a reference text on legal issues and principles of relevance to practising engineers; and to prepare candidates for Canada''s professional practice engineering law examinations. The professional practice examination is now a prerequisite in many provinces and territories for licensure of Professional Engineers. Consistent with the purpose of the professional practice examinations, the focus of this text is to provide helpful insights into areas of the law of particular relevance to engineers in practice. This fourth edition has been prepared to update particular aspects of the law that have seen significant change through legislation or court decisions since the third edition in 1996.', 149.9500, N'Donald Marston', 10, N'LawforProfessional.jpg', N'LawforProfessional(big).jpg', 2008)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (35, N'0132111713   ', N'Practical Law of Architecture, Engineering, and Geoscience, Second Canadian Edition', N'This book provides a broad overview of the laws relevant to the practice of architecture, engineering, and geoscience in Canada. Legal concepts and language are simplified and presented in practical, rather than theoretical, terms to provide professionals and students a sufficient background to identify legal issues. This text is an excellent reference for professionals and an excellent study aid for the Professional Practice Exam.', 170.5400, N'Brian M. Samuels and Doug R. Sanders', 5, N'PracticalLawofArchitecture.jpg', N'PracticalLawofArchitecturebig).jpg', 2010)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (36, N'110761550    ', N'Cambridge IELTS 9 Self-study Pack (Student''s Book with Answers and Audio CDs (2))- Authentic Examination Papers', N'Cambridge IELTS 9 contains four authentic IELTS past papers from Cambridge ESOL, providing excellent exam practice. The Student''s Book with answers allows students to familiarise themselves with IELTS and to practise examination techniques using authentic test material. It contains four complete tests for Academic candidates, plus extra Reading and Writing modules for General Training candidates. An introduction to these different modules is included in each book, together with with an explanation of the scoring system used by Cambridge ESOL. A comprehensive section of answers and tapescripts makes the material ideal for students working partly or entirely on their own. Audio CDs containing the listening tests material are available separately, or as part of a self-study pack.', 27.0800, N'Cambridge ESOL', 20, N'CambridgeIELTS.jpg', N'CambridgeIELTS(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (37, N'0195418166   ', N'Canadian Oxford Dictionary', N'This second edition of the Canadian Oxford Dictionary continues to define the authoritative standard for Canadian dictionaries. This popular dictionary''s 300,000 words, senses and definitions combine in one reference book information on English as it is used worldwide and as it is used particularly in Canada. Definitions, worded for ease of comprehension, are presented so that the meaning most familiar to Canadians appears first and foremost. Each of these entries is exceptionally reliable, the result of thorough research into the language and Oxford''s unparalleled language resources. Five professionally trained lexicographers spent five years examining databases containing over 20 million words of Canadian text from more than 8,000 Canadian sources of an astonishing diversity. The lexicographers also examined an additional 20 million words of international sources.', 60.0000, N'Katherine Barber', 15, N'CanadianOxford.jpg', N'CanadianOxford(big).jpg', 2005)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (38, N'052118939X   ', N'English Grammar in Use with Answers and CD-ROM- A Self-Study Reference and Practice Book for Intermediate Learners', N'English Grammar in Use Fourth edition is an updated version of the world''s best-selling grammar title. It has a fresh, appealing new design and clear layout, with revised and updated examples, but retains all the key features of clarity and accessibility that have made the book popular with millions of learners and teachers around the world. The CD-ROM contains lots of additional practice exercises to consolidate learning, ideal for self-study but also suitable for reinforcement work in the classroom. An online version and book without answers are available separately.', 17.1800, N'Raymond Murphy', 12, N'EnglishGrammar.jpg', N'EnglishGrammar(big).jpg', 2012)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (39, N'007178781X   ', N'Practice Makes Perfect Complete French Grammar', N'From present tense regular verbs to double object pronouns, this comprehensive guide and workbook covers all those aspects of French grammar that you might find a little intimidating or hard to remember. Practice Makes Perfect: Complete French Grammar focuses on the practical aspects of French as it''s really spoken, so you are not bogged down by unnecessary technicalities. Each unit features crystal-clear explanations, numerous realistic examples, and dozens of engaging exercises in a variety of formats--including multiple choice, fill-in sentences and passages, sentence rewrites, and creative writing--perfect for whatever your learning style.', 11.1400, N'Annie Heminway', 9, N'PracticeMakes.jpg', N'PracticeMakes(big).jpg', 2012)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (40, N'0888643004   ', N'The Canadian Dictionary of ASL', N'Developed in conjunction with the Canadian Cultural Society of the Deaf, this comprehensive new dictionary of American Sign Language (ASL) has over 8700 signs, many unique to Canada. Material for this extensive work has been drawn from many sources and includes input gathered from members of Canada''s Deaf community over the past twenty years. The Canadian Dictionary of ASL offers clear illustrations and sign descriptions alongside English definitions, making it a valuable reference for Deaf and hearing users alike. Authoritative and up-to-date, The Canadian Dictionary of ASL will prove to be the standard reference for years to come.', 83.7200, N'Carole Sue Bailey and Kathy Dolby', 6, N'TheCanadianDictionary.jpg', N'TheCanadianDictionary(big).jpg', 2002)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (41, N'0132161974   ', N'Aboriginal Peoples in Canada (9th Edition)', N'Aboriginal Peoples in Canada, with an extensive reorganizatoin and revision for its ninth edition, continues to provide a current and comprehensive introduction to Native Studies. Approaching events from the perspective of both the majority and the minority, it traces the history and evolution of Aboriginal—Non-Aboriginal relations over time. You will come away from the text with an understanding of Aboriginal rights within the context of the Canadian Constitution and Canadian society as a whole. Analytical in nature, Aboriginal Peoples in Canada supplies a critical interpretation of the events that have shaped Aboriginal-Euro-Canadian relations and illustrates how these relations have in turn formed the structure of Canadian society.', 122.6800, N'James S. Frideres and René R. Gadacz', 8, N'AboriginalPeoples.jpg', N'AboriginalPeoples(big).jpg', 2011)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (42, N'1599869772   ', N'The Art of War', N'Twenty-Five Hundred years ago, Sun Tzu wrote this classic book of military strategy based on Chinese warfare and military thought. Since that time, all levels of military have used the teaching on Sun Tzu to warfare and cilivzation have adapted these teachings for use in politics, business and everyday life. The Art of War is a book which should be used to gain advantage of opponents in the boardroom and battlefield alike.', 3.9900, N'Sun Tzu', 5, N'TheArtofWar.jpg', N'TheArtofWar(big).jpg', 2007)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (43, N'0199936765   ', N'The History of the World', N'J.M. Roberts''s renowned History of the World is widely considered the finest available one-volume survey of the major events, developments, and personalities of the known past, offering generations of readers a tour of the vast landscape of human history.', 39.0000, N'J. M. Roberts and O. A. Westad', 8, N'TheHistoryoftheWorld.jpg', N'TheHistoryoftheWorld(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (44, N'0670026069   ', N'The Republic of Imagination: America in Three Books', N'Ten years ago, Azar Nafisi electrified readers with her million-copy bestseller, Reading Lolita in Tehran, which told the story of how, against the backdrop of morality squads and executions, she taught The Great Gatsby and other classics to her eager students in Iran. In this exhilarating followup, Nafisi has written the book her fans have been waiting for: an impassioned, beguiling, and utterly original tribute to the vital importance of fiction in a democratic society. What Reading Lolita in Tehran was for Iran, The Republic of Imagination is for America.', 20.9900, N'Azar Nafisi', 5, N'TheRepublic.jpg', N'TheRepublic(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (45, N'0812980662   ', N'The War That Ended Peace: The Road to 1914', N'From the bestselling and award-winning author of Paris 1919 comes a masterpiece of narrative nonfiction, a fascinating portrait of Europe from 1900 up to the outbreak of World War I.', 12.6500, N'Margaret MacMillan', 7, N'TheEndedPeace.jpg', N'TheEndedPeace(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (46, N'0986045519   ', N'10 Actual, Official LSAT PrepTests Volume V: PrepTests 62 through 71', N'For pure practice at an unbelievable price, you can''t beat the 10 Actual series. Each book includes: 10 previously administered LSATs, an answer key for each test, a writing sample for each test,score-conversion tables, and sample Comparative Reading questions and explanations.', 21.5100, N'Law School Admission Council', 3, N'ActualOfficialLSAT.jpg', N'ActualOfficialLSAT(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (47, N'0984636005   ', N'10 New Actual, Official LSAT PrepTests with Comparative Reading: (PrepTests 52-61)', N'Comparative Reading questions first appeared in the LSAT in 2007. Our new 10 Actual, Official LSAT PrepTests book is the first one ever to include previously administered Comparative Reading questions. This essential LSAT preparation tool encompasses PrepTest 52 (the September 2007 LSAT) through PrepTest 61 (the October 2010 LSAT).', 21.4000, N'Law School Admission Council', 6, N'NewActualOfficialLSAT.jpg', N'NewActualOfficialLSAT(big).jpg', 2011)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (48, N'0840053592   ', N'Real Estate Law', N'Clear and concise, REAL ESTATE LAW, 8th Edition combines practical legal examples with theory and case law to illustrate the concepts for readers. Rather than a state-specific format, the text covers real estate law generally, with discussions, short case summaries, longer teaching cases, exhibits, and practical applications that help readers spot the issues and apply legal principles to realistic situations. Chapters build on each other to give a comprehensive picture of real estate law, while integrating important ethical and public policy issues.', 242.8800, N'Robert J. Aalberts', 3, N'RealEstateLaw.jpg', N'RealEstateLaw(big).jpg', 2011)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (49, N'0979305063   ', N'The Official LSAT SuperPrep: The Champion of LSAT Prep', N'SuperPrep is our most comprehensive LSAT preparation book.', 16.2400, N'Law School Admission Council ', 5, N'TheOfficialLSATSuperPrep.jpg', N'TheOfficialLSATSuperPrep(big).jpg', 2007)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (50, N'1462513395   ', N'Treating Complex Traumatic Stress Disorders (Adults): Scientific Foundations and Therapeutic Models', N'Combining scientific and clinical perspectives, this volume brings together leading authorities on complex traumatic stress and its treatment in adults. Contributors review the research that supports the conceptualization of complex traumatic stress as distinct from PTSD. They explore the pathways by which chronic trauma can affect psychological development, attachment security, and adult relationships. Chapters describe evidence-based assessment tools and an array of treatment models for individuals, couples, families, and groups.', 32.1700, N'Judith Lewis Herman MD and Bessel A. ', 7, N'TreatingComplex.jpg', N'TreatingComplex(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (51, N'070204654X   ', N'Anatomy Trains: Myofascial Meridians for Manual and Movement Therapists', N'The new edition of this hugely successful book continues to present a unique understanding of the role of fascia in healthy movement and postural distortion which is of vital importance to bodyworkers and movement therapists worldwide. Fully updated throughout and now with accompanying website (www.myersmyofascialmeridians.com), Anatomy Trains: Myofascial  Meridians for Manual and Movement Therapists will be ideal for all those professionals who have an interest in human movement: massage therapists, structural integration practitioners, craniosacral therapists,  yoga teachers, osteopaths, manual therapists, physiotherapists, athletic trainers, personal trainers, dance and movement teachers, chiropractors and  acupuncturists.', 53.6300, N'Thomas W. Myers', 9, N'AnatomyTrains.jpg', N'AnatomyTrains(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (52, N'0199005524   ', N'Doing Right: A Practical Guide to Ethics for Medical Trainees and Physicians', N'The third edition of Doing Right: A Practical Guide to Ethics for Medical Trainees and Physicians is a practical guide to analyzing and resolving the ethical dilemmas medical practitioners face on a day-to-day basis. Drawing extensively on real-life scenarios, this book takes a case-based approach to provide students and practitioners with the advice and skills they need to help their patients and overcome ethical challenges in the field. Fully revised to include up-to-date coverage of such important topics as patient-practitioner relationships in the digital age and advances in reproductive medicine and reproductive technologies, this third edition of Doing Right will provide readers with the most up-to-date guidebook to medical ethics available.', 69.8700, N'Philip C. Hebert', 6, N'DoingRight.jpg', N'DoingRight(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (53, N'155643880X   ', N'In the Realm of Hungry Ghosts: Close Encounters with Addiction', N'Based on Gabor Maté’s two decades of experience as a medical doctor and his groundbreaking work with the severely addicted on Vancouver’s skid row, In the Realm of Hungry Ghosts radically reenvisions this much misunderstood field by taking a holistic approach. Dr. Maté presents addiction not as a discrete phenomenon confined to an unfortunate or weak-willed few, but as a continuum that runs throughout (and perhaps underpins) our society; not a medical "condition" distinct from the lives it affects, rather the result of a complex interplay among personal history, emotional, and neurological development, brain chemistry, and the drugs (and behaviors) of addiction.', 11.5200, N'Gabor Mate', 7, N'HungryGhosts.jpg', N'HungryGhosts(big).jpg', 2010)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (54, N'1618654993   ', N'NCLEX-RN Premier 2014-2015 with 2 Practice Tests', N'Pass the NCLEX-RN or your money back--guaranteed! NCLEX-RN Premier 2014-2015 with 2 Practice Tests combines Kaplan''s unique strategy guide with the most test-like questions available to help you to meet the challenges of this exacting computer-adaptive test.', 38.3200, N'Kaplan', 5, N'NCLEX-RN.jpg', N'NCLEX-RN(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (55, N'1433805618   ', N'Publication Manual of the American Psychological Association', N'The "Publication Manual" is the style manual of choice for writers, editors, students, and educators. Although it is specifically designed to help writers in the behavioral sciences and social sciences, anyone who writes non-fiction prose can benefit from its guidance. The newly-revised Sixth Edition has not only been rewritten. It has also been thoroughly rethought and reorganized, making it the most user-friendly "Publication Manual" the APA has ever produced. You will be able to find answers to your questions faster than ever before. When you need advice on how to present information, including text, data, and graphics, for publication in any type of format--such as college and university papers, professional journals, presentations for colleagues, and online publication--you will find the advice you''re looking for in the "Publication Manual."', 25.7800, N'American Psychological Association', 9, N'Publication.jpg', N'Publication(big).jpg', 2009)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (56, N'0553380168   ', N'A Brief History of Time', N'A landmark volume in science writing by one of the great minds of our time, Stephen Hawking’s book explores such profound questions as: How did the universe begin—and what made its start possible? Does time always flow forward? Is the universe unending—or are there boundaries? Are there other dimensions in space? What will happen when it all ends?', 12.5900, N'Stephen Hawking', 4, N'ABriefHistory.jpg', N'ABriefHistory(big).jpg', 1998)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (57, N'0671212095   ', N'How to Read a Book', N'With half a million copies in print, How to Read a Book is the best and most successful guide to reading comprehension for the general reader, completely rewritten and updated with new material.', 10.9000, N'Mortimer J. Adler and Charles Van Doren', 7, N'HowtoRead.jpg', N'HowtoRead(big).jpg', 1972)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (58, N'0871401002   ', N'Meaning Of Human Existence', N'In The Meaning of Human Existence, his most philosophical work to date, Pulitzer Prize–winning biologist Edward O. Wilson grapples with these and other existential questions, examining what makes human beings supremely different from all other species. Searching for meaning in what Nietzsche once called "the rainbow colors" around the outer edges of knowledge and imagination, Wilson takes his readers on a journey, in the process bridging science and philosophy to create a twenty-first-century treatise on human existence—from our earliest inception to a provocative look at what the future of mankind portends.', 15.1500, N'Edward O. Wilson', 6, N'MeaningOfHuman.jpg', N'MeaningOfHuman(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (59, N'1606232940   ', N'The Mindfulness Solution: Everyday Practices for Everyday Problems', N'Mindfulness offers a path to well-being and tools for coping with life''s inevitable hurdles. And though mindfulness may sound exotic, you can cultivate it--and reap its proven benefits--without special training or lots of spare time. Trusted therapist and mindfulness expert Dr. Ronald Siegel shows exactly how in this inviting guide. You''ll get effective strategies to use while driving to work, walking the dog, or washing the dishes, plus tips on creating a formal practice routine in as little as 20 minutes a day. Flexible, step-by-step action plans will help you become more focused and efficient in daily life; cope with difficult feelings, such as anger and sadness; deepen your connection to your spouse or partner; feel more rested and less stressed; curb unhealthy habits; find relief from anxiety and depression; and resolve stress-related pain, insomnia, and other physical problems.', 14.8800, N'Ronald D. Siegel', 9, N'TheMindfulnessSolution.jpg', N'TheMindfulnessSolution(big).jpg', 2009)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (60, N'1494461943   ', N'The Prince', N'The Prince is a political treatise by the Italian diplomat, historian and political theorist Niccolò Machiavelli. From correspondence a version appears to have been distributed in 1513, using a Latin title, De Principatibus (About Principalities). However, the printed version was not published until 1532, five years after Machiavelli''s death. This was done with the permission of the Medici pope Clement VII, but "long before then, in fact since the first appearance of the Prince in manuscript, controversy had swirled about his writings". Although it was written as if it were a traditional work in the mirrors for princes style, it is generally agreed that it was especially innovative. This is only partly because it was written in the Vernacular (Italian) rather than Latin, a practice which had become increasingly popular since the publication of Dante''s Divine Comedy and other works of Renaissance literature.', 11.8500, N'Nicolo Machiavelli', 2, N'ThePrince.jpg', N'ThePrince(big).jpg', 1992)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (61, N'1603585079   ', N'Farming the Woods', N'In the eyes of many people, the practices of forestry and farming are mutually exclusive, because in the modern world, agriculture involves open fields, straight rows, and machinery to grow crops, while forests are primarily reserved for timber and firewood harvesting. ', 28.2300, N'Ken Mudge and Steve Gabriel', 7, N'FarmingtheWoods.jpg', N'FarmingtheWoods(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (62, N'0871401002   ', N'Meaning Of Human Existence', N'In The Meaning of Human Existence, his most philosophical work to date, Pulitzer Prize–winning biologist Edward O. Wilson grapples with these and other existential questions, examining what makes human beings supremely different from all other species. Searching for meaning in what Nietzsche once called "the rainbow colors" around the outer edges of knowledge and imagination, Wilson takes his readers on a journey, in the process bridging science and philosophy to create a twenty-first-century treatise on human existence—from our earliest inception to a provocative look at what the future of mankind portends.', 15.1500, N'Edward O. Wilson', 5, N'MeaningOfHuman.jpg', N'MeaningOfHuman(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (63, N'1452226105   ', N'Research Design: Qualitative, Quantitative, and Mixed Methods Approaches, 4th Edition', N'The eagerly anticipated Fourth Edition of the title that pioneered the comparison of qualitative, quantitative, and mixed methods research design is here! For all three approaches, Creswell includes a preliminary consideration of philosophical assumptions, a review of the literature, an assessment of the use of theory in research approaches, and refl ections about the importance of writing and ethics in scholarly inquiry. He also presents the key elements of the research process, giving specifi c attention to each approach. The Fourth Edition includes extensively revised mixed methods coverage, increased coverage of ethical issues in research, and an expanded emphasis on worldview perspectives.', 63.3300, N'John W. Creswell', 9, N'ResearchDesign.jpg', N'ResearchDesign(big).jpg', 2013)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (64, N'1118799941   ', N'The Colder War: How the Global Energy Trade Slipped from America''s Grasp', N'There is a new cold war underway, driven by a massive geopolitical power shift to Russia that went almost unnoticed across the globe. In The Colder War: How the Global Energy Trade Slipped from America''s Grasp, energy expert Marin Katusa takes a look at the ways the western world is losing control of the energy market, and what can be done about it.', 22.4600, N'Marin Katusa', 7, N'TheColderWar.jpg', N'TheColderWar(big).jpg', 2014)
INSERT [dbo].[Books] ([BookID], [ISBN], [Title], [Description], [Price], [Author], [Quantity], [Thumbnail], [Image], [Year]) VALUES (65, N'1451636016   ', N'Waking Up: A Guide to Spirituality Without Religion', N'From Sam Harris, neuroscientist and author of numerous New York Times bestselling books, Waking Up is for the twenty percent of Americans who follow no religion but who suspect that important truths can be found in the experiences of such figures as Jesus, the Buddha, Lao Tzu, Rumi, and the other saints and sages of history. Throughout this book, Harris argues that there is more to understanding reality than science and secular culture generally allow, and that how we pay attention to the present moment largely determines the quality of our lives.', 15.8500, N'Sam Harris', 6, N'WakingUp.jpg', N'WakingUp(big).jpg', 2014)



Insert into Category (CategoryID, Name) values (1,'Architecture')
Insert into Category (CategoryID, Name) values (2,'Children')
Insert into Category (CategoryID, Name) values (3,'Communication and Journalism')
Insert into Category (CategoryID, Name) values (4,'Computer Science')
Insert into Category (CategoryID, Name) values (5,'Design')
Insert into Category (CategoryID, Name) values (6,'Economics')
Insert into Category (CategoryID, Name) values (7,'Engeneering')
Insert into Category (CategoryID, Name) values (8,'Foreign Languages')
Insert into Category (CategoryID, Name) values (9,'History')
Insert into Category (CategoryID, Name) values (10,'Humanitarian dept')
Insert into Category (CategoryID, Name) values (11,'Law')
Insert into Category (CategoryID, Name) values (12,'Medicine')
Insert into Category (CategoryID, Name) values (13,'Philosophy')
Insert into Category (CategoryID, Name) values (14,'Science')
Insert into Category (CategoryID, Name) values (15,'Technical dept')

Insert into Category (CategoryID, Name) values (16,'New Arrivals')
Insert into Category (CategoryID, Name) values (17,'Best sellers')
Insert into Category (CategoryID, Name) values (18,'Kids')
Insert into Category (CategoryID, Name) values (19,'Special Deals')
Insert into Category (CategoryID, Name) values (20,'Recommended Books')


insert into BooksCategory values(1,1)
insert into BooksCategory values(2,1)
insert into BooksCategory values(3,1)
insert into BooksCategory values(4,1)
insert into BooksCategory values(5,1)
insert into BooksCategory values(7,2)
insert into BooksCategory values(6,2)
insert into BooksCategory values(8,2)
insert into BooksCategory values(9,2)
insert into BooksCategory values(10,2)
insert into BooksCategory values(11,3)
insert into BooksCategory values(12,3)
insert into BooksCategory values(13,3)
insert into BooksCategory values(14,3)
insert into BooksCategory values(15,3)
insert into BooksCategory values(16,4)
insert into BooksCategory values(17,4)
insert into BooksCategory values(18,4)
insert into BooksCategory values(19,4)
insert into BooksCategory values(20,4)
insert into BooksCategory values(21,5)
insert into BooksCategory values(22,5)
insert into BooksCategory values(23,5)
insert into BooksCategory values(24,5)
insert into BooksCategory values(25,5)
insert into BooksCategory values(26,6)
insert into BooksCategory values(27,6)
insert into BooksCategory values(28,6)
insert into BooksCategory values(29,6)
insert into BooksCategory values(30,6)
insert into BooksCategory values(31,7)
insert into BooksCategory values(32,7)
insert into BooksCategory values(33,7)
insert into BooksCategory values(34,7)
insert into BooksCategory values(35,7)
insert into BooksCategory values(36,8)
insert into BooksCategory values(37,8)
insert into BooksCategory values(38,8)
insert into BooksCategory values(39,8)
insert into BooksCategory values(40,8)
insert into BooksCategory values(41,9)
insert into BooksCategory values(42,9)
insert into BooksCategory values(43,9)
insert into BooksCategory values(44,9)
insert into BooksCategory values(45,9)
insert into BooksCategory values(45,11)
insert into BooksCategory values(46,11)
insert into BooksCategory values(47,11)
insert into BooksCategory values(48,11)
insert into BooksCategory values(49,11)
insert into BooksCategory values(50,11)
insert into BooksCategory values(51,12)
insert into BooksCategory values(52,12)
insert into BooksCategory values(53,12)
insert into BooksCategory values(54,12)
insert into BooksCategory values(55,12)
insert into BooksCategory values(56,13)
insert into BooksCategory values(57,13)
insert into BooksCategory values(58,13)
insert into BooksCategory values(59,13)
insert into BooksCategory values(60,13)
insert into BooksCategory values(61,14)
insert into BooksCategory values(62,14)
insert into BooksCategory values(63,14)
insert into BooksCategory values(64,14)
insert into BooksCategory values(65,14)

insert into BooksCategory values(4,16)
insert into BooksCategory values(53,16)
insert into BooksCategory values(14,16)
insert into BooksCategory values(23,16)
insert into BooksCategory values(41,16)
insert into BooksCategory values(28,16)
insert into BooksCategory values(34,16)
insert into BooksCategory values(11,17)
insert into BooksCategory values(9,17)
insert into BooksCategory values(19,17)
insert into BooksCategory values(29,17)
insert into BooksCategory values(30,17)
insert into BooksCategory values(38,17)
insert into BooksCategory values(40,17)
insert into BooksCategory values(60,17)
insert into BooksCategory values(6,18)
insert into BooksCategory values(7,18)
insert into BooksCategory values(8,18)
insert into BooksCategory values(9,18)
insert into BooksCategory values(10,18)
insert into BooksCategory values(45,19)
insert into BooksCategory values(55,19)
insert into BooksCategory values(56,19)
insert into BooksCategory values(44,19)
insert into BooksCategory values(5,19)
insert into BooksCategory values(13,19)
insert into BooksCategory values(8,20)
insert into BooksCategory values(27,20)
insert into BooksCategory values(36,20)
insert into BooksCategory values(12,20)
insert into BooksCategory values(17,20)
insert into BooksCategory values(25,20)
insert into BooksCategory values(52,20)
insert into BooksCategory values(65,20)

