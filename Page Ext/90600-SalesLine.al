pageextension 90600 SalesLineAssOrd extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Roll Up &Price")
        {
            action("All Roll Up Price")
            {
                ApplicationArea = All;
                Image = Calculate;
                trigger OnAction()
                var
                    salesheader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    AssemblyLine: Record "Assembly Line";
                    AssemblyHeader: Record "Assembly Header";
                    TotalAmount: Decimal;
                    priceSalesType: enum "Sales Price Type";
                    OrderTrackEntry: Record "Order Tracking Entry";
                    ATOLink: Record "Assemble-to-Order Link";
                    salesprice: Record "Sales Price";
                begin
                    // TotalAmount := 0;
                    // SalesLine.SetRange("Document Type", rec."Document Type"::Order);
                    // SalesLine.SetRange("Document No.", Rec."Document No.");
                    // if SalesLine.FindSet() then
                    //     repeat
                    //         if SalesLine.Type = SalesLine.Type::Item then
                    //             AssemblyHeader.SetRange("Item No.", rec."No.");
                    //         if AssemblyHeader.FindSet() then
                    //             repeat
                    //                 Message(AssemblyHeader."No.");
                    //                 AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                    //                 if AssemblyLine.FindSet() then
                    //                     repeat
                    //                         Message(Assemblyline.Description);
                    //                     until AssemblyLine.Next() = 0;
                    //             until Assemblyheader.Next() = 0;
                    //     until SalesLine.Next() = 0
                    // else begin
                    //     Message('Total Amount: %1', TotalAmount);
                    // end;

                    SalesLine.SetRange("Document Type", rec."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."Document No.");
                    if SalesLine.FindSet() then
                        repeat
                            Message(format(SalesLine."Line No."));
                            if SalesLine.Type = SalesLine.Type::Item then
                                ATOLink.SetRange("Document Line No.", SalesLine."Line No.");
                            ATOLink.SetRange("Document No.", SalesLine."document No.");
                            // OrderTrackEntry.Reset();

                            // OrderTrackEntry.SetRange("Item No.", rec."No.");
                            // Message(OrderTrackEntry."Item No.");
                            // OrderTrackEntry.SetRange("From ID", rec."Document No.");
                            // OrderTrackEntry.SetRange("from ref. no.", rec."Line No.");
                            if ATOLink.FindSet() then
                                repeat
                                    TotalAmount := 0;
                                    salesprice.Reset();
                                    Message(ATOLink."Assembly Document No.");
                                    AssemblyLine.SetRange("Document No.", ATOLink."Assembly Document No.");
                                    if AssemblyLine.FindSet() then
                                        repeat
                                            if SalesLine."Customer Price Group" = '' then begin
                                                salesprice.SetRange("Sales Code", SalesLine."Sell-to Customer No.");
                                                if salesprice.FindSet() then begin
                                                    priceSalesType := salesprice."Sales Type";
                                                    salesprice.SetRange("Sales type", priceSalesType);
                                                    salesprice.SetRange("Item No.", AssemblyLine."No.");
                                                    if salesprice.FindSet() then
                                                        TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                end
                                                else begin
                                                    salesprice.Reset();
                                                    priceSalesType := "Sales Price Type"::"All Customers";
                                                    salesprice.SetRange("Item No.", AssemblyLine."No.");
                                                    salesprice.SetRange("Sales Type", priceSalesType);
                                                    if salesprice.FindSet() then
                                                        TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                end;

                                                // salesprice.SetRange("Item No.", SalesLine."No.");
                                            end
                                            else begin
                                                salesprice.SetRange("Sales Code", SalesLine."Customer Price Group");
                                                if salesprice.FindSet() then
                                                    priceSalesType := salesprice."Sales Type";
                                                salesprice.SetRange("Sales type", priceSalesType);
                                                salesprice.SetRange("Item No.", AssemblyLine."No.");
                                                if salesprice.FindSet() then
                                                    TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                            end;
                                        until AssemblyLine.Next() = 0;
                                    Message(format(TotalAmount));
                                    SalesLine.Validate("Unit Price", TotalAmount);
                                    SalesLine.Modify(true);
                                until ATOLink.Next() = 0;
                        until SalesLine.Next() = 0
                end;
            }
        }
    }

    var
        myInt: Integer;
}