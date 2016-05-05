using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Common;
using System.Text.RegularExpressions;

public partial class Users_Register : ScriptPage
{
    Account act = new Account();

    protected void Page_Load(object sender, EventArgs e)
    {
        string mem_ID = string.Empty;
        string First_Name = string.Empty;
        string Last_Name = string.Empty;

        if (Page.IsPostBack == false)
        {
            //Member_ID.Attributes.Add("readonly", "true");
            check_result.Visible = false;

            //if cookies exist, this is edit mode. so user's info should be given in the textfield.

            if (Convert.ToString(Request.Cookies["userInfo"]) != "")
            {
                if (Request.Cookies["userInfo"]["mem_ID"] != null)
                { mem_ID = Request.Cookies["userInfo"]["mem_ID"]; }

                if (Request.Cookies["userInfo"]["mem_Name"] != null)
                {
                    string userName = Request.Cookies["userInfo"]["mem_Name"];
                    string[] name = Regex.Split(userName, " ");

                    First_Name = name[0];
                    Last_Name = name[1];
                }

                UserDetails ds = act.userDetail(mem_ID);

                if (ds.FirstName != "")
                {
                    Member_ID.Text = mem_ID;
                    Member_ID.ReadOnly = true;

                    First_name.Text = ds.FirstName;
                    Last_name.Text = ds.LastName;

                    Province.Items.FindByValue(ds.Province.Trim()).Selected = true;
                    //set city according to province
                    setCity(ds.Province.Trim());
                    City.Items.FindByValue(ds.City.Trim()).Selected = true;

                    Address.Text = ds.Address;
                    PostalCode.Text = ds.PostalCode;


                    string CellPhone = ds.CellPhone;
                    string[] phone = Regex.Split(CellPhone, "-");

                    cell_phone1.Text = phone[0].ToString();
                    cell_phone2.Text = phone[1].ToString();
                    cell_phone3.Text = phone[2].ToString();


                    Email.Text = ds.Email;
 
                }
                else
                {
                    Response.Redirect("/Default.aspx", false);
                }
            }
        }
    }

    protected void Province_SelectedIndexChanged(object sender, EventArgs e)
    {
        setCity(Province.SelectedValue);
    }

    protected void setCity(string province)
    {
        //according to province, set databind city
        string[] Ontario = {"Barrie", "Belleville", "Brampton", "Brant", "Brantford", "Brockville", "Burlington", "Cambridge", "Clarence-Rockland", "Cornwall", "Dryden", "Elliot", "Greater Sudbury", "Guelph", "Haldimand County", "Hamilton", "Kawartha Lakes", "Kenora", "Kingston", "Kitchener", "London", "Markham", "Mississauga", "Niagara Falls", "Norfolk County", "North Bay", "Orillia", "Oshawa", "Ottawa", "Owen Sound", "Pembroke", "Peterborough", "Pickering", "Ajax", "Port Colborne", "Prince Edward County", "Quinte West", "Sarnia", "Sault Ste. Marie", "St. Catharines", "St. Thomas", "Stratford", "Temiskaming Shores", "Thorold", "Thunder Bay", "Timmins", "Toronto", "Vaughan", "Waterloo", "Welland", "Windsor", "Woodstock"};
        string[] Quebec = { "Acton Vale", "Alma", "Amos", "Amqui", "Asbestos", "Baie-Comeau", "Baie-D'Urfé", "Baie-Saint-Paul", "Barkmere", "Beaconsfield", "Beauceville", "Beauharnois", "Beaupré", "Bécancour", "Bedford", "Belleterre", "Beloeil", "Berthierville", "Blainville", "Boisbriand", "Bois-des-Filion", "Bonaventure", "Boucherville", "Brome Lake", "Bromont	Brome-Missisquoi", "Brossard", "Brownsburg-Chatham", "Candiac	Roussillon" };
        string[] British = { "Abbotsford", "Armstrong", "Burnaby", "Campbell River", "Castlegar", "Chilliwack", "Colwood", "Coquitlam", "Courtenay", "Cranbrook", "Dawson Creek", "Duncan", "Enderby", "Fernie", "Fort St. John", "Grand Forks", "Greenwood", "Kamloops", "Kelowna", "Kimberley", "Langford", "Langley", "Maple Ridge", "Merritt", "Nanaimo", "Nelson", "New Westminster", "North Vancouver", "Parksville", "Penticton", "Pitt Meadows", "Port Alberni", "Port Coquitlam", "Port Moody", "Powell River", "Prince George", "Prince Rupert", "Quesnel", "Revelstoke", "Richmond", "Rossland", "Salmon Arm", "Surrey", "Terrace", "Trail", "Vancouver", "Vernon", "Victoria", "White Rock", "Williams Lake" };
        string[] Alberta = { "Airdrie", "Brooks", "Calgary", "Camrose", "Cold Lake", "Edmonton", "Fort Saskatchewan", "Grande Prairie", "Lacombe", "Leduc", "Lethbridge", "Lloydminster", "Medicine Hat", "Red Deer", "Spruce Grove", "St. Albert", "Wetaskiwin" };
        string[] Manitoba = { "Brandon", "Dauphin", "Flin Flon", "Morden", "Portage la Prairie", "Selkirk", "Steinbach", "Thompson", "Winkler", "Winnipeg" };
        string[] Saskatchewan = { "Estevan", "Flin Flon", "Humboldt", "Lloydminster", "Martensville", "Meadow Lake", "Melfort", "Melville", "Moose Jaw", "North Battleford", "Prince Albert", "Regina", "Saskatoon", "Swift Current", "Warman", "Weyburn", "Yorkton" };
        string[] Nova = { "" };
        string[] New = { "Bathurst", "Campbellton", "Dieppe", "Edmundston", "Fredericton", "Miramichi", "Moncton", "Saint John" };
        string[] Newfoundland = { "Corner Brook", "Mount Pearl", "St. John's" };
        string[] Prince = { "Charlottetown", "Summerside" };
        string[] Northwest = { "Yellowknife" };
        string[] Yukon = { "Whitehorse" };
        string[] Nunavut = { "Iqaluit" };

        switch (province)
        {
            case "Ontario":
                City.DataSource = Ontario;
                City.DataBind();
                break;
            case "Quebec":
                City.DataSource = Quebec;
                City.DataBind();
                break;
            case "British Columbia":
                City.DataSource = British;
                City.DataBind();
                break;
            case "Alberta":
                City.DataSource = Alberta;
                City.DataBind();
                break;
            case "Manitoba":
                City.DataSource = Manitoba;
                City.DataBind();
                break;
            case "Saskatchewan":
                City.DataSource = Saskatchewan;
                City.DataBind();
                break;
            case "Nova Scotia":
                City.DataSource = Nova;
                City.DataBind();
                break;
            case "New Brunswick":
                City.DataSource = New;
                City.DataBind();
                break;
            case "Newfoundland and Labrador":
                City.DataSource = Newfoundland;
                City.DataBind();
                break;
            case "Prince Edward Island":
                City.DataSource = Prince;
                City.DataBind();
                break;
            case "Northwest Territories":
                City.DataSource = Northwest;
                City.DataBind();
                break;
            case "Yukon":
                City.DataSource = Yukon;
                City.DataBind();
                break;
            case "Nunavut":
                City.DataSource = Nunavut;
                City.DataBind();
                break;
        }
    }

     protected void submit_Click(object sender, EventArgs e)
    {
         //it means the situation user create
        if (Convert.ToString(Request.Cookies["userInfo"]) == "")
        {
            

            string mem_ID = Member_ID.Text;
            string firstName = First_name.Text;
            string lastName = Last_name.Text;
            string mem_pwd = Pwd.Text;
            string pwd_check = Pwd_check.Text;
            string province = Province.SelectedValue;
            string city = City.SelectedValue;
            string address = Address.Text;
            string postalcode = PostalCode.Text;
            string cellPhone = cell_phone1.Text + "-" + cell_phone2.Text + "-" + cell_phone3.Text;
            string mem_email = Email.Text;

            Account membiz = new Account();

            int reVal = membiz.userCreate(mem_ID, firstName, lastName, mem_pwd, province, city, address, postalcode, cellPhone, mem_email);


            if (reVal != -1)
            {
                //try to login by created info.
                login(mem_ID, firstName + " " + lastName);
                Response.Redirect("/Default.aspx", false);
                //ErrorMsg("You've been successfully joined!! Please login again", "/final/Default.aspx");
            }
            else
            {
                Response.Redirect("/Account/Register.aspx", false);
                //ErrorMsg("Sorry, try again","/final/Account/Register.aspx");
            }

        }
        // the situation user modify
        else
        {
 
           

            string mem_ID = Member_ID.Text;
            string firstName = First_name.Text;
            string lastName = Last_name.Text;
            string mem_pwd = Pwd.Text;
            string pwd_check = Pwd_check.Text;
            string province = Province.SelectedValue;
            string city = City.SelectedValue;
            string address = Address.Text;
            string postalcode = PostalCode.Text;
            string cellPhone = cell_phone1.Text + "-" + cell_phone2.Text + "-" + cell_phone3.Text;
            string mem_email = Email.Text;


            Account membiz = new Account();

            int reVal = membiz.userEdit(mem_ID, firstName, lastName, mem_pwd, province, city, address, postalcode, cellPhone, mem_email);


            if (reVal != -1)
            {
                //try to login again by edited info.
                login(mem_ID, firstName + " " + lastName);
                Response.Redirect("/Default.aspx", false);
                //ErrorMsg("Your information have been successfully modified. Please login again.", "/final/Default.aspx");
            }
            else
            {
                Response.Redirect("/Account/Register.aspx", false);
                //ErrorMsg("Sorry, try again", "/final/Account/Register.aspx");
            }
        }
    }

     protected void login(string userID, string userName)
     {
         //create cookie..
         FormsAuthentication.SetAuthCookie(userID, false);

         //set cookie information
         HttpCookie myCookie = new HttpCookie("userInfo");
         myCookie["mem_ID"] = userID;
         myCookie["mem_Name"] = userName;

         myCookie.Expires = DateTime.Now.AddMinutes(30.0);
         Response.Cookies.Add(myCookie);

     }

    protected void check_ID(object sender, EventArgs e)
    {
        string TemID = Member_ID.Text;

        if (TemID.Length < 5)
        {
            check_result.Visible = true;
            check_result.ForeColor = System.Drawing.Color.Red;
            check_result.Text = "Please enter your ID at least 5 letters";
        }
        else
        {
            check_result.Visible = true;

            Account membiz = new Account();

            string reVal = membiz.IDCheck(TemID);


            if (reVal == "")
            {
                check_result.ForeColor = System.Drawing.Color.Blue;
                check_result.Text = "You can use this ID -> " + TemID;   
            }
            else
            {
                check_result.ForeColor = System.Drawing.Color.Red;
                check_result.Text = "Someone is already using this ID -> " + TemID;
                Member_ID.Text = "";
            }
        }
    }
}