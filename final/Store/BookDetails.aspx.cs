using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using AjaxControlToolkit;


public partial class Store_BookDetails : ScriptPage
{
    public string BookID = string.Empty;
    public string stars;
    HttpContext context = HttpContext.Current;

    protected void Page_Load(object sender, EventArgs e)
    {


        //don't reload date during postbacks
        //if (!IsPostBack)
        //{
            //Set Book id from query string
            BookID = Request.QueryString["BookID"];

            SetControls();
            getReview(BookID);


        //}
    }

    private void SetControls()
    {
        //stores book details
        BooksDetails bd;
        bd = CatalogAccess.GetBookDetails(BookID);

        mainCover.ImageUrl = "/BookImg/" + bd.Image2FileName.Trim();

        ISBN.Text = bd.ISBN;
        bookTitle.Text = bd.Title;
        Author.Text = bd.Author;
        ListPrice.Text = "$ " + bd.Price;
        Year.Text = bd.Year;
        Desc.Text = bd.Description;
    }



    protected void addToCartButton_Click(object sender, EventArgs e)
    {
        if (Convert.ToString(Request.Cookies["userInfo"]) != "")
        {
            string userID = Request.Cookies["userInfo"]["mem_ID"];
            // Retrieve ProductID from the query string
            string BookId = Request.QueryString["BookID"];
            // Add the product to the shopping cart

            if (ShoppingCartAccess.AddItem(userID, BookId))
            {
                Response.Write("<script language=javascript>var r = confirm('The item was added to the Shopping Cart! Do you want to Check Out?'); if (r == true) {window.location = '/Store/ShoppingCartDetails.aspx';}else{history.back();};</script>");
            }
            else
            {
                Response.Write("<script language=javascript>alert('Error');history.back;</script>");
            };
        }
        else
        {
            Response.Write("<script language=javascript>alert('You need login first for using shopping cart');history.back;</script>");
        }
    }


    protected void addComm_Click(object sender, EventArgs e)
    {
        if (Convert.ToString(Request.Cookies["userInfo"]) != "")
        {
            string userID = Request.Cookies["userInfo"]["mem_ID"];
            string memo = editor1.Text;
            string reviewTitle = reviewTl.Text;
            BookID = Request.QueryString["BookID"];

            if (memo == null && memo == "" && memo == "<br />" && memo == "&nbsp;")
            {
                lblError.Text = "Please enter your review.";
                Response.End();
            }
            else
            {
                //review insert.
                bool reVal = CatalogAccess.CreateReview(userID, Convert.ToInt32(BookID), reviewTitle, memo);

                if (reVal)
                {
                    editor1.Text = string.Empty;
                    UpdatePanel1.Update();
                    getReview(BookID);

                }
                else
                {
                    ErrorMsg("Errors!!");
                }
            }
        }
        else
        {
            Response.Write("<script language=javascript>alert('You need login first for using wishList');history.back;</script>");
        }
    }

    private void getReview(string BookID)
    {
        //select reviews.
        DataTable dsComm = CatalogAccess.GetReviews(Convert.ToInt32(BookID));

        commList.DataSource = dsComm;
        commList.DataBind();
        UpdatePanel1.Update();
        commListUp.Update();
    }

    protected void ListView_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        ListViewDataItem item = (ListViewDataItem)e.Item;

        if (item.ItemType == ListViewItemType.DataItem)
        {
            if (Convert.ToString(Request.Cookies["userInfo"]) != "")
            {

                string userID = Request.Cookies["userInfo"]["mem_ID"];

                //if it matches between logined ID and author's ID,
                string wID = DataBinder.Eval(item.DataItem, "UserID").ToString();

                if (userID == wID)
                {
                    ImageButton imgBtn = item.FindControl("x") as ImageButton;
                    imgBtn.Visible = true;
                    imgBtn.ImageUrl = "../images/x-gif.gif";
                }
            }

        }
    }
    protected void continueShoppingButton_Click(object sender, EventArgs e)
    {
        // redirect to the last visited catalog page, or to the
        // main page of the catalog
        object page;
        if ((page = Session["LastVisitedCatalogPage"]) != null)
            Response.Redirect(page.ToString());
        else
            Response.Redirect(Request.ApplicationPath);
    }
    protected void imgBtn_Click(Object sender, CommandEventArgs e) 
    {
        if (e.CommandName == "reviewDel")
        {
            Response.Write("<script>alert('Error! Please try again');</script>");

            if (Convert.ToString(Request.Cookies["userInfo"]) != "")
            {

                string userID = Request.Cookies["userInfo"]["mem_ID"];
                BookID = Request.QueryString["BookID"];

                //review delete
                bool reVal = CatalogAccess.DeleteReview(userID, Convert.ToInt16(e.CommandArgument));


                if (reVal)
                {
                    UpdatePanel1.Update();
                    getReview(BookID);
                }
                else
                {
                    Response.Write("<script>alert('Error! Please try again');</script>");
                }
            }
        }
    }

}