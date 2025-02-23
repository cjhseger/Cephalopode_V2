{-
    Library for CableCar programs in Cephalopode.
    CableCar is available on github:
        https://github.com/popje-chalmers/cablecar

    GHC and company will need to know to include CableCar, so use:
        ... -i<cablecar directory> ...
    in any relevant commands.
-}
module CableCarStuff where

import CableCar

---------------
-- Functions
---------------

-- Generate an FL file from a cablecar Plan. Prefixes it with cload statements and also a warning about being auto-generated.
generate :: FilePath -> FilePath -> [String] -> [String] -> Plan -> IO ()
generate destfile sourcefile fl_global_libs fl_local_libs plan = writeFile destfile text
  where
    text = prelude ++ "\n" ++ body
    prelude = unlines $ warning : libs
    warning = unlines
                [ "// Do not modify;"
                , "// file auto-generated"
                , "// using CableCar"
                , "// --" ++ sourcefile
                ]
    libs = map global_load fl_global_libs ++ map local_load fl_local_libs
    global_load s = "cload " ++ show s ++ ";"
    local_load s = "cload (DIR^" ++ show s ++ ");"
    body = printFL $ makeHardware plan

-------------
-- HWTypes
-------------

bit :: HWType
bit = "bit"

addr :: HWType
addr = "addr"

node :: HWType
node = "node"

graphptr :: HWType
graphptr = "graphptr"

----------------
-- CableTypes
----------------

-- Generic
t_reqack = cabletype nopower handshake [] [] -- just req/ack, no data

-- Memory module
t_mem_init = cabletype nopower handshake [] ["freeptr" `typed` addr]
t_mem_read = cabletype nopower handshake ["addr" `typed` addr] ["dout" `typed` node]
t_mem_write = cabletype nopower handshake ["addr" `typed` addr, "din" `typed` node] []
t_snap_prepare = t_reqack
t_snap_take = t_reqack
t_snap_read = t_mem_read
t_snap_ready = cabletype nopower nohandshake [] ["ready" `typed` bit]
t_mark_get = cabletype nopower handshake ["addr" `typed` addr] ["value" `typed` bit]
t_mark_set = cabletype nopower handshake ["addr" `typed` addr, "value" `typed` bit] []

-- Reduction engine
t_reduce = cabletype nopower handshake ["gp_in" `typed` graphptr] ["gp_out" `typed` graphptr]

-- Allocator
t_alloc = cabletype nopower handshake [] ["addr" `typed` addr]

-- Freelist
t_checkout = cabletype nopower handshake [] ["freeptr" `typed` addr]
t_checkin = cabletype nopower handshake ["freeptr" `typed` addr] []

-- Manager
t_manager_run = t_reqack
t_freeze = t_reqack
t_unfreeze = t_reqack
t_pause = cabletype nopower nohandshake [] ["pause" `typed` bit]

-- Garbage collector
t_gc_run = t_reqack

-- Boot
t_boot_run = t_reqack
