`timescale 1ns/1ps

module UART_Rx_tb ();

//Rx Signals
wire                     RX_IN_tb;
reg         [7:0]        Prescale_tb;
reg                      PAR_EN_tb;
reg                      PAR_TYP_tb;
reg                      CLK_Rx_tb;  
reg                      RST_tb;
wire        [7:0]        P_DATA_Rx_tb;
wire                     Data_Valid_Rx_tb;

//Tx Signals
reg         [7:0]        P_DATA_Tx_tb;
reg                      DATA_VALID_Tx_tb;
reg                      CLK_Tx_tb;
wire                     TX_OUT_tb;
wire                     Busy_tb;

localparam IDLE             =   3'b000,
           START            =   3'b001,
           RECEIVE_DATA     =   3'b010,
           PARITY           =   3'b011,
           STOP             =   3'b100,
           CHECK            =   3'b101;


reg     Manual_Input;
reg     Manual_Mode;

//Using my Tx to send the data frames and using Manual Mode to introduce errors.
assign RX_IN_tb = Manual_Mode ? Manual_Input : TX_OUT_tb;

initial 
    begin
        $dumpfile("UART_Rx.vcd");
        $dumpvars;


        P_DATA_Tx_tb = 0;
        DATA_VALID_Tx_tb = 0;
        PAR_EN_tb = 0;
        CLK_Rx_tb = 0;
        CLK_Tx_tb = 0;
        RST_tb = 1;
        Prescale_tb = 8;
        Manual_Mode = 0;

        RST_tb = 0;
        #40
        RST_tb = 1;
        #40


        $display("-----RECEIVING FRAME WITH EVEN PARITY AND NO ERRORS-----");

        #15
        P_DATA_Tx_tb = 8'b0010_1010;
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 0;
        #5  //Tx Rising
        DATA_VALID_Tx_tb = 1'b1;


        #20 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting.
        #10 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 1: Received Start Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != START)
            $display("TEST CASE 1 FAILED.");
        else
            $display("TEST CASE 1 PASSED."); 

        #10 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #30 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 2: Received Bit 0.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 2 FAILED.");
        else
            $display("TEST CASE 2 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 3: Received Bit 1.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 3 FAILED.");
        else
            $display("TEST CASE 3 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 4: Received Bit 2.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 4 FAILED.");
        else
            $display("TEST CASE 4 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 5: Received Bit 3.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 5 FAILED.");
        else
            $display("TEST CASE 5 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 6: Received Bit 4.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 6 FAILED.");
        else
            $display("TEST CASE 6 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 7: Received Bit 5.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 7 FAILED.");
        else
            $display("TEST CASE 7 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 8: Received Bit 6.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 8 FAILED.");
        else
            $display("TEST CASE 8 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 9: Received Bit 7.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 9 FAILED.");
        else
            $display("TEST CASE 9 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 10: Received Correct Parity Bit. (Even)");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != PARITY)
            $display("TEST CASE 10 FAILED.");
        else
            $display("TEST CASE 10 PASSED.");

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 11: Received Stop Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != STOP)
            $display("TEST CASE 11 FAILED.");
        else
            $display("TEST CASE 11 PASSED.");

        #5
        $display("TEST CASE 12: Output Received Frame and Data Valid Signal.");
        
        if (P_DATA_Rx_tb != 8'b0010_1010 || Data_Valid_Rx_tb != 1)
            $display("TEST CASE 12 FAILED.");
        else
            $display("TEST CASE 12 PASSED.");
        #15




        $display("\n\n-----RECEIVING FRAME WITH ODD PARITY AND NO ERRORS-----");


        #20
        P_DATA_Tx_tb = 8'b1101_0110;
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 1;
        #10  //Tx Rising
        DATA_VALID_Tx_tb = 1'b1;

        #20 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting
        #10 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 13: Received Start Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != START)
            $display("TEST CASE 13 FAILED.");
        else
            $display("TEST CASE 13 PASSED."); 

        #10 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #30 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 14: Received Bit 0.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 14 FAILED.");
        else
            $display("TEST CASE 14 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 15: Received Bit 1.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 15 FAILED.");
        else
            $display("TEST CASE 15 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 16: Received Bit 2.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 16 FAILED.");
        else
            $display("TEST CASE 16 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 17: Received Bit 3.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 17 FAILED.");
        else
            $display("TEST CASE 17 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 18: Received Bit 4.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 18 FAILED.");
        else
            $display("TEST CASE 18 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 19: Received Bit 5.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 19 FAILED.");
        else
            $display("TEST CASE 19 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 20: Received Bit 6.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 20 FAILED.");
        else
            $display("TEST CASE 20 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 21: Received Bit 7.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 21 FAILED.");
        else
            $display("TEST CASE 21 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 22: Received Correct Parity Bit (Odd).");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != PARITY)
            $display("TEST CASE 22 FAILED.");
        else
            $display("TEST CASE 22 PASSED.");

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 23: Received Stop Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != STOP)
            $display("TEST CASE 23 FAILED.");
        else
            $display("TEST CASE 23 PASSED.");

        #5
        $display("TEST CASE 24: Output Received Frame and Data Valid Signal.");
        
        if (P_DATA_Rx_tb != 8'b1101_0110 || Data_Valid_Rx_tb != 1)
            $display("TEST CASE 24 FAILED.");
        else
            $display("TEST CASE 24 PASSED.");
        #15


        
        $display("\n\n-----RECEIVING FRAME WITH NO PARITY BIT AND NO ERRORS-----");


        #20
        P_DATA_Tx_tb = 8'b1010_1010;
        PAR_EN_tb = 1'b0;
        #10  //Tx Rising
        DATA_VALID_Tx_tb = 1'b1;

        #20 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting
        #10 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 25: Received Start Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != START)
            $display("TEST CASE 25 FAILED.");
        else
            $display("TEST CASE 25 PASSED."); 

        #10 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #30 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 26: Received Bit 0.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 26 FAILED.");
        else
            $display("TEST CASE 26 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 27: Received Bit 1.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 27 FAILED.");
        else
            $display("TEST CASE 27 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 28: Received Bit 2.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 28 FAILED.");
        else
            $display("TEST CASE 28 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 29: Received Bit 3.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 29 FAILED.");
        else
            $display("TEST CASE 29 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 30: Received Bit 4.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 30 FAILED.");
        else
            $display("TEST CASE 30 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 31: Received Bit 5.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 31 FAILED.");
        else
            $display("TEST CASE 31 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 32: Received Bit 6.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 32 FAILED.");
        else
            $display("TEST CASE 32 PASSED."); 

        #40 //8 Rx Clock Cycles
        $display("TEST CASE 33: Received Bit 7.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 33 FAILED.");
        else
            $display("TEST CASE 33 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 34: Received Stop Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != STOP)
            $display("TEST CASE 34 FAILED.");
        else
            $display("TEST CASE 34 PASSED.");

        #5
        $display("TEST CASE 35: Output Received Frame and Data Valid Signal.");
        
        if (P_DATA_Rx_tb != 8'b1010_1010 || Data_Valid_Rx_tb != 1)
            $display("TEST CASE 35 FAILED.");
        else
            $display("TEST CASE 35 PASSED.");



        $display("\n\n-----RECEIVING BACK-TO-BACK FRAME WITH PARITY ERROR-----");

        P_DATA_Tx_tb = 8'b0001_0101;
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 1'b0;
        
        //Tx's Data Valid goes high right before previous frame ends to immediately send a new frame.
        DATA_VALID_Tx_tb = 1'b1;
        #5  //Tx Rising 

        #20 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting
        #10 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 36: Received Start Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != START)
            $display("TEST CASE 36 FAILED.");
        else
            $display("TEST CASE 36 PASSED."); 

        #10 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #30 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 37: Received Bit 0.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 37 FAILED.");
        else
            $display("TEST CASE 37 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 38: Received Bit 1.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 38 FAILED.");
        else
            $display("TEST CASE 38 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 39: Received Bit 2.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 39 FAILED.");
        else
            $display("TEST CASE 39 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 40: Received Bit 3.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 40 FAILED.");
        else
            $display("TEST CASE 40 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 41: Received Bit 4.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 41 FAILED.");
        else
            $display("TEST CASE 41 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 42: Received Bit 5.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 42 FAILED.");
        else
            $display("TEST CASE 42 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 43: Received Bit 6.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 43 FAILED.");
        else
            $display("TEST CASE 43 PASSED."); 


        #40 //8 Rx Clock Cycles
        $display("TEST CASE 44: Received Bit 7.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 44 FAILED.");
        else
            $display("TEST CASE 44 PASSED."); 


        //Using Manual Mode to send incorrect parity bit.
        Manual_Mode = 1;
        #10
        Manual_Input = 0;
        #30 //8 Rx Clock Cycles, Now on falling edge
        #5
        $display("TEST CASE 45: Checking Par_Err Bit");
        
        if (DUT.ParityCheck.Par_Err != 1)
            $display("TEST CASE 45 FAILED.");
        else
            $display("TEST CASE 45 PASSED.");
        

        #5
        Manual_Input = 1;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 46: Received Stop Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != STOP)
            $display("TEST CASE 46 FAILED.");
        else
            $display("TEST CASE 46 PASSED.");

        #5
        $display("TEST CASE 47: Data Valid is Low After Checking Errors.");
        
        if (Data_Valid_Rx_tb != 0)
            $display("TEST CASE 47 FAILED.");
        else
            $display("TEST CASE 47 PASSED.");
        #15




        $display("\n\n-----RECEIVING FRAME WITH STOP ERROR-----");

        //Using Manual Mode to send incorrect stop bit.
        #20
        Manual_Mode = 1;
        #10  //Tx Rising 
        DATA_VALID_Tx_tb = 1'b1;
        Manual_Input = 0;

        #20 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting
        #10 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 48: Received Start Bit.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != START)
            $display("TEST CASE 48 FAILED.");
        else
            $display("TEST CASE 48 PASSED."); 

        #10 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        Manual_Input = 1;
        
        #30 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 49: Received Bit 0.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 49 FAILED.");
        else
            $display("TEST CASE 49 PASSED."); 

        #10
        Manual_Input = 1;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 50: Received Bit 1.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 50 FAILED.");
        else
            $display("TEST CASE 50 PASSED."); 

        #10
        Manual_Input = 0;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 51: Received Bit 2.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 51 FAILED.");
        else
            $display("TEST CASE 51 PASSED."); 

        #10
        Manual_Input = 0;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 52: Received Bit 3.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 52 FAILED.");
        else
            $display("TEST CASE 52 PASSED."); 

        #10
        Manual_Input = 1;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 53: Received Bit 4.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 53 FAILED.");
        else
            $display("TEST CASE 53 PASSED."); 

        #10
        Manual_Input = 1;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 54: Received Bit 5.");
        
        if (DUT.Sampler.Sampled_Bit != 1 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 54 FAILED.");
        else
            $display("TEST CASE 54 PASSED."); 

        #10
        Manual_Input = 0;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 55: Received Bit 6.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 55 FAILED.");
        else
            $display("TEST CASE 55 PASSED."); 

        #10
        Manual_Input = 0;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 56: Received Bit 7.");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 56 FAILED.");
        else
            $display("TEST CASE 56 PASSED."); 


        #10
        Manual_Input = 0;
        #30 //8 Rx Clock Cycles, Now on falling edge
        $display("TEST CASE 57: Received Correct Parity Bit (Even).");
        
        if (DUT.Sampler.Sampled_Bit != 0 || DUT.FSM.current_state != PARITY)
            $display("TEST CASE 57 FAILED.");
        else
            $display("TEST CASE 57 PASSED.");
        

        #10
        Manual_Input = 0;
        #30 //8 Rx Clock Cycles
        $display("TEST CASE 58: Checking Stp_Err Bit.");
        #5
        if (DUT.StopCheck.Stp_Err != 1)
            $display("TEST CASE 58 FAILED.");
        else
            $display("TEST CASE 58 PASSED.");


        $display("TEST CASE 59: Data Valid is Low after checking errors.");
        
        if (Data_Valid_Rx_tb != 0)
            $display("TEST CASE 59 FAILED.");
        else
            $display("TEST CASE 59 PASSED.");
        Manual_Input = 1;
        
        
        

        $display("\n\n-----Testing Start Glitch-----");

        //Using Manual Mode to introduce start glitch.
        #20 
        Manual_Input = 0;
        #5
        Manual_Input = 1;
        #50
        $display("TEST CASE 60: Checking Strt_Glitch and IDLE State.");
        if (DUT.StartCheck.Strt_Glitch != 1 || DUT.FSM.current_state != IDLE)
            $display("TEST CASE 60 FAILED.");
        else
            $display("TEST CASE 60 PASSED.");


    
    
        #300
        $finish;
    end



always #2.5 CLK_Rx_tb = ~CLK_Rx_tb;
always #20 CLK_Tx_tb = ~CLK_Tx_tb;

UART_Rx_TOP DUT (
    .RX_IN_TOP(RX_IN_tb),
    .Prescale_TOP(Prescale_tb),
    .PAR_EN_TOP(PAR_EN_tb),
    .PAR_TYP_TOP(PAR_TYP_tb),
    .CLK_TOP(CLK_Rx_tb),  
    .RST_TOP(RST_tb),
    .P_DATA_TOP(P_DATA_Rx_tb),
    .Data_Valid_TOP(Data_Valid_Rx_tb)
);


UART_Tx_TOP Tx (
    .P_DATA_TOP(P_DATA_Tx_tb),
    .DATA_VALID_TOP(DATA_VALID_Tx_tb),
    .PAR_EN_TOP(PAR_EN_tb),
    .PAR_TYP_TOP(PAR_TYP_tb),
    .CLK_TOP(CLK_Tx_tb),
    .RST_TOP(RST_tb),
    .TX_OUT_TOP(TX_OUT_tb),
    .Busy_TOP(Busy_tb)
);


endmodule
