module SYS_CTRL_Rx (
    //Rx
    input       wire        [7:0]       RX_P_DATA,
    input       wire                    RX_D_VLD,

    //ALU
    input       wire        [7:0]       ALU_OUT,
    input       wire                    OUT_Valid,
    output      reg                     ALU_En,
    output      reg         [3:0]       ALU_Fun,
    output      reg                     CLK_En,


    //Register File
    input       wire        [7:0]       RdData,
    input       wire                    RdData_Valid,
    output      reg         [3:0]       Address,
    output      reg                     WrEn,
    output      reg                     RdEn,
    output      reg         [7:0]       WrData,

    //Clock and Reset
    input       wire                    CLK,
    input       wire                    RST
);

reg     [2:0]       currentState, nextState;
reg     [7:0]       currentInstruction, currentAddress, currentData, currentFun;

localparam  IDLE        =   0,
            ADD_WAIT    =   1,
            DATA_WAIT   =   2,
            OPA_WAIT    =   3,
            OPB_WAIT    =   4,
            FUN_WAIT    =   5,
            PROCESS     =   6,
            ALU_OFF     =   7;




localparam  RF_Write    =   8'hAA,
            RF_Read     =   8'hBB,
            ALU_Op      =   8'hCC,
            ALU_No_Op   =   8'hDD;


//Next State Transition
always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                currentState <= IDLE; 
                currentInstruction <= 0;
                currentAddress <= 0;
                currentData <= 0;   
            end
        else
            begin
                currentState <= nextState;

                case (currentState)
                    
                    IDLE        :   begin
                                        if (RX_D_VLD)
                                            currentInstruction <= RX_P_DATA;
                                    end

                    
                    ADD_WAIT    :   begin
                                        if (RX_D_VLD)
                                            currentAddress <= RX_P_DATA;
                                    end


                    DATA_WAIT   :   begin
                                        if (RX_D_VLD)
                                            currentData <= RX_P_DATA;
                                    end

                    FUN_WAIT    :   begin
                                        if (RX_D_VLD)
                                            currentFun <= RX_P_DATA;
                                    end

                endcase
            end
    end


//Next State Logic
always @ (*)
    begin
        case (currentState)

            IDLE        :   begin
                                if (RX_D_VLD)
                                    begin
                                        case (RX_P_DATA)

                                            RF_Write    :   begin
                                                                nextState = ADD_WAIT;
                                                            end

                                            RF_Read     :   begin
                                                                nextState = ADD_WAIT;
                                                            end

                                            ALU_Op      :   begin
                                                                nextState = OPA_WAIT;
                                                            end

                                            ALU_No_Op   :   begin
                                                                nextState = FUN_WAIT;
                                                            end

                                            default     :   begin
                                                                nextState = IDLE;
                                                            end
                                        endcase
                                    end
                                
                                else
                                    nextState = IDLE;

                            end

            
            ADD_WAIT    :   begin
                                if (RX_D_VLD)
                                    begin
                                        if (currentInstruction == RF_Write)
                                            nextState = DATA_WAIT;
                                        else
                                            nextState = PROCESS;
                                    end
                                else
                                    nextState = ADD_WAIT;
                            end


            DATA_WAIT   :   begin
                                if (RX_D_VLD)
                                    nextState = PROCESS;
                                else
                                    nextState = DATA_WAIT;
                            end

            OPA_WAIT    :   begin
                                if (RX_D_VLD)
                                    nextState = OPB_WAIT;
                                else
                                    nextState = OPA_WAIT;
                            end

            OPB_WAIT    :   begin
                                if (RX_D_VLD)
                                    nextState = FUN_WAIT;
                                else
                                    nextState = OPB_WAIT;
                            end

            FUN_WAIT    :   begin
                                if (RX_D_VLD)
                                    nextState = PROCESS;
                                else
                                    nextState = FUN_WAIT;
                            end

            PROCESS     :   begin
                                if (currentInstruction == RF_Read)
                                    begin
                                        if (RdData_Valid)
                                            nextState = IDLE;
                                        else
                                            nextState = PROCESS;
                                    end

                                else if (currentInstruction == RF_Write)
                                    nextState = IDLE;
                                
                                else if (currentInstruction == ALU_No_Op || currentInstruction == ALU_Op)
                                    begin
                                        if (OUT_Valid)
                                            nextState = ALU_OFF;
                                        else
                                            nextState = PROCESS;
                                    end   
                                
                                else
                                    nextState = IDLE;
                            end

            ALU_OFF     :   nextState = IDLE;

            default     :   nextState = IDLE;

        endcase
    end


//Output Logic
always @ (*)
    begin
        case (currentState)

            IDLE        :   begin
                                ALU_En = 0;
                                ALU_Fun = 0;
                                CLK_En = 0;
                                Address = 0;
                                WrEn = 0;
                                RdEn = 0;
                                WrData = 0;
                            end

            
            ADD_WAIT    :   begin
                                ALU_En = 0;
                                ALU_Fun = 0;
                                CLK_En = 0;
                                Address = currentAddress;
                                WrEn = 0;
                                RdEn = 0;
                                WrData = 0;
                            end


            DATA_WAIT   :   begin
                                ALU_En = 0;
                                ALU_Fun = 0;
                                CLK_En = 0;
                                Address = currentAddress;
                                WrEn = 0;
                                RdEn = 0;
                                WrData = currentData;
                            end

            OPA_WAIT    :   begin
                                ALU_En = 0;
                                ALU_Fun = 0;
                                CLK_En = 0;
                                RdEn = 0;

                                Address = 8'h0;
                                if (RX_D_VLD)
                                    begin
                                        WrEn = 1;
                                        WrData = RX_P_DATA;
                                    end
                                else
                                    begin
                                        WrEn = 0;
                                        WrData = 0;
                                    end
                            end

            OPB_WAIT    :   begin
                                ALU_En = 0;
                                ALU_Fun = 0;
                                CLK_En = 0;
                                RdEn = 0;

                                Address = 8'h1;
                                if (RX_D_VLD)
                                    begin
                                        WrEn = 1;
                                        WrData = RX_P_DATA;
                                    end
                                else
                                    begin
                                        WrEn = 0;
                                        WrData = 0;
                                    end
                            end

            FUN_WAIT    :   begin
                                ALU_En = 0;
                                ALU_Fun = currentFun;
                                CLK_En = 0;
                                Address = 0;
                                WrEn = 0;
                                RdEn = 0;
                                WrData = 0;
                            end

            PROCESS     :   begin
                                if (currentInstruction == ALU_No_Op || currentInstruction == ALU_Op)
                                    begin
                                        ALU_En = 1;
                                        ALU_Fun = currentFun;
                                        CLK_En = 1;

                                        Address = 0;
                                        WrEn = 0;
                                        RdEn = 0;
                                        WrData = 0;
                                    end

                                else if (currentInstruction == RF_Read)
                                    begin
                                        ALU_En = 0;
                                        ALU_Fun = 0;
                                        CLK_En = 0;

                                        Address = currentAddress;
                                        WrEn = 0;
                                        RdEn = 1;
                                        WrData = 0;
                                    end

                                else if (currentInstruction == RF_Write)
                                    begin
                                        ALU_En = 0;
                                        ALU_Fun = 0;
                                        CLK_En = 0;

                                        Address = currentAddress;
                                        WrEn = 1;
                                        RdEn = 0;
                                        WrData = currentData;
                                    end

                                else
                                    begin
                                        ALU_En = 0;
                                        ALU_Fun = 0;
                                        CLK_En = 0;
                                        Address = 0;
                                        WrEn = 0;
                                        RdEn = 0;
                                        WrData = 0;
                                    end
                            end

            ALU_OFF     :   begin
                                ALU_En = 0;
                                ALU_Fun = 0;
                                CLK_En = 1;
                                Address = 0;
                                WrEn = 0;
                                RdEn = 0;
                                WrData = 0;
                            end

            default     :   begin
                                ALU_En = 0;
                                ALU_Fun = 0;
                                CLK_En = 0;
                                Address = 0;
                                WrEn = 0;
                                RdEn = 0;
                                WrData = 0;
                            end

        endcase
    end



endmodule
