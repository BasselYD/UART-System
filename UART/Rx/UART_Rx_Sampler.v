module UART_Rx_Sampler #(parameter PRESCALE_WIDTH = 5) (
    input       wire                                    RX_IN,
    input       wire                                    Sample_En,
    input       wire        [PRESCALE_WIDTH-1:0]        Prescale,
    input       wire        [PRESCALE_WIDTH-1:0]        Edge_Cnt,
    input       wire                                    CLK,  
    input       wire                                    RST,
    output      reg                                     Sampled_Bit
);

wire    [PRESCALE_WIDTH-2:0]    Mid;
reg              Val1, Val2, Val3;
wire             Majority_comb;

assign Mid = Prescale[PRESCALE_WIDTH-1:1];

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Val1 <= 0;
                Val2 <= 0;
                Val3 <= 0;
            end
        else if (Edge_Cnt == Mid - 1)
            Val1 <= RX_IN;
        else if (Edge_Cnt == Mid)
            Val2 <= RX_IN;
        else if (Edge_Cnt == Mid + 1)
            begin
                Val3 <= RX_IN;
                Sampled_Bit <= Majority_comb;
            end
    end

assign Majority_comb = (Val1 & Val2) | (Val1 & Val3) | (Val2 & Val3);

endmodule