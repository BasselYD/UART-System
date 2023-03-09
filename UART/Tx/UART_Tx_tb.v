`timescale 1ns/1ps

module UART_Tx_tb ();

reg         [7:0]        P_DATA_tb;
reg                      DATA_VALID_tb;
reg                      PAR_EN_tb;
reg                      PAR_TYP_tb;
reg                      CLK_tb;
reg                      RST_tb;
wire                     TX_OUT_tb;
wire                     Busy_tb;

localparam IDLE            = 3'b000,
           START           = 3'b001,
           TRANSMIT_DATA   = 3'b010,
           PARITY          = 3'b011,
           STOP            = 3'b100;

initial 
    begin
        $dumpfile("UART_Tx.vcd");
        $dumpvars;

        P_DATA_tb = 0;
        DATA_VALID_tb = 0;
        PAR_EN_tb = 0;
        CLK_tb = 0;
        RST_tb = 1;

        RST_tb = 0;
        #5
        RST_tb = 1;
        #5


        //Test Case 1
        $display("TEST CASE 1: Valid Data got loaded");
        #2
        P_DATA_tb = 8'b0010_1010;
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 0;
        #0.5
        DATA_VALID_tb = 1'b1;
        #1
        if (DUT.Serializer.Shift_Register != 8'b0010_1010)
            $display("TEST CASE 1 FAILED.");
        else
            $display("TEST CASE 1 PASSED."); 


        #1.5
        //Test Case 2
        $display("TEST CASE 2: Start Bit and Busy Flag");
        
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 2 FAILED.");
        else
            $display("TEST CASE 2 PASSED."); 


        //Test Case 3
        $display("TEST CASE 3: Serializer didn't read new data from the bus after DATA_VALID went low.");
        #2.5
        DATA_VALID_tb = 1'b0;
        P_DATA_tb = 8'b1111_1111;
        if (DUT.Serializer.Shift_Register != 8'b0010_1010)
            $display("TEST CASE 3 FAILED.");
        else
            $display("TEST CASE 3 PASSED."); 
         
     

        //Test Case 4
        $display("TEST CASE 4: Bit 0 and Busy Flag");
        
        #2.5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 4 FAILED.");
        else
            $display("TEST CASE 4 PASSED.");  

        //Test Case 5
        $display("TEST CASE 5: Bit 1 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 5 FAILED.");
        else
            $display("TEST CASE 5 PASSED.");  

        //Test Case 6
        $display("TEST CASE 6: Bit 2 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 6 FAILED.");
        else
            $display("TEST CASE 6 PASSED.");  

        //Test Case 7
        $display("TEST CASE 7: Bit 3 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 7 FAILED.");
        else
            $display("TEST CASE 7 PASSED."); 

        //Test Case 8
        $display("TEST CASE 8: Bit 4 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 8 FAILED.");
        else
            $display("TEST CASE 8 PASSED.");  

        //Test Case 9
        $display("TEST CASE 9: Bit 5 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 9 FAILED.");
        else
            $display("TEST CASE 9 PASSED."); 

        //Test Case 10
        $display("TEST CASE 10: Bit 6 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 10 FAILED.");
        else
            $display("TEST CASE 10 PASSED.");  
        
        //Test Case 11
        $display("TEST CASE 11: Bit 7 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 11 FAILED.");
        else
            $display("TEST CASE 11 PASSED.");  

        //Test Case 12
        $display("TEST CASE 12: Even Parity Bit and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 12 FAILED.");
        else
            $display("TEST CASE 12 PASSED.");  

        //Test Case 13
        $display("TEST CASE 13: Stop Bit and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 13 FAILED.");
        else
            $display("TEST CASE 13 PASSED.");  

        //Test Case 14
        $display("TEST CASE 14: Back to IDLE");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 0)
            $display("TEST CASE 14 FAILED.");
        else
            $display("TEST CASE 14 PASSED.");  




        #2
        P_DATA_tb = 8'h59; //0101_1001
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 1;
        #0.5
        DATA_VALID_tb = 1'b1;

        #2.5
        //Test Case 15
        $display("TEST CASE 15: Start Bit and Busy Flag");
        
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 15 FAILED.");
        else
            $display("TEST CASE 15 PASSED."); 

        //Test Case 16
        $display("TEST CASE 16: Bit 0 and Busy Flag");
        
        #2.5
        DATA_VALID_tb = 1'b0;
        #2.5

        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 16 FAILED.");
        else
            $display("TEST CASE 16 PASSED.");  

        //Test Case 17
        $display("TEST CASE 17: Bit 1 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 17 FAILED.");
        else
            $display("TEST CASE 17 PASSED.");  

        //Test Case 18
        $display("TEST CASE 18: Bit 2 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 18 FAILED.");
        else
            $display("TEST CASE 18 PASSED.");  


        P_DATA_tb = 8'b1111_1111;
        #2.5
        DATA_VALID_tb = 1'b1;
        #2.5

        //Test Case 16
        $display("TEST CASE 19: DATA_VALID goes high while transmitting.");
        
        if (DUT.Serializer.Shift_Register != 8'b0000_0101)
            $display("TEST CASE 19 FAILED.");
        else
            $display("TEST CASE 19 PASSED.");  

        
        //Test Case 20
        $display("TEST CASE 20: Bit 3 and Busy Flag");
        
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 20 FAILED.");
        else
            $display("TEST CASE 20 PASSED."); 

        
        #2.5
        DATA_VALID_tb = 1'b0;

        //Test Case 21
        $display("TEST CASE 21: Bit 4 and Busy Flag");
        
        #2.5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 21 FAILED.");
        else
            $display("TEST CASE 21 PASSED.");  

        //Test Case 22
        $display("TEST CASE 22: Bit 5 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 22 FAILED.");
        else
            $display("TEST CASE 22 PASSED."); 

        //Test Case 23
        $display("TEST CASE 23: Bit 6 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 23 FAILED.");
        else
            $display("TEST CASE 23 PASSED.");  
        
        //Test Case 24
        $display("TEST CASE 24: Bit 7 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 24 FAILED.");
        else
            $display("TEST CASE 24 PASSED.");  

        //Test Case 25
        $display("TEST CASE 25: Parity Bit and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 25 FAILED.");
        else
            $display("TEST CASE 25 PASSED.");  

        //Test Case 26
        $display("TEST CASE 26: Stop Bit and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 26 FAILED.");
        else
            $display("TEST CASE 26 PASSED.");

        //Test Case 27
        $display("TEST CASE 27: Back to IDLE");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 0)
            $display("TEST CASE 27 FAILED.");
        else
            $display("TEST CASE 27 PASSED.");  





        #2
        P_DATA_tb = 8'h42; //0100_0010
        PAR_EN_tb = 1'b0;
        #0.5
        DATA_VALID_tb = 1'b1;

        #2.5
        //Test Case 28
        $display("TEST CASE 28: Start Bit and Busy Flag");
        
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 28 FAILED.");
        else
            $display("TEST CASE 28 PASSED."); 

        //Test Case 29
        $display("TEST CASE 29: Bit 0 and Busy Flag");
        
        #2.5
        DATA_VALID_tb = 1'b0;
        #2.5

        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 29 FAILED.");
        else
            $display("TEST CASE 29 PASSED.");  

        //Test Case 30
        $display("TEST CASE 30: Bit 1 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 30 FAILED.");
        else
            $display("TEST CASE 30 PASSED.");  

        //Test Case 31
        $display("TEST CASE 31: Bit 2 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 31 FAILED.");
        else
            $display("TEST CASE 31 PASSED.");  


        //Test Case 32
        $display("TEST CASE 32: Bit 3 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 32 FAILED.");
        else
            $display("TEST CASE 32 PASSED."); 

        //Test Case 33
        $display("TEST CASE 33: Bit 4 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 33 FAILED.");
        else
            $display("TEST CASE 33 PASSED.");  

        //Test Case 34
        $display("TEST CASE 34: Bit 5 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 34 FAILED.");
        else
            $display("TEST CASE 34 PASSED."); 

        //Test Case 35
        $display("TEST CASE 35: Bit 6 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 35 FAILED.");
        else
            $display("TEST CASE 35 PASSED.");  
        
        //Test Case 36
        $display("TEST CASE 36: Bit 7 and Busy Flag");
        
        #5
        if (TX_OUT_tb != 0 || Busy_tb != 1)
            $display("TEST CASE 36 FAILED.");
        else
            $display("TEST CASE 36 PASSED.");  


        //Test Case 37
        $display("TEST CASE 37: Stop Bit and Busy Flag");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 1)
            $display("TEST CASE 37 FAILED.");
        else
            $display("TEST CASE 37 PASSED.");

        //Test Case 38
        $display("TEST CASE 38: Back to IDLE");
        
        #5
        if (TX_OUT_tb != 1 || Busy_tb != 0)
            $display("TEST CASE 38 FAILED.");
        else
            $display("TEST CASE 38 PASSED.");  


        
        #100
        $finish;
    end

always #2.5 CLK_tb = ~CLK_tb;

UART_Tx_TOP DUT (
    .P_DATA_TOP(P_DATA_tb),
    .DATA_VALID_TOP(DATA_VALID_tb),
    .PAR_EN_TOP(PAR_EN_tb),
    .PAR_TYP_TOP(PAR_TYP_tb),
    .CLK_TOP(CLK_tb),
    .RST_TOP(RST_tb),
    .TX_OUT_TOP(TX_OUT_tb),
    .Busy_TOP(Busy_tb)
);

endmodule
