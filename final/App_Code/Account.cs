using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Text;
/// <summary>
/// Descrizione di riepilogo per Account
/// </summary>
/// 
public struct UserDetails
{
    public string FirstName;
    public string LastName;
    public string Password;
    public string CellPhone;
    public string Email;
    public string City;
    public string Address;
    public string Province;
    public string PostalCode;
}

public class Account
{
	public Account()
	{
		//
		// TODO: aggiungere qui la logica del costruttore
		//
	}

    public UserDetails userDetail(string mem_ID)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();

        // set the stored procedure name
        comm.CommandText = "UserDetails";

        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = mem_ID;
        param.DbType = DbType.AnsiString;
        param.Size = 30;
        comm.Parameters.Add(param);

        // execute the stored procedure
        DataTable table = GenericDataAccess.ExecuteSelectCommand(comm);

        // wrap retrieved data into a DepartmentDetails object
        UserDetails details = new UserDetails();

        if (table.Rows.Count > 0)
        {
            details.FirstName = table.Rows[0]["FirstName"].ToString();
            details.LastName = table.Rows[0]["LastName"].ToString();
            details.Password = table.Rows[0]["Password"].ToString();
            details.CellPhone = table.Rows[0]["CellPhone"].ToString();
            details.Email = table.Rows[0]["Email"].ToString();
            details.City = table.Rows[0]["City"].ToString();
            details.Address = table.Rows[0]["Address"].ToString();
            details.Province = table.Rows[0]["Province"].ToString();
            details.PostalCode = table.Rows[0]["PostalCode"].ToString();
        }

        // return department details
        return details;
    }

    public int userCreate(string mem_ID, string First_name, string Last_name, string mem_pwd, string province, string city, string address, string postalcode, string cellPhone, string mem_email)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();

        // set the stored procedure name
        comm.CommandText = "UserCreate";

        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = mem_ID;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);

        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@FirstName";
        param.Value = First_name + " ";
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);

        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@LastName";
        param.Value = Last_name;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Password";
        param.Value = mem_pwd;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@CellPhone";
        param.Value = cellPhone;
        param.DbType = DbType.AnsiStringFixedLength;
        param.Size = 12;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Email";
        param.Value = mem_email;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@City";
        param.Value = city;
        param.DbType = DbType.String;
        param.Size = 20;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Address";
        param.Value = address;
        param.DbType = DbType.String;
        param.Size = 100;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Province";
        param.Value = province;
        param.DbType = DbType.String;
        param.Size = 20;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PostalCode";
        param.Value = postalcode;
        param.DbType = DbType.String;
        param.Size = 6;
        comm.Parameters.Add(param);


        // execute the stored procedure
        int result = GenericDataAccess.ExecuteNonQuery(comm);

        // return rsult
        return result;
    }

    public int userEdit(string mem_ID, string First_name, string Last_name, string mem_pwd, string province, string city, string address, string postalcode, string cellPhone, string mem_email)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();

        // set the stored procedure name
        comm.CommandText = "UserEdit";

        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = mem_ID;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);

        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@FirstName";
        param.Value = First_name + " ";
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);

        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@LastName";
        param.Value = Last_name;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Password";
        param.Value = mem_pwd;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@CellPhone";
        param.Value = cellPhone;
        param.DbType = DbType.AnsiStringFixedLength;
        param.Size = 12;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Email";
        param.Value = mem_email;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@City";
        param.Value = city;
        param.DbType = DbType.String;
        param.Size = 20;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Address";
        param.Value = address;
        param.DbType = DbType.String;
        param.Size = 100;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Province";
        param.Value = province;
        param.DbType = DbType.String;
        param.Size = 20;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@PostalCode";
        param.Value = postalcode;
        param.DbType = DbType.String;
        param.Size = 6;
        comm.Parameters.Add(param);


        // execute the stored procedure
        int result = GenericDataAccess.ExecuteNonQuery(comm);

        // return rsult
        return result;
    }

    public string IDCheck(string Member_ID)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();

        // set the stored procedure name
        comm.CommandText = "UserIDCheck";

        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = Member_ID;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);

        //execute the procedure and return number of result.

        try
        {   
            //return user id
            return Convert.ToString(GenericDataAccess.ExecuteScalar(comm));
            
        }
        catch
        {
            //any error
            return "";
        }

    }

    public string AuthenticateSQL(string user, string password)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();

        // set the stored procedure name
        comm.CommandText = "UserLogin";

        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@UserID";
        param.Value = user;
        param.DbType = DbType.String;
        param.Size = 30;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@pwd";
        param.Value = password;
        param.DbType = DbType.String;
        param.Size = 50;
        comm.Parameters.Add(param);

        //execute the procedure and return number of result.

        try
        {
            //return user name
            return Convert.ToString(GenericDataAccess.ExecuteScalar(comm));

        }
        catch
        {
            //any error
            return "-1";
        }

    }
}