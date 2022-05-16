codeunit 50700 "Sales Price & Discount"
{
    trigger OnRun()
    var
        myInt: Integer;
    begin

    end;

    //diesel
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineLineDisc', '', true, true)]
    local procedure GetFinalDieselFleetDiscount(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var SalesLineDiscount: Record "Sales Line Discount")
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::Invoice then exit;
        if SalesLineDiscount."Final Diesel Fleet Disc. Amt" <> 0 then
            SalesLine."Final Diesel Fleet Disc. Amt" := SalesLineDiscount."Final Diesel Fleet Disc. Amt";
    end;

    //Petrol
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterSalesLineLineDiscExists', '', false, false)]
    local procedure OnAfterSalesLineLineDiscExists(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var TempSalesLineDisc: Record "Sales Line Discount" temporary; ShowAll: Boolean)
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::Invoice then exit;
        SalesLine."Final Diesel Fleet Disc. Amt" := TempSalesLineDisc."Final Diesel Fleet Disc. Amt";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateLineDiscountPercentOnBeforeUpdateAmounts', '', false, false)]
    local procedure OnValidateLineDiscountPercentOnBeforeUpdateAmounts(var SalesLine: Record "Sales Line"; CurrFieldNo: Integer);
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::Invoice then exit;
        if SalesLine."Final Diesel Fleet Disc. Amt" <> 0 then begin
            if SalesLine."Line Discount Amount" > SalesLine."Final Diesel Fleet Disc. Amt" then begin
                if SalesLine.Quantity <> 0 then
                    SalesLine.Validate("Line Discount Amount", SalesLine."Final Diesel Fleet Disc. Amt" * SalesLine.Quantity)
                else
                    SalesLine.Validate("Line Discount Amount", SalesLine."Final Diesel Fleet Disc. Amt");
            end else
                //petrol
                if SalesLine."Line Discount %" = 0 then begin
                    if SalesLine.Quantity <> 0 then
                        SalesLine.Validate("Line Discount Amount", SalesLine."Final Diesel Fleet Disc. Amt" * SalesLine.Quantity)
                    else
                        SalesLine.Validate("Line Discount Amount", SalesLine."Final Diesel Fleet Disc. Amt");
                end;
        end;
    end;
    //petrol- 
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeTestQtyFromLindDiscountAmount', '', false, false)]
    local procedure OnBeforeTestQtyFromLindDiscountAmount(var SalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean);
    begin
        IsHandled := True;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Line Discount Amount', false, false)]
    local procedure OnBeforeVaildateLineDiscountAmount(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec."Document Type" <> Rec."Document Type"::Invoice then exit;
        if Rec."Final Diesel Fleet Disc. Amt" <> 0 then begin
            if Rec."Line Discount Amount" > Rec."Final Diesel Fleet Disc. Amt" then begin
                Rec.Validate("Line Discount Amount", Rec."Final Diesel Fleet Disc. Amt");
            end;
            //  else
            //     if Rec."Line Discount %" = 0 then begin
            //         Rec.Validate("Line Discount Amount", Rec."Final Diesel Fleet Disc. Amt");
            //     end;
        end;
    end;

}
