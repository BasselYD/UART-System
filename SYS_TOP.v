module SYS_TOP (
    input       wire                REF_CLK,
    input       wire                UART_CLK,
    input       wire                RST,
    input       wire                RX_IN,
    output      wire                TX_OUT,
    output      wire                PAR_ERR,
    output      wire                STP_ERR
);

//////////////////Internal Signals//////////////////

localparam              WIDTH           =   8,
                        PRESCALE_WIDTH  =   5,
                        FUN_WIDTH       =   4,
                        ADDRESS_WIDTH   =   4,
                        DIV_WIDTH       =   4,
                        SYNC_STAGES     =   2;

//System Controller
wire        [WIDTH-1:0]                 RX_P_DATA_SYNC;
wire                                    RX_D_VLD_SYNC;
wire        [WIDTH-1:0]                 ALU_OUT_TOP;
wire                                    OUT_Valid_TOP;
wire                                    ALU_En_TOP;
wire        [FUN_WIDTH-1:0]             ALU_Fun_TOP;
wire                                    Gate_EN;
wire        [WIDTH-1:0]                 RdData_TOP;
wire                                    RdData_Valid_TOP;
wire        [ADDRESS_WIDTH-1:0]         Address_TOP;
wire                                    WrEn_TOP;
wire                                    RdEn_TOP;
wire        [WIDTH-1:0]                 WrData_TOP;
wire        [WIDTH-1:0]                 P_DATA_Tx_UNSYNC;
wire                                    Data_Valid_Tx_UNSYNC;


//Registers
wire        [WIDTH-1:0]                 OperandA;
wire        [WIDTH-1:0]                 OperandB;
wire        [WIDTH-1:0]                 UARTConfig;
wire        [WIDTH-1:0]                 DivRatio; 


//UART
wire        [PRESCALE_WIDTH-1:0]        Prescale_TOP        =       UARTConfig[6:2];
wire                                    PAR_TYP_TOP         =       UARTConfig[1];
wire                                    PAR_EN_TOP          =       UARTConfig[0];
wire        [WIDTH-1:0]                 P_DATA_Rx_TOP;
wire                                    Data_Valid_Rx_TOP;
wire        [WIDTH-1:0]                 P_DATA_Tx_SYNC;
wire                                    Data_Valid_Tx_SYNC;
wire                                    CLK_Tx_TOP;
wire                                    Busy_TOP;


//CLK and RST
wire                    Gated_Clk;
wire                    REF_CLK_RST;
wire                    UART_CLK_RST;



SYS_CTRL Controller (
    .RX_P_DATA(RX_P_DATA_SYNC),
    .RX_D_VLD(RX_D_VLD_SYNC),
    .ALU_OUT(ALU_OUT_TOP),
    .OUT_Valid(OUT_Valid_TOP),
    .ALU_En(ALU_En_TOP),
    .ALU_Fun(ALU_Fun_TOP),
    .CLK_En(Gate_EN),
    .RdData(RdData_TOP),
    .RdData_Valid(RdData_Valid_TOP),
    .Address(Address_TOP),
    .WrEn(WrEn_TOP),
    .RdEn(RdEn_TOP),
    .WrData(WrData_TOP),
    .CLK(REF_CLK),
    .RST(REF_CLK_RST),
    .Busy(Busy_TOP),
    .TX_P_DATA(P_DATA_Tx_UNSYNC),
    .TX_D_VLD(Data_Valid_Tx_UNSYNC)
);

System_UART_TOP #(.WIDTH(WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)) UART (
    .RX_IN_TOP(RX_IN),
    .Prescale_TOP(Prescale_TOP),
    .PAR_EN_TOP(PAR_EN_TOP),
    .PAR_TYP_TOP(PAR_TYP_TOP),
    .CLK_Rx_TOP(UART_CLK),  
    .RST_TOP(UART_CLK_RST),
    .P_DATA_Rx_TOP(P_DATA_Rx_TOP),
    .Data_Valid_Rx_TOP(Data_Valid_Rx_TOP),
    .Par_Err_TOP(PAR_ERR),
    .Stp_Err_TOP(STP_ERR),

    .P_DATA_Tx_TOP(P_DATA_Tx_SYNC),
    .Data_Valid_Tx_TOP(Data_Valid_Tx_SYNC),
    .CLK_Tx_TOP(CLK_Tx_TOP),
    .TX_OUT_TOP(TX_OUT),
    .Busy_TOP(Busy_TOP)
);

ClkDiv #(.DIV_WIDTH(DIV_WIDTH)) Tx_Divider (
    .i_ref_clk(UART_CLK),
    .i_rst_n(UART_CLK_RST),
    .i_clk_en(1'b1),
    .i_div_ratio(DivRatio[DIV_WIDTH-1:0]),
    .o_div_clk(CLK_Tx_TOP)
);

Register_File #(.WIDTH(WIDTH), .DEPTH_BITS(ADDRESS_WIDTH)) RF (
    .WrData(WrData_TOP),
    .Address(Address_TOP),
    .WrEn(WrEn_TOP),
    .RdEn(RdEn_TOP),
    .CLK(REF_CLK),
    .RST(REF_CLK_RST),
    .RdData(RdData_TOP),
    .RdData_Valid(RdData_Valid_TOP),
    .REG0(OperandA),
    .REG1(OperandB),
    .REG2(UARTConfig),
    .REG3(DivRatio)
);

ALU #(.WIDTH(WIDTH), .OUT_WIDTH(WIDTH), .FUN_WIDTH(FUN_WIDTH)) ALU (
    .A(OperandA),
    .B(OperandB),
    .ALU_FUN(ALU_Fun_TOP),
    .Enable(ALU_En_TOP),
    .CLK(Gated_Clk),
    .RST(REF_CLK_RST),
    .ALU_OUT(ALU_OUT_TOP),
    .OUT_Valid(OUT_Valid_TOP)
);

CLK_GATE ALU_Gate (
    .CLK_EN(Gate_EN),
    .CLK(REF_CLK),
    .GATED_CLK(Gated_Clk)
);


Data_Sync #(.NUM_STAGES(SYNC_STAGES), .BUS_WIDTH(WIDTH)) Rx_Sync (
    .UNSYNC_BUS(P_DATA_Rx_TOP),
    .Bus_Enable(Data_Valid_Rx_TOP),
    .CLK(REF_CLK),
    .RST(REF_CLK_RST),
    .SYNC_BUS(RX_P_DATA_SYNC),
    .Enable_Pulse(RX_D_VLD_SYNC)
);


Data_Sync #(.NUM_STAGES(SYNC_STAGES), .BUS_WIDTH(WIDTH)) Tx_Sync (
    .UNSYNC_BUS(P_DATA_Tx_UNSYNC),
    .Bus_Enable(Data_Valid_Tx_UNSYNC),
    .CLK(CLK_Tx_TOP),
    .RST(UART_CLK_RST),
    .SYNC_BUS(P_DATA_Tx_SYNC),
    .Enable_Pulse(Data_Valid_Tx_SYNC)
);


RST_Sync #(.NUM_STAGES(SYNC_STAGES)) Ref_RST_Sync (
    .RST(RST),
    .CLK(REF_CLK),
    .SYNC_RST(REF_CLK_RST)
);

RST_Sync #(.NUM_STAGES(SYNC_STAGES)) UART_RST_Sync (
    .RST(RST),
    .CLK(UART_CLK),
    .SYNC_RST(UART_CLK_RST)
);

endmodule