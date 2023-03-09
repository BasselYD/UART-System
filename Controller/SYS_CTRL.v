module SYS_CTRL (
    //Rx
    input       wire        [7:0]       RX_P_DATA,
    input       wire                    RX_D_VLD,

    //Tx
    input       wire                    Busy, 
    output      wire        [7:0]       TX_P_DATA,
    output      wire                    TX_D_VLD,

    //ALU
    input       wire        [7:0]       ALU_OUT,
    input       wire                    OUT_Valid,
    output      wire                    ALU_En,
    output      wire        [3:0]       ALU_Fun,
    output      wire                    CLK_En,


    //Register File
    input       wire        [7:0]       RdData,
    input       wire                    RdData_Valid,
    output      wire        [3:0]       Address,
    output      wire                    WrEn,
    output      wire                    RdEn,
    output      wire        [7:0]       WrData,

    //Clock and Reset
    input       wire                    CLK,
    input       wire                    RST
);

SYS_CTRL_Rx CTRL_Rx (
    .RX_P_DATA(RX_P_DATA),
    .RX_D_VLD(RX_D_VLD),
    .ALU_OUT(ALU_OUT),
    .OUT_Valid(OUT_Valid),
    .ALU_En(ALU_En),
    .ALU_Fun(ALU_Fun),
    .CLK_En(CLK_En),
    .RdData(RdData),
    .RdData_Valid(RdData_Valid),
    .Address(Address),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .WrData(WrData),
    .CLK(CLK),
    .RST(RST)
);


SYS_CTRL_Tx CTRL_Tx (
    .ALU_OUT(ALU_OUT),
    .OUT_Valid(OUT_Valid),
    .RdData(RdData),
    .RdData_Valid(RdData_Valid),
    .CLK(CLK),
    .RST(RST),
    .Busy(Busy),
    .TX_P_DATA(TX_P_DATA),
    .TX_D_VLD(TX_D_VLD)
);


endmodule