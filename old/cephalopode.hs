-- Do not compile this! Instead, run it directly:
--      runhaskell -i<cablecar directory> cephalopode.hs

import CableCar
import CableCarStuff

main :: IO ()
main = generate "cephalopode.fl" "cephalopode.hs" []
    [ "types.fl"
    , "memory/memory.fl"
    , "arbiters/arb_memory.fl"
    , "reduction/reduction.fl"
    , "gc/gc.fl"
    , "allocator/allocator.bfst.fl"
    , "freelist/freelist.fl"
    , "arbiters/arb_freelist.fl"
    , "manager/manager.fl"
    , "boot/boot.bfst.fl"
    ]
    cephalopode

cephalopode :: Plan
cephalopode = runCableCar $ do
    begin "cephalopode"
    -- CABLES
    -- Ordinary memory read/write, shared across several units
    mem_init <- cable "mem_init" t_mem_init
    mem_read <- cable "mem_read" t_mem_read
    mem_read_re <- cable "mem_read_re" t_mem_read
    mem_read_allocator <- cable "mem_read_allocator" t_mem_read
    mem_read_re_allocator <- cable "mem_read_re_allocator" t_mem_read
    mem_read_gc <- cable "mem_read_gc" t_mem_read
    mem_write <- cable "mem_write" t_mem_write
    mem_write_re <- cable "mem_write_re" t_mem_write
    mem_write_allocator <- cable "mem_write_allocator" t_mem_write
    mem_write_re_allocator <- cable "mem_write_re_allocator" t_mem_write
    mem_write_gc <- cable "mem_write_gc" t_mem_write
    -- Snapshots
    snap_prepare <- cable "snap_prepare" t_snap_prepare
    snap_take <- cable "snap_take" t_snap_take
    snap_read <- cable "snap_read" t_snap_read
    snap_ready <- cable "snap_ready" t_snap_ready
    -- Marking
    mark_get <- cable "mark_get" t_mark_get
    mark_set <- cable "mark_set" t_mark_set
    -- Freelist
    checkout_gc <- cable "checkout_gc" t_checkout
    checkout_allocator <- cable "checkout_allocator" t_checkout
    checkout_boot <- cable "checkout_boot" t_checkout
    checkout_allocator_boot <- cable "checkout_allocator_boot" t_checkout
    checkin_gc <- cable "checkin_gc" t_checkin
    checkin_allocator <- cable "checkin_allocator" t_checkin
    checkin_boot <- cable "checkin_boot" t_checkin
    checkin_allocator_boot <- cable "checkin_allocator_boot" t_checkin
    -- Manager
    manager_run <- cable "manager_run" t_manager_run
    freeze <- cable "freeze" t_freeze
    unfreeze <- cable "unfreeze" t_unfreeze
    pause <- cable "pause" t_pause
    -- Other
    reduce <- cable "reduce" t_reduce
    alloc <- cable "alloc" t_alloc
    gc_run <- cable "gc_run" t_gc_run
    boot_run <- cable "boot_run" t_boot_run
    -- INPUT/OUTPUT
    plug boot_run from world
    -- MODULES AND PLUGS
    memory <- make "memory" []
    plug mem_init into memory
    plug mem_read into memory
    plug mem_write into memory
    plug snap_prepare into memory
    plug snap_take into memory
    plug snap_read into memory
    plug mark_get into memory
    plug mark_set into memory
    plug snap_ready into memory
    --
    arb_mem_read <- make "arb_mem_read" []      -- between gc and other
    plug mem_read from arb_mem_read
    plug mem_read_gc into arb_mem_read
    plug mem_read_re_allocator into arb_mem_read
    --
    fork_mem_read <- make "fork_mem_read" []    -- for re and allocator
    plug mem_read_re_allocator from fork_mem_read
    plug mem_read_re into fork_mem_read
    plug mem_read_allocator into fork_mem_read
    --
    arb_mem_write <- make "arb_mem_write" []    -- between gc and other
    plug mem_write from arb_mem_write
    plug mem_write_gc into arb_mem_write
    plug mem_write_re_allocator into arb_mem_write
    --
    fork_mem_write <- make "fork_mem_write" []  -- for re and allocator
    plug mem_write_re_allocator from fork_mem_write
    plug mem_write_re into fork_mem_write
    plug mem_write_allocator into fork_mem_write
    --
    re <- make "reduction_engine" []
    plug reduce into re
    plug mem_read_re from re
    plug mem_write_re from re
    plug alloc from re
    plug pause from re
    --
    manager <- make "manager" []
    plug manager_run into manager
    plug freeze into manager
    plug unfreeze into manager
    plug reduce from manager
    plug pause into manager
    --
    gc <- make "gc" []
    plug gc_run into gc
    plug mem_read_gc from gc
    plug mem_write_gc from gc
    plug snap_prepare from gc
    plug snap_take from gc
    plug snap_read from gc
    plug snap_ready from gc
    plug mark_get from gc
    plug mark_set from gc
    plug checkout_gc from gc
    plug checkin_gc from gc
    plug freeze from gc
    plug unfreeze from gc
    --
    allocator <- make "allocator" []
    plug alloc into allocator
    plug mem_read_allocator from allocator
    plug mem_write_allocator from allocator
    plug checkout_allocator from allocator
    plug checkin_allocator from allocator
    --
    freelist <- make "freelist" []
    plug checkout_gc into freelist
    plug checkout_allocator_boot into freelist
    plug checkin_gc into freelist
    plug checkin_allocator_boot into freelist
    --
    fork_checkout <- make "fork_checkout" []    -- for allocator and boot
    plug checkout_allocator_boot from fork_checkout
    plug checkout_allocator into fork_checkout
    plug checkout_boot into fork_checkout
    --
    fork_checkin <- make "fork_checkin" []      -- for allocator and boot
    plug checkin_allocator_boot from fork_checkin
    plug checkin_allocator into fork_checkin
    plug checkin_boot into fork_checkin
    --
    boot <- make "boot" []
    plug boot_run into boot
    plug mem_init from boot
    plug gc_run from boot
    plug manager_run from boot
    plug checkout_boot from boot
    plug checkin_boot from boot
    --
    return ()   

