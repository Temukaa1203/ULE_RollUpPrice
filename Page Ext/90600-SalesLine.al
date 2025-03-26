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
                    priceSalesType: enum "Price Source Type";
                    OrderTrackEntry: Record "Order Tracking Entry";
                    ATOLink: Record "Assemble-to-Order Link";
                    salesprice: Record "Price List Line";
                    orderdate: date;
                begin
                    salesheader.SetRange("No.", rec."Document No.");
                    if salesheader.FindSet() then begin
                        orderdate := salesheader."Order Date";
                        // Message(salesheader."No.");
                        // Message(Format(orderdate));
                    end;
                    SalesLine.SetRange("Document Type", rec."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."Document No.");
                    if SalesLine.FindSet() then
                        repeat
                            if SalesLine.Type = SalesLine.Type::Item then
                                ATOLink.SetRange("Document Line No.", SalesLine."Line No.");
                            ATOLink.SetRange("Document No.", SalesLine."document No.");
                            if ATOLink.FindSet() then
                                repeat
                                    TotalAmount := 0;
                                    salesprice.Reset();
                                    AssemblyLine.SetRange("Document No.", ATOLink."Assembly Document No.");
                                    if AssemblyLine.FindSet() then
                                        repeat
                                            if SalesLine."Customer Price Group" = '' then begin
                                                salesprice.SetRange("Source No.", SalesLine."Sell-to Customer No.");
                                                if salesprice.FindSet() then begin
                                                    priceSalesType := salesprice."Source Type";
                                                    salesprice.SetRange("Source type", priceSalesType);
                                                    salesprice.SetRange("Product No.", AssemblyLine."No.");
                                                    if salesprice.FindSet() then begin
                                                        repeat
                                                            // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                            if ((salesprice."Starting Date" < orderdate) and (orderdate < salesprice."Ending Date")) or ((salesprice."Starting Date" = 0D) and (salesprice."ending date" = 0D)) or ((salesprice."Starting Date" < orderdate) and (salesprice."Ending Date" = 0D)) then begin
                                                                TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                                AssemblyLine.validate("Unit Price Actual", AssemblyLine.Quantity * salesprice."Unit Price");
                                                                Message(Format(AssemblyLine."No."));
                                                                AssemblyLine.Modify(true);
                                                            end;
                                                        until salesprice.Next() = 0;
                                                    end;
                                                end
                                                else begin
                                                    salesprice.Reset();
                                                    salesprice.SetRange("Source type", priceSalesType::"All Customers");
                                                    salesprice.SetRange("Product No.", AssemblyLine."No.");
                                                    if salesprice.FindSet() then begin
                                                        // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                        repeat
                                                            // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                            if ((salesprice."Starting Date" < orderdate) and (orderdate < salesprice."Ending Date")) or ((salesprice."Starting Date" = 0D) and (salesprice."ending date" = 0D)) or ((salesprice."Starting Date" < orderdate) and (salesprice."Ending Date" = 0D)) then begin
                                                                TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                                AssemblyLine.validate("Unit Price Actual", AssemblyLine.Quantity * salesprice."Unit Price");
                                                                Message(Format(AssemblyLine."No."));
                                                                AssemblyLine.Modify(true);
                                                            end;
                                                        until salesprice.Next() = 0;
                                                    end;
                                                end;

                                                // salesprice.SetRange("Item No.", SalesLine."No.");
                                            end
                                            else begin
                                                salesprice.SetRange("source no.", SalesLine."Customer Price Group");
                                                if salesprice.FindSet() then
                                                    priceSalesType := salesprice."Source Type";
                                                salesprice.SetRange("Source type", priceSalesType);
                                                salesprice.SetRange("Product No.", AssemblyLine."No.");
                                                if salesprice.FindSet() then begin
                                                    // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                    repeat
                                                        // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                        if ((salesprice."Starting Date" < orderdate) and (orderdate < salesprice."Ending Date")) or ((salesprice."Starting Date" = 0D) and (salesprice."ending date" = 0D)) or ((salesprice."Starting Date" < orderdate) and (salesprice."Ending Date" = 0D)) then begin
                                                            TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                            AssemblyLine.validate("Unit Price Actual", AssemblyLine.Quantity * salesprice."Unit Price");
                                                            Message(Format(AssemblyLine."No."));
                                                            AssemblyLine.Modify(true);
                                                        end;
                                                    until salesprice.Next() = 0;
                                                end;

                                            end;

                                        until AssemblyLine.Next() = 0;
                                    SalesLine.Validate("Unit Price", TotalAmount);
                                    SalesLine.Modify(true);
                                until ATOLink.Next() = 0;
                        until SalesLine.Next() = 0
                end;
            }
            action("Roll Up Price")
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
                    priceSalesType: enum "Price Source Type";
                    OrderTrackEntry: Record "Order Tracking Entry";
                    ATOLink: Record "Assemble-to-Order Link";
                    salesprice: Record "Price List Line";
                    orderdate: date;
                begin
                    salesheader.SetRange("No.", rec."Document No.");
                    if salesheader.FindSet() then begin
                        orderdate := salesheader."Order Date";
                        // Message(salesheader."No.");
                        // Message(Format(orderdate));
                    end;
                    SalesLine.SetRange("Document Type", rec."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."Document No.");
                    SalesLine.SetRange("Line No.", rec."Line No.");
                    if SalesLine.FindSet() then
                        repeat
                            if SalesLine.Type = SalesLine.Type::Item then
                                ATOLink.SetRange("Document Line No.", SalesLine."Line No.");
                            ATOLink.SetRange("Document No.", SalesLine."document No.");
                            if ATOLink.FindSet() then
                                repeat
                                    TotalAmount := 0;
                                    salesprice.Reset();
                                    AssemblyLine.SetRange("Document No.", ATOLink."Assembly Document No.");
                                    if AssemblyLine.FindSet() then
                                        repeat
                                            if SalesLine."Customer Price Group" = '' then begin
                                                salesprice.SetRange("Source No.", SalesLine."Sell-to Customer No.");
                                                if salesprice.FindSet() then begin
                                                    priceSalesType := salesprice."Source Type";
                                                    salesprice.SetRange("Source type", priceSalesType);
                                                    salesprice.SetRange("Product No.", AssemblyLine."No.");
                                                    if salesprice.FindSet() then begin
                                                        // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                        repeat
                                                            // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                            if ((salesprice."Starting Date" < orderdate) and (orderdate < salesprice."Ending Date")) or ((salesprice."Starting Date" = 0D) and (salesprice."ending date" = 0D)) or ((salesprice."Starting Date" < orderdate) and (salesprice."Ending Date" = 0D)) then begin
                                                                TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                            end;
                                                        until salesprice.Next() = 0;
                                                    end;
                                                end
                                                else begin
                                                    salesprice.Reset();
                                                    salesprice.SetRange("Source type", priceSalesType::"All Customers");
                                                    salesprice.SetRange("Product No.", AssemblyLine."No.");
                                                    if salesprice.FindSet() then begin
                                                        // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                        repeat
                                                            // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                            if ((salesprice."Starting Date" < orderdate) and (orderdate < salesprice."Ending Date")) or ((salesprice."Starting Date" = 0D) and (salesprice."ending date" = 0D)) or ((salesprice."Starting Date" < orderdate) and (salesprice."Ending Date" = 0D)) then begin
                                                                TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                            end;
                                                        until salesprice.Next() = 0;
                                                    end;
                                                end;

                                                // salesprice.SetRange("Item No.", SalesLine."No.");
                                            end
                                            else begin
                                                salesprice.SetRange("source no.", SalesLine."Customer Price Group");
                                                if salesprice.FindSet() then
                                                    priceSalesType := salesprice."Source Type";
                                                salesprice.SetRange("Source type", priceSalesType);
                                                salesprice.SetRange("Product No.", AssemblyLine."No.");
                                                if salesprice.FindSet() then begin
                                                    // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                    repeat
                                                        // TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                        if ((salesprice."Starting Date" < orderdate) and (orderdate < salesprice."Ending Date")) or ((salesprice."Starting Date" = 0D) and (salesprice."ending date" = 0D)) or ((salesprice."Starting Date" < orderdate) and (salesprice."Ending Date" = 0D)) then begin
                                                            TotalAmount += AssemblyLine.Quantity * salesprice."Unit Price";
                                                        end;
                                                    until salesprice.Next() = 0;
                                                end;

                                            end;
                                            AssemblyLine."Unit Price Actual" := AssemblyLine.Quantity * salesprice."Unit Price";
                                        until AssemblyLine.Next() = 0;
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