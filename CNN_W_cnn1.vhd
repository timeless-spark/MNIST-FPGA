library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.ML_types.all;

package CNN_W_CNN1 is

    constant CNN1_bounds : CNN_info := (OHidx => 7, OWidx => 7, OCidx => 4, FHidx => 5, FWidx => 5, FCidx => 1);

    constant S_cnn1 : intTensor1D (0 to 3) := (12, 9, 10, 9); -- scaling factors are in power of two format

    constant Z_cnn1 : signed(15+WCS downto 0) := to_signed(0, 15+WCS+1); -- there is no zero point in this NN

    constant W_CNN1 : tensor3D (0 to 3) (0 to 4) (0 to 4) (7 downto 0) := ( -- weights
        (
            (
                x"bd", x"be", x"a4", x"b2", x"9e"
            ),
            (
                x"0c", x"fb", x"f8", x"fc", x"cc"
            ),
            (
                x"df", x"e4", x"b2", x"ea", x"b3"
            ),
            (
                x"fb", x"f2", x"df", x"d3", x"f1"
            ),
            (
                x"09", x"f7", x"e8", x"f0", x"f6"
            )
        ),
        (
            (
                x"1e", x"f5", x"f3", x"f9", x"fa"
            ),
            (
                x"1c", x"1d", x"20", x"11", x"1e"
            ),
            (
                x"17", x"25", x"1f", x"19", x"2c"
            ),
            (
                x"fa", x"10", x"37", x"13", x"14"
            ),
            (
                x"b6", x"b9", x"81", x"ba", x"c9"
            )
        ),
        (
            (
                x"31", x"15", x"28", x"30", x"f4"
            ),
            (
                x"28", x"fc", x"1b", x"11", x"c0"
            ),
            (
                x"25", x"0c", x"fc", x"16", x"cf"
            ),
            (
                x"07", x"f9", x"18", x"11", x"a5"
            ),
            (
                x"45", x"f2", x"d6", x"ae", x"e9"
            )
        ),
        (
            (
                x"25", x"33", x"3b", x"2a", x"5a"
            ),
            (
                x"e1", x"f1", x"f5", x"03", x"fc"
            ),
            (
                x"e4", x"d5", x"db", x"d0", x"e6"
            ),
            (
                x"01", x"ef", x"df", x"f6", x"e2"
            ),
            (
                x"13", x"14", x"07", x"00", x"0b"
            )
        )
    );

end package;
