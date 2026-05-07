library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Cache is
    Port ( 
            --INPUTS
            CLK     : in STD_LOGIC;
            CLK_EN  : in STD_LOGIC;
            
            w_en    : in STD_LOGIC;
            w_data  : in STD_LOGIC_VECTOR (31 downto 0);
           
            JUMP_F  : in STD_LOGIC;
            PC_RST  : in STD_LOGIC;
            PC_SET  : in UNSIGNED(31 downto 0);
            
            --OUTPUTS
            PC      : out UNSIGNED(31 downto 0);
            r_data  : out STD_LOGIC_VECTOR (31 downto 0)
        );
           
end Instruction_Cache;

architecture Behavioral of Instruction_Cache is

    --Declare memory  
    --INSTRUCTION MEMORY IS 36863*8bits --> 36,864 kBytes 
    type mem_type is array (0 to 9215) of std_logic_vector(31 downto 0);
    signal mem : mem_type := (
        -- 00000000 <delay>:
        0 => x"00A00793",
        4 => x"00000013",
        8 => x"00000013",
        12 => x"00000013",
        16 => x"FFF78793",
        20 => x"FE0798E3",
        24 => x"00008067",
        -- 
        -- 0000001c <main>:
        28 => x"10000637",
        32 => x"100006B7",
        36 => x"10000537",
        40 => x"FFF00593",
        44 => x"00460613",
        48 => x"00168693",
        52 => x"00B50023",
        56 => x"00064703",
        60 => x"00A00793",
        64 => x"0FF77713",
        68 => x"00E68023",
        72 => x"00000013",
        76 => x"00000013",
        80 => x"00000013",
        84 => x"FFF78793",
        88 => x"FE0798E3",
        92 => x"FD9FF06F",
        -- 
        -- Disassembly of section .init:
        -- 
        -- 00000060 <_start>:
        96 => x"00000013",
        100 => x"00001197",
        104 => x"84418193",
        108 => x"FFF00113",
        112 => x"00010433",
        116 => x"FA9FF0EF",
        120 => x"00000073",

    -- 114 => x"00A00713", -- addi -- rd(01110)(14)(0x0E) = rs1(0) + imm(000000001010)(10)(0x00A)
    -- 115 => x"002007B7", -- lui  -- rd(01111)(15)(0x0F) = imm()(0x2000)()
    -- 116 => x"07F78793", -- addi -- rd(01111)(15)(0x0F) = rs1(01111)(15)(0x0F) + imm(01111111)(0x07F)
    -- 117 => x"00000013", -- addi -- rd(00000)(00)(0x00) = rs1(0) + imm(0) 
    -- 118 => x"FFF78793", -- addi -- rd(01111)(15)(0x0F) = rs1(01111)(15)(0x0F) + imm(111111111111)(-1)(0xFFF)
    -- 119 => "00001110000001111001010101100011", -- bne  -- if(rs1(01111)(15)(0x0F) != rs2(0)) PC += imm(111010100)(468)(0x1D4)
    -- 120 => "10000000000000000000111000010011", -- addi -- rd(11100)(28)(0x1C) = rs1(0) + imm(100000000000)()(0x800)
    -- 121 => x"00E01123", --"0000000-01110-00000-001-00010-0100011", -- sh -- M[rs1(0)+imm(0)][0:15] = rs2(01110)(14)(0x0E)[0:15]
    -- 122 => x"FFF70713", -- addi -- rd(01110)(14)(0x0E) = rs1(01110)(14)(0x0E) + imm(111111111111)(-1)(0xFFF)
    -- 123 => x"FE0712E3", -- bne  -- if(rs1(01110)(9)(0x09) != rs2(0)) PC += imm(111111110100)(0xFF4)
    -- 124 => x"00008067", -- jalr -- rd(0) = PC+4; PC = rs1(1) + imm(0)
    -- -- delay_sec (0x1F0)
    -- 125 => x"000027B7", -- lui  -- rd(01111)(15)(0x0F) = imm()()()
    -- 126 => x"07F78793", -- addi -- rd(01111)(15)(0x0F) = rs1(01111)(15)(0x0F) + imm(01111111)(0x07F)
    -- 127 => x"00000013", -- addi -- rd(00000)(00)(0x00) = rs1(0) + imm(0) 
    -- 128 => x"FFF78793", -- addi -- rd(01111)(15)(0x0F) = rs1(01111)(15)(0x0F) + imm(111111111111)(-1)(0xFFF)
    -- 129 => x"FE0796E3", -- bne  -- if(rs1(01111)(15)(0x0F) != rs2(0)) PC += imm(111111110110)(0xFF6)
    -- 130 => x"00008067", -- jalr -- rd(0) = PC+4; PC = rs1(1) + imm(0)

    others => (others => '0')
    );
        
    --Memory should be implemented as block RAM
    attribute ram_style : string;
    attribute ram_style of mem : signal is "block";

    SIGNAL PC_internal : UNSIGNED(29 downto 0)  := (others => '0');
    SIGNAL PC_internal_next : UNSIGNED(29 downto 0) := (others => '0');
    
begin

    process(CLK)
        variable index : integer;
    begin
        if rising_edge(CLK) then
            index := to_integer(unsigned(PC_internal_next));

            IF PC_RST = '0' THEN
                PC_internal <= TO_UNSIGNED(0, 30);
            ELSIF CLK_EN = '1' THEN
                PC_internal <= PC_internal_next;
                PC <= PC_internal_next & "00";
                r_data <= mem(index);
            END IF;

            -- write
            if w_en = '1' and CLK_EN = '1' then
                mem(index) <= w_data;
            end if;

            -- read
        end if;
    end process;

    PROCESS (PC_internal, PC_SET, JUMP_F)
    BEGIN
        PC_internal_next <= PC_internal + 1;
        IF JUMP_F = '1' THEN
            PC_internal_next <= PC_SET(31 downto 2); 
        END IF;
    END PROCESS;
    
end Behavioral;
