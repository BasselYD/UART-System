module SYS_CTRL_Tx (
    //ALU
    input       wire       [7:0]        ALU_OUT,
    input       wire                    OUT_Valid,

    //Register File
    input       wire       [7:0]        RdData,
    input       wire                    RdData_Valid,

    //Clock and Reset
    input       wire                    CLK,
    input       wire                    RST,

    //Tx
    input       wire                    Busy, 
    output      reg        [7:0]        TX_P_DATA,
    output      reg                     TX_D_VLD
);

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                TX_P_DATA <= 0;
                TX_D_VLD  <= 0;
            end
        else
            begin
                if (OUT_Valid)
                    begin
                        TX_P_DATA <= ALU_OUT;
                        TX_D_VLD  <= 1;
                    end
                else if (RdData_Valid)
                    begin
                        TX_P_DATA <= RdData;
                        TX_D_VLD  <= 1;
                    end
                else if (Busy)
                    begin
                        TX_P_DATA <= 0;
                        TX_D_VLD  <= 0;
                    end
            end
    end


endmodule
