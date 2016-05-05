using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Store_ShoppingCartDetails : System.Web.UI.Page
{
    HttpContext context = HttpContext.Current;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Convert.ToString(Request.Cookies["userInfo"]) != "")
        {
            if (!IsPostBack)
                PopulateControls();
        }
        //not exist user info
        else
        {
            Response.Write("<script lanuage=javascript>alert('you need login');history.back();</script>");
        }
    }

  
  // fill shopping cart controls with data
  private void PopulateControls()
  {
      if (Convert.ToString(Request.Cookies["userInfo"]) != "")
      {
          string userID = Request.Cookies["userInfo"]["mem_ID"];

          // set the title of the page
          this.Title = BookClipConfiguration.SiteName + " : Shopping Cart";
          // get the items in the shopping cart
          DataTable dt = ShoppingCartAccess.GetItems(userID);
          // if the shopping cart is empty...
          if (dt.Rows.Count == 0)
          {
              titleLabel.Text = "Your shopping cart is empty!";
              grid.Visible = false;
              updateButton.Enabled = false;
              checkoutButton.Enabled = false;
              totalAmountLabel.Text = String.Format("{0:c}", 0);
          }
          else
          // if the shopping cart is not empty...
          {
              // populate the list with the shopping cart contents
              grid.DataSource = dt;
              grid.DataBind();
              // setup controls
              titleLabel.Text = "These are the products in your shopping cart:";
              grid.Visible = true;
              updateButton.Enabled = true;
              checkoutButton.Enabled = true;
              // display the total amount
              decimal amount = ShoppingCartAccess.GetTotalAmount(userID);
              totalAmountLabel.Text = String.Format("{0:c}", amount);
          }


      }
      else
      {
          Response.Write("<script language=javascript>alert('You need login first');history.back;</script>");
      }

  }

  // remove a product from the cart
  protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
  {
      if (Convert.ToString(Request.Cookies["userInfo"]) != "")
      {
          string userID = Request.Cookies["userInfo"]["mem_ID"];

            // Index of the row being deleted
            int rowIndex = e.RowIndex;
            // The ID of the product being deleted
            string BookID = grid.DataKeys[rowIndex].Value.ToString();
            // Remove the product from the shopping cart
            bool success = ShoppingCartAccess.RemoveItem(userID, BookID);
            // Display status
            statusLabel.Text = success ? "<br />Product successfully removed!<br />" :
                              "<br />There was an error removing the product!<br />";
            // Repopulate the control
            PopulateControls();
            Response.Redirect(Request.RawUrl);
    }
      else
        {
            Response.Write("<script lanuage=javascript>alert('you need login');history.back();</script>");
        }
    }



  // update shopping cart product quantities
  protected void updateButton_Click(object sender, EventArgs e)
  {
        if (Convert.ToString(Request.Cookies["userInfo"]) != "")
        {
            string userID = Request.Cookies["userInfo"]["mem_ID"];

              // Number of rows in the GridView
              int rowsCount = grid.Rows.Count;
              // Will store a row of the GridView

              GridViewRow gridRow;
              // Will reference a quantity TextBox in the GridView
              TextBox quantityTextBox;
              // Variables to store product ID and quantity
              string BookID;
              int quantity;
              // Was the update successful?
              bool success = true;
              // Go through the rows of the GridView
              for (int i = 0; i < rowsCount; i++)
              {
  
                      // Get a row
                      gridRow = grid.Rows[i];
                      // The ID of the product being deleted
                      BookID = grid.DataKeys[i].Value.ToString();
                      // Get the quantity TextBox in the Row
                      quantityTextBox = (TextBox)gridRow.FindControl("editQuantity");
                      // Get the quantity, guarding against bogus values
                      if (Int32.TryParse(quantityTextBox.Text, out quantity))
                      {
                          // Update product quantity
                          success = success && ShoppingCartAccess.UpdateItem(userID, BookID, quantity);
                      }
                      else
                      {
                          // if TryParse didn't succeed
                          success = false;
                      }
                      // Display status message
                      statusLabel.Text = success ?
                        "<br />Your shopping cart was successfully updated!<br />" :
                        "<br />Some quantity updates failed! Please verify your cart!<br />";
              }
        }
        else
        {
            Response.Write("<script lanuage=javascript>alert('you need login');</script>");
        }
          // Repopulate the control
          PopulateControls();
          Response.Redirect(Request.RawUrl);
  }




  // Redirects to the previously visited catalog page 
  // (an alternate to the functionality implemented here is to to 
  // Request.UrlReferrer, although that way you have no control to 
  // what pages you forward your visitor back to)
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

  // create a new order and redirect to a payment page
  protected void checkoutButton_Click(object sender, EventArgs e)
  {
      if (Convert.ToString(Request.Cookies["userInfo"]) != "")
      {
          string userID = Request.Cookies["userInfo"]["mem_ID"];
          // Store the total amount because the cart 
          // is emptied when creating the order
          decimal amount = ShoppingCartAccess.GetTotalAmount(userID);
          // Create the order and store the order ID
          string orderId = ShoppingCartAccess.CreateOrder(userID);
          // Obtain the site name from the configuration settings
          string siteName = BookClipConfiguration.SiteName;
          // Create the PayPal redirect location
          string redirect = "";
          redirect += "https://www.paypal.com/xclick/business=bookclip@gmail.com";
          redirect += "&item_name=" + siteName + " Order " + orderId;
          redirect += "&item_number=" + orderId;
          redirect += "&amount=" + String.Format("{0:0.00} ", amount);
          redirect += "&currency=USD";
          redirect += "&return=http://www." + siteName + ".com";
          redirect += "&cancel_return=http://www." + siteName + ".com";
          // Redirect to the payment page
          Response.Redirect(redirect);
      }
      else
      {
          Response.Write("<script language=javascript>alert('You need login first');history.back;</script>");
      }
  }

  protected void grid_SelectedIndexChanged(object sender, EventArgs e)
  {

  }
}