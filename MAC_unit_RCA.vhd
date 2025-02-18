library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ML_types.all;

entity MAC_unit_RCA is
    port (
        A :  in tensor1D (0 to N-1) (7 downto 0);
        B :  in tensor1D (0 to N-1) (7 downto 0);
        C :  in signed(15+WCS downto 0);
        O : out signed(15+WCS downto 0)
    );
end entity;

-- for didactical purposes, only the adder (RCA) is implemented at the gate-level
architecture RTL of MAC_unit_RCA is

    component RCA is
        generic 
        (
            N : integer := 4
        );
        port
        (
            A  : in  std_logic_vector(N-1 downto 0);
            B  : in  std_logic_vector(N-1 downto 0);
            Ci : in  std_logic;
            S  : out std_logic_vector(N-1 downto 0);
            Co : out std_logic
        );
      end component;

    signal mul_part_res : tensor1D (0 to N-1) (15 downto 0);
    signal add_part_res : tensor1D (0 to N) (15+WCS downto 0);

    begin
        process(A, B)
        begin
            for i in 0 to N-1 loop
                mul_part_res(i) <= A(i) * B(i);
            end loop;
        end process;

        add_part_res(0) <= C;

        RCA_gen : for i in 0 to N-1 generate
            RCA_i : RCA generic map (N => 15+WCS+1)
                        port map (A(15+WCS downto 16) => (others => mul_part_res(i)(15)), A(15 downto 0) => std_logic_vector(mul_part_res(i)), B => std_logic_vector(add_part_res(i)), Ci => '0', signed(S) => add_part_res(i+1));
        end generate;

        O <= add_part_res(N);

end architecture;
