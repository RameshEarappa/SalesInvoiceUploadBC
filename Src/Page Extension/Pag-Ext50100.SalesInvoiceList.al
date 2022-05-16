pageextension 50700 SalesInvoiceList extends "Sales Invoice List"
{
    actions
    {
        addfirst(processing)
        {
            action("Upload Invoices")
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    //Xmlport.Run(Xmlport::UploadSalesInvoice);
                    Xmlport.Run(Xmlport::UploadSalesInvoices);
                end;
            }
        }
    }
}
