library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ML_types.all;

entity MAC_unit_rescale is
    port (
        A :  in tensor1D (0 to N-1) (7 downto 0);
        B :  in tensor1D (0 to N-1) (7 downto 0); 
        C :  in signed(15+WCS downto 0);
        R :  in std_logic;
        S :  in integer range 0 to 15;
        Z :  in signed(15+WCS downto 0);
        O : out signed(15+WCS downto 0)
    );
end entity;

-- wrapper of the MAC_unit, implementing the rescaling of the accumulated value
architecture RTL of MAC_unit_rescale is

    component MAC_unit is -- comment this to include the MAC_unit_RCA custom implementation
        port (
            A :  in tensor1D (0 to N-1) (7 downto 0);
            B :  in tensor1D (0 to N-1) (7 downto 0);
            C :  in signed(15+WCS downto 0);
            O : out signed(15+WCS downto 0)
        );
    end component;

    -- component MAC_unit_RCA is -- uncomment this to include the MAC_unit_RCA custom implementation
    --     port (
    --         A :  in tensor1D (0 to N-1) (7 downto 0);
    --         B :  in tensor1D (0 to N-1) (7 downto 0);
    --         C :  in signed(15+WCS downto 0);
    --         O : out signed(15+WCS downto 0)
    --     );
    -- end component;

    signal int_O : signed(15+WCS downto 0);

  begin

    MAC_u_i : MAC_unit port map (A => A, B => B, C => C, O => int_O);  -- comment this to include the MAC_unit_RCA custom implementation
--    MAC_u_i : MAC_unit_RCA port map (A => A, B => B, C => C, O => int_O);  -- uncomment this to include the MAC_unit_RCA custom implementation

    process(int_O, R, S)
    variable rounded : signed(15+WCS downto 0);
    begin
        -- rescaling is done assuming 8 bit for output features
        if R = '1' then
            rounded := shift_right(int_O, S);
            if rounded < Z then -- halving of the dynamic with ReLU is done for didactical purposes
                rounded := Z;
            elsif rounded > to_signed(+127, 15+WCS+1) then
                rounded := to_signed(+127, 15+WCS+1);
            end if;
            O <= rounded;
        else
            O <= int_O;
        end if;
    end process;

end architecture;
