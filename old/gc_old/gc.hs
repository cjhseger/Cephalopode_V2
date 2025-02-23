import CableCar
import CableCarStuff

main :: IO ()
main = generate "gc.fl" "gc.hs" []
    [ "../types.fl"
    , "gc_ctrl.bfst.fl"
    , "gc_stack.fl"
    ]
    gc

gc :: Plan
gc = runCableCar $ do
    begin "gc"
    -- Cables
    gc_run <- cable "gc_run" t_gc_run
    mem_read <- cable "mem_read" t_mem_read
    mem_write <- cable "mem_write" t_mem_write
    snap_prepare <- cable "snap_prepare" t_snap_prepare
    snap_take <- cable "snap_take" t_snap_take
    snap_read <- cable "snap_read" t_snap_read
    snap_ready <- cable "snap_ready" t_snap_ready
    mark_get <- cable "mark_get" t_mark_get
    mark_set <- cable "mark_set" t_mark_set
    checkout <- cable "checkout" t_checkout
    checkin <- cable "checkin" t_checkin
    freeze <- cable "freeze" t_freeze
    unfreeze <- cable "unfreeze" t_unfreeze
    gcs_push <- cable "gcs_push" t_gcs_push
    gcs_pop <- cable "gcs_pop" t_gcs_pop
    gcs_nonempty <- cable "gcs_nonempty" t_gcs_nonempty
    -- Preparation
    let group0 = [gc_run]
    let group1 = [mem_read, mem_write, snap_prepare, snap_take, snap_read, snap_ready, mark_get, mark_set, checkout, checkin, freeze, unfreeze]
    let group2 = [gcs_push, gcs_pop, gcs_nonempty]
    -- I/O
    plugs group0 from world
    plugs group1 into world
    -- Control
    ctrl <- make "gc_ctrl" []
    plugs group0 into ctrl
    plugs group1 from ctrl
    plugs group2 from ctrl
    -- Stack
    stack <- make "gc_stack" []
    plugs group2 into stack
    --
    return ()

t_gcs_push = cabletype nopower handshake ["addr" `typed` addr] []
t_gcs_pop = cabletype nopower handshake [] ["addr" `typed` addr]
t_gcs_nonempty = cabletype nopower nohandshake [] ["ne" `typed` bit]
