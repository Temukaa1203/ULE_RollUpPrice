pageextension 90602 PostedAssemblyOrder extends "Posted Assembly Order Subform"
{
    layout
    {
        addafter("Unit Cost")
        {
            field("Unit Price Actual"; Rec."Unit Price Actual")
            {
                ApplicationArea = all;
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