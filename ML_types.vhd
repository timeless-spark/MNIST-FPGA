library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package ML_types is

    constant N : integer := 4;  -- number of MAC instantiated in parallel, for this NN only values in [1, 4] make sense
    constant WCS : integer := 8; -- "Worst Case Sum", maximum number of summations done when accumulating the input_feature x filter partial results

    -- some useful types
    type tensor1D is array (natural range <>) of signed;
    type tensor2D is array (natural range <>) of tensor1D;
    type tensor3D is array (natural range <>) of tensor2D;
    type tensor4D is array (natural range <>) of tensor3D;
    type intTensor1D is array (natural range <>) of integer range 0 to 15;

    -- used to track indexing and boundaries of each NN layer during the computation
    type CNN_info is record
        OHidx : integer range 0 to 32;
        OWidx : integer range 0 to 32;
        OCidx : integer range 0 to 32;
        FHidx : integer range 0 to 32;
        FWidx : integer range 0 to 32;
        FCidx : integer range 0 to 32;
    end record;
    type FC_info is record
        OCidx : integer range 0 to 63;
        FCidx : integer range 0 to 63;
    end record;

end package;
