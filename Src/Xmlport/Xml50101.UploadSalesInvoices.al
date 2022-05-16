xmlport 50701 UploadSalesInvoices
{
    Caption = 'Upload Sales Invoice';//Multiple Invoices per sheet. One Invoice for one Customer
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("SalesInvoiceStaging"; "Sales Invoice Staging")
            {
                fieldelement(CustomerNo; SalesInvoiceStaging."Customer Id")
                {

                }
                textelement(OrderDate)
                {
                }
                fieldelement(ItemNo; SalesInvoiceStaging."Item No.")
                {
                }
                textelement(Quantity)
                {
                }
                textelement(DiscountPercentage)
                {
                }
                fieldelement(TruckId; SalesInvoiceStaging."Truck Id")
                {
                }
                fieldelement(VehicleId; SalesInvoiceStaging."Vehicle Id")
                {
                }
                fieldelement(LocationCode; SalesInvoiceStaging."Location Code")
                {

                }

                trigger OnAfterInitRecord()
                begin
                    if Pagecaption = true then begin
                        Pagecaption := false;
                        RowNumber += 1;
                        currXMLport.Skip();
                    end;
                end;

                trigger OnBeforeInsertRecord()
                var
                    testdecimal: Decimal;
                    dt: Date;
                begin
                    Evaluate(dt, OrderDate);
                    SalesInvoiceStaging.Validate("Order Date", dt);

                    if Quantity = '' then
                        testdecimal := 0
                    else
                        Evaluate(testdecimal, Quantity);
                    SalesInvoiceStaging.Validate(Quantity, testdecimal);


                    if DiscountPercentage = '' then
                        testdecimal := 0
                    else
                        Evaluate(testdecimal, DiscountPercentage);
                    SalesInvoiceStaging.Validate("Discount %", testdecimal);

                    nRecNum += 1;
                    dlgProgress.UPDATE(1, nRecNum);
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        Pagecaption := true;
        RowNumber := 0;
        sRowNum := 0;
        dlgProgress.OPEN(tcProgress);

        //clear Buffer
        RecSalesInvStaging.DeleteAll();
    end;

    trigger OnPostXmlPort()
    var
        CheckList: List of [Text];
        RecHeader: Record "Sales Header";
        RecLines: Record "Sales Line";
        RecStaging: Record "Sales Invoice Staging";
        LineNo: Integer;
        InvoiceCount: Integer;
    begin
        Clear(CheckList);
        Clear(SalesInvoices);
        InvoiceCount := 0;
        Clear(RecSalesInvStaging);
        if RecSalesInvStaging.FindSet() then begin
            repeat
                if not CheckList.Contains(RecSalesInvStaging."Customer Id") then begin
                    CheckList.Add(RecSalesInvStaging."Customer Id");
                    LineNo := 0;
                    Clear(RecHeader);
                    RecHeader.Init();
                    RecHeader.SetHideValidationDialog(true);
                    RecHeader.Validate("Document Type", RecHeader."Document Type"::Invoice);
                    RecHeader.Validate("Sell-to Customer No.", RecSalesInvStaging."Customer Id");
                    RecHeader.Validate("Posting Date", RecSalesInvStaging."Order Date");
                    RecHeader.Validate("Order Date", RecSalesInvStaging."Order Date");
                    RecHeader.Insert(true);


                    SalesInvoices.Append(RecHeader."No." + ', ');
                    InvoiceCount += 1;
                    Clear(RecStaging);
                    RecStaging.SetRange("Customer Id", RecSalesInvStaging."Customer Id");
                    if RecStaging.FindSet() then begin
                        repeat
                            LineNo += 10000;
                            Clear(RecLines);
                            RecLines.Init();
                            RecLines.SetHideValidationDialog(true);
                            RecLines.Validate("Document Type", RecLines."Document Type"::Invoice);
                            RecLines.Validate("Document No.", RecHeader."No.");
                            RecLines.Validate("Line No.", LineNo);
                            RecLines.Validate(Type, RecLines.Type::Item);
                            RecLines.Validate("No.", RecStaging."Item No.");
                            RecLines.Validate("Location Code", RecStaging."Location Code");
                            RecLines.Validate(Quantity, RecStaging.Quantity);
                            if RecStaging."Discount %" <> 0 then
                                RecLines.Validate("Line Discount %", RecStaging."Discount %");
                            RecLines.Validate("Truck Id", RecStaging."Truck Id");
                            RecLines.Validate("Vehicle Id", RecStaging."Vehicle Id");
                            RecLines.Insert(true);
                            sRowNum += 1;
                            dlgProgress.UPDATE(2, sRowNum);
                        until RecStaging.Next() = 0;
                    end;
                    RecHeader."Location Code" := RecSalesInvStaging."Location Code";
                    RecHeader.Modify();
                end;
            until RecSalesInvStaging.Next() = 0;
        end;
        dlgProgress.CLOSE;
        Message('Total No. of Sales Invoice created: %1 \Sales Invoice No.: %2', InvoiceCount, CopyStr(SalesInvoices.ToText(), 1, SalesInvoices.Length - 2));
    end;


    var
        Pagecaption: Boolean;
        RowNumber: Integer;
        dlgProgress: Dialog;
        nRecNum: Integer;
        sRowNum: Integer;
        tcProgress: Label 'Uploading Records #1 \Creating Sales Invoice #2';
        RecSalesInvStaging: Record "Sales Invoice Staging";
        SalesInvoices: TextBuilder;
}
