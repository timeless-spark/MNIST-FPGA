library ieee;
use ieee.std_logic_1164.all;

entity RCA is
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
  end entity;

-- this implementation is intended to be a golden for didactical purposes
architecture struct of RCA is 

    component FA is
        port 
        (
            A  : in  std_logic;
            B  : in  std_logic;
            Ci : in  std_logic;
            S  : out std_logic;
            Co : out std_logic
        );
    end component;

    signal int_carry: std_logic_vector(N downto 0);

    begin
        int_carry(0) <= Ci;

        ADDER: for i in 0 to N-1 generate
            FAi: FA
            port map (A(i), B(i), int_carry(i), S(i), int_carry(i+1));
        end generate;

        Co <= int_carry(N);
end architecture;
