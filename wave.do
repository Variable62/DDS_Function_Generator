onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Testbrench/m_DDS_Top/m_samp/Fg_CLK
add wave -noupdate /Testbrench/m_DDS_Top/m_samp/oIntBtn
add wave -noupdate /Testbrench/m_DDS_Top/m_samp/Fg_RESETn
add wave -noupdate /Testbrench/m_DDS_Top/m_samp/DDSReady
add wave -noupdate -radix unsigned -childformat {{{/Testbrench/m_DDS_Top/m_samp/rDDSMode[2]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rDDSMode[1]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rDDSMode[0]} -radix unsigned}} -expand -subitemconfig {{/Testbrench/m_DDS_Top/m_samp/rDDSMode[2]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rDDSMode[1]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rDDSMode[0]} {-radix unsigned}} /Testbrench/m_DDS_Top/m_samp/rDDSMode
add wave -noupdate -radix unsigned -expand /Testbrench/m_DDS_Top/m_samp/rValue
add wave -noupdate -radix unsigned -childformat {{{/Testbrench/m_DDS_Top/m_samp/rCnt[13]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[12]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[11]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[10]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[9]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[8]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[7]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[6]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[5]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[4]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[3]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[2]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[1]} -radix unsigned} {{/Testbrench/m_DDS_Top/m_samp/rCnt[0]} -radix unsigned}} -subitemconfig {{/Testbrench/m_DDS_Top/m_samp/rCnt[13]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[12]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[11]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[10]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[9]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[8]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[7]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[6]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[5]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[4]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[3]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[2]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[1]} {-radix unsigned} {/Testbrench/m_DDS_Top/m_samp/rCnt[0]} {-radix unsigned}} /Testbrench/m_DDS_Top/m_samp/rCnt
add wave -noupdate /Testbrench/m_DDS_Top/m_samp/rDDSEnable
add wave -noupdate /Testbrench/m_DDS_Top/m_samp/rDDSReady
add wave -noupdate /Testbrench/m_DDS_Top/m_samp/rPulse_In
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5442913386 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 309
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {10500 us}
