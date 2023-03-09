# UART-System

This fully parametrized system recieves commands via UART and sends the result back to the user.

It has a Register File and an ALU with the following operations:
  - Addition
  - Subtraction
  - Multiplication
  - Division
  - AND
  - OR
  - NAND
  - NOR
  - XOR
  - XNOR
  - CMP: A = B
  - CMP: A < B
  - CMP: A > B
  - SHIFT: A >> 1
  - SHIFT: A << 1
  
  It deals with CLock-Domain-Crossing and gates the ALU Clock to save power.
