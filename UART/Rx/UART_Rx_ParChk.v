module UART_Rx_ParChk #(parameter WIDTH = 8, parameter PRESCALE_WIDTH = 5) (
    input       wire                                    Par_Chk_En,
    input       wire                                    Sampled_Bit,
    input       wire        [WIDTH-1:0]                 P_DATA,
    input       wire                                    PAR_TYP,
    input       wire        [PRESCALE_WIDTH-1:0]        Prescale,
    input       wire        [PRESCALE_WIDTH-1:0]        Edge_Cnt,
    input       wire                                    CLK,  
    input       wire                                    RST,
    output      reg                                     Par_Err
);

reg    Calculated_Parity;


always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            Par_Err <= 0;
        else    
            begin
                if (Par_Chk_En && (Edge_Cnt == ((Prescale >> 1) + 2)))
                    begin
                        Par_Err <= (Sampled_Bit != Calculated_Parity);
                    end
            end
    end


always @ (*)
    begin
        if (!PAR_TYP)
            Calculated_Parity = ^P_DATA;
        else
            Calculated_Parity = ~^P_DATA;
    end



endmodule


