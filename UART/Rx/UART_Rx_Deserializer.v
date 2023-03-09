module UART_Rx_Deserializer #(parameter WIDTH = 8) (
    input       wire                            Deser_En, 
    input       wire                            Sampled_Bit, 
    input       wire                            CLK,  
    input       wire                            RST,
    output      reg         [WIDTH-1:0]         P_DATA
);

reg         [WIDTH-1:0]        SR;


always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                SR <= 'b0;
                P_DATA <= 'b0;
            end
        else
            begin
		P_DATA <= SR;
                if (Deser_En)
                    begin
                        SR <= SR >> 1;
                        SR[WIDTH-1] <= Sampled_Bit;
                    end
            end
    end

endmodule
