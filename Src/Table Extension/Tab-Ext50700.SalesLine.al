tableextension 50700 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(50700; "Truck Id"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50701; "Vehicle Id"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50702; "Final Diesel Fleet Disc. Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
}
