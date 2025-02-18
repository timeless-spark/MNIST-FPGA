library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.ML_types.all;

package CNN_W_CNN2 is

    constant CNN2_bounds : CNN_info := (OHidx => 3, OWidx => 3, OCidx => 4, FHidx => 3, FWidx => 3, FCidx => 4);

    constant S_cnn2 : intTensor1D (0 to 3) := (6, 5, 6, 6); -- scaling factors are in power of two format

    constant Z_cnn2 : signed(15+WCS downto 0) := to_signed(0, 15+WCS+1); -- there is no zero point in this NN

    constant W_CNN2 : tensor4D (0 to 3) (0 to 2) (0 to 2) (0 to 3) (7 downto 0) := ( -- weights
        (
            (
                (x"9b", x"e2", x"15", x"e0"),
                (x"c6", x"03", x"07", x"f8"),
                (x"e1", x"fc", x"f7", x"02")
            ),
            (
                (x"fc", x"03", x"0b", x"00"),
                (x"21", x"12", x"f2", x"13"),
                (x"ff", x"0a", x"f3", x"08")
            ),
            (
                (x"35", x"ff", x"e3", x"0b"),
                (x"65", x"0c", x"fc", x"1e"),
                (x"5a", x"01", x"0c", x"16")
            )
        ),
        (
            (
                (x"fd", x"07", x"02", x"e8"),
                (x"ff", x"20", x"c9", x"e3"),
                (x"02", x"f1", x"d6", x"a5")
            ),
            (
                (x"31", x"fc", x"1c", x"0c"),
                (x"b9", x"07", x"f7", x"1d"),
                (x"0e", x"0e", x"db", x"27")
            ),
            (
                (x"f6", x"03", x"eb", x"0e"),
                (x"27", x"fb", x"f6", x"ed"),
                (x"c2", x"08", x"15", x"f2")
            )
        ),
        (
            (
                (x"f9", x"fa", x"2e", x"09"),
                (x"10", x"07", x"2d", x"fc"),
                (x"cb", x"13", x"34", x"0e")
            ),
            (
                (x"00", x"cc", x"30", x"d6"),
                (x"5c", x"d2", x"55", x"e9"),
                (x"27", x"f9", x"31", x"fa")
            ),
            (
                (x"44", x"d3", x"1d", x"cc"),
                (x"69", x"f4", x"35", x"df"),
                (x"f0", x"00", x"22", x"f3")
            )
        ),
        (
            (
                (x"e5", x"ed", x"e8", x"f5"),
                (x"c7", x"da", x"3b", x"df"),
                (x"c5", x"e9", x"31", x"ed")
            ),
            (
                (x"15", x"cb", x"12", x"b7"),
                (x"e0", x"03", x"2d", x"d6"),
                (x"f3", x"f1", x"97", x"ef")
            ),
            (
                (x"65", x"f6", x"2d", x"f6"),
                (x"6f", x"3e", x"33", x"28"),
                (x"67", x"2c", x"dd", x"0d")
            )
        )
    );

end package;
