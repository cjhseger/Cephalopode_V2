

proc start_eval_seq_vis { } {
    set w .ev
    catch {destroy $w}

    toplevel $w
    set lx [winfo rootx .]
    set ly [winfo rooty .]
    wm geometry $w 800x1000+[expr $lx+2]+[expr $ly+2]
    wm title $w "Evaluation visualization"
    set cmds $w.cmds
    frame $cmds
    pack $cmds -side top -fill x
	button $cmds.prev -text "Previous" -command previous_reduction
	button $cmds.next -text "Next" -command next_reduction
	button $cmds.quit -text "Quit" -command {send_top_voss2_cmd "quit;"}
	pack $cmds.prev -side left -padx 20
	pack $cmds.next -side left -padx 20
	pack $cmds.quit -side right -padx 20
    pack $cmds -side top -fill x
    set nb $w.nb
    set ::eval_seq(nb)  $nb
    set ::eval_seq(tab_cnt) 0
    ttk::notebook $nb
    ttk::notebook::enableTraversal $nb
    bind $nb <<NotebookTabChanged>> [list set_focus $nb]
    pack $nb -side top -fill both -expand yes
}

proc set_focus {nb} {
    set cur [$nb index "current"]
    set c [format {%s.f%d} $nb [expr $cur+1]].c
    update
    focus $c
}

proc add_eval_graph {msg dot_pgm} {
    set w [format {%s.f%d} $::eval_seq(nb) $::eval_seq(tab_cnt)]
    frame $w
    $::eval_seq(nb) add $w -text "R$::eval_seq(tab_cnt)"

    set l $w.l
    label $l -text $msg
    pack $l -side top -fill x -anchor w
    set c $w.c
    scrollbar $w.yscroll -command "$c yview"
    scrollbar $w.xscroll -orient horizontal -command "$c xview"
    canvas $c -background white \
	    -yscrollcommand "$w.yscroll set" \
	    -xscrollcommand "$w.xscroll set"
    pack $w.yscroll -side right -fill y
    pack $w.xscroll -side bottom -fill x
    pack $c -side top -fill both -expand yes

    bind $c <2> "%W scan mark %x %y"
    bind $c <B2-Motion> "%W scan dragto %x %y"

    # Zoom bindings
    bind $c <ButtonPress-3> "zoom_lock %W %x %y"
    bind $c <B3-Motion> "zoom_move %W %x %y"
    bind $c <ButtonRelease-3> "zoom_execute %W %x %y %X %Y {}"

    # Mouse-wheel bindings for zooming in/out
    bind $c <Button-4> "zoom_out $c 1.1 %x %y"
    bind $c <Button-5> "zoom_out $c [expr {1.0/1.1}] %x %y"

    bind $c <KeyPress-Right>  next_reduction
    bind $c <KeyPress-Left>  previous_reduction

    display_dot $dot_pgm $w
    $::eval_seq(nb) select [expr [$::eval_seq(nb) index end]-1]
    focus $c
    update
    zoom_to_fit $c
}

proc next_reduction {} {
    set nb $::eval_seq(nb)
    set cnt [$nb index "end"]
    if { $cnt == 0 } {
	incr ::eval_seq(tab_cnt)
	after idle {fl_show_eval_sequence $::eval_seq(tab_cnt)}
	return;
    }
    set cur [$nb index "current"]
    if [expr $cur == ($cnt-1)] {
	incr ::eval_seq(tab_cnt)
	after idle {fl_show_eval_sequence $::eval_seq(tab_cnt)}
	return;
    }
    $nb select [expr $cur+1]
}

proc previous_reduction {} {
    set nb $::eval_seq(nb)
    if { [$nb index "end"] == 0 } { return; }
    set cur [$nb index "current"]
    if [expr $cur <= 0] { return; }
    $nb select [expr $cur-1]
}

