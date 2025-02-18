library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ML_types.all;

entity MAC_unit is -- vector MAC_unit, it accepts N inputs of 8 bits each. both N and WCS are defined in ML_types.vhd
    port (
        A :  in tensor1D (0 to N-1) (7 downto 0);
        B :  in tensor1D (0 to N-1) (7 downto 0); 
        C :  in signed(15+WCS downto 0);
        O : out signed(15+WCS downto 0)
    );
end entity;

-- this implementation is intended to be a golden for didactical purposes
architecture RTL of MAC_unit is
    begin
        process(A, B, C)
        variable part_sum : signed(15+WCS downto 0);
        begin
            part_sum := signed(C);
            for i in 0 to N-1 loop
                part_sum := part_sum + (A(i) * B(i));
            end loop;
            O <= part_sum;
        end process;

end architecture;
