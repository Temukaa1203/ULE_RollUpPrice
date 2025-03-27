pageextension 90603 assembletoorderlines extends "Assemble-to-Order Lines"
{
    layout
    {
        addafter("Unit Cost")
        {
            field("Unit Price Actual"; Rec."Unit Price Actual")
            {
                ApplicationArea = All;
                Caption = 'Unit Price Actual';
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}