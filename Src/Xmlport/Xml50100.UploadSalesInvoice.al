xmlport 50700 UploadSalesInvoice
{
    Caption = 'Upload Sales Invoice';// One Invoice per sheet
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(SalesLine; "Sales Line")
            {
                textelement(CustomerId)
                {
                }
                textelement(OrderDate)
                {
                }
                textelement(ItemNumber)
                {
                }
                textelement(Quantity)
                {
                }
                textelement(DiscountPercentage)
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
                    RecLines: Record "Sales Line";
                    testdecimal: Decimal;
                    dt: Date;
                begin
                    LineNumber += 10000;


                    RecHeader.Validate("Sell-to Customer No.", CustomerId);
                    Evaluate(dt, OrderDate);
                    RecHeader.Validate("Order Date", dt);
                    RecHeader.Modify(true);

                    SalesLine.SetHideValidationDialog(true);
                    SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);
                    SalesLine.Validate("Document No.", RecHeader."No.");
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine."Line No." := LineNumber;
                    SalesLine.Validate("No.", ItemNumber);
                    if Quantity = '' then
                        testdecimal := 0
                    else
                        Evaluate(testdecimal, Quantity);
                    SalesLine.Validate(Quantity, testdecimal);
                    if DiscountPercentage = '' then
                        testdecimal := 0
                    else
                        Evaluate(testdecimal, DiscountPercentage);
                    SalesLine.Validate("Line Discount %", testdecimal);

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
        LineNumber := 0;
        dlgProgress.OPEN(tcProgress);

        Clear(RecHeader);
        RecHeader.Init();
        RecHeader.SetHideValidationDialog(true);
        RecHeader.Validate("Document Type", RecHeader."Document Type"::Invoice);
        RecHeader.Insert(true);
    end;

    trigger OnPostXmlPort()
    begin
        dlgProgress.CLOSE;
        Message('Sales Invoice No. %1 has been created successfully.', RecHeader."No.");
    end;


    var
        Pagecaption: Boolean;
        RowNumber: Integer;
        dlgProgress: Dialog;
        nRecNum: Integer;
        LineNumber: Integer;
        tcProgress: Label 'Uploading Records #1';
        RecHeader: Record "Sales Header";
}
