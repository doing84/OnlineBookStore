using System;
using System.Data;
using System.Data.Sql;
using System.Configuration;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class UserControls_SlideShow : System.Web.UI.UserControl
{
 
    /// <summary>
    /// The height of the image.
    /// </summary>
    private int _ImageHeight = 0;
    public int ImageHeight
    {
        get { return _ImageHeight; }
        set { _ImageHeight = value; }
    }

    /// <summary>
    /// The width of the image.
    /// </summary>
    private int _ImageWidth = 0;
    public int ImageWidth
    {
        get { return _ImageWidth; }
        set { _ImageWidth = value; }
    }

    /// <summary>
    /// The image item collection.
    /// </summary>
    private ImageItems _Items = null;
    public ImageItems ImageDataSource
    {
        get { return _Items; }
        set { _Items = value; }
    }

    private int _categoryID = 0;

    public int categoryID
    {
        get { return _categoryID; }
        set { _categoryID = value; }
    }


    /// <summary>
    /// Title for the user control.
    /// </summary>
    private string _Title = string.Empty;
    public string Title
    {
        get { return _Title; }
        set { _Title = value; }
    }


    /// <summary>
    /// Horizontal alignment for the user control title.
    /// </summary>
    private HorizontalAlign _TitleAlign = HorizontalAlign.NotSet;
    public HorizontalAlign TitleAlign
    {
        get { return _TitleAlign; }
        set { _TitleAlign = value; }
    }

 
    DataTable dt;

    /// <summary>
    /// Methos for page load event.
    /// </summary>
    /// <param name="sender">Reference of the object that raises this event.</param>
    /// <param name="e">Contains information regarding page load event data.</param>
    protected void Page_Load(object sender, EventArgs e)
    {
        lblTitle.Text = string.IsNullOrEmpty(_Title) ? "Slide Show" : _Title;


        dt = CatalogAccess.SlideGetBooksInCategory(_categoryID);

        dataList.DataSource = dt;
        dataList.DataBind();

 
    }

    protected void dataList_ItemCreated(object sender, DataListItemEventArgs e)
    {
        DataListItem item = (DataListItem)e.Item;

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            ImageButton imgSlideShow = (ImageButton)e.Item.FindControl("imgSlideShow");
            imgSlideShow.Height = Unit.Pixel(_ImageHeight);
            imgSlideShow.Width = Unit.Pixel(_ImageWidth);
            imgSlideShow.ImageUrl = "/BookImg/" + Convert.ToString(DataBinder.Eval(item.DataItem,"Image")).Trim();
            imgSlideShow.PostBackUrl = "/Store/BookDetails.aspx?BookID=" + Convert.ToString(DataBinder.Eval(item.DataItem,"BookID"));

            HyperLink link = (HyperLink)e.Item.FindControl("viewDetail");
            link.NavigateUrl = "/Store/BookDetails.aspx?BookID=" + Convert.ToString(DataBinder.Eval(item.DataItem,"BookID"));
        }
    }


}

public class ImageItem
{
    private string _ToolTip = string.Empty;
    public string ToolTip
    {
        get { return _ToolTip; }
        set { _ToolTip = value; }
    }

    private string _URL = string.Empty;
    public string URL
    {
        get { return _URL; }
        set { _URL = value; }
    }

    // Default constructor.
    public ImageItem()
    { }

    public ImageItem(string ToolTip, string URL)
    {
        this._ToolTip = ToolTip;
        this._URL = URL;
    }
}

public class ImageItems : List<ImageItem>
{
    public ImageItems()
    { }
}

public class SlideShowImageEventArgs : EventArgs
{
    private ImageButton _ImageButton = null;
    private int _X = 0;
    private int _Y = 0;

    public int X
    {
        get { return _X; }
    }

    public int Y
    {
        get { return _Y; }
    }

    public string URL
    {
        get { return _ImageButton.ImageUrl; }
    }

    public string ToolTip
    {
        get { return _ImageButton.ToolTip; }
    }

    public SlideShowImageEventArgs(ImageButton O, int X, int Y)
    {
        _ImageButton = O;
        _X = X;
        _Y = Y;
    }
}
