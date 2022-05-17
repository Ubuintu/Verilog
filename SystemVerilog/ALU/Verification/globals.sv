`ifndef GBL_SV
`define GBL_SV

//Package is used to store methods, data, etc that is to be re-used throughout the testbench;
//They exist in the same level as the top-level module so all data can be reference on a global scope and prevents cluttering 
package globals;
    
    //global flag 
    const int debug = 0;

    //"enum" defines a set of named values
    //"typedef" creates a user-defined datatype from existing datatypes
    typedef enum {
                  ADD,
                  SUB,
                  MUL,
                  DIV,
                  LSL,
                  LSR,
                  ROL,
                  ROR,
                  AND,
                  OR,
                  XOR,
                  NOR,
                  NAND,
                  XNOR,
                  GRThan,
                  EQL
                } OPCODES;  //this is the alias for this typedef enum


    //associative array for debugging; <DataType> <Arr_name> [Datatype of index];
    string operation [OPCODES]= '{ADD:  "Addition",
                                  SUB:  "Subtraction",
                                  MUL:  "Multiplication",
                                  DIV:  "Division",
                                  LSL:  "Logical Shift Left",
                                  LSR:  "Logical Shift Right",
                                  ROL:  "Rotate Left",
                                  ROR:  "Rotate Right",
                                  AND:  "Logical AND",
                                  OR:  "Logical OR",
                                  XOR: "Logical XOR",
                                  NOR: "Logical NOR",
                                  NAND: "Logical NAND",
                                  XNOR: "Logical XNOR",
                                  GRThan: "A > B",
                                  EQL: "A = B"};

    
    //transaction for DUT inputs & outputs
    class transactionIn;
      rand logic [7:0] a_in,b_in;
      rand logic [3:0] op_in;
      //use next() to return the next "Nth" enumeration value; SV implicitly cast all datatype with numbers
      OPCODES op;   //by default is "0th enum"
      logic reset;
      
      function void display(string name);
        $display("\n=================================================================");
        $display("= %s | time: %0d", name, $time);
        $display("= alu_a_in = %0h, alu_b_in = %0h, reset = %0d, alu_opcode_in = %s", a_in, b_in, reset, operation[op.next(op_in)]);
        $display("=================================================================\n");
      endfunction
      
    endclass

    class transactionOut;
      logic [7:0] y;
      logic carry_out;
      
      function void display(string name);
        $display("\n=================================================================");
        $display("= %s | time: %0d", name, $time);
        $display("= alu_y_out = %0h, alu_co_out = %0d", y, carry_out);
        $display("=================================================================\n");
      endfunction
      
    endclass
//-------------------------------------------------
//Extension of transaction class for testcases
//-------------------------------------------------
// All these transactions inherit transIn's properties & methods

    class transactionAdd extends transactionIn;
      //constraint <constraint_name> { <expression 1 of N>; };
      constraint c_opcode {
        op_in[3:0] inside {0};
      }
    endclass

    class transactionMult extends transactionIn;
      constraint c_opcode {
        op_in[3:0] inside {2};
      }
    endclass

    class transactionDiv extends transactionIn;
      constraint c_opcode {
        op_in[3:0] inside {3};
      }
      constraint c_b {
        b_in[7:0] > 0;
      }
    endclass

    class transTestDiv extends transactionIn;
      constraint c_opcode {
        op_in[3:0] inside {3};
      }
      constraint c_a {
        a_in[7:0] inside {255};
      }
      constraint c_b {
        b_in[7:0] inside {1};
      }
    endclass

endpackage

`endif
