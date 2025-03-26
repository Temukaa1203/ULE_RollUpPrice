pageextension 90601 AssemblyOrder extends "Assembly Order Subform"
{
    layout
    {
        addafter("Unit Cost")
        {
            field("Unit Price Actual"; Rec."Unit Price Actual")
            {
                ApplicationArea = all;
                Caption = 'Unit Price Actual';
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