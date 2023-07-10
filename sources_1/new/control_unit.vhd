library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port ( 
        Op, Func : in std_logic_vector(5 downto 0);
        ALUOp : out std_logic_vector(3 downto 0);
        SHAMTSrc, PCSource, MemDSrc, RegDst : out std_logic_vector(1 downto 0);
        MemtoReg, ALUSrcB : out std_logic_vector(2 downto 0);
        clk, rst, Overflow, Zero, MSB, Done : in std_logic;
        PCWriteCond, PCWrite, IorD, MultRegs, rst_out: out std_logic;
        ALUSrcA, ALUOut, A, B, MemD : out std_logic;
        MemWrite, RegWrite, IRWrite : out std_logic);
    end control_unit;

architecture Structural of control_unit is

    type state is (S0, S1, S2, S3, S4);
    signal pr_state, nx_state: state;

begin
  
-- fsm process
    process(clk, rst) begin
        if rst = '1' then
            pr_state <= S0;
        elsif (clk'event and clk = '1') then
            pr_state <= nx_state;
        end if;
    end process;

-- other process
process(pr_state, Func, Op, Overflow, Zero, Done) begin
case pr_state is
-- FETCH INSTRUCTIONS
    when S0 =>
        -- init PC
        ALUOp <= "0101";
        ALUOut <= '1';
        ALUSrcA <= '0';
        ALUSrcB <= "001";
        
        IRWrite <= '1'; -- get instr
        IorD <= '0'; -- no jump
        
        -- Unused
        MultRegs <= '0';
        rst_out <= '0';
        PCWriteCond <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        A <= '0';
        B <= '0';
        
        nx_state <= S1;
        
    when S1 =>
        -- DECODE INSTRUCTIONS
        -- SPECIAL OR CLO
        if (Op = "000000" or (Op = "011100" and Func = "100001")) then
            A <= '1';
            B <= '1';    
            
        -- ADDI OR ORI OR ?? OR SLTI OR ADDU, LW, LUI
        elsif (Op = "001000" or Op = "001101" or Op = "100000" or Op = "001010" or Op = "100001" or Op = "100011" or Op = "001111") then
            A <= '1';
            B <= '0';
            
        -- BNE
        elsif (Op = "000101" or Op = "000001") then
            A <= '1';
            B <= '1';
            ALUSrcA <= '0'; -- GET PC ADDR
            ALUSrcB <= "011"; -- OFFSET 2 BITS
            ALUOp <= "0100"; -- ADD for calculating offset
            ALUOut <= '1'; -- PRIME OUT
        
        -- SW
        elsif (Op = "101011") then
            A <= '1';
            B <= '1';
            
        -- Jump
        elsif (Op = "000010") then
            A <= '0';
            B <= '0';
            PCWrite <= '1';
        end if;
        
        -- FINISH JUMP
        if (Op = "000010") then
            PCSource <= "10"; -- SL2
            nx_state <= S0;
        else
            PCSource <= "01"; -- ALUOut
            nx_state <= S2;
        end if;
        
        -- Unused
        IRWrite <= '0';
        PCWriteCond <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        PCWrite <= '1'; 
        
    when S2 =>
    -- EXECUTE 
        -- R-type instructions
        if (Op = "000000") then
            ALUSrcA <= '1';
            ALUSrcB <= "000";
            ALUOut <= '1';
            
            if (Func = "100001") then  -- ADDU
                ALUOp <= "0101";  
            
            elsif (Func = "100100") then  -- AND
                ALUOp <= "0000";
            
            elsif (Func = "000000") then -- SLL
                ALUOp <= "1100";
                SHAMTSrc <= "01";
                    
            elsif (Func = "000100") then -- SLLV
                ALUOp <= "1100";
                SHAMTSrc <= "00";
            
            elsif (Func = "000011") then -- SRA
                ALUOp <= "1111";
                SHAMTSrc <= "01";
            
            elsif (Func = "100010") then -- SUB
                ALUOp <= "0110";
            
            elsif (Func = "001000") then -- JR
                PCSource <= "11";
            
            elsif (Func = "011001") then -- MULTU
                rst_out <= '1';
            end if;
        
        -- I-type and Loads
        -- ADDI OR ORI OR ?? OR SLTI OR ADDU, LW, LUI
        elsif (Op = "001000" or Op = "001101" or Op = "100000" or Op = "001010" or Op = "100001" or Op = "100011" or Op = "001111") then
            
            if (Op = "001101") then -- ORI
                ALUSrcB <= "100"; -- SE,SL
            else
                ALUSrcB <= "010"; -- SE, ONLY
            end if;
            
            ALUSrcA <= '1';
            ALUOut <= '1';
            
            
            if (Op = "001000" or Op = "100000" or Op = "100001" or Op = "100011") then
                ALUOp <= "0100";  -- ADDI
            elsif (Op = "001101") then
                ALUOP <= "0001"; -- ORI
            elsif (Op = "001010") then -- SLTI
                ALUOp <= "0110"; -- SUB
            elsif (Op = "001111") then -- SL 16
                ALUOp <= "1100";
                SHAMTSrc <= "10";
            end if;
        
        -- BNE instruction
        elsif (Op = "000101") then
            ALUSrcA <= '1';
            ALUSrcB <= "000";
            ALUOp <= "0110"; -- SIGNED SUB ON 0 BIT
            ALUOut <= '0';
        
        -- BLTZAL instruction
        elsif (Op = "000001") then
            if (MSB = '1') then
                RegWrite <= '1';
                RegDst <= "10";
                MemtoReg <= "110";
            end if;
        
        -- SW instruction 
        elsif (Op = "101011") then
            ALUSrcA <= '1';
            ALUSrcB <= "010";
            ALUOp <= "0100";
            ALUOut <= '1';
            PCWriteCond <= '1';
        
        -- CLO instruction
        elsif (Op = "011100") then
            RegDst <= "01";
            RegWrite <= '1';
            MemtoReg <= "101";
        end if;
        
        if ((Op = "000000" and Func = "001000") or (Op = "011100" and Func = "100001") or (Op = "000001" and MSB = '0') or Op = "000010") then -- JR and CLO done
            nx_state <= S0;
        else 
            nx_state <= S3;
        end if;
        -- Unused
        
        if (Op = "000000" and Func = "001000") then
            PCWrite <= '1';
        else
            PCWrite <= '0';
        end if;
        
        IRWrite <= '0';
        A <= '0';
        B <= '0';
    
    
    when S3 =>
    -- WRITE BACK
    -- R AND I TYPE DONE
        if (Op = "000000" or Op = "001000" or Op = "001101" or Op = "001010" or Op = "001111") then
            if ((Func = "100010" and Op = "000000") or Op = "001000") then -- check overflow for ADDI and SUB
                if (Overflow = '1') then
                RegWrite <= '0';
                else
                RegWrite <= '1';
                MemtoReg <= "000";
                end if;
                
            elsif (Op = "001010") then
                RegWrite <= '1';
                MemtoReg <= "100";
            elsif (Func = "011001") then -- Multu
                rst_out <= '0'; 
            elsif (Func = "010000") then -- MFHI
                RegWrite <= '1';
                MemtoReg <= "010";
            elsif (Func = "010010") then -- MFLO
                RegWrite <= '1';
                MemtoReg <= "011";
            else
                RegWrite <= '1';
                MemtoReg <= "000";
            end if;
            
            if (Op = "000000") then
                RegDst <= "01";  -- R-tyoe
            else 
                RegDst <= "00";  -- I-type
            end if;
            
            elsif (Op = "000101") then -- BNE
                if (Zero = '0') then
                    PCSource <= "01";
                    PCWrite <= '1';
                end if;
            
            elsif (Op = "000001") then -- BLTZAL
                PCSource <= "01";
                PCWrite <= '1';
                
            elsif (Op = "101011") then -- Store Word
                IorD <= '1';
                MemWrite <= '1';
            
            elsif (Op = "100000" or Op = "100001" or Op = "100011") then -- Load
                IorD <= '1';
                MemD <= '1';
            if (Op = "100000") then
                MemDSrc <= "00";
            elsif (Op = "100001") then
            MemDSrc <= "01";
            elsif (Op = "100011") then
            MemDSrc <= "10";
            end if;
            end if;
            
            if (Op = "100000" or Op = "100001" or Op = "100011" or (Op = "000000" and Func = "011001" and Done = '1')) then -- checking for load case
            nx_state <= S4;
            elsif (Op = "000000" and Func = "011001") then
            nx_state <= S3;
            else
            nx_state <= S0;
        end if;
        
    -- Load WB
    when S4 =>
    
    if (Op = "000000") then
    MultRegs <= '1';
    else
    MemtoReg <= "001";
    RegWrite <= '1';
    RegDst <= "00";
    end if;
    
    nx_state <= S0;
    

end case;
end process;

end Structural;
