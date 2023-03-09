module UART_Rx_TOP #(parameter WIDTH = 8, parameter PRESCALE_WIDTH = 5) (
    input       wire                                        RX_IN_TOP,
    input       wire        [PRESCALE_WIDTH-1:0]            Prescale_TOP,
    input       wire                                        PAR_EN_TOP,
    input       wire                                        PAR_TYP_TOP,
    input       wire                                        CLK_TOP,  
    input       wire                                        RST_TOP,
    output      wire        [WIDTH-1:0]                     P_DATA_TOP,
    output      wire                                        Data_Valid_TOP,
    output      wire                                        Par_Err_TOP,
    output      wire                                        Stp_Err_TOP
);

wire                                    Strt_Glitch_TOP;
wire                                    Count_En_TOP;
wire                                    Data_Samp_En_TOP;
wire                                    Par_Chk_En_TOP;
wire                                    Strt_Chk_En_TOP;
wire                                    Stp_Chk_En_TOP;
wire                                    Deser_En_TOP;
wire         [PRESCALE_WIDTH-1:0]       Edge_Cnt_TOP;
wire         [3:0]                      Bit_Cnt_TOP;
wire                                    Sampled_Bit_TOP;


UART_Rx_FSM #(.WIDTH(WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)) FSM (
    .RX_IN(RX_IN_TOP),
    .PAR_EN(PAR_EN_TOP),
    .Prescale(Prescale_TOP),
    .Edge_Cnt(Edge_Cnt_TOP),
    .Bit_Cnt(Bit_Cnt_TOP),
    .Par_Err(Par_Err_TOP),
    .Strt_Glitch(Strt_Glitch_TOP),
    .Stp_Err(Stp_Err_TOP),
    .CLK(CLK_TOP),  
    .RST(RST_TOP),
    .Count_En(Count_En_TOP),
    .Data_Samp_En(Data_Samp_En_TOP),
    .Par_Chk_En(Par_Chk_En_TOP),
    .Strt_Chk_En(Strt_Chk_En_TOP),
    .Stp_Chk_En(Stp_Chk_En_TOP),
    .Deser_En(Deser_En_TOP),
    .Data_Valid(Data_Valid_TOP)
);

UART_Rx_Counter #(.PRESCALE_WIDTH(PRESCALE_WIDTH)) Edge_Bit_Cnt (
    .Count_En(Count_En_TOP),
    .Prescale(Prescale_TOP),
    .CLK(CLK_TOP),  
    .RST(RST_TOP),
    .Edge_Cnt(Edge_Cnt_TOP),
    .Bit_Cnt(Bit_Cnt_TOP)
);

UART_Rx_Sampler #(.PRESCALE_WIDTH(PRESCALE_WIDTH)) Sampler (
    .RX_IN(RX_IN_TOP),
    .Sample_En(Data_Samp_En_TOP),
    .Prescale(Prescale_TOP),
    .Edge_Cnt(Edge_Cnt_TOP),
    .CLK(CLK_TOP),  
    .RST(RST_TOP),
    .Sampled_Bit(Sampled_Bit_TOP)
);

UART_Rx_Deserializer #(.WIDTH(WIDTH)) Deserializer (
    .Deser_En(Deser_En_TOP), 
    .Sampled_Bit(Sampled_Bit_TOP), 
    .CLK(CLK_TOP),  
    .RST(RST_TOP),
    .P_DATA(P_DATA_TOP)
);

UART_Rx_StrtChk #(.PRESCALE_WIDTH(PRESCALE_WIDTH)) StartCheck (
    .Strt_Chk_En(Strt_Chk_En_TOP),
    .Sampled_Bit(Sampled_Bit_TOP),
    .Prescale(Prescale_TOP),
    .Edge_Cnt(Edge_Cnt_TOP),
    .CLK(CLK_TOP),  
    .RST(RST_TOP),
    .Strt_Glitch(Strt_Glitch_TOP)
);

UART_Rx_StpChk #(.PRESCALE_WIDTH(PRESCALE_WIDTH)) StopCheck (
    .Stp_Chk_En(Stp_Chk_En_TOP),
    .Sampled_Bit(Sampled_Bit_TOP),
    .Prescale(Prescale_TOP),
    .Edge_Cnt(Edge_Cnt_TOP),
    .CLK(CLK_TOP),  
    .RST(RST_TOP),
    .Stp_Err(Stp_Err_TOP)
);

UART_Rx_ParChk #(.WIDTH(WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)) ParityCheck (
    .Par_Chk_En(Par_Chk_En_TOP),
    .Sampled_Bit(Sampled_Bit_TOP),
    .P_DATA(P_DATA_TOP),
    .PAR_TYP(PAR_TYP_TOP),
    .Prescale(Prescale_TOP),
    .Edge_Cnt(Edge_Cnt_TOP),
    .CLK(CLK_TOP),  
    .RST(RST_TOP),
    .Par_Err(Par_Err_TOP)
);



endmodule