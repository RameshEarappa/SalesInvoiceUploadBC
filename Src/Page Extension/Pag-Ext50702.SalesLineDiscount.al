pageextension 50702 "Sales Line Discount" extends "Sales Line Discounts"
{
    layout
    {
        addafter("Line Discount %")
        {
            field("Final Diesel Fleet Disc. Amt"; "Final Diesel Fleet Disc. Amt")
            {
                ApplicationArea = All;
                Caption = 'Final Diesel Fleet Disc. Amt';
            }
        }
    }
}
