permissionset 50700 UploadSalesInvoice
{
    Assignable = true;
    Caption = 'UploadSalesInvoice', MaxLength = 30;
    Permissions =
        table "Sales Invoice Staging" = X,
        tabledata "Sales Invoice Staging" = RMID,
        xmlport UploadSalesInvoice = X,
        xmlport UploadSalesInvoices = X;
}
