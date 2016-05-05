using System;
using System.Data;
using System.Data.Common;

/// <summary>
/// Wraps category details data
/// </summary>
public struct CategoryDetails
{
    public string Name;
    public string Description;
}

/// <summary>
/// Wraps product details data
/// </summary>
public struct BooksDetails
{
    public string ISBN;
    public string Title;
    public string Description;
    public string Price;
    public string Author;
    public string Image1FileName;
    public string Image2FileName;
    public string Year;
}

/// <summary>
/// Product catalog business tier component
/// </summary>
public static class CatalogAccess
{
    static CatalogAccess()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    //Main Slide book list in category
    public static DataTable SlideGetBooksInCategory(int categoryId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "SlideGetBooksInCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@CategoryID";
        param.Value = categoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);

        // execute the stored procedure and save the results in a DataTable
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);
 
        // return the page of products
        return table;
    }

    // Get category details
    public static CategoryDetails GetCategoryDetails(string categoryId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetCategoryDetails";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@CategoryID";
        param.Value = categoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);
        // wrap retrieved data into a CategoryDetails object
        CategoryDetails details = new CategoryDetails();
        if (table.Rows.Count > 0)
        {
            details.Name = table.Rows[0]["Name"].ToString();
            details.Description = table.Rows[0]["Description"].ToString();
        }
        // return department details
        return details;
    }

    // Get product details
    public static BooksDetails GetBookDetails(string bookId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetBookDetails";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@BookID";
        param.Value = Convert.ToInt32(bookId);
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);
        // wrap retrieved data into a ProductDetails object
        BooksDetails details = new BooksDetails();
        if (table.Rows.Count > 0)
        {
            // get the first table row
            DataRow dr = table.Rows[0];
            // get product details
            details.ISBN = dr["ISBN"].ToString();
            details.Title = dr["Title"].ToString();
            details.Description = dr["Description"].ToString();
            details.Price = dr["Price"].ToString();
            details.Author = dr["Author"].ToString();
            details.Image1FileName = dr["Thumbnail"].ToString();
            details.Image2FileName = dr["Image"].ToString();
            details.Year = dr["Year"].ToString();

            details.Price = details.Price.Remove(details.Price.Length - 2);
        }
        // return department details
        return details;
    }

   
    // retrieve the list of products in a category
    public static DataTable GetBooksInCategory(int categoryId, string pageNumber, out int howManyPages)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetBooksInCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@CategoryID";
        param.Value = categoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@DescriptionLength";
        param.Value = BookClipConfiguration.ProductDescriptionLength;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PageNumber";
        param.Value = pageNumber;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@BooksPerPage";
        param.Value = BookClipConfiguration.ProductsPerPage;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@HowManyBooks";
        param.Direction = ParameterDirection.Output;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure and save the results in a DataTable
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);
        // calculate how many pages of products and set the out parameter
        int howManyProducts = Int32.Parse(comm.Parameters["@HowManyBooks"].Value.ToString());
        howManyPages = (int)Math.Ceiling((double)howManyProducts /
                       (double)BookClipConfiguration.ProductsPerPage);
        // return the page of products
        return table;
    }


    // retrieve the list of products in a category
    public static DataTable GetBooksWithoutCategory(string pageNumber, out int howManyPages)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetBooksWithoutCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@DescriptionLength";
        param.Value = BookClipConfiguration.ProductDescriptionLength;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PageNumber";
        param.Value = pageNumber;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@BooksPerPage";
        param.Value = BookClipConfiguration.ProductsPerPage;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@HowManyBooks";
        param.Direction = ParameterDirection.Output;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure and save the results in a DataTable
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);
        // calculate how many pages of products and set the out parameter
        int howManyProducts = Int32.Parse(comm.Parameters["@HowManyBooks"].Value.ToString());
        howManyPages = (int)Math.Ceiling((double)howManyProducts /
                       (double)BookClipConfiguration.ProductsPerPage);
        // return the page of products
        return table;
    }

    // retrieve the list of WishList
    public static DataTable GetWishList(string userID, int pageNumber, out int howManyPages)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "WhishListSelect";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = userID;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@DescriptionLength";
        param.Value = BookClipConfiguration.ProductDescriptionLength;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PageNumber";
        param.Value = pageNumber;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@BooksPerPage";
        param.Value = BookClipConfiguration.ProductsPerPage;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@HowManyBooks";
        param.Direction = ParameterDirection.Output;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure and save the results in a DataTable
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);
        // calculate how many pages of products and set the out parameter
        int howManyProducts = Int32.Parse(comm.Parameters["@HowManyBooks"].Value.ToString());
        howManyPages = (int)Math.Ceiling((double)howManyProducts /
                       (double)BookClipConfiguration.ProductsPerPage);
        // return the page of products
        return table;
    }

    // Create a WishLIst
    public static bool CreateWishList(string userID, int bookID)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "WishListCreate";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = userID;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@BookID";
        param.Value = bookID;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
 
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // Delete a WishLIst
    public static bool DeleteWishList(string userID, int bookID)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "WishListDelete";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = userID;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@BookID";
        param.Value = bookID;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);

        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // retrieve the list of Review
    public static DataTable GetReviews(int bookID)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "ReviewList";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@BookID";
        param.Value = bookID;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);

        // execute the stored procedure and save the results in a DataTable
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);

        // return the page of products
        return table;
    }

    // Create a WishLIst
    public static bool CreateReview(string userID, int bookID, string title, string desc)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "ReviewCreate";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = userID;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@BookID";
        param.Value = bookID;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Title";
        param.Value = title;
        param.DbType = DbType.String;
        param.Size = 200;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Description";
        param.Value = desc;
        param.DbType = DbType.String;
        param.Size = 1000;
        comm.Parameters.Add(param);

        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // Delete a WishLIst
    public static bool DeleteReview(string userID, int bookID)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "ReviewDelete";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = userID;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@BookID";
        param.Value = bookID;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);

        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // Create a new Category
    public static bool CreateCategory(string departmentId, string name, string description)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogCreateCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@DepartmentID";
        param.Value = departmentId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@CategoryName";
        param.Value = name;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@CategoryDescription";
        param.Value = description;
        param.DbType = DbType.String;
        param.Size = 1000;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // Update category details
    public static bool UpdateCategory(string id, string name, string description)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogUpdateCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@CategoryId";
        param.Value = id;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@CategoryName";
        param.Value = name;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@CategoryDescription";
        param.Value = description;
        param.DbType = DbType.String;
        param.Size = 1000;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // Delete Category
    public static bool DeleteCategory(string id)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogDeleteCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@CategoryId";
        param.Value = id;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure; an error will be thrown by the
        // database in case the Category has related categories, in which case
        // it is not deleted
        int result = -1;
        try
        {
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch (Exception e)
        {
            // any errors are logged in GenericDataAccess, we ingore them here
            Console.WriteLine(e.Message);
        }
        // result will be 1 in case of success
        return (result != -1);
    }

    // retrieve the list of products in a category
    public static DataTable GetAllProductsInCategory(string categoryId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetAllBooksInCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@CategoryID";
        param.Value = categoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure and save the results in a DataTable
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);
        return table;
    }

    // Create a new product
    public static bool CreateProduct(string categoryId, string name, string description, string price, string image1FileName, string image2FileName, string onDepartmentPromotion, string onCatalogPromotion)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogCreateProduct";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@CategoryID";
        param.Value = categoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@ProductName";
        param.Value = name;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@ProductDescription";
        param.Value = description;
        param.DbType = DbType.AnsiString;
        param.Size = 5000;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Price";
        param.Value = price;
        param.DbType = DbType.Decimal;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Thumbnail";
        param.Value = image1FileName;
        param.DbType = DbType.String;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Image";
        param.Value = image2FileName;
        param.DbType = DbType.String;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PromoDept";
        param.Value = onDepartmentPromotion;
        param.DbType = DbType.Boolean;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PromoFront";
        param.Value = onCatalogPromotion;
        param.DbType = DbType.Boolean;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here

        }
        // result will be 1 in case of success 
        return (result >= 1);
    }

    // Update an existing product
    public static bool UpdateProduct(string productId, string name, string description, string price, string image1FileName, string image2FileName, string onDepartmentPromotion, string onCatalogPromotion)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogUpdateProduct";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@ProductName";
        param.Value = name;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@ProductDescription";
        param.Value = description;
        param.DbType = DbType.AnsiString;
        param.Size = 5000;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Price";
        param.Value = price;
        param.DbType = DbType.Decimal;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Thumbnail";
        param.Value = image1FileName;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Image";
        param.Value = image2FileName;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PromoDept";
        param.Value = onDepartmentPromotion;
        param.DbType = DbType.Boolean;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PromoFront";
        param.Value = onCatalogPromotion;
        param.DbType = DbType.Boolean;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch (Exception e)
        {
            // any errors are logged in GenericDataAccess, we ingore them here
            Console.WriteLine(e.Message);
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // get categories that contain a specified product
    public static DataTable GetCategoriesWithProduct(string productId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetCategoriesWithBooks";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@BookID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure
        return GenericDataAccess.ExecuteSelectCommand(comm);
    }

    // get categories that do not contain a specified product
    public static DataTable GetCategoriesWithoutBooks(string productId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetCategoriesWithoutBooks";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@BookID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure
        return GenericDataAccess.ExecuteSelectCommand(comm);
    }

    // assign a product to a new category
    public static bool AssignProductToCategory(string productId, string categoryId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogAssignProductToCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@CategoryID";
        param.Value = categoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch (Exception e)
        {
            // any errors are logged in GenericDataAccess, we ingore them here
            Console.WriteLine(e.Message);
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // move product to a new category
    public static bool MoveProductToCategory(string productId, string oldCategoryId, string newCategoryId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogMoveProductToCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@OldCategoryID";
        param.Value = oldCategoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@NewCategoryID";
        param.Value = newCategoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // removes a product from a category 
    public static bool RemoveProductFromCategory(string productId, string categoryId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogRemoveProductFromCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@CategoryID";
        param.Value = categoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // deletes a product from the product catalog
    public static bool DeleteProduct(string productId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogDeleteProduct";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ingore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // gets product recommendations
    public static DataTable GetRecommendations(string productId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetProductRecommendations";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@DescriptionLength";
        param.Value = BookClipConfiguration.ProductDescriptionLength;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure
        return GenericDataAccess.ExecuteSelectCommand(comm);
    }
}