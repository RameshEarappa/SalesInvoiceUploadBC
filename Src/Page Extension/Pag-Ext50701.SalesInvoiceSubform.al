pageextension 50701 "Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Truck Id"; Rec."Truck Id")
            {
                ApplicationArea = All;
            }
            field("Vehicle Id"; Rec."Vehicle Id")
            {
                ApplicationArea = All;
            }
        }
        modify("Line Discount Amount")
        {
            Visible = true;
        }
        moveafter("Line Discount %"; "Line Discount Amount")
    }
}
