table 50700 "Sales Invoice Staging"
{
    Caption = 'Sales Invoice Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Customer Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(6; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            DataClassification = ToBeClassified;
        }
        field(7; "Truck Id"; Text[30])
        {
            Caption = 'Truck Id';
            DataClassification = ToBeClassified;
        }
        field(8; "Vehicle Id"; Text[30])
        {
            Caption = 'Vehicle Id';
            DataClassification = ToBeClassified;
        }
        field(9; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
