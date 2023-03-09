`timescale 1ns/1ps

module SYS_tb ();

//System
reg                 REF_CLK_tb;
reg                 UART_CLK_tb;
reg                 RST_tb;
wire                RX_IN_tb;
wire                TX_OUT_tb;
wire                PAR_ERR_tb;
wire                STP_ERR_tb;


//Testbench's UART
reg         [4:0]        Prescale_User;
reg                      PAR_EN_User;
reg                      PAR_TYP_User;
wire        [7:0]        P_DATA_Rx_User;
wire                     Data_Valid_Rx_User;
reg         [7:0]        P_DATA_Tx_User;
reg                      Data_Valid_Tx_User;
reg                      CLK_Tx_User;
wire                     Busy_User;
wire                     PAR_ERR_User;
wire                     STP_ERR_User;



//Parameters
localparam          SYS_PER     =       20,
                    H_SYS_PER   =       10,
                    UART_PER    =       12755.02,
                    H_UART_PER  =       6377.551,
                    TX_PER      =       104166.666,
                    H_TX_PER    =       52083.333;


localparam  RF_Write    =   8'hAA,
            RF_Read     =   8'hBB,
            ALU_Op      =   8'hCC,
            ALU_No_Op   =   8'hDD;


localparam  ADD    =   4'b0000,
            SUB    =   4'b0001,
            MUL    =   4'b0010,
            DIV    =   4'b0011,
            AND    =   4'b0100,
            OR     =   4'b0101,
            NAND   =   4'b0110,
            NOR    =   4'b0111,
            XOR    =   4'b1000,
            XNOR   =   4'b1001,
            EQU    =   4'b1010,
            GRT    =   4'b1011,
            LESS   =   4'b1100,
            SHR    =   4'b1101,
            SHL    =   4'b1110;


//Tasks
task    Send_Frame;
    input   [7:0]   frame;
    integer I;
    begin
        P_DATA_Tx_User = frame;
        Data_Valid_Tx_User = 1;
        #TX_PER;
        Data_Valid_Tx_User = 0;
        for (I = 0; I < 10; I = I + 1)
            begin
                #TX_PER;
            end
    end
endtask

task    Wait_for_Response;
    integer I;
    begin
        //Two Tx Clock Cycles for frame to reach Tx through Synchronizers.
        for (I = 0; I < 2; I = I + 1)
            begin
                #TX_PER;
            end

        //Eleven Tx Clock Cycles to send frame.
        for (I = 0; I < 11; I = I + 1)
        begin
            #TX_PER;
        end
    end
endtask


//Testbench
initial 
    begin
        $dumpfile("SYS.vcd");
        $dumpvars;

        //Resetting the System
        RST_tb = 0;
        REF_CLK_tb = 0;
        UART_CLK_tb = 0;

        //Initial Values for Testbench's UART
        CLK_Tx_User = 0;
        Prescale_User = 8;
        PAR_EN_User = 1;
        PAR_TYP_User = 0;
       
        #UART_PER
        RST_tb = 1;
        #UART_PER;

        //Initial values for System UART
        DUT.RF.RF[2] = 8'b00_01000_01;
        DUT.RF.RF[3] = 8;



        //Sending Register Read Command
        //0xBB
        $display("----------Reading from Register 2 (Initial UART Configuration)----------");

        Send_Frame(RF_Read);
        Send_Frame(2); //Address

        $display("TEST CASE 1: Controller has Correct Instruction and Address.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == RF_Read && DUT.Controller.CTRL_Rx.currentAddress == 2)
            $display("TEST CASE 1 PASSED.");
        else
            $display("TEST CASE 1 FAILED.");

        Wait_for_Response();
        
        $display("TEST CASE 2: Received Correct Data.");
        if (P_DATA_Rx_User == 8'b00_01000_01)
            $display("TEST CASE 2 PASSED.");
        else
            $display("TEST CASE 2 FAILED.");



        //Sending Register Write Command
        //0xAA
        //Changing UART Configuration
        $display("\n----------Writing to Register 2 (Changing UART Configuration to Odd Parity)----------");
        Send_Frame(RF_Write);
        Send_Frame(2);
        Send_Frame(8'b00_01000_11);

        $display("TEST CASE 3: Controller has Correct Instruction, Address, and Data.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == RF_Write && DUT.Controller.CTRL_Rx.currentAddress == 2 && DUT.Controller.CTRL_Rx.currentData == 8'b00_01000_11)
            $display("TEST CASE 3 PASSED.");
        else
            $display("TEST CASE 3 FAILED.");
        
        $display("TEST CASE 4: Wrote Data.");
        if (DUT.RF.RF[2] == 8'b00_01000_11)
            $display("TEST CASE 4 PASSED.");
        else
            $display("TEST CASE 4 FAILED.");


        //Changing User's Parity to match System's UART.
        PAR_TYP_User = 1;


        //Sending Register Read Command
        //0xBB
        $display("\n----------Reading from Register 2 (Current UART Configuration)----------");
        Send_Frame(RF_Read);
        Send_Frame(2);

        $display("TEST CASE 5: Controller has Correct Instruction and Address.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == RF_Read && DUT.Controller.CTRL_Rx.currentAddress == 2)
            $display("TEST CASE 5 PASSED.");
        else
            $display("TEST CASE 5 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 6: Received Correct Data.");
        if (P_DATA_Rx_User == 8'b00_01000_11)
            $display("TEST CASE 6 PASSED.");
        else
            $display("TEST CASE 6 FAILED.");




        //Sending ALU with Operands Command
        //0xCC
        $display("\n\n----------ALU Operation with Operands (Addition)----------");
        Send_Frame(ALU_Op);
        Send_Frame(28);
        Send_Frame(14);
        Send_Frame(ADD);

        $display("TEST CASE 7: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_Op && DUT.RF.RF[0] == 28 && DUT.RF.RF[1] == 14 && DUT.Controller.CTRL_Rx.currentFun == ADD)
            $display("TEST CASE 7 PASSED.");
        else
            $display("TEST CASE 7 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 8: Received Correct Result.");
        if (P_DATA_Rx_User == 42)
            $display("TEST CASE 8 PASSED.");
        else
            $display("TEST CASE 8 FAILED.");



        //Sending ALU with no Operands Command
        //0xDD
        $display("\n----------ALU Operation with no Operands (Subtraction)----------");
        Send_Frame(ALU_No_Op);
        Send_Frame(SUB);

        $display("TEST CASE 9: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_No_Op && DUT.RF.RF[0] == 28 && DUT.RF.RF[1] == 14 && DUT.Controller.CTRL_Rx.currentFun == SUB)
            $display("TEST CASE 9 PASSED.");
        else
            $display("TEST CASE 9 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 10: Received Correct Result.");
        if (P_DATA_Rx_User == 14)
            $display("TEST CASE 10 PASSED.");
        else
            $display("TEST CASE 10 FAILED.");



        //Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (Multiplication)----------");
        Send_Frame(ALU_Op);
        Send_Frame(25);
        Send_Frame(10);
        Send_Frame(MUL);

        $display("TEST CASE 11: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_Op && DUT.RF.RF[0] == 25 && DUT.RF.RF[1] == 10 && DUT.Controller.CTRL_Rx.currentFun == MUL)
            $display("TEST CASE 11 PASSED.");
        else
            $display("TEST CASE 11 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 12: Received Correct Result.");
        if (P_DATA_Rx_User == 250)
            $display("TEST CASE 12 PASSED.");
        else
            $display("TEST CASE 12 FAILED.");



        //Sending ALU with no Operands Command
        //0xDD
        $display("\n----------ALU Operation with no Operands (Division)----------");
        Send_Frame(ALU_No_Op);
        Send_Frame(DIV);

        $display("TEST CASE 13: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_No_Op && DUT.RF.RF[0] == 25 && DUT.RF.RF[1] == 10 && DUT.Controller.CTRL_Rx.currentFun == DIV)
            $display("TEST CASE 13 PASSED.");
        else
            $display("TEST CASE 13 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 14: Received Correct Result.");
        if (P_DATA_Rx_User == 2)
            $display("TEST CASE 14 PASSED.");
        else
            $display("TEST CASE 14 FAILED.");

        


        //Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (AND)----------");
        Send_Frame(ALU_Op);
        Send_Frame(8'b1111_0000);
        Send_Frame(8'b0000_1111);
        Send_Frame(AND);

        $display("TEST CASE 15: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_Op && DUT.RF.RF[0] == 8'b1111_0000 && DUT.RF.RF[1] == 8'b0000_1111 && DUT.Controller.CTRL_Rx.currentFun == AND)
            $display("TEST CASE 15 PASSED.");
        else
            $display("TEST CASE 15 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 16: Received Correct Result.");
        if (P_DATA_Rx_User == 0)
            $display("TEST CASE 16 PASSED.");
        else
            $display("TEST CASE 16 FAILED.");



        //Sending ALU with no Operands Command
        //0xDD
        $display("\n----------ALU Operation with no Operands (OR)----------");
        Send_Frame(ALU_No_Op);
        Send_Frame(OR);

        $display("TEST CASE 17: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_No_Op && DUT.RF.RF[0] == 8'b1111_0000 && DUT.RF.RF[1] == 8'b0000_1111 && DUT.Controller.CTRL_Rx.currentFun == OR)
            $display("TEST CASE 17 PASSED.");
        else
            $display("TEST CASE 17 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 18: Received Correct Result.");
        if (P_DATA_Rx_User == 255)
            $display("TEST CASE 18 PASSED.");
        else
            $display("TEST CASE 18 FAILED.");



        //Sending ALU with no Operands Command
        //0xDD
        $display("\n----------ALU Operation with no Operands (NAND)----------");
        Send_Frame(ALU_No_Op);
        Send_Frame(NAND);

        $display("TEST CASE 19: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_No_Op && DUT.RF.RF[0] == 8'b1111_0000 && DUT.RF.RF[1] == 8'b0000_1111 && DUT.Controller.CTRL_Rx.currentFun == NAND)
            $display("TEST CASE 19 PASSED.");
        else
            $display("TEST CASE 19 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 20: Received Correct Result.");
        if (P_DATA_Rx_User == 255)
            $display("TEST CASE 20 PASSED.");
        else
            $display("TEST CASE 20 FAILED.");


        
        //Sending ALU with no Operands Command
        //0xDD
        $display("\n----------ALU Operation with no Operands (NOR)----------");
        Send_Frame(ALU_No_Op);
        Send_Frame(NOR);

        $display("TEST CASE 21: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_No_Op && DUT.RF.RF[0] == 8'b1111_0000 && DUT.RF.RF[1] == 8'b0000_1111 && DUT.Controller.CTRL_Rx.currentFun == NOR)
            $display("TEST CASE 21 PASSED.");
        else
            $display("TEST CASE 21 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 22: Received Correct Result.");
        if (P_DATA_Rx_User == 0)
            $display("TEST CASE 22 PASSED.");
        else
            $display("TEST CASE 22 FAILED.");


        
        

        //Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (XOR)----------");
        Send_Frame(ALU_Op);
        Send_Frame(8'b1111_0000);
        Send_Frame(8'b0011_0011);
        Send_Frame(XOR);

        $display("TEST CASE 23: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_Op && DUT.RF.RF[0] == 8'b1111_0000 && DUT.RF.RF[1] == 8'b0011_0011 && DUT.Controller.CTRL_Rx.currentFun == XOR)
            $display("TEST CASE 23 PASSED.");
        else
            $display("TEST CASE 23 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 24: Received Correct Result.");
        if (P_DATA_Rx_User == 8'b1100_0011)
            $display("TEST CASE 24 PASSED.");
        else
            $display("TEST CASE 24 FAILED.");
            


        //Sending ALU with no Operands Command
        //0xDD
        $display("\n----------ALU Operation with no Operands (XNOR)----------");
        Send_Frame(ALU_No_Op);
        Send_Frame(XNOR);

        $display("TEST CASE 25: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_No_Op && DUT.RF.RF[0] == 8'b1111_0000 && DUT.RF.RF[1] == 8'b0011_0011 && DUT.Controller.CTRL_Rx.currentFun == XNOR)
            $display("TEST CASE 25 PASSED.");
        else
            $display("TEST CASE 25 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 26: Received Correct Result.");
        if (P_DATA_Rx_User == 8'b0011_1100)
            $display("TEST CASE 26 PASSED.");
        else
            $display("TEST CASE 26 FAILED.");


        
        //Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (EQUAL)----------");
        Send_Frame(ALU_Op);
        Send_Frame(27);
        Send_Frame(27);
        Send_Frame(EQU);

        $display("TEST CASE 27: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_Op && DUT.RF.RF[0] == 27 && DUT.RF.RF[1] == 27 && DUT.Controller.CTRL_Rx.currentFun == EQU)
            $display("TEST CASE 27 PASSED.");
        else
            $display("TEST CASE 27 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 28: Received Correct Result.");
        if (P_DATA_Rx_User == 1)
            $display("TEST CASE 28 PASSED.");
        else
            $display("TEST CASE 28 FAILED.");



        
        //Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (GREATER THAN)----------");
        Send_Frame(ALU_Op);
        Send_Frame(27);
        Send_Frame(19);
        Send_Frame(GRT);

        $display("TEST CASE 29: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_Op && DUT.RF.RF[0] == 27 && DUT.RF.RF[1] == 19 && DUT.Controller.CTRL_Rx.currentFun == GRT)
            $display("TEST CASE 29 PASSED.");
        else
            $display("TEST CASE 29 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 30: Received Correct Result.");
        if (P_DATA_Rx_User == 2)
            $display("TEST CASE 30 PASSED.");
        else
            $display("TEST CASE 30 FAILED.");




        //Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (LESS THAN)----------");
        Send_Frame(ALU_Op);
        Send_Frame(19);
        Send_Frame(27);
        Send_Frame(LESS);

        $display("TEST CASE 31: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_Op && DUT.RF.RF[0] == 19 && DUT.RF.RF[1] == 27 && DUT.Controller.CTRL_Rx.currentFun == LESS)
            $display("TEST CASE 31 PASSED.");
        else
            $display("TEST CASE 31 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 32: Received Correct Result.");
        if (P_DATA_Rx_User == 3)
            $display("TEST CASE 32 PASSED.");
        else
            $display("TEST CASE 32 FAILED.");



        //Sending ALU with Operands Command
        //0xCC
        $display("\n----------ALU Operation with Operands (SHIFT RIGHT)----------");
        Send_Frame(ALU_Op);
        Send_Frame(8'b0010_1010);
        Send_Frame(0);
        Send_Frame(SHR);

        $display("TEST CASE 33: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_Op && DUT.RF.RF[0] == 8'b0010_1010 && DUT.RF.RF[1] == 0 && DUT.Controller.CTRL_Rx.currentFun == SHR)
            $display("TEST CASE 33 PASSED.");
        else
            $display("TEST CASE 33 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 34: Received Correct Result.");
        if (P_DATA_Rx_User == 8'b0001_0101)
            $display("TEST CASE 34 PASSED.");
        else
            $display("TEST CASE 34 FAILED.");




        //Sending ALU with no Operands Command
        //0xDD
        $display("\n----------ALU Operation with no Operands (SHIFT LEFT)----------");
        Send_Frame(ALU_No_Op);
        Send_Frame(SHL);

        $display("TEST CASE 35: Controller has Correct Instruction, Operands, and Function.");
        if (DUT.Controller.CTRL_Rx.currentInstruction == ALU_No_Op && DUT.RF.RF[0] == 8'b0010_1010 && DUT.RF.RF[1] == 0 && DUT.Controller.CTRL_Rx.currentFun == SHL)
            $display("TEST CASE 35 PASSED.");
        else
            $display("TEST CASE 35 FAILED.");

        Wait_for_Response();

        $display("TEST CASE 36: Received Correct Result.");
        if (P_DATA_Rx_User == 8'b0101_0100)
            $display("TEST CASE 36 PASSED.");
        else
            $display("TEST CASE 36 FAILED.");



        $stop;
    end


//Clocks Generation
always #H_SYS_PER       REF_CLK_tb  = ~REF_CLK_tb;
always #H_UART_PER      UART_CLK_tb = ~UART_CLK_tb; 
always #H_TX_PER        CLK_Tx_User = ~CLK_Tx_User; 


//Instantiation
SYS_TOP DUT (
    .REF_CLK(REF_CLK_tb),
    .UART_CLK(UART_CLK_tb),
    .RST(RST_tb),
    .RX_IN(RX_IN_tb),
    .TX_OUT(TX_OUT_tb),
    .PAR_ERR(PAR_ERR_tb),
    .STP_ERR(STP_ERR_tb)
);


System_UART_TOP #(.WIDTH(8), .PRESCALE_WIDTH(5)) User (
    .RX_IN_TOP(TX_OUT_tb),
    .Prescale_TOP(Prescale_User),
    .PAR_EN_TOP(PAR_EN_User),
    .PAR_TYP_TOP(PAR_TYP_User),
    .CLK_Rx_TOP(UART_CLK_tb),  
    .RST_TOP(RST_tb),
    .P_DATA_Rx_TOP(P_DATA_Rx_User),
    .Data_Valid_Rx_TOP(Data_Valid_Rx_User),
    .Par_Err_TOP(PAR_ERR_User),
    .Stp_Err_TOP(STP_ERR_User),

    .P_DATA_Tx_TOP(P_DATA_Tx_User),
    .Data_Valid_Tx_TOP(Data_Valid_Tx_User),
    .CLK_Tx_TOP(CLK_Tx_User),
    .TX_OUT_TOP(RX_IN_tb),
    .Busy_TOP(Busy_User)
);

endmodule



