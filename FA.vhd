library ieee;
use ieee.std_logic_1164.all;

entity FA is
    port 
    (
        A  : in  std_logic;
        B  : in  std_logic;
        Ci : in  std_logic;
        S  : out std_logic;
        Co : out std_logic
    );
end entity;

-- this implementation is intended to be a golden for didactical purposes
architecture struct of FA is
    begin
    
        S  <= A xor B xor Ci;
        Co <= (A and B) or (B and Ci) or (A and Ci);
        
end architecture;
