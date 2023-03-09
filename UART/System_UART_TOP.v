module System_UART_TOP #(parameter WIDTH = 8, parameter PRESCALE_WIDTH = 5) (
    input       wire                                            RX_IN_TOP,
    input       wire        [PRESCALE_WIDTH-1:0]                Prescale_TOP,
    input       wire                                            PAR_EN_TOP,
    input       wire                                            PAR_TYP_TOP,
    input       wire                                            CLK_Rx_TOP,  
    input       wire                                            RST_TOP,
    output      wire        [WIDTH-1:0]                         P_DATA_Rx_TOP,
    output      wire                                            Data_Valid_Rx_TOP,
    output      wire                                            Par_Err_TOP,
    output      wire                                            Stp_Err_TOP,


    input       wire        [WIDTH-1:0]                         P_DATA_Tx_TOP,
    input       wire                                            Data_Valid_Tx_TOP,
    input       wire                                            CLK_Tx_TOP,
    output      wire                                            TX_OUT_TOP,
    output      wire                                            Busy_TOP
);

UART_Rx_TOP #(.WIDTH(WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)) Rx (
    .RX_IN_TOP(RX_IN_TOP),
    .Prescale_TOP(Prescale_TOP),
    .PAR_EN_TOP(PAR_EN_TOP),
    .PAR_TYP_TOP(PAR_TYP_TOP),
    .CLK_TOP(CLK_Rx_TOP),  
    .RST_TOP(RST_TOP),
    .P_DATA_TOP(P_DATA_Rx_TOP),
    .Data_Valid_TOP(Data_Valid_Rx_TOP),
    .Par_Err_TOP(Par_Err_TOP),
    .Stp_Err_TOP(Stp_Err_TOP)
);

UART_Tx_TOP #(.WIDTH(WIDTH)) Tx (
    .P_DATA_TOP(P_DATA_Tx_TOP),
    .DATA_VALID_TOP(Data_Valid_Tx_TOP),
    .PAR_EN_TOP(PAR_EN_TOP),
    .PAR_TYP_TOP(PAR_TYP_TOP),
    .CLK_TOP(CLK_Tx_TOP),
    .RST_TOP(RST_TOP),
    .TX_OUT_TOP(TX_OUT_TOP),
    .Busy_TOP(Busy_TOP)
);


endmodule