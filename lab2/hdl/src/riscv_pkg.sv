package riscv_pkg;
    // ALU Operations
    typedef enum logic [2:0] {
        ALU_ADD  = 3'b000,
        ALU_SUB  = 3'b001,
        ALU_AND  = 3'b010,
        ALU_OR   = 3'b011,
        ALU_SLT  = 3'b101
    } alu_op_t;

    // Immediate Format Types
    typedef enum logic [1:0] {
        IMM_I = 2'b00,  // I-type
        IMM_S = 2'b01,  // S-type (stores)
        IMM_B = 2'b10,  // B-type (branches)
        IMM_J = 2'b11   // J-type (jal)
    } imm_type_t;

    // Result Source Types
    typedef enum logic [1:0] {
        RES_ALU  = 2'b00,  // ALU Result
        RES_MEM  = 2'b01,  // Memory Read Data
        RES_PC4  = 2'b10   // PC + 4
    } result_src_t;

endpackage
