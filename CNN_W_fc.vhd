library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.ML_types.all;

package CNN_W_FC is

    constant FC_bounds  : FC_info  := (OCidx => 10, FCidx => 36);

    constant S_fc : intTensor1D (0 to 9) := (8, 9, 8, 8, 8, 8, 8, 8, 9, 9);  -- scaling factors are in power of two format

    constant Z_fc : signed(15+WCS downto 0) := to_signed(-127, 15+WCS+1);  -- there is no zero point in this NN

    constant W_FC : tensor2D (0 to 9) (0 to 35) (7 downto 0) := ( -- weights
        (
            x"d4", x"dc", x"10", x"ed", x"21", x"f1", x"1f", x"ed", x"c7", x"e9", x"13", x"e0", x"aa", x"f2", x"df", x"ff", x"5a", x"fe", x"47", x"de", x"b9", x"f1", x"02", x"0c", x"19", x"ec", x"1e", x"19", x"09", x"fd", x"0b", x"e5", x"f9", x"ef", x"02", x"e7"
        ),
        (
            x"18", x"f3", x"37", x"e6", x"81", x"e4", x"7f", x"d6", x"56", x"86", x"49", x"43", x"47", x"f0", x"f0", x"af", x"d7", x"e0", x"3f", x"1b", x"d1", x"fc", x"46", x"31", x"81", x"ec", x"02", x"c8", x"f7", x"f1", x"f8", x"12", x"f2", x"12", x"b3", x"e7"
        ),
        (
            x"3c", x"08", x"14", x"0c", x"2e", x"08", x"01", x"00", x"ce", x"fb", x"2e", x"ea", x"ee", x"0d", x"f7", x"e7", x"13", x"e1", x"24", x"f0", x"fb", x"eb", x"fe", x"19", x"25", x"ee", x"26", x"f8", x"fa", x"fb", x"1c", x"e3", x"ec", x"00", x"d1", x"a6"
        ),
        (
            x"5b", x"00", x"09", x"10", x"f7", x"0a", x"e7", x"fa", x"c0", x"ca", x"13", x"fe", x"36", x"ff", x"06", x"ff", x"46", x"00", x"ff", x"fa", x"ca", x"e6", x"22", x"d7", x"1a", x"06", x"07", x"e7", x"d5", x"f5", x"fe", x"ec", x"11", x"cf", x"fd", x"f4"
        ),
        (
            x"81", x"f7", x"08", x"d8", x"94", x"d2", x"5d", x"e6", x"ce", x"23", x"21", x"0e", x"01", x"ea", x"d9", x"f2", x"49", x"de", x"04", x"ee", x"f4", x"df", x"0e", x"09", x"fc", x"f7", x"2c", x"ee", x"fd", x"f9", x"19", x"06", x"10", x"ff", x"fc", x"f1"
        ),
        (
            x"d7", x"e8", x"12", x"fa", x"30", x"f3", x"24", x"fa", x"4f", x"f4", x"df", x"0a", x"30", x"fe", x"fb", x"06", x"4d", x"0e", x"0d", x"f6", x"99", x"21", x"37", x"c9", x"11", x"03", x"17", x"f2", x"e8", x"e9", x"f1", x"e1", x"f7", x"f4", x"fb", x"09"
        ),
        (
            x"9a", x"e3", x"18", x"c1", x"0f", x"e6", x"6e", x"f0", x"54", x"f8", x"fb", x"00", x"ad", x"d4", x"e0", x"03", x"24", x"fc", x"13", x"f7", x"8d", x"09", x"00", x"ea", x"05", x"e9", x"28", x"0b", x"34", x"fb", x"f0", x"f2", x"f1", x"f6", x"13", x"e0"
        ),
        (
            x"28", x"02", x"ec", x"f1", x"16", x"ea", x"f7", x"fc", x"93", x"dd", x"13", x"04", x"21", x"03", x"01", x"d9", x"3d", x"0e", x"3a", x"e2", x"00", x"d4", x"0a", x"03", x"e8", x"e4", x"29", x"e1", x"cf", x"f4", x"26", x"06", x"fe", x"02", x"13", x"00"
        ),
        (
            x"88", x"b7", x"0d", x"e0", x"0b", x"00", x"f6", x"ee", x"d8", x"10", x"ef", x"f3", x"0d", x"f7", x"ee", x"f5", x"56", x"e6", x"fc", x"fc", x"db", x"05", x"3c", x"b3", x"2f", x"da", x"55", x"38", x"42", x"d1", x"d7", x"f1", x"df", x"e1", x"1e", x"05"
        ),
        (
            x"81", x"b8", x"1e", x"ba", x"eb", x"f6", x"d0", x"f3", x"e6", x"ef", x"2b", x"af", x"43", x"ee", x"e3", x"0d", x"7f", x"f1", x"07", x"c2", x"ee", x"bb", x"77", x"da", x"f9", x"07", x"2e", x"a6", x"b0", x"f0", x"4a", x"0d", x"0b", x"f8", x"fb", x"32"
        )
    );

end package;
