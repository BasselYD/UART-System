module UART_Rx_StpChk #(parameter PRESCALE_WIDTH = 5) (
    input       wire                                    Stp_Chk_En,
    input       wire                                    Sampled_Bit,
    input       wire        [PRESCALE_WIDTH-1:0]        Prescale,
    input       wire        [PRESCALE_WIDTH-1:0]        Edge_Cnt,
    input       wire                                    CLK,  
    input       wire                                    RST,
    output      reg                                     Stp_Err
);

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            Stp_Err <= 0;
        else
            begin
                if (Stp_Chk_En && (Edge_Cnt == ((Prescale >> 1) + 2)))
                    Stp_Err <= (Sampled_Bit != 1);
            end
    end


endmodule
