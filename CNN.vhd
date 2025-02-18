library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.ML_types.all;
use work.CNN_W_cnn1.all;
use work.CNN_W_cnn2.all;
use work.CNN_W_fc.all;

entity CNN is
    port (
        CLK  : in std_logic;
        RSTn : in std_logic;
        I : in tensor2D (0 to 28) (0 to 28) (7 downto 0);
        O : out std_logic_vector(9 downto 0);
        DONE : out std_logic
    );
end entity;

architecture RTL of CNN is

    signal CNN1_idxs : CNN_info;
    signal CNN2_idxs : CNN_info;
    signal FC_idxs   : FC_info;

    signal N_idx : integer range 0 to 3;

    signal CNN1_ACT : tensor3D (0 to 6) (0 to 6) (0 to 3) (7 downto 0);
    signal CNN2_ACT : tensor3D (0 to 2) (0 to 2) (0 to 3) (7 downto 0);
    signal CNN2_ACT_FLAT : tensor1D (0 to 35) (7 downto 0); -- flatten of CNN2_ACT
    signal FC_ACT   : tensor1D (0 to 9) (7 downto 0);

    component MAC_unit_rescale is
      port (
        A :  in tensor1D (0 to N-1) (7 downto 0);
        B :  in tensor1D (0 to N-1) (7 downto 0);
        C :  in signed(15+WCS downto 0);
        R :  in std_logic;
        S :  in integer range 0 to 15;
        Z :  in signed(15+WCS downto 0);
        O : out signed(15+WCS downto 0)
      );
    end component;

    signal MAC_A : tensor1D (0 to N-1) (7 downto 0);
    signal MAC_B : tensor1D (0 to N-1) (7 downto 0);
    signal MAC_C : signed(15+WCS downto 0);
    signal MAC_R : std_logic;
    signal MAC_S : integer range 0 to 15;
    signal MAC_Z : signed(15+WCS downto 0);
    signal MAC_O : signed(15+WCS downto 0);

    begin

        MAC_u_i : MAC_unit_rescale port map (A => MAC_A, B => MAC_B, C => MAC_C, R => MAC_R, S => MAC_S, Z => MAC_Z, O => MAC_O);

        -- update indexes
        process(CLK, RSTn) is
        begin
            if RSTn = '0' then
                CNN1_idxs.OHidx <= 0; CNN1_idxs.OWidx <= 0; CNN1_idxs.OCidx <= 0; CNN1_idxs.FHidx <= 0; CNN1_idxs.FWidx <= 0; CNN1_idxs.FCidx <= 0;
                CNN2_idxs.OHidx <= 0; CNN2_idxs.OWidx <= 0; CNN2_idxs.OCidx <= 0; CNN2_idxs.FHidx <= 0; CNN2_idxs.FWidx <= 0; CNN2_idxs.FCidx <= 0;
                FC_idxs.OCidx <= 0; FC_idxs.FCidx <= 0;
                N_idx <= 0;
                MAC_C <= (others => '0');
                DONE <= '0';
            elsif rising_edge(CLK) then
                MAC_C <= MAC_O;
                if N_idx = 0 then
                    -- layer CNN1
                    if CNN1_idxs.FWidx < CNN1_bounds.FWidx-1 then
                        CNN1_idxs.FWidx <= CNN1_idxs.FWidx + 1;
                    else
                        if CNN1_idxs.FHidx < CNN1_bounds.FHidx-1 then
                            CNN1_idxs.FHidx <= CNN1_idxs.FHidx + 1;
                        else
                            if CNN1_idxs.OCidx < CNN1_bounds.OCidx-1 then
                                CNN1_idxs.OCidx <= CNN1_idxs.OCidx + 1;
                            else
                                if CNN1_idxs.OWidx < CNN1_bounds.OWidx-1 then
                                    CNN1_idxs.OWidx <= CNN1_idxs.OWidx + 1;
                                else
                                    if CNN1_idxs.OHidx < CNN1_bounds.OHidx-1 then
                                        CNN1_idxs.OHidx <= CNN1_idxs.OHidx + 1;
                                    else
                                        N_idx <= N_idx + 1;
                                        CNN1_idxs.OHidx <= 0;
                                    end if;
                                    CNN1_idxs.OWidx <= 0;
                                end if;
                                CNN1_idxs.OCidx <= 0;
                            end if;
                            CNN1_idxs.FHidx <= 0;
                            MAC_C <= (others => '0');
                        end if;
                        CNN1_idxs.FWidx <= 0;
                    end if;
                elsif N_idx = 1 then
                    -- layer CNN2
                    if CNN2_idxs.FCidx < CNN2_bounds.FCidx-N then
                        CNN2_idxs.FCidx <= CNN2_idxs.FCidx + N;
                    else
                        if CNN2_idxs.FWidx < CNN2_bounds.FWidx-1 then
                            CNN2_idxs.FWidx <= CNN2_idxs.FWidx + 1;
                        else
                            if CNN2_idxs.FHidx < CNN2_bounds.FHidx-1 then
                                CNN2_idxs.FHidx <= CNN2_idxs.FHidx + 1;
                            else
                                if CNN2_idxs.OCidx < CNN2_bounds.OCidx-1 then
                                    CNN2_idxs.OCidx <= CNN2_idxs.OCidx + 1;
                                else
                                    if CNN2_idxs.OWidx < CNN2_bounds.OWidx-1 then
                                        CNN2_idxs.OWidx <= CNN2_idxs.OWidx + 1;
                                    else
                                        if CNN2_idxs.OHidx < CNN2_bounds.OHidx-1 then
                                            CNN2_idxs.OHidx <= CNN2_idxs.OHidx + 1;
                                        else
                                            N_idx <= N_idx + 1;
                                            CNN2_idxs.OHidx <= 0;
                                        end if;
                                        CNN2_idxs.OWidx <= 0;
                                    end if;
                                    CNN2_idxs.OCidx <= 0;
                                end if;
                                CNN2_idxs.FHidx <= 0;
                                MAC_C <= (others => '0');
                            end if;
                            CNN2_idxs.FWidx <= 0;
                        end if;
                        CNN2_idxs.FCidx <= 0;
                    end if;
                elsif N_idx = 2 then
                    -- layer FC
                    if FC_idxs.FCidx < FC_bounds.FCidx-N then
                        FC_idxs.FCidx <= FC_idxs.FCidx + N;
                    else
                        if FC_idxs.OCidx < FC_bounds.OCidx-1 then
                            FC_idxs.OCidx <= FC_idxs.OCidx + 1;
                        else
                            N_idx <= N_idx + 1;
                            FC_idxs.OCidx <= 0;
                        end if;
                        FC_idxs.FCidx <= 0;
                        MAC_C <= (others => '0');
                    end if;
                else
                    DONE <= '1';
                end if;
            end if;
        end process;

        -- define inputs to the MAC unit
        process(RSTn, CNN1_idxs, CNN2_idxs, FC_idxs, N_idx)
        begin
            if RSTn = '0' then
                for i in 0 to N-1 loop
                    MAC_A(i) <= (others => '0');
                    MAC_B(i) <= (others => '0');
                end loop;
                MAC_S <= 0;
                MAC_R <= '0';
            else
                if N_idx = 0 then
                    -- layer CNN1
                    MAC_A(0) <= I((4*CNN1_idxs.OHidx) + CNN1_idxs.FHidx)((4*CNN1_idxs.OWidx) + CNN1_idxs.FWidx);
                    MAC_B(0) <= W_CNN1(CNN1_idxs.OCidx)(CNN1_idxs.FHidx)(CNN1_idxs.FWidx);
                    MAC_S <= S_cnn1(CNN1_idxs.OCidx);
                    MAC_Z <= Z_cnn1;
                    MAC_R <= '0';
                    if CNN1_idxs.FHidx + 1 = CNN1_bounds.FHidx and CNN1_idxs.FWidx + 1 = CNN1_bounds.FWidx then
                        MAC_R <= '1';
                    end if;
                elsif N_idx = 1 then
                    -- layer CNN2
                    for i in 0 to N-1 loop
                        MAC_A(i) <= CNN1_ACT((2*CNN2_idxs.OHidx) + CNN2_idxs.FHidx)((2*CNN2_idxs.OWidx) + CNN2_idxs.FWidx)(CNN2_idxs.FCidx + i);
                        MAC_B(i) <= W_CNN2(CNN2_idxs.OCidx)(CNN2_idxs.FHidx)(CNN2_idxs.FWidx)(CNN2_idxs.FCidx + i);
                    end loop;
                    MAC_S <= S_cnn2(CNN2_idxs.OCidx);
                    MAC_Z <= Z_cnn2;
                    MAC_R <= '0';
                    if CNN2_idxs.FHidx + 1 = CNN2_bounds.FHidx and CNN2_idxs.FWidx + 1 = CNN2_bounds.FWidx and CNN2_idxs.FCidx + N = CNN2_bounds.FCidx then
                        MAC_R <= '1';
                    end if;
                elsif N_idx = 2 then
                    -- layer FC
                    for i in 0 to N-1 loop
                        MAC_A(i) <= CNN2_ACT_FLAT(FC_idxs.FCidx + i);
                        MAC_B(i) <= W_FC(FC_idxs.OCidx)(FC_idxs.FCidx + i);
                    end loop;
                    MAC_S <= S_fc(FC_idxs.OCidx);
                    MAC_Z <= Z_fc;
                    MAC_R <= '0';
                    if FC_idxs.FCidx + N = FC_bounds.FCidx then
                        MAC_R <= '1';
                    end if;
                end if;
            end if;
        end process;

        -- assign the output from MAC to the right location
        process(N_idx, MAC_O, MAC_R)
        begin
            if N_idx = 0 then
                -- layer CNN1
                if MAC_R = '1' then
                    CNN1_ACT(CNN1_idxs.OHidx)(CNN1_idxs.OWidx)(CNN1_idxs.OCidx) <= MAC_O(7 downto 0);
                end if;
                elsif N_idx = 1 then
                -- layer CNN2
                if MAC_R = '1' then
                    CNN2_ACT(CNN2_idxs.OHidx)(CNN2_idxs.OWidx)(CNN2_idxs.OCidx) <= MAC_O(7 downto 0);
                end if;
            elsif N_idx = 2 then
                -- layer FC
                if MAC_R = '1' then
                    FC_ACT(FC_idxs.OCidx) <= MAC_O(7 downto 0);
                end if;
            end if;
        end process;
        
        -- simply copy from CNN2_ACT to CNN2_ACT_FLAT
        process(CNN2_ACT)
        begin
            for OHidx in 0 to CNN2_bounds.OHidx-1 loop
                for OWidx in 0 to CNN2_bounds.OWidx-1 loop
                    for OCidx in 0 to CNN2_bounds.OCidx-1 loop
                        CNN2_ACT_FLAT(OCidx + (OWidx * CNN2_bounds.OCidx) + ((OHidx * CNN2_bounds.OCidx) * CNN2_bounds.OWidx)) <= CNN2_ACT(OHidx)(OWidx)(OCidx);
                    end loop;
                end loop;
            end loop;
        end process;

        -- pick the greatest among predicted values from NN
        process(FC_ACT)
        variable max_value : signed(7 downto 0);
        variable max_pos : integer range 0 to 9;
        begin
            max_value := FC_ACT(0);
            max_pos := 0;
            for i in 1 to 9 loop
                if FC_ACT(i) >= max_value then
                    max_value := FC_ACT(i);
                    max_pos := i;
                end if;
            end loop;
            O <= (others => '0');
            O(max_pos) <= '1';
        end process;

end architecture;
